import 'package:flutter/material.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:bookscout/l10n/app_localizations.dart';
import 'package:bookscout/services/system/drive_backup_service.dart';
import 'package:bookscout/services/workers/backup_worker_service.dart';
import 'package:bookscout/models/backup_frequency.dart';
import 'package:bookscout/models/custom_colors.dart';
import 'package:bookscout/services/settings/preferences_service.dart';
import 'package:bookscout/utils/snack_bar.dart';
import 'package:bookscout/widgets/inputs_and_filters/drop_down_selector.dart';
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
  String? _loadingMessage;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() {
      _isLoading = true;
      _loadingMessage = null;
    });

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
    setState(() {
      _isLoading = true;
      _loadingMessage = AppLocalizations.of(context)?.signingIn;
    });
    final account = await _driveService.signIn();
    if (account != null) {
      _isSignedIn = true;
      _lastBackup = await _driveService.getLastBackupInfo();
    }
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _handleSignOut() async {
    setState(() {
      _isLoading = true;
      _loadingMessage = null;
    });
    await _driveService.signOut();
    _isSignedIn = false;
    _lastBackup = null;
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _handleManualBackup() async {
    setState(() {
      _isLoading = true;
      _loadingMessage = null;
    });
    final success = await _driveService.backupDatabase();
    if (success) {
      _lastBackup = await _driveService.getLastBackupInfo();
      if (mounted) {
        SnackMessage.showSnackBar(AppLocalizations.of(context)!.backupSuccess);
      }
    } else {
      if (mounted) {
        SnackMessage.showSnackBar(AppLocalizations.of(context)!.backupError);
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
      setState(() {
        _isLoading = true;
        _loadingMessage = null;
      });
      final success = await _driveService.restoreDatabase();
      if (mounted) {
        SnackMessage.showSnackBar(
          success ? l10n.restoreSuccess : l10n.restoreError,
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

  String _getFrequencyText(BackupFrequency frequency, AppLocalizations l10n) {
    switch (frequency) {
      case BackupFrequency.daily:
        return l10n.backupFrequencyDaily;
      case BackupFrequency.weekly:
        return l10n.backupFrequencyWeekly;
      case BackupFrequency.monthly:
        return l10n.backupFrequencyMonthly;
      case BackupFrequency.disabled:
        return l10n.backupFrequencyDisabled;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.backupSettings)),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  if (_loadingMessage != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      _loadingMessage!,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ],
              ),
            )
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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Wrap(
                      spacing: 16.0,
                      runSpacing: 16.0,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.account_circle),
                            const SizedBox(width: 16),
                            Flexible(
                              child: Text(
                                _driveService.currentUser?.email ?? '',
                              ),
                            ),
                          ],
                        ),
                        OutlinedButton.icon(
                          onPressed: _handleSignOut,
                          icon: const Icon(Icons.logout),
                          label: Text(l10n.signOut),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: customColors.dividerColor),
                  ListTile(
                    leading: const Icon(Icons.schedule),
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(l10n.backupFrequency),
                    ),
                    subtitle: DropdownSelector(
                      isExpanded: true,
                      selectedOption: _getFrequencyText(_backupFrequency, l10n),
                      options: [
                        l10n.backupFrequencyDisabled,
                        l10n.backupFrequencyDaily,
                        l10n.backupFrequencyWeekly,
                        l10n.backupFrequencyMonthly,
                      ],
                      onSelected: (String value) {
                        if (value == l10n.backupFrequencyDisabled) {
                          _updateFrequency(BackupFrequency.disabled);
                        } else if (value == l10n.backupFrequencyDaily) {
                          _updateFrequency(BackupFrequency.daily);
                        } else if (value == l10n.backupFrequencyWeekly) {
                          _updateFrequency(BackupFrequency.weekly);
                        } else if (value == l10n.backupFrequencyMonthly) {
                          _updateFrequency(BackupFrequency.monthly);
                        }
                      },
                      border: Border.all(color: customColors.dividerColor),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  Divider(color: customColors.dividerColor),
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
                  Wrap(
                    spacing: 16.0,
                    runSpacing: 16.0,
                    alignment: WrapAlignment.end,
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
