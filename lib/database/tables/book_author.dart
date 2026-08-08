import 'package:drift/drift.dart';
import 'package:bookscout/database/tables/author.dart';
import 'package:bookscout/database/tables/book.dart';

/// Many-to-many junction table between books and authors.
class BookAuthors extends Table {
  TextColumn get bookId =>
      text().references(Books, #id, onDelete: KeyAction.cascade)();
  TextColumn get authorId =>
      text().references(Authors, #id, onDelete: KeyAction.cascade)();
  TextColumn get role => text().withDefault(const Constant('author'))();
  IntColumn get orderIndex => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {bookId, authorId};
}
