import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:bookscout/utils/app_constants.dart';

class UrlConstants {
  // BookScout BFF
  static String get bffBaseUrl {
    if (kReleaseMode) {
      final url = dotenv.env[AppConstants.backendUrl];
      if (url == null || url.isEmpty) {
        throw Exception(
          'BACKEND_URL is not set in .env file. Please check DEVELOP.md for instructions.',
        );
      }

      final cleanUrl = url.endsWith('/')
          ? url.substring(0, url.length - 1)
          : url;
      return '$cleanUrl/api';
    }
    if (kIsWeb) {
      return 'http://localhost:8080/api';
    }
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8080/api';
    }
    return 'http://localhost:8080/api';
  }

  // Repository & Web
  static const String githubRepoUrl = 'https://github.com/xcarol/bookscout';
}
