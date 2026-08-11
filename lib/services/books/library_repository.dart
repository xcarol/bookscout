import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import 'package:bookscout/database/app_database.dart';
import 'package:bookscout/database/tables/user_book_status.dart';
import 'package:bookscout/models/book.dart' as model;
import 'package:bookscout/services/core/database_service.dart';
import 'package:bookscout/services/api/google_books_service.dart';
import 'package:bookscout/services/api/open_library_service.dart';

class LibraryRepository extends ChangeNotifier {
  final AppDatabase _db = DatabaseService.instance;

  Set<String> _libraryBookIds = {};

  Set<String> get libraryBookIds => _libraryBookIds;

  LibraryRepository() {
    _init();
  }

  Future<void> _init() async {
    final statuses = await _db.select(_db.userBookStatuses).get();
    _libraryBookIds = statuses.map((s) => s.bookId).toSet();
    notifyListeners();
  }

  bool isInLibrary(String bookId) {
    return _libraryBookIds.contains(bookId);
  }

  Future<void> toggleLibrary(model.Book book) async {
    final inLibrary = isInLibrary(book.id);
    if (inLibrary) {
      await removeFromLibrary(book.id);
    } else {
      await addToLibrary(book);
    }
  }

  Future<void> addToLibrary(model.Book book) async {
    model.Book bookToSave = book;
    if (book.isLite) {
      final googleBook = await GoogleBooksService().getBookById(book.id);
      if (googleBook != null) {
        bookToSave = googleBook;
      }
      if (bookToSave.isbn != null) {
        final olBook = await OpenLibraryService().getBookByIsbn(bookToSave.isbn!);
        if (olBook != null) {
          bookToSave = bookToSave.merge(olBook);
        }
      }
    }

    await _db.transaction(() async {
      await _db
          .into(_db.books)
          .insert(bookToSave.toCompanion(), mode: InsertMode.insertOrReplace);

      for (int i = 0; i < bookToSave.authors.length; i++) {
        final authorName = bookToSave.authors[i];
        final authorId = authorName
            .toLowerCase()
            .replaceAll(' ', '_')
            .replaceAll(RegExp(r'[^a-z0-9_]'), '');
        if (authorId.isEmpty) continue;

        await _db
            .into(_db.authors)
            .insert(
              AuthorsCompanion.insert(id: authorId, name: authorName),
              mode: InsertMode.insertOrIgnore,
            );

        await _db
            .into(_db.bookAuthors)
            .insert(
              BookAuthorsCompanion.insert(
                bookId: bookToSave.id,
                authorId: authorId,
                orderIndex: Value(i),
              ),
              mode: InsertMode.insertOrIgnore,
            );
      }

      await _db
          .into(_db.userBookStatuses)
          .insert(
            UserBookStatusesCompanion.insert(
              bookId: bookToSave.id,
              status: BookReadingStatus.wantToRead,
            ),
            mode: InsertMode.insertOrReplace,
          );
    });
    _libraryBookIds.add(bookToSave.id);
    notifyListeners();
  }

  Future<void> removeFromLibrary(String bookId) async {
    await (_db.delete(
      _db.userBookStatuses,
    )..where((t) => t.bookId.equals(bookId))).go();
    _libraryBookIds.remove(bookId);
    notifyListeners();
  }

  Future<List<model.Book>> getLibraryBooks({
    int offset = 0,
    int limit = 20,
  }) async {
    final query =
        _db.select(_db.books).join([
            innerJoin(
              _db.userBookStatuses,
              _db.userBookStatuses.bookId.equalsExp(_db.books.id),
            ),
          ])
          ..orderBy([OrderingTerm.desc(_db.userBookStatuses.dateAdded)])
          ..limit(limit, offset: offset);

    final rows = await query.get();

    final books = <model.Book>[];
    for (final row in rows) {
      final bookData = row.readTable(_db.books);
      final statusData = row.readTable(_db.userBookStatuses);

      final authors = await _getAuthorsForBook(bookData.id);

      books.add(
        model.Book.fromDrift(
          bookData,
          authors: authors,
          currentPage: statusData.currentPage,
          isFavorite: statusData.isFavorite,
          userRating: statusData.rating,
          readingStatus: statusData.status.name,
        ),
      );
    }
    return books;
  }

  Future<List<String>> _getAuthorsForBook(String bookId) async {
    final authorsQuery =
        _db.select(_db.bookAuthors).join([
            innerJoin(
              _db.authors,
              _db.authors.id.equalsExp(_db.bookAuthors.authorId),
            ),
          ])
          ..where(_db.bookAuthors.bookId.equals(bookId))
          ..orderBy([OrderingTerm.asc(_db.bookAuthors.orderIndex)]);
    final authorsRows = await authorsQuery.get();
    return authorsRows.map((r) => r.readTable(_db.authors).name).toList();
  }

  Future<model.Book?> getBook(String id) async {
    final bookData = await (_db.select(
      _db.books,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (bookData == null) return null;

    final authors = await _getAuthorsForBook(id);
    return model.Book.fromDrift(bookData, authors: authors);
  }

  Future<List<ReadingSession>> getReadingSessions(String bookId) async {
    final query = _db.select(_db.readingSessions)
      ..where((t) => t.bookId.equals(bookId))
      ..orderBy([(t) => OrderingTerm.desc(t.date)]);
    return query.get();
  }

  Future<void> insertReadingSession(ReadingSessionsCompanion session) async {
    await _db.transaction(() async {
      await _db.into(_db.readingSessions).insert(session);

      final bookId = session.bookId.value;
      final endPage = session.endPage.value;

      final currentStatus = await (_db.select(
        _db.userBookStatuses,
      )..where((t) => t.bookId.equals(bookId))).getSingleOrNull();

      if (currentStatus != null && currentStatus.currentPage < endPage) {
        await (_db.update(_db.userBookStatuses)
              ..where((t) => t.bookId.equals(bookId)))
            .write(UserBookStatusesCompanion(currentPage: Value(endPage)));
      }
    });
    notifyListeners();
  }
}
