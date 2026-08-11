import 'package:drift/drift.dart' as drift;
import 'package:bookscout/database/app_database.dart' as db;
import 'package:bookscout/utils/url_constants.dart';

class Book {
  final String id;
  final String title;
  final String? subtitle;
  final String? originalTitle;
  final List<String> authors;
  final String? publisher;
  final String? publishedDate;
  final String? description;
  final String? isbn10;
  final String? isbn13;
  final int? pageCount;
  final List<String> categories;
  final double? averageRating;
  final int? ratingsCount;
  final String? coverUrl;
  final String? language;
  final String? previewLink;
  final String? infoLink;
  final DateTime? createdAt;

  final double? userRating;
  final String? readingStatus;
  final int? currentPage;
  final bool isFavorite;
  final bool isLite;

  const Book({
    required this.id,
    required this.title,
    this.subtitle,
    this.originalTitle,
    this.authors = const [],
    this.publisher,
    this.publishedDate,
    this.description,
    this.isbn10,
    this.isbn13,
    this.pageCount,
    this.categories = const [],
    this.averageRating,
    this.ratingsCount,
    this.coverUrl,
    this.language,
    this.previewLink,
    this.infoLink,
    this.createdAt,
    this.userRating,
    this.readingStatus,
    this.currentPage,
    this.isFavorite = false,
    this.isLite = false,
  });

  String get authorsFormatted {
    if (authors.isEmpty) return '';
    return authors.join(', ');
  }

  String? get publishedYear {
    if (publishedDate == null || publishedDate!.isEmpty) return null;
    final match = RegExp(r'\b\d{4}\b').firstMatch(publishedDate!);
    return match?.group(0);
  }

  bool get hasRating => averageRating != null && averageRating! > 0.0;

  String? get isbn => isbn13 ?? isbn10;

  factory Book.fromGoogleBooksJson(Map<String, dynamic> json, {bool isLite = false}) {
    final id = json['id'] as String? ?? '';
    final volumeInfo = json['volumeInfo'] as Map<String, dynamic>? ?? {};

    final title = volumeInfo['title'] as String? ?? '';
    final subtitle = volumeInfo['subtitle'] as String?;
    final publisher = volumeInfo['publisher'] as String?;
    final publishedDate = volumeInfo['publishedDate'] as String?;
    final description = volumeInfo['description'] as String?;
    final language = volumeInfo['language'] as String?;

    final authorsList =
        (volumeInfo['authors'] as List?)
            ?.map((author) => author.toString())
            .toList() ??
        const <String>[];

    final categoriesList =
        (volumeInfo['categories'] as List?)
            ?.map((cat) => cat.toString())
            .toList() ??
        const <String>[];

    int? pageCount;
    if (volumeInfo['pageCount'] is num) {
      pageCount = (volumeInfo['pageCount'] as num).toInt();
    }

    double? averageRating;
    if (volumeInfo['averageRating'] is num) {
      averageRating = (volumeInfo['averageRating'] as num).toDouble();
    }

    int? ratingsCount;
    if (volumeInfo['ratingsCount'] is num) {
      ratingsCount = (volumeInfo['ratingsCount'] as num).toInt();
    }

    String? isbn10;
    String? isbn13;
    final industryIdentifiers = volumeInfo['industryIdentifiers'] as List?;
    if (industryIdentifiers != null) {
      for (final item in industryIdentifiers) {
        if (item is Map<String, dynamic>) {
          final type = item['type'] as String?;
          final identifier = item['identifier'] as String?;
          if (type == 'ISBN_10') {
            isbn10 = identifier;
          } else if (type == 'ISBN_13') {
            isbn13 = identifier;
          }
        }
      }
    }

    String? coverUrl;
    final imageLinks = volumeInfo['imageLinks'] as Map<String, dynamic>?;
    if (imageLinks != null) {
      final rawCover =
          imageLinks['extraLarge'] ??
          imageLinks['large'] ??
          imageLinks['medium'] ??
          imageLinks['small'] ??
          imageLinks['thumbnail'] ??
          imageLinks['smallThumbnail'];

      coverUrl = (rawCover is String)
          ? rawCover
                .replaceFirst('http://', 'https://')
                .replaceAll('&edge=curl', '')
          : null;
    }

    return Book(
      id: id,
      title: title,
      subtitle: subtitle,
      authors: authorsList,
      publisher: publisher,
      publishedDate: publishedDate,
      description: description,
      isbn10: isbn10,
      isbn13: isbn13,
      pageCount: pageCount,
      categories: categoriesList,
      averageRating: averageRating,
      ratingsCount: ratingsCount,
      coverUrl: coverUrl,
      language: language,
      previewLink: volumeInfo['previewLink'] as String?,
      infoLink: volumeInfo['infoLink'] as String?,
      isLite: isLite,
    );
  }

