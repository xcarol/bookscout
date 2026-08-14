import 'package:flutter/material.dart';
import 'package:bookscout/l10n/app_localizations.dart';

enum ReadingLocation {
  home,
  bedroom,
  livingroom,
  train,
  bus,
  park,
  cafe,
  other;

  IconData get icon {
    switch (this) {
      case ReadingLocation.home:
        return Icons.home_rounded;
      case ReadingLocation.bedroom:
        return Icons.bed_rounded;
      case ReadingLocation.livingroom:
        return Icons.weekend_rounded;
      case ReadingLocation.train:
        return Icons.train_rounded;
      case ReadingLocation.bus:
        return Icons.directions_bus_rounded;
      case ReadingLocation.park:
        return Icons.park_rounded;
      case ReadingLocation.cafe:
        return Icons.local_cafe_rounded;
      case ReadingLocation.other:
        return Icons.place_rounded;
    }
  }

  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case ReadingLocation.home:
        return l10n.locationHome;
      case ReadingLocation.bedroom:
        return l10n.locationBedroom;
      case ReadingLocation.livingroom:
        return l10n.locationLivingroom;
      case ReadingLocation.train:
        return l10n.locationTrain;
      case ReadingLocation.bus:
        return l10n.locationBus;
      case ReadingLocation.park:
        return l10n.locationPark;
      case ReadingLocation.cafe:
        return l10n.locationCafe;
      case ReadingLocation.other:
        return l10n.locationOther;
    }
  }

  static ReadingLocation fromString(String name) {
    return ReadingLocation.values.firstWhere(
      (e) => e.name == name,
      orElse: () => ReadingLocation.other,
    );
  }
}
