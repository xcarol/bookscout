class UrlConstants {
  // Google Books API
  static const String googleBooksApiAuthority = 'www.googleapis.com';
  static const String googleBooksApiPath = '/books/v1/volumes';
  static const String googleBooksApiBaseUrl =
      'https://$googleBooksApiAuthority$googleBooksApiPath';

  // OpenLibrary API
  static const String openLibraryApiAuthority = 'openlibrary.org';
  static const String openLibraryApiPath = '/search.json';
  static const String openLibraryApiBooksPath = '/api/books';
  static const String openLibraryBaseUrl = 'https://openlibrary.org';
  static const String openLibraryCoversBaseUrl =
      'https://covers.openlibrary.org/b/id/';

  // Templates
  static const String openLibraryCoverMediumTemplate =
      '$openLibraryCoversBaseUrl{ID}-M.jpg';
  static const String openLibraryCoverLargeTemplate =
      '$openLibraryCoversBaseUrl{ID}-L.jpg';

  // Repository & Web
  static const String githubRepoUrl = 'https://github.com/xcarol/bookscout';
}
