import 'dart:io';
import 'package:flutter/foundation.dart';

class UrlConstants {
  // BookScout BFF
  static String get bffBaseUrl {
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
