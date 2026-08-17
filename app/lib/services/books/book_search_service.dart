import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:bookscout/models/book.dart';
import 'package:bookscout/models/search_filter.dart';
import 'package:bookscout/services/api/bookscout_api_service.dart';

class BookSearchService extends ChangeNotifier {
  final BookScoutApiService _apiService;

  final List<Book> _books = [];
  bool _isLoading = false;
  String _currentQuery = '';
  SearchFilter _currentFilter = SearchFilter.title;
  String? _errorMessage;

  BookSearchService({BookScoutApiService? apiService})
    : _apiService = apiService ?? BookScoutApiService();

  List<Book> get books => List.unmodifiable(_books);
  int get count => _books.length;
  bool get isLoading => _isLoading;
  String get currentQuery => _currentQuery;
  SearchFilter get currentFilter => _currentFilter;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get isEmpty => !_isLoading && _books.isEmpty && _currentQuery.isNotEmpty;

  Book? getItem(int index) {
    if (index >= 0 && index < _books.length) {
      return _books[index];
    }
    return null;
  }

  Future<void> search(
    String query, {
    String? langCode,
    SearchFilter filter = SearchFilter.title,
  }) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) {
      clear();
      return;
    }

    _currentQuery = cleanQuery;
    _currentFilter = filter;
    _isLoading = true;
    _errorMessage = null;
    _books.clear();
    notifyListeners();

    try {
      final books = await _apiService.searchBooks(cleanQuery);

      if (_currentQuery != cleanQuery) return;

      _books.addAll(books);
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

  void clear() {
    _books.clear();
    _currentQuery = '';
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}