  factory Book.fromOpenLibraryJson(Map<String, dynamic> json, {bool isLite = false}) {
    final key = json['key'] as String? ?? '';
    final id = key.replaceAll('/works/', '');
    final title = json['title'] as String? ?? '';

    final authorsList =
        (json['author_name'] as List?)
            ?.map((author) => author.toString())
            .toList() ??
        const <String>[];

    final firstPublishYear = json['first_publish_year']?.toString();
    final publisherList = (json['publisher'] as List?)
        ?.map((p) => p.toString())
        .toList();
    final publisher = publisherList?.isNotEmpty == true
        ? publisherList!.first
        : null;

    final isbns = (json['isbn'] as List?)?.map((i) => i.toString()).toList();
    String? isbn10;
    String? isbn13;
    if (isbns != null) {
      for (final isbn in isbns) {
        final clean = isbn.replaceAll('-', '').trim();
        if (clean.length == 10 && isbn10 == null) {
          isbn10 = clean;
        } else if (clean.length == 13 && isbn13 == null) {
          isbn13 = clean;
        }
      }
    }

    int? pageCount;
    if (json['number_of_pages_median'] is num) {
      pageCount = (json['number_of_pages_median'] as num).toInt();
    }

    double? averageRating;
    if (json['ratings_average'] is num) {
      averageRating = (json['ratings_average'] as num).toDouble();
    }

    int? ratingsCount;
    if (json['ratings_count'] is num) {
      ratingsCount = (json['ratings_count'] as num).toInt();
    }

    final coverId = json['cover_i'];
    String? coverUrl;
    if (coverId != null) {
      coverUrl = UrlConstants.openLibraryCoverMediumTemplate.replaceAll(
        '{ID}',
        coverId.toString(),
      );
    }

    final languageList = (json['language'] as List?)
        ?.map((l) => l.toString())
        .toList();
    final language = languageList?.isNotEmpty == true
        ? languageList!.first
        : null;

    return Book(
      id: id,
      title: title,
      authors: authorsList,
      publisher: publisher,
      publishedDate: firstPublishYear,
      isbn10: isbn10,
      isbn13: isbn13,
      pageCount: pageCount,
      averageRating: averageRating,
      ratingsCount: ratingsCount,
      coverUrl: coverUrl,
      language: language,
      isLite: isLite,
    );
  }

