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

  @override
  String get sessionInProgress => 'Session in progress';

  @override
  String get endSessionButton => 'END SESSION';

  @override
  String get endReadingSessionTitle => 'End Reading Session';

  @override
  String get errorEndTimeBeforeStart => 'End time cannot be before start time.';

  @override
  String get errorInvalidPage => 'Invalid page number.';

  @override
  String errorConflictReachedPage(String date, int page) {
    return 'Conflict: Session on $date reached page $page.';
  }

  @override
  String get startLabel => 'Start:';

  @override
  String get endLabel => 'End:';

  @override
  String get locationLabel => 'Location';

  @override
  String get pageReachedLabel => 'Page Reached';

  @override
  String get save => 'Save';

  @override
  String get locationHome => 'Home';

  @override
  String get locationBedroom => 'Bedroom';

  @override
  String get locationLivingroom => 'Living room';

  @override
  String get locationTrain => 'Train';

  @override
  String get locationBus => 'Bus';

  @override
  String get locationPark => 'Park';

  @override
  String get locationCafe => 'Cafe';

  @override
  String get locationOther => 'Other';

  @override
  String get missingDescription => 'No description available.';

  @override
  String get labelPages => 'Pages';

  @override
  String get labelPublished => 'Published';

  @override
  String get labelPublisher => 'Publisher';

  @override
  String get labelGenres => 'Genres';

  @override
  String get labelRating => 'Rating';

  @override
  String get labelAuthors => 'Authors';

  @override
  String get confirmDeleteSession => 'Confirm Delete';

  @override
  String get confirmDeleteSessionMessage =>
      'Are you sure you want to delete this session?';

  @override
  String get noReadingSessions => 'No sessions';

  @override
  String get actionDelete => 'Delete';

  @override
  String get searchFilterAll => 'All';

  @override
  String get searchFilterTitle => 'Title';

  @override
  String get searchFilterAuthor => 'Author';

  @override
  String get searchFilterIsbn => 'ISBN';
}
