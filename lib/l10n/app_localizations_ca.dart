// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class AppLocalizationsCa extends AppLocalizations {
  AppLocalizationsCa([String locale = 'ca']) : super(locale);

  @override
  String get appTitle => 'BookScout';

  @override
  String get appTagline => 'Organitza les teves lectures';

  @override
  String get catalan => 'Català';

  @override
  String get spanish => 'Español';

  @override
  String get english => 'English';

  @override
  String get selectLanguage => 'Selecciona l\'idioma';

  @override
  String get language => 'Idioma';

  @override
  String get settings => 'Configuració';

  @override
  String get about => 'Quant a';

  @override
  String get aboutDescription =>
      'BookScout és una aplicació per organitzar i seguir les teves lectures.';

  @override
  String get cancel => 'Cancel·la';

  @override
  String get select => 'Selecciona';

  @override
  String get welcomeMessage => 'Benvingut a BookScout';

  @override
  String get emptyBooksMessage => 'No hi ha llibres a la llista';
}
