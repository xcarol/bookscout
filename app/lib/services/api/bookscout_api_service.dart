import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bookscout/services/core/error_service.dart';
import 'package:http/http.dart' as http;
import 'package:bookscout/models/book.dart';
import 'package:bookscout/models/availability_provider.dart';

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
        ErrorService.log(
          'API Error: ${response.statusCode} - Failed to load search results: ${response.body}',
          showSnackBar: true,
        );
        return [];
      }
    } on SocketException catch (e) {
      ErrorService.log('Network connection error: $e');
      return [];
    } on TimeoutException catch (e) {
      ErrorService.log('Request timed out: $e');
      return [];
    } catch (e, stackTrace) {
      ErrorService.log('Failed to search books in BFF: $e\n$stackTrace');
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
        ErrorService.log(
          'API Error: ${response.statusCode} - Failed to load book details: ${response.body}',
          showSnackBar: true,
        );
        return null;
      }
    } on SocketException catch (e) {
      ErrorService.log('Network connection error: $e');
      return null;
    } on TimeoutException catch (e) {
      ErrorService.log('Request timed out: $e');
      return null;
    } catch (e, stackTrace) {
      ErrorService.log(
        'Failed to fetch book details from BFF: $e\n$stackTrace',
      );
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getLocations() async {
    try {
      final uri = Uri.parse('${UrlConstants.bffBaseUrl}/locations');
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.cast<Map<String, dynamic>>();
      } else {
        ErrorService.log(
          'API Error: ${response.statusCode} - Failed to load locations: ${response.body}',
        );
        return [];
      }
    } catch (e, stackTrace) {
      ErrorService.log('Failed to fetch locations from BFF: $e\n$stackTrace');
      return [];
    }
  }

  Future<List<AvailabilityProvider>> getAvailability(
    String isbn, {
    required String? country,
    required String? region,
  }) async {
    if (country == null || country.isEmpty) {
      return [];
    }

    final cleanIsbn = isbn.trim().replaceAll('-', '');
    if (cleanIsbn.isEmpty) return [];

    try {
      var urlStr =
          '${UrlConstants.bffBaseUrl}/availability/$cleanIsbn?country=$country';
      if (region != null && region.isNotEmpty) {
        urlStr += '&region=${Uri.encodeComponent(region)}';
      }

      final uri = Uri.parse(urlStr);
      final response = await http.get(uri).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList
            .map(
              (json) =>
                  AvailabilityProvider.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      } else {
        ErrorService.log(
          'API Error: ${response.statusCode} - Failed to load availability: ${response.body}',
        );
        return [];
      }
    } on SocketException catch (e) {
      ErrorService.log('Network connection error: $e');
      return [];
    } on TimeoutException catch (e) {
      ErrorService.log('Request timed out: $e');
      return [];
    } catch (e, stackTrace) {
      ErrorService.log(
        'Failed to fetch availability from BFF: $e\n$stackTrace',
      );
      return [];
    }
  }
}