  factory Book.fromOpenLibraryDataJson(Map<String, dynamic> json) {
    final title = json['title'] as String? ?? '';
    final url = json['url'] as String?;
    final id = json['key']?.toString().replaceAll('/books/', '') ?? '';

    final authorsList = (json['authors'] as List?)
        ?.map((a) => (a as Map)['name'].toString())
        .toList() ?? const <String>[];

    final publishDate = json['publish_date']?.toString();
    final publishersList = (json['publishers'] as List?)
        ?.map((p) => (p as Map)['name'].toString())
        .toList();
    final publisher = publishersList?.isNotEmpty == true ? publishersList!.first : null;

    int? pageCount;
    if (json['number_of_pages'] is num) {
      pageCount = (json['number_of_pages'] as num).toInt();
    }

    final categoriesList = (json['subjects'] as List?)
        ?.map((s) => (s as Map)['name'].toString())
        .toList() ?? const <String>[];

    String? coverUrl;
    final cover = json['cover'] as Map?;
    if (cover != null) {
      coverUrl = cover['large'] ?? cover['medium'] ?? cover['small'];
    }

    return Book(
      id: id,
      title: title,
      authors: authorsList,
      publisher: publisher,
      publishedDate: publishDate,
      pageCount: pageCount,
      categories: categoriesList,
      coverUrl: coverUrl,
      infoLink: url,
    );
  }

  Book merge(Book other) {
    return copyWith(
      title: title.isEmpty ? other.title : title,
      subtitle: subtitle?.isNotEmpty == true ? subtitle : other.subtitle,
      originalTitle: originalTitle?.isNotEmpty == true ? originalTitle : other.originalTitle,
      authors: authors.isNotEmpty ? authors : other.authors,
      publisher: publisher?.isNotEmpty == true ? publisher : other.publisher,
      publishedDate: publishedDate?.isNotEmpty == true ? publishedDate : other.publishedDate,
      description: description?.isNotEmpty == true ? description : other.description,
      isbn10: isbn10?.isNotEmpty == true ? isbn10 : other.isbn10,
      isbn13: isbn13?.isNotEmpty == true ? isbn13 : other.isbn13,
      pageCount: (pageCount != null && pageCount! > 0) ? pageCount : other.pageCount,
      categories: categories.isNotEmpty ? categories : other.categories,
      averageRating: averageRating ?? other.averageRating,
      ratingsCount: ratingsCount ?? other.ratingsCount,
      coverUrl: coverUrl?.isNotEmpty == true ? coverUrl : other.coverUrl,
      language: language?.isNotEmpty == true ? language : other.language,
      previewLink: previewLink?.isNotEmpty == true ? previewLink : other.previewLink,
      infoLink: infoLink?.isNotEmpty == true ? infoLink : other.infoLink,
      createdAt: createdAt ?? other.createdAt,
      userRating: userRating ?? other.userRating,
      readingStatus: readingStatus ?? other.readingStatus,
      currentPage: currentPage ?? other.currentPage,
      isLite: false,
    );
  }

  db.BooksCompanion toCompanion() {
    return db.BooksCompanion(
      id: drift.Value(id),
      title: drift.Value(title),
      subtitle: drift.Value(subtitle),
      originalTitle: drift.Value(originalTitle),
      description: drift.Value(description),
      isbn10: drift.Value(isbn10),
      isbn13: drift.Value(isbn13),
      pageCount: drift.Value(pageCount),
      publisher: drift.Value(publisher),
      publishedDate: drift.Value(publishedDate),
      coverUrl: drift.Value(coverUrl),
      language: drift.Value(language),
      averageRating: drift.Value(averageRating),
      ratingsCount: drift.Value(ratingsCount),
      categories: drift.Value(
        categories.isNotEmpty ? categories.join(',') : null,
      ),
      previewLink: drift.Value(previewLink),
      infoLink: drift.Value(infoLink),
    );
  }

