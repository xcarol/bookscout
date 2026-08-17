import 'package:drift/drift.dart' as drift;
import 'package:bookscout/database/app_database.dart' as db;

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

  factory Book.fromBffLiteJson(Map<String, dynamic> json) {
    final String id = json['isbn']?.toString() ?? '';
    final String title = json['title']?.toString() ?? '';
    final String? subtitle = json['subtitle']?.toString();

    final List<String> authors =
        (json['authors'] as List?)?.map((e) => e.toString()).toList() ??
        const [];

    final String? publisher = json['publisher']?.toString();
    final String? publishedYear = json['publishedYear']?.toString();

    int? pageCount;
    if (json['pageCount'] is num) {
      pageCount = (json['pageCount'] as num).toInt();
    }

    final List<String> categories =
        (json['categories'] as List?)?.map((e) => e.toString()).toList() ??
        const [];

    final String? coverUrl = json['coverUrl']?.toString();

    double? averageRating;
    if (json['averageRating'] is num) {
      averageRating = (json['averageRating'] as num).toDouble();
    }

    return Book(
      id: id,
      title: title,
      subtitle: subtitle,
      authors: authors,
      publisher: publisher,
      publishedDate: publishedYear,
      isbn10: id.length == 10 ? id : null,
      isbn13: id.length == 13 ? id : null,
      pageCount: pageCount,
      categories: categories,
      coverUrl: coverUrl,
      averageRating: averageRating,
      isLite: true,
    );
  }

  factory Book.fromBffFullJson(Map<String, dynamic> json) {
    final String id = json['isbn']?.toString() ?? '';
    final String title = json['title']?.toString() ?? '';
    final String? subtitle = json['subtitle']?.toString();
    final String? description = json['description']?.toString();

    final List<String> authors =
        (json['contributors'] as List?)
            ?.map((e) => (e as Map)['name']?.toString() ?? '')
            .where((name) => name.isNotEmpty)
            .toList() ??
        const [];

    final String? publisher = json['publisher']?.toString();
    final String? publishedDate = json['publishedDate']?.toString();
    final String? language = json['language']?.toString();

    int? pageCount;
    if (json['pageCount'] is num) {
      pageCount = (json['pageCount'] as num).toInt();
    }

    final List<String> categories =
        (json['categories'] as List?)?.map((e) => e.toString()).toList() ??
        const [];

    final String? coverUrl = json['coverUrl']?.toString();

    double? averageRating;
    if (json['averageRating'] is num) {
      averageRating = (json['averageRating'] as num).toDouble();
    }

    return Book(
      id: id,
      title: title,
      subtitle: subtitle,
      description: description,
      authors: authors,
      publisher: publisher,
      publishedDate: publishedDate,
      language: language,
      isbn10: id.length == 10 ? id : null,
      isbn13: id.length == 13 ? id : null,
      pageCount: pageCount,
      categories: categories,
      coverUrl: coverUrl,
      averageRating: averageRating,
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
