class AppConstants {
  // List Names
  static const String readingList = 'readinglist';
  static const String toReadList = 'watchlist';
  static const String ratesList = 'rateslist';
  static const String discoverList = 'discoverlist';
  static const String searchList = 'searchlist';

  // Preference Keys
  static const String lastUpdateSuffix = '_last_update';
  static const String searchHistory = 'search_history';
  static const String themeMode = 'theme_mode';
  static const String themeScheme = 'ThemeScheme';
  static const String language = 'language';
  static const String region = 'region';
  static const String lastBackgroundRun = 'last_background_run';
  static const String updateLogs = 'update_logs';
  static const String notificationsEnabled = 'notifications_enabled';
  static const String showEditContent = 'show_edit_content';

  // Languages
  static const String catalan = 'ca-ES';
  static const String spanish = 'es-ES';
  static const String english = 'en-US';

  static const List<String> supportedLanguages = [catalan, spanish, english];

  // Environment & Keys
  static const String saveLogsMessage = 'saveLogs';
  static const String enableLogs = 'ENABLE_LOGS';
  static const String appVersion = 'VERSION';

  // Search & Pagination Limits
  static const int minSearchChars = 3;
  static const int searchDebounceMs = 300;
  static const int maxSearchBooks = 20;
  static const int searchHistoryLimit = 40;

  // Cache & Network
  static const String bookCoverCacheKey = 'bookscout_covers_cache';
  static const int cacheMaxAgeDays = 30;
  static const int cacheMaxObjects = 500;
  static const int apiTimeoutSeconds = 10;
  static const int openLibraryTimeoutSeconds = 12;
}
