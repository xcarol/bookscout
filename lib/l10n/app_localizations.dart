import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ca.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ca'),
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'BookScout'**
  String get appTitle;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Track and organize your reading'**
  String get appTagline;

  /// No description provided for @catalan.
  ///
  /// In en, this message translates to:
  /// **'Catalan'**
  String get catalan;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get selectLanguage;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @aboutDescription.
  ///
  /// In en, this message translates to:
  /// **'BookScout is an application to organize and track your readings.'**
  String get aboutDescription;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to BookScout'**
  String get welcomeMessage;

  /// No description provided for @emptyBooksMessage.
  ///
  /// In en, this message translates to:
  /// **'No books in the list'**
  String get emptyBooksMessage;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search books by title, author, or ISBN...'**
  String get searchHint;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearch;

  /// No description provided for @noBooksFound.
  ///
  /// In en, this message translates to:
  /// **'No books found'**
  String get noBooksFound;

  /// No description provided for @searchInitialPrompt.
  ///
  /// In en, this message translates to:
  /// **'Type to start searching for books'**
  String get searchInitialPrompt;

  /// No description provided for @searchHistory.
  ///
  /// In en, this message translates to:
  /// **'Search history'**
  String get searchHistory;

  /// No description provided for @unknownAuthor.
  ///
  /// In en, this message translates to:
  /// **'Unknown author'**
  String get unknownAuthor;

  /// No description provided for @pagesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} pages'**
  String pagesCount(int count);

  /// No description provided for @searchError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while searching for books'**
  String get searchError;

  /// No description provided for @searchTimeout.
  ///
  /// In en, this message translates to:
  /// **'Search request timed out'**
  String get searchTimeout;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @sessionInProgress.
  ///
  /// In en, this message translates to:
  /// **'Session in progress'**
  String get sessionInProgress;

  /// No description provided for @endSessionButton.
  ///
  /// In en, this message translates to:
  /// **'END SESSION'**
  String get endSessionButton;

  /// No description provided for @endReadingSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'End Reading Session'**
  String get endReadingSessionTitle;

  /// No description provided for @errorEndTimeBeforeStart.
  ///
  /// In en, this message translates to:
  /// **'End time cannot be before start time.'**
  String get errorEndTimeBeforeStart;

  /// No description provided for @errorInvalidPage.
  ///
  /// In en, this message translates to:
  /// **'Invalid page number.'**
  String get errorInvalidPage;

  /// No description provided for @errorConflictReachedPage.
  ///
  /// In en, this message translates to:
  /// **'Conflict: Session on {date} reached page {page}.'**
  String errorConflictReachedPage(String date, int page);

  /// No description provided for @errorConflictStartedPage.
  ///
  /// In en, this message translates to:
  /// **'Conflict: Session on {date} started at page {page}.'**
  String errorConflictStartedPage(String date, int page);

  /// No description provided for @errorEndPageLessThanStart.
  ///
  /// In en, this message translates to:
  /// **'End page ({end}) cannot be less than start page ({start}).'**
  String errorEndPageLessThanStart(int end, int start);

  /// No description provided for @startLabel.
  ///
  /// In en, this message translates to:
  /// **'Start:'**
  String get startLabel;

  /// No description provided for @endLabel.
  ///
  /// In en, this message translates to:
  /// **'End:'**
  String get endLabel;

  /// No description provided for @locationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationLabel;

  /// No description provided for @pageReachedLabel.
  ///
  /// In en, this message translates to:
  /// **'Page Reached'**
  String get pageReachedLabel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @locationHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get locationHome;

  /// No description provided for @locationBedroom.
  ///
  /// In en, this message translates to:
  /// **'Bedroom'**
  String get locationBedroom;

  /// No description provided for @locationLivingroom.
  ///
  /// In en, this message translates to:
  /// **'Living room'**
  String get locationLivingroom;

  /// No description provided for @locationTrain.
  ///
  /// In en, this message translates to:
  /// **'Train'**
  String get locationTrain;

  /// No description provided for @locationBus.
  ///
  /// In en, this message translates to:
  /// **'Bus'**
  String get locationBus;

  /// No description provided for @locationPark.
  ///
  /// In en, this message translates to:
  /// **'Park'**
  String get locationPark;

  /// No description provided for @locationCafe.
  ///
  /// In en, this message translates to:
  /// **'Cafe'**
  String get locationCafe;

  /// No description provided for @locationOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get locationOther;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ca', 'en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ca':
      return AppLocalizationsCa();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
