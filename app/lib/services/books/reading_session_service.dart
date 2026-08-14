import 'package:flutter/foundation.dart';
import 'package:bookscout/services/settings/preferences_service.dart';

class ReadingSessionService extends ChangeNotifier {
  static const String _activeBookIdKey = 'active_reading_session_book_id';
  static const String _startTimeKey = 'active_reading_session_start_time';
  static const String _locationKey = 'active_reading_session_location';

  String? _activeBookId;
  DateTime? _sessionStartTime;
  String? _sessionLocation;
  bool _isMinimized = false;

  String? get activeBookId => _activeBookId;
  DateTime? get sessionStartTime => _sessionStartTime;
  String? get sessionLocation => _sessionLocation;
  bool get isSessionActive => _activeBookId != null;
  bool get isMinimized => _isMinimized;

  void minimizeSession() {
    _isMinimized = true;
    notifyListeners();
  }

  void maximizeSession() {
    _isMinimized = false;
    notifyListeners();
  }

  ReadingSessionService() {
    _init();
  }

  void _init() {
    final prefs = PreferencesService().prefs;
    _activeBookId = prefs.getString(_activeBookIdKey);
    final startTimeStr = prefs.getString(_startTimeKey);
    if (startTimeStr != null) {
      _sessionStartTime = DateTime.tryParse(startTimeStr);
    }
    _sessionLocation = prefs.getString(_locationKey) ?? 'home';
  }

  Future<void> startSession(String bookId) async {
    final prefs = PreferencesService().prefs;
    final now = DateTime.now();

    await prefs.setString(_activeBookIdKey, bookId);
    await prefs.setString(_startTimeKey, now.toIso8601String());
    if (!prefs.containsKey(_locationKey)) {
      await prefs.setString(_locationKey, 'home');
      _sessionLocation = 'home';
    }

    _activeBookId = bookId;
    _sessionStartTime = now;
    _isMinimized = false;
    notifyListeners();
  }

  Future<void> updateLocation(String location) async {
    final prefs = PreferencesService().prefs;
    await prefs.setString(_locationKey, location);
    _sessionLocation = location;
    notifyListeners();
  }

  Future<void> endSession() async {
    final prefs = PreferencesService().prefs;
    await prefs.remove(_activeBookIdKey);
    await prefs.remove(_startTimeKey);
    // We intentionally keep _locationKey in prefs so it remembers the last used location!

    _activeBookId = null;
    _sessionStartTime = null;
    _isMinimized = false;
    notifyListeners();
  }
}
