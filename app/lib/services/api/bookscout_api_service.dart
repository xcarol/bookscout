import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:bookscout/models/book.dart';

import 'package:bookscout/utils/url_constants.dart';

class BookScoutApiService {
  Future<List<Book>> searchBooks(String query) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) return [];

    try {
      final uri = Uri.parse(
        '${UrlConstants.bffBaseUrl}/search?q=${Uri.encodeComponent(cleanQuery)}',
      );
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList
            .map((json) => Book.fromBffLiteJson(json as Map<String, dynamic>))
            .toList();
      } else {
        debugPrint(
          'API Error: ${response.statusCode} - Failed to load search results: ${response.body}',
        );
        return [];
      }
    } on SocketException catch (e) {
      debugPrint('Network connection error: $e');
      return [];
    } on TimeoutException catch (e) {
      debugPrint('Request timed out: $e');
      return [];
    } catch (e, stackTrace) {
      debugPrint('Failed to search books in BFF: $e\n$stackTrace');
      return [];
    }
  }

  Future<Book?> getBookDetails(String isbn) async {
    final cleanIsbn = isbn.trim().replaceAll('-', '');
    if (cleanIsbn.isEmpty) return null;

    try {
      final uri = Uri.parse('${UrlConstants.bffBaseUrl}/books/$isbn');
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonBody = json.decode(response.body);
        return Book.fromBffFullJson(jsonBody);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        debugPrint(
          'API Error: ${response.statusCode} - Failed to load book details: ${response.body}',
        );
        return null;
      }
    } on SocketException catch (e) {
      debugPrint('Network connection error: $e');
      return null;
    } on TimeoutException catch (e) {
      debugPrint('Request timed out: $e');
      return null;
    } catch (e, stackTrace) {
      debugPrint('Failed to fetch book details from BFF: $e\n$stackTrace');
      return null;
    }
  }
}
