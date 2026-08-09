import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import 'package:bookscout/database/app_database.dart';
import 'package:bookscout/database/tables/user_book_status.dart';
import 'package:bookscout/models/book.dart' as model;
import 'package:bookscout/services/core/database_service.dart';

class LibraryService extends ChangeNotifier {
  final AppDatabase _db = DatabaseService.instance;
  
  Set<String> _libraryBookIds = {};
  
  Set<String> get libraryBookIds => _libraryBookIds;
  
  LibraryService() {
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
      await _db.into(_db.books).insert(book.toCompanion(), mode: InsertMode.insertOrReplace);
      await _db.into(_db.userBookStatuses).insert(
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
    await (_db.delete(_db.userBookStatuses)..where((t) => t.bookId.equals(bookId))).go();
    _libraryBookIds.remove(bookId);
    notifyListeners();
  }
}
