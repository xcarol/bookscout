// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'BookScout';

  @override
  String get catalan => 'Català';

  @override
  String get spanish => 'Español';

  @override
  String get english => 'English';

  @override
  String get selectLanguage => 'Selecciona el idioma';

  @override
  String get language => 'Idioma';

  @override
  String get settings => 'Ajustes';

  @override
  String get about => 'Acerca de';

  @override
  String get aboutDescription => 'BookScout es una aplicación para organizar y seguir tus lecturas.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get select => 'Seleccionar';

  @override
  String get anonymousUser => 'Usuario anónimo';

  @override
  String get welcomeMessage => 'Bienvenido a BookScout';

  @override
  String get emptyBooksMessage => 'No hay libros en la lista';
}
