import 'package:flutter/foundation.dart';
import 'package:bookscout/models/book.dart' as model;
import 'package:bookscout/services/books/library_repository.dart';

class BookListService extends ChangeNotifier {
  final LibraryRepository _libraryRepository;
  static const int _pageSize = 20;

  final List<model.Book> _books = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _offset = 0;
  String? _errorMessage;

  BookListService(this._libraryRepository) {
    _libraryRepository.addListener(_onLibraryChanged);
  }

  void _onLibraryChanged() {
    refresh();
  }

  @override
  void dispose() {
    _libraryRepository.removeListener(_onLibraryChanged);
    super.dispose();
  }

  List<model.Book> get books => List.unmodifiable(_books);
  int get count => _books.length;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get isEmpty => !_isLoading && _books.isEmpty;

  Future<void> load() async {
    _isLoading = true;
    _isLoadingMore = false;
    _errorMessage = null;
    _books.clear();
    _offset = 0;
    _hasMore = true;
    notifyListeners();

    try {
      final newBooks = await _libraryRepository.getLibraryBooks(offset: _offset, limit: _pageSize);
      _books.addAll(newBooks);
      _offset += newBooks.length;
      _hasMore = newBooks.length == _pageSize;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (_isLoading || _isLoadingMore || !_hasMore) {
      return;
    }

    _isLoadingMore = true;
    notifyListeners();

    try {
      final newBooks = await _libraryRepository.getLibraryBooks(offset: _offset, limit: _pageSize);
      if (newBooks.isNotEmpty) {
        _books.addAll(newBooks);
        _offset += newBooks.length;
        _hasMore = newBooks.length == _pageSize;
      } else {
        _hasMore = false;
      }
      _isLoadingMore = false;
      notifyListeners();
    } catch (e) {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  void refresh() {
    load();
  }
}
