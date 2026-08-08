import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:bookscout/models/book.dart';
import 'package:bookscout/services/api/open_library_service.dart';
import 'package:bookscout/services/core/error_service.dart';
import 'package:bookscout/utils/api_constants.dart';
import 'package:bookscout/utils/app_constants.dart';
import 'package:bookscout/utils/url_constants.dart';

class GoogleBooksSearchResult {
  final List<Book> books;
  final int totalItems;

  const GoogleBooksSearchResult({
    required this.books,
    required this.totalItems,
  });

  static const empty = GoogleBooksSearchResult(books: [], totalItems: 0);
}

class GoogleBooksService {
  static const String _authority = UrlConstants.googleBooksApiAuthority;
  static const String _unencodedPath = UrlConstants.googleBooksApiPath;
  static const Duration _timeout = Duration(
    seconds: AppConstants.apiTimeoutSeconds,
  );

  final http.Client _client;
  final OpenLibraryService? openLibraryFallback;

  GoogleBooksService({http.Client? client, this.openLibraryFallback})
    : _client = client ?? http.Client();

  OpenLibraryService get _fallbackService =>
      openLibraryFallback ?? OpenLibraryService(client: _client);

  /// Searches for books using the Google Books API.
  /// Requires [AppConstants.googleBooksApiKey] to be set in .env.
  /// Falls back to OpenLibrary API if HTTP 429 (quota / rate limit exceeded) is returned.
  Future<GoogleBooksSearchResult> searchBooks(
    String query, {
    int startIndex = 0,
    int maxResults = AppConstants.maxSearchBooks,
    String? langRestrict,
  }) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) {
      return GoogleBooksSearchResult.empty;
    }

    final apiKey = dotenv.env[AppConstants.googleBooksApiKey];
    if (apiKey == null || apiKey.isEmpty) {
      ErrorService.log(
        '${AppConstants.googleBooksApiKey} is not set in .env',
        userMessage: '${AppConstants.googleBooksApiKey} is missing',
      );
      return GoogleBooksSearchResult.empty;
    }

    final queryParameters = <String, String>{
      ApiConstants.q: cleanQuery,
      ApiConstants.startIndex: startIndex.toString(),
      ApiConstants.maxResults: maxResults.toString(),
      ApiConstants.printType: ApiConstants.books,
      ApiConstants.projection: ApiConstants.full,
      ApiConstants.key: apiKey,
    };

    if (langRestrict != null && langRestrict.isNotEmpty) {
      queryParameters[ApiConstants.langRestrict] = langRestrict;
    }

    final uri = Uri.https(_authority, _unencodedPath, queryParameters);

    try {
      var response = await _client
          .get(
            uri,
            headers: {
              HttpHeaders.acceptHeader: 'application/json',
              HttpHeaders.contentTypeHeader: 'application/json',
            },
          )
          .timeout(_timeout);

      // If transient server error (500, 502, 503, 504), retry once after a short delay
      if (response.statusCode >= 500 && response.statusCode < 600) {
        await Future.delayed(const Duration(milliseconds: 600));
        response = await _client
            .get(
              uri,
              headers: {
                HttpHeaders.acceptHeader: 'application/json',
                HttpHeaders.contentTypeHeader: 'application/json',
              },
            )
            .timeout(_timeout);
      }

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final totalItems =
            (data[ApiConstants.totalItems] as num?)?.toInt() ?? 0;
        final items = data[ApiConstants.items] as List<dynamic>? ?? [];

        final books = items
            .whereType<Map<String, dynamic>>()
            .map((item) => Book.fromGoogleBooksJson(item))
            .where((b) => b.title.isNotEmpty)
            .toList();

        return GoogleBooksSearchResult(books: books, totalItems: totalItems);
      } else if (response.statusCode == 429 ||
          (response.statusCode >= 500 && response.statusCode < 600)) {
        ErrorService.log(
          'Google Books API unavailable (HTTP ${response.statusCode}). Falling back to OpenLibrary API.',
          reportToCrashlytics: false,
        );
        return await _fallbackService.searchBooks(
          cleanQuery,
          startIndex: startIndex,
          maxResults: maxResults,
        );
      } else {
        final errorMsg =
            'Google Books API error: HTTP ${response.statusCode} - ${response.reasonPhrase}';
        throw HttpException(errorMsg, uri: uri);
      }
    } on TimeoutException catch (e, stackTrace) {
      ErrorService.log(
        e,
        userMessage: 'Timeout searching Google Books',
        stackTrace: stackTrace,
      );
      rethrow;
    } on SocketException catch (e, stackTrace) {
      ErrorService.log(
        e,
        userMessage: 'Network error searching Google Books',
        stackTrace: stackTrace,
      );
      rethrow;
    } catch (e, stackTrace) {
      ErrorService.log(
        e,
        userMessage: 'Error searching Google Books',
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Retrieves full metadata for a specific volume by its ID.
  /// Requires [AppConstants.googleBooksApiKey] to be set in .env.
  Future<Book?> getBookById(String volumeId) async {
    final cleanId = volumeId.trim();
    if (cleanId.isEmpty) return null;

    final apiKey = dotenv.env[AppConstants.googleBooksApiKey];
    if (apiKey == null || apiKey.isEmpty) {
      ErrorService.log(
        '${AppConstants.googleBooksApiKey} is not set in .env',
        userMessage: '${AppConstants.googleBooksApiKey} is missing',
      );
      return null;
    }

    final queryParameters = <String, String>{ApiConstants.key: apiKey};

    final uri = Uri.https(
      _authority,
      '$_unencodedPath/$cleanId',
      queryParameters,
    );

    try {
      var response = await _client
          .get(uri, headers: {HttpHeaders.acceptHeader: 'application/json'})
          .timeout(_timeout);

      // If transient server error (500, 502, 503, 504), retry once
      if (response.statusCode >= 500 && response.statusCode < 600) {
        await Future.delayed(const Duration(milliseconds: 600));
        response = await _client
            .get(uri, headers: {HttpHeaders.acceptHeader: 'application/json'})
            .timeout(_timeout);
      }

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return Book.fromGoogleBooksJson(data);
      }
      return null;
    } catch (e, stackTrace) {
      ErrorService.log(
        e,
        userMessage: 'Error fetching book details for $volumeId',
        stackTrace: stackTrace,
      );
      return null;
    }
  }
}
