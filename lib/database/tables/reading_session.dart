import 'package:drift/drift.dart';
import 'package:bookscout/database/tables/book.dart';

/// Individual reading session for tracking progress and analytics.
class ReadingSessions extends Table {
  TextColumn get id => text()();
  TextColumn get bookId =>
      text().references(Books, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();
  IntColumn get startPage => integer()();
  IntColumn get endPage => integer()();
  IntColumn get pagesRead => integer()();
  IntColumn get durationMinutes => integer().withDefault(const Constant(0))();
  TextColumn get notes => text().nullable()();
  TextColumn get location => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