  factory Book.fromDrift(
    db.Book data, {
    List<String> authors = const [],
    double? averageRating,
    int? ratingsCount,
    double? userRating,
    String? readingStatus,
    int? currentPage,
    bool isFavorite = false,
    bool isLite = false,
  }) {
    return Book(
      id: data.id,
      title: data.title,
      subtitle: data.subtitle,
      originalTitle: data.originalTitle,
      authors: authors,
      publisher: data.publisher,
      publishedDate: data.publishedDate,
      description: data.description,
      isbn10: data.isbn10,
      isbn13: data.isbn13,
      pageCount: data.pageCount,
      categories: data.categories?.split(',') ?? const [],
      coverUrl: data.coverUrl,
      language: data.language,
      previewLink: data.previewLink,
      infoLink: data.infoLink,
      createdAt: data.createdAt,
      averageRating: averageRating ?? data.averageRating,
      ratingsCount: ratingsCount ?? data.ratingsCount,
      userRating: userRating,
      readingStatus: readingStatus,
      currentPage: currentPage,
      isFavorite: isFavorite,
      isLite: isLite,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'originalTitle': originalTitle,
      'authors': authors,
      'publisher': publisher,
      'publishedDate': publishedDate,
      'description': description,
      'isbn10': isbn10,
      'isbn13': isbn13,
      'pageCount': pageCount,
      'categories': categories,
      'averageRating': averageRating,
      'ratingsCount': ratingsCount,
      'coverUrl': coverUrl,
      'language': language,
      'previewLink': previewLink,
      'infoLink': infoLink,
      'createdAt': createdAt?.toIso8601String(),
      'userRating': userRating,
      'readingStatus': readingStatus,
      'currentPage': currentPage,
      'isFavorite': isFavorite,
      'isLite': isLite,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      subtitle: map['subtitle'] as String?,
      originalTitle: map['originalTitle'] as String?,
      authors:
          (map['authors'] as List?)?.map((e) => e.toString()).toList() ??
          const [],
      publisher: map['publisher'] as String?,
      publishedDate: map['publishedDate'] as String?,
      description: map['description'] as String?,
      isbn10: map['isbn10'] as String?,
      isbn13: map['isbn13'] as String?,
      pageCount: map['pageCount'] as int?,
      categories:
          (map['categories'] as List?)?.map((e) => e.toString()).toList() ??
          const [],
      averageRating: (map['averageRating'] as num?)?.toDouble(),
      ratingsCount: map['ratingsCount'] as int?,
      coverUrl: map['coverUrl'] as String?,
      language: map['language'] as String?,
      previewLink: map['previewLink'] as String?,
      infoLink: map['infoLink'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'] as String)
          : null,
      userRating: (map['userRating'] as num?)?.toDouble(),
      readingStatus: map['readingStatus'] as String?,
      currentPage: map['currentPage'] as int?,
      isFavorite: map['isFavorite'] as bool? ?? false,
      isLite: map['isLite'] as bool? ?? false,
    );
  }

  Book copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? originalTitle,
    List<String>? authors,
    String? publisher,
    String? publishedDate,
    String? description,
    String? isbn10,
    String? isbn13,
    int? pageCount,
    List<String>? categories,
    double? averageRating,
    int? ratingsCount,
    String? coverUrl,
    String? language,
    String? previewLink,
    String? infoLink,
    DateTime? createdAt,
    double? userRating,
    String? readingStatus,
    int? currentPage,
    bool? isFavorite,
    bool? isLite,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      originalTitle: originalTitle ?? this.originalTitle,
      authors: authors ?? this.authors,
      publisher: publisher ?? this.publisher,
      publishedDate: publishedDate ?? this.publishedDate,
      description: description ?? this.description,
      isbn10: isbn10 ?? this.isbn10,
      isbn13: isbn13 ?? this.isbn13,
      pageCount: pageCount ?? this.pageCount,
      categories: categories ?? this.categories,
      averageRating: averageRating ?? this.averageRating,
      ratingsCount: ratingsCount ?? this.ratingsCount,
      coverUrl: coverUrl ?? this.coverUrl,
      language: language ?? this.language,
      previewLink: previewLink ?? this.previewLink,
      infoLink: infoLink ?? this.infoLink,
      createdAt: createdAt ?? this.createdAt,
      userRating: userRating ?? this.userRating,
      readingStatus: readingStatus ?? this.readingStatus,
      currentPage: currentPage ?? this.currentPage,
      isFavorite: isFavorite ?? this.isFavorite,
      isLite: isLite ?? this.isLite,
    );
  }
}
