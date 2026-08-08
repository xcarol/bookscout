import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:bookscout/models/book.dart';
import 'package:bookscout/services/api/google_books_service.dart';
import 'package:bookscout/services/core/error_service.dart';
import 'package:bookscout/utils/api_constants.dart';
import 'package:bookscout/utils/app_constants.dart';
import 'package:bookscout/utils/url_constants.dart';

class OpenLibraryService {
  static const String _authority = UrlConstants.openLibraryApiAuthority;
  static const String _unencodedPath = UrlConstants.openLibraryApiPath;
  static const Duration _timeout = Duration(
    seconds: AppConstants.openLibraryTimeoutSeconds,
  );

  final http.Client _client;

  OpenLibraryService({http.Client? client}) : _client = client ?? http.Client();

  /// Searches for books using the OpenLibrary API.
  Future<GoogleBooksSearchResult> searchBooks(
    String query, {
    int startIndex = 0,
    int maxResults = AppConstants.maxSearchBooks,
  }) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) {
      return GoogleBooksSearchResult.empty;
    }

    final page = (startIndex ~/ maxResults) + 1;
    final queryParameters = <String, String>{
      ApiConstants.q: cleanQuery,
      ApiConstants.limit: maxResults.toString(),
      ApiConstants.page: page.toString(),
    };

    final uri = Uri.https(_authority, _unencodedPath, queryParameters);

    try {
      final response = await _client
          .get(uri, headers: {HttpHeaders.acceptHeader: 'application/json'})
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final totalItems = (data[ApiConstants.numFound] as num?)?.toInt() ?? 0;
        final docs = data[ApiConstants.docs] as List<dynamic>? ?? [];

        final books = docs
            .whereType<Map<String, dynamic>>()
            .map((doc) => Book.fromOpenLibraryJson(doc))
            .where((b) => b.title.isNotEmpty)
            .toList();

        return GoogleBooksSearchResult(books: books, totalItems: totalItems);
      } else {
        throw HttpException(
          'OpenLibrary API error: HTTP ${response.statusCode}',
          uri: uri,
        );
      }
    } catch (e, stackTrace) {
      ErrorService.log(
        e,
        userMessage: 'Error searching OpenLibrary',
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
