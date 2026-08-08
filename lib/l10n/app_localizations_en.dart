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
  String get appTagline => 'Track and organize your reading';

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
  String get aboutDescription =>
      'BookScout is an application to organize and track your readings.';

  @override
  String get cancel => 'Cancel';

  @override
  String get select => 'Select';

  @override
  String get welcomeMessage => 'Welcome to BookScout';

  @override
  String get emptyBooksMessage => 'No books in the list';

  @override
  String get home => 'Home';

  @override
  String get search => 'Search';

  @override
  String get searchHint => 'Search books by title, author, or ISBN...';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get noBooksFound => 'No books found';

  @override
  String get searchInitialPrompt => 'Type to start searching for books';

  @override
  String get searchHistory => 'Search history';

  @override
  String get unknownAuthor => 'Unknown author';

  @override
  String pagesCount(int count) {
    return '$count pages';
  }

  @override
  String get searchError => 'An error occurred while searching for books';

  @override
  String get searchTimeout => 'Search request timed out';

  @override
  String get retry => 'Retry';
}
