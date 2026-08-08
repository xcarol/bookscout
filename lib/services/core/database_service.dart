import 'package:bookscout/database/app_database.dart';

/// Singleton service to manage the lifecycle of the Drift [AppDatabase].
class DatabaseService {
  static AppDatabase? _database;

  /// Returns the singleton instance of [AppDatabase].
  static AppDatabase get instance {
    if (_database == null) {
      throw StateError(
        'DatabaseService has not been initialized. Call DatabaseService.init() first.',
      );
    }
    return _database!;
  }

  /// Convenient getter for the database instance.
  static AppDatabase get db => instance;

  /// Initializes the database instance.
  static Future<void> init({AppDatabase? database}) async {
    _database = database ?? AppDatabase();
  }

  /// Closes the database connection.
  static Future<void> close() async {
    await _database?.close();
    _database = null;
  }
}
