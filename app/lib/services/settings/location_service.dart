import 'package:flutter/material.dart';
import 'package:bookscout/services/settings/preferences_service.dart';

class LocationService extends ChangeNotifier {
  static const String _countryKey = 'selected_country';
  static const String _regionKey = 'selected_region';

  String? _currentCountry;
  String? _currentRegion;

  LocationService() {
    _loadLocation();
  }

  String? get currentCountry => _currentCountry;
  String? get currentRegion => _currentRegion;

  void _loadLocation() {
    final prefs = PreferencesService().prefs;
    _currentCountry = prefs.getString(_countryKey);
    _currentRegion = prefs.getString(_regionKey);
    notifyListeners();
  }

  Future<void> setLocation(String? country, String? region) async {
    final prefs = PreferencesService().prefs;

    if (country == null) {
      await prefs.remove(_countryKey);
      await prefs.remove(_regionKey);
    } else {
      await prefs.setString(_countryKey, country);
      if (region != null && region.isNotEmpty) {
        await prefs.setString(_regionKey, region);
      } else {
        await prefs.remove(_regionKey);
      }
    }

    _currentCountry = country;
    _currentRegion = (region != null && region.isNotEmpty) ? region : null;
    notifyListeners();
  }
}
