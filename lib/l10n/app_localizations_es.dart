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

  @override
  String get sessionInProgress => 'Sesión en curso';

  @override
  String get endSessionButton => 'FINALIZAR SESIÓN';

  @override
  String get endReadingSessionTitle => 'Finalizar Sesión de Lectura';

  @override
  String get errorEndTimeBeforeStart =>
      'La hora de fin no puede ser anterior a la de inicio.';

  @override
  String get errorInvalidPage => 'Número de página inválido.';

  @override
  String errorConflictReachedPage(String date, int page) {
    return 'Conflicto: La sesión del $date llegó a la página $page.';
  }

  @override
  String errorConflictStartedPage(String date, int page) {
    return 'Conflicto: La sesión del $date empezó en la página $page.';
  }

  @override
  String errorEndPageLessThanStart(int end, int start) {
    return 'La página final ($end) debe ser mayor que la inicial ($start).';
  }

  @override
  String get startLabel => 'Inicio:';

  @override
  String get endLabel => 'Fin:';

  @override
  String get locationLabel => 'Ubicación';

  @override
  String get pageReachedLabel => 'Página';

  @override
  String get save => 'Guardar';

  @override
  String get locationHome => 'Casa';

  @override
  String get locationBedroom => 'Habitación';

  @override
  String get locationLivingroom => 'Salón';

  @override
  String get locationTrain => 'Tren';

  @override
  String get locationBus => 'Autobús';

  @override
  String get locationPark => 'Parque';

  @override
  String get locationCafe => 'Cafetería';

  @override
  String get locationOther => 'Otro';

  @override
  String get missingDescription => 'No hay descripción disponible.';
}
