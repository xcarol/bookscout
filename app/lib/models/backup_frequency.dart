enum BackupFrequency {
  disabled,
  daily,
  weekly,
  monthly;

  String get value => name;

  static BackupFrequency fromString(String? value) {
    return BackupFrequency.values.firstWhere(
      (e) => e.name == value,
      orElse: () => BackupFrequency.disabled,
    );
  }
}
