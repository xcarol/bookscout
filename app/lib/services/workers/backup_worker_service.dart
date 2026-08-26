import 'package:workmanager/workmanager.dart';
import 'package:bookscout/services/system/drive_backup_service.dart';
import 'package:bookscout/services/settings/preferences_service.dart';

const String backupTaskKey = "bookscout.backupTask";

class BackupWorkerService {
  static final BackupWorkerService _instance = BackupWorkerService._internal();

  factory BackupWorkerService() {
    return _instance;
  }

  BackupWorkerService._internal();

  void setupWorker(String frequency) {
    if (frequency == 'disabled') {
      Workmanager().cancelByUniqueName(backupTaskKey);
      return;
    }

    Duration backupFrequency;
    switch (frequency) {
      case 'daily':
        backupFrequency = const Duration(days: 1);
        break;
      case 'weekly':
        backupFrequency = const Duration(days: 7);
        break;
      case 'monthly':
        backupFrequency = const Duration(days: 30);
        break;
      default:
        backupFrequency = const Duration(days: 1);
    }

    Workmanager().registerPeriodicTask(
      backupTaskKey,
      backupTaskKey,
      frequency: backupFrequency,
      existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
      constraints: Constraints(networkType: NetworkType.unmetered),
    );
  }

  static Future<void> executeBackupTask() async {
    final driveService = DriveBackupService();

    // Initialize preferences if not initialized
    try {
      await PreferencesService().init();
    } catch (e) {
      // Ignored if already initialized
    }

    final account = await driveService.signInSilently();
    if (account != null) {
      await driveService.backupDatabase();
    }
  }
}
