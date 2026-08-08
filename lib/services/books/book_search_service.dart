import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:bookscout/models/book.dart';
import 'package:bookscout/services/api/google_books_service.dart';
import 'package:bookscout/utils/app_constants.dart';

class BookSearchService extends ChangeNotifier {
  final GoogleBooksService _apiService;
  static const int _pageSize = AppConstants.maxSearchBooks;

  final List<Book> _books = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = false;
  int _totalItems = 0;
  String _currentQuery = '';
  String? _errorMessage;
  int _nextStartIndex = 0;

  BookSearchService({GoogleBooksService? apiService})
    : _apiService = apiService ?? GoogleBooksService();

  List<Book> get books => List.unmodifiable(_books);
  int get count => _books.length;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  int get totalItems => _totalItems;
  String get currentQuery => _currentQuery;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get isEmpty => !_isLoading && _books.isEmpty && _currentQuery.isNotEmpty;

  Book? getItem(int index) {
    if (index >= 0 && index < _books.length) {
      return _books[index];
    }
    return null;
  }

  Future<void> search(String query, {String? langCode}) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) {
      clear();
      return;
    }

    _currentQuery = cleanQuery;
    _isLoading = true;
    _isLoadingMore = false;
    _errorMessage = null;
    _books.clear();
    _nextStartIndex = 0;
    _hasMore = false;
    _totalItems = 0;
    notifyListeners();

    try {
      final result = await _apiService.searchBooks(
        cleanQuery,
        startIndex: 0,
        maxResults: _pageSize,
        langRestrict: langCode,
      );

      if (_currentQuery != cleanQuery) return;

      _books.addAll(result.books);
      _totalItems = result.totalItems;
      _nextStartIndex = _books.length;
      _hasMore = _books.length < _totalItems && result.books.isNotEmpty;
      _isLoading = false;
      notifyListeners();
    } on TimeoutException {
      if (_currentQuery != cleanQuery) return;
      _isLoading = false;
      _errorMessage = 'TIMEOUT';
      notifyListeners();
    } catch (e) {
      if (_currentQuery != cleanQuery) return;
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> loadMore({String? langCode}) async {
    if (_isLoading || _isLoadingMore || !_hasMore || _currentQuery.isEmpty) {
      return;
    }

    _isLoadingMore = true;
    notifyListeners();

    try {
      final result = await _apiService.searchBooks(
        _currentQuery,
        startIndex: _nextStartIndex,
        maxResults: _pageSize,
        langRestrict: langCode,
      );

      if (result.books.isNotEmpty) {
        final existingIds = _books.map((b) => b.id).toSet();
        final newBooks = result.books
            .where((b) => !existingIds.contains(b.id))
            .toList();

        _books.addAll(newBooks);
        _nextStartIndex += result.books.length;
        _hasMore =
            _books.length < _totalItems && result.books.length >= _pageSize;
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

  void clear() {
    _books.clear();
    _currentQuery = '';
    _totalItems = 0;
    _nextStartIndex = 0;
    _hasMore = false;
    _errorMessage = null;
    _isLoading = false;
    _isLoadingMore = false;
    notifyListeners();
  }
}
