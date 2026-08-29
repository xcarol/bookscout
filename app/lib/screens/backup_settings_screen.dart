import 'package:flutter/material.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:bookscout/l10n/app_localizations.dart';
import 'package:bookscout/services/system/drive_backup_service.dart';
import 'package:bookscout/services/workers/backup_worker_service.dart';
import 'package:bookscout/models/backup_frequency.dart';
import 'package:bookscout/services/settings/preferences_service.dart';
import 'package:intl/intl.dart';

class BackupSettingsScreen extends StatefulWidget {
  const BackupSettingsScreen({super.key});

  @override
  State<BackupSettingsScreen> createState() => _BackupSettingsScreenState();
}

class _BackupSettingsScreenState extends State<BackupSettingsScreen> {
  final DriveBackupService _driveService = DriveBackupService();
  bool _isLoading = true;
  bool _isSignedIn = false;
  drive.File? _lastBackup;
  BackupFrequency _backupFrequency = BackupFrequency.disabled;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);

    final prefs = PreferencesService().prefs;
    _backupFrequency = BackupFrequency.fromString(
      prefs.getString('backupFrequency'),
    );

    final account = await _driveService.signInSilently();
    _isSignedIn = account != null;

    if (_isSignedIn) {
      _lastBackup = await _driveService.getLastBackupInfo();
    }

    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _handleSignIn() async {
    setState(() => _isLoading = true);
    final account = await _driveService.signIn();
    if (account != null) {
      _isSignedIn = true;
      _lastBackup = await _driveService.getLastBackupInfo();
    }
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _handleSignOut() async {
    setState(() => _isLoading = true);
    await _driveService.signOut();
    _isSignedIn = false;
    _lastBackup = null;
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _handleManualBackup() async {
    setState(() => _isLoading = true);
    final success = await _driveService.backupDatabase();
    if (success) {
      _lastBackup = await _driveService.getLastBackupInfo();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.backupSuccess)),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.backupError)),
        );
      }
    }
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _handleRestore() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.restoreBackup),
        content: Text(l10n.restoreWarning),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.restoreBackup),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isLoading = true);
      final success = await _driveService.restoreDatabase();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? l10n.restoreSuccess : l10n.restoreError),
          ),
        );
      }
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _updateFrequency(BackupFrequency? frequency) async {
    if (frequency == null) return;

    setState(() {
      _backupFrequency = frequency;
    });

    final prefs = PreferencesService().prefs;
    await prefs.setString('backupFrequency', frequency.name);

    BackupWorkerService().setupWorker(frequency.name);
  }

  String _formatSize(String? bytesStr) {
    if (bytesStr == null) return 'Unknown size';
    final bytes = int.tryParse(bytesStr) ?? 0;
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.backupSettings)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (!_isSignedIn)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_off,
                          size: 64,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.signInRequired,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          onPressed: _handleSignIn,
                          icon: const Icon(Icons.login),
                          label: Text(l10n.signInGoogle),
                        ),
                      ],
                    ),
                  )
                else ...[
                  ListTile(
                    leading: const Icon(Icons.account_circle),
                    title: Text(_driveService.currentUser?.email ?? ''),
                    trailing: TextButton(
                      onPressed: _handleSignOut,
                      child: Text(l10n.signOut),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.schedule),
                    title: Text(l10n.backupFrequency),
                    subtitle: DropdownButton<BackupFrequency>(
                      isExpanded: true,
                      value: _backupFrequency,
                      onChanged: _updateFrequency,
                      items: [
                        DropdownMenuItem(
                          value: BackupFrequency.disabled,
                          child: Text(l10n.backupFrequencyDisabled),
                        ),
                        DropdownMenuItem(
                          value: BackupFrequency.daily,
                          child: Text(l10n.backupFrequencyDaily),
                        ),
                        DropdownMenuItem(
                          value: BackupFrequency.weekly,
                          child: Text(l10n.backupFrequencyWeekly),
                        ),
                        DropdownMenuItem(
                          value: BackupFrequency.monthly,
                          child: Text(l10n.backupFrequencyMonthly),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.cloud_done),
                    title: Text(l10n.lastBackup),
                    subtitle: Text(
                      _lastBackup != null
                          ? '${DateFormat.yMMMd(Localizations.localeOf(context).toString()).add_Hm().format(_lastBackup!.modifiedTime!.toLocal())} • ${_formatSize(_lastBackup!.size)}'
                          : l10n.noBackupFound,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton.icon(
                        onPressed: _handleManualBackup,
                        icon: const Icon(Icons.cloud_upload),
                        label: Text(l10n.backupNow),
                      ),
                      if (_lastBackup != null)
                        FilledButton.icon(
                          onPressed: _handleRestore,
                          icon: const Icon(Icons.cloud_download),
                          label: Text(l10n.restoreBackup),
                        ),
                    ],
                  ),
                ],
              ],
            ),
    );
  }
}
