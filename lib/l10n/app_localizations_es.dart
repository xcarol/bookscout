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
  String get appTagline => 'Organiza tus lecturas';

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
  String get aboutDescription =>
      'BookScout es una aplicación para organizar y seguir tus lecturas.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get select => 'Seleccionar';

  @override
  String get welcomeMessage => 'Bienvenido a BookScout';

  @override
  String get emptyBooksMessage => 'No hay libros en la lista';

  @override
  String get home => 'Inicio';

  @override
  String get search => 'Buscar';

  @override
  String get searchHint => 'Buscar libros por título, autor o ISBN...';

  @override
  String get clearSearch => 'Limpiar búsqueda';

  @override
  String get noBooksFound => 'No se encontraron libros';

  @override
  String get searchInitialPrompt => 'Escribe para empezar a buscar libros';

  @override
  String get searchHistory => 'Historial de búsqueda';

  @override
  String get unknownAuthor => 'Autor desconocido';

  @override
  String pagesCount(int count) {
    return '$count páginas';
  }

  @override
  String get searchError => 'Se produjo un error al buscar libros';

  @override
  String get searchTimeout => 'El tiempo de espera de la búsqueda ha expirado';

  @override
  String get retry => 'Reintentar';
}
