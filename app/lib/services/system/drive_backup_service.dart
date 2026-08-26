import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:bookscout/services/core/database_service.dart';
import 'package:bookscout/services/core/error_service.dart';
import 'package:bookscout/services/settings/preferences_service.dart';
import 'package:bookscout/services/workers/backup_worker_service.dart';
import 'package:bookscout/models/backup_frequency.dart';
import 'package:bookscout/utils/app_constants.dart';

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}

class DriveBackupService {
  static final DriveBackupService _instance = DriveBackupService._internal();

  factory DriveBackupService() {
    return _instance;
  }

  DriveBackupService._internal();

  GoogleSignInAccount? _currentUser;

  GoogleSignInAccount? get currentUser => _currentUser;

  Future<void> init() async {
    final webClientId = dotenv.env[AppConstants.googleClientId]!;

    await GoogleSignIn.instance.initialize(serverClientId: webClientId);

    GoogleSignIn.instance.authenticationEvents.listen((event) {
      if (event is GoogleSignInAuthenticationEventSignIn) {
        _currentUser = event.user;
      } else if (event is GoogleSignInAuthenticationEventSignOut) {
        _currentUser = null;
      }
    });
  }

  Future<GoogleSignInAccount?> signIn() async {
    return await GoogleSignIn.instance.authenticate();
  }

  Future<GoogleSignInAccount?> signInSilently() async {
    return await GoogleSignIn.instance.attemptLightweightAuthentication();
  }

  Future<void> signOut() async {
    await GoogleSignIn.instance.disconnect();
  }

  Future<drive.DriveApi?> _getDriveApi(GoogleSignInAccount account) async {
    final headers = await account.authorizationClient.authorizationHeaders([
      drive.DriveApi.driveAppdataScope,
    ], promptIfNecessary: true);

    if (headers == null || headers.isEmpty) {
      // User denied permissions, cancelled the dialog, or token expired permanently.
      // We must reset the state to avoid leaving the app in a "broken logged-in" state.
      debugPrint('Drive API permissions missing. Resetting auth state.');
      await signOut();
      await PreferencesService().prefs.setString(
        'backupFrequency',
        BackupFrequency.disabled.name,
      );
      BackupWorkerService().setupWorker(BackupFrequency.disabled.name);
      return null;
    }

    final client = GoogleAuthClient(headers);
    return drive.DriveApi(client);
  }

  Future<File> _getDatabaseFile() async {
    final dir = await getApplicationSupportDirectory();
    final dbPath = p.join(dir.path, AppConstants.databaseName);
    return File(dbPath);
  }

  Future<bool> backupDatabase() async {
    try {
      GoogleSignInAccount? account = _currentUser;
      account ??= await signInSilently();
      if (account == null) {
        debugPrint('Backup failed: No user signed in.');
        return false;
      }

      final driveApi = await _getDriveApi(account);
      if (driveApi == null) {
        debugPrint('Backup failed: Could not create Drive API client.');
        return false;
      }

      final dbFile = await _getDatabaseFile();
      if (!await dbFile.exists()) {
        debugPrint('Backup failed: Database file does not exist.');
        return false;
      }

      // Check if backup already exists
      final query =
          "name='${AppConstants.backupFileName}' and 'appDataFolder' in parents and trashed=false";
      final fileList = await driveApi.files.list(
        q: query,
        spaces: 'appDataFolder',
        $fields: 'files(id, name)',
      );

      final media = drive.Media(dbFile.openRead(), dbFile.lengthSync());

      if (fileList.files != null && fileList.files!.isNotEmpty) {
        // Update existing backup
        final existingFileId = fileList.files!.first.id!;
        final driveFile = drive.File();
        await driveApi.files.update(
          driveFile,
          existingFileId,
          uploadMedia: media,
        );
        debugPrint('Backup updated successfully.');
      } else {
        // Create new backup
        final driveFile = drive.File()
          ..name = AppConstants.backupFileName
          ..parents = ['appDataFolder'];
        await driveApi.files.create(driveFile, uploadMedia: media);
        debugPrint('Backup created successfully.');
      }

      return true;
    } catch (e, stackTrace) {
      debugPrint('Error backing up database: $e');
      ErrorService.log(
        e,
        stackTrace: stackTrace,
        userMessage: 'DriveBackupService.backupDatabase',
      );
      return false;
    }
  }

  Future<bool> restoreDatabase() async {
    try {
      GoogleSignInAccount? account = _currentUser;
      account ??= await signInSilently();
      if (account == null) {
        debugPrint('Restore failed: No user signed in.');
        return false;
      }

      final driveApi = await _getDriveApi(account);
      if (driveApi == null) {
        debugPrint('Restore failed: Could not create Drive API client.');
        return false;
      }

      final query =
          "name='${AppConstants.backupFileName}' and 'appDataFolder' in parents and trashed=false";
      final fileList = await driveApi.files.list(
        q: query,
        spaces: 'appDataFolder',
        $fields: 'files(id, name)',
      );

      if (fileList.files == null || fileList.files!.isEmpty) {
        debugPrint('Restore failed: No backup found.');
        return false;
      }

      final fileId = fileList.files!.first.id!;
      final drive.Media response =
          await driveApi.files.get(
                fileId,
                downloadOptions: drive.DownloadOptions.fullMedia,
              )
              as drive.Media;

      // Close the current database connection
      await DatabaseService.close();

      final dbFile = await _getDatabaseFile();
      final sink = dbFile.openWrite();
      await response.stream.pipe(sink);
      await sink.close();

      // Re-initialize the database connection
      await DatabaseService.init();

      debugPrint('Restore completed successfully.');
      return true;
    } catch (e, stackTrace) {
      debugPrint('Error restoring database: $e');
      ErrorService.log(
        e,
        stackTrace: stackTrace,
        userMessage: 'DriveBackupService.restoreDatabase',
      );
      // Attempt to re-initialize DB in case of error
      await DatabaseService.init();
      return false;
    }
  }

  Future<drive.File?> getLastBackupInfo() async {
    try {
      GoogleSignInAccount? account = _currentUser;
      account ??= await signInSilently();
      if (account == null) return null;

      final driveApi = await _getDriveApi(account);
      if (driveApi == null) return null;

      final query =
          "name='${AppConstants.backupFileName}' and 'appDataFolder' in parents and trashed=false";
      final fileList = await driveApi.files.list(
        q: query,
        spaces: 'appDataFolder',
        $fields: 'files(id, name, modifiedTime, size)',
      );

      if (fileList.files != null && fileList.files!.isNotEmpty) {
        return fileList.files!.first;
      }
      return null;
    } catch (e, stackTrace) {
      debugPrint('Error getting backup info: $e');
      ErrorService.log(
        e,
        stackTrace: stackTrace,
        userMessage: 'DriveBackupService.getLastBackupInfo',
      );
      return null;
    }
  }
}
