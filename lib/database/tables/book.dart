import 'package:drift/drift.dart';

/// Main table for books and their metadata.
class Books extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().withLength(min: 1, max: 1000)();
  TextColumn get subtitle => text().nullable()();
  TextColumn get originalTitle => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get isbn10 => text().nullable()();
  TextColumn get isbn13 => text().nullable()();
  IntColumn get pageCount => integer().nullable()();
  TextColumn get publisher => text().nullable()();
  TextColumn get publishedDate => text().nullable()();
  TextColumn get coverUrl => text().nullable()();
  TextColumn get language => text().nullable()();
  RealColumn get averageRating => real().nullable()();
  IntColumn get ratingsCount => integer().nullable()();
  TextColumn get categories => text().nullable()();
  TextColumn get previewLink => text().nullable()();
  TextColumn get infoLink => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
