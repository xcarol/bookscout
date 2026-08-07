// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'BookScout';

  @override
  String get catalan => 'Catalan';

  @override
  String get spanish => 'Spanish';

  @override
  String get english => 'English';

  @override
  String get selectLanguage => 'Select language';

  @override
  String get language => 'Language';

  @override
  String get settings => 'Settings';

  @override
  String get about => 'About';

  @override
  String get aboutDescription => 'BookScout is an application to organize and track your readings.';

  @override
  String get cancel => 'Cancel';

  @override
  String get select => 'Select';

  @override
  String get anonymousUser => 'Anonymous User';

  @override
  String get welcomeMessage => 'Welcome to BookScout';

  @override
  String get emptyBooksMessage => 'No books in the list';
}
