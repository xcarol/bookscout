import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'package:path_provider/path_provider.dart';

import 'package:bookscout/database/tables/tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Authors, Books, BookAuthors, UserBookStatuses, ReadingSessions],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'bookscout_database',
      native: DriftNativeOptions(
        shareAcrossIsolates: true,
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }
}
