import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import 'package:bookscout/database/app_database.dart';
import 'package:bookscout/database/tables/user_book_status.dart';
import 'package:bookscout/models/book.dart' as model;
import 'package:bookscout/services/core/database_service.dart';

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
    await _db.transaction(() async {
      await _db
          .into(_db.books)
          .insert(book.toCompanion(), mode: InsertMode.insertOrReplace);
      await _db
          .into(_db.userBookStatuses)
          .insert(
            UserBookStatusesCompanion.insert(
              bookId: book.id,
              status: BookReadingStatus.wantToRead,
            ),
            mode: InsertMode.insertOrReplace,
          );
    });
    _libraryBookIds.add(book.id);
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

    return rows.map((row) {
      final bookData = row.readTable(_db.books);
      final statusData = row.readTable(_db.userBookStatuses);

      return model.Book.fromDrift(
        bookData,
        currentPage: statusData.currentPage,
        isFavorite: statusData.isFavorite,
        userRating: statusData.rating,
        readingStatus: statusData.status.name,
      );
    }).toList();
  }

  Future<model.Book?> getBook(String id) async {
    final bookData = await (_db.select(
      _db.books,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (bookData == null) return null;
    return model.Book.fromDrift(bookData);
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
