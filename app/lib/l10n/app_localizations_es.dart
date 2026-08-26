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
  String get aboutGithub => 'Visita el proyecto en ';

  @override
  String get apiDisclaimer =>
      'Este producto utiliza las APIs de Google Books y OpenLibrary entre otros, pero no está respaldado ni certificado por Google Books, OpenLibrary ni ningún otro proveedor de datos.';

  @override
  String get privacyDisclaimerPrefix => 'Consulta la ';

  @override
  String get privacyDisclaimer => 'política de privacidad';

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

  @override
  String get labelPages => 'Páginas';

  @override
  String get labelPublished => 'Publicación';

  @override
  String get labelPublisher => 'Editorial';

  @override
  String get labelGenres => 'Géneros';

  @override
  String get labelRating => 'Valoración';

  @override
  String get labelAuthors => 'Autores';

  @override
  String get confirmDeleteSession => 'Confirmar eliminación';

  @override
  String get confirmDeleteSessionMessage =>
      '¿Estás seguro de que quieres eliminar esta sesión?';

  @override
  String get noReadingSessions => 'No hay sesiones';

  @override
  String get actionDelete => 'Eliminar';

  @override
  String get searchFilterAll => 'Todos';

  @override
  String get searchFilterTitle => 'Título';

  @override
  String get searchFilterAuthor => 'Autor';

  @override
  String get searchFilterIsbn => 'ISBN';

  @override
  String get availability => 'Disponibilidad';

  @override
  String get country => 'País';

  @override
  String get region => 'Región';

  @override
  String get setLocation => 'Configurar ubicación';

  @override
  String get clearLocation => 'Borra la ubicación';

  @override
  String get backupSettings => 'Ajustes de copia de seguridad';

  @override
  String get backupFrequency => 'Frecuencia de copia de seguridad';

  @override
  String get backupFrequencyDaily => 'Diariamente';

  @override
  String get backupFrequencyWeekly => 'Semanalmente';

  @override
  String get backupFrequencyMonthly => 'Mensualmente';

  @override
  String get backupFrequencyDisabled => 'Desactivado';

  @override
  String get backupNow => 'Hacer copia ahora';

  @override
  String get restoreBackup => 'Restaurar copia';

  @override
  String get lastBackup => 'Última copia';

  @override
  String get noBackupFound => 'No se encontró copia de seguridad';

  @override
  String get backupSuccess => 'Copia de seguridad exitosa';

  @override
  String get backupError => 'Fallo al hacer copia de seguridad';

  @override
  String get restoreSuccess => 'Restauración exitosa';

  @override
  String get restoreError => 'Fallo al restaurar';

  @override
  String get restoreWarning =>
      'La restauración reemplazará todos los datos locales actuales con la copia de seguridad. ¿Estás seguro?';

  @override
  String get signInRequired => 'Se requiere iniciar sesión';

  @override
  String get googleDriveBackup => 'Copia de seguridad en Google Drive';

  @override
  String get signInGoogle => 'Iniciar sesión con Google';

  @override
  String get signOut => 'Cerrar sesión';
}
