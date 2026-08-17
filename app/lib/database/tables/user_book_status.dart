import 'package:drift/drift.dart';
import 'package:bookscout/database/tables/book.dart';

enum BookReadingStatus { wantToRead, reading, read, abandoned, onHold }

/// Reading status and rating of a book in the user's library.
class UserBookStatuses extends Table {
  TextColumn get bookId =>
      text().references(Books, #id, onDelete: KeyAction.cascade)();
  TextColumn get status => textEnum<BookReadingStatus>()();
  RealColumn get rating => real().nullable()();
  IntColumn get currentPage => integer().withDefault(const Constant(0))();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get finishDate => dateTime().nullable()();
  DateTimeColumn get dateAdded => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get dateUpdated =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {bookId};
}
