// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AuthorsTable extends Authors with TableInfo<$AuthorsTable, Author> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuthorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 500,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bioMeta = const VerificationMeta('bio');
  @override
  late final GeneratedColumn<String> bio = GeneratedColumn<String>(
    'bio',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoUrlMeta = const VerificationMeta(
    'photoUrl',
  );
  @override
  late final GeneratedColumn<String> photoUrl = GeneratedColumn<String>(
    'photo_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, bio, photoUrl, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'authors';
  @override
  VerificationContext validateIntegrity(
    Insertable<Author> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('bio')) {
      context.handle(
        _bioMeta,
        bio.isAcceptableOrUnknown(data['bio']!, _bioMeta),
      );
    }
    if (data.containsKey('photo_url')) {
      context.handle(
        _photoUrlMeta,
        photoUrl.isAcceptableOrUnknown(data['photo_url']!, _photoUrlMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Author map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Author(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      bio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bio'],
      ),
      photoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_url'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AuthorsTable createAlias(String alias) {
    return $AuthorsTable(attachedDatabase, alias);
  }
}

class Author extends DataClass implements Insertable<Author> {
  final String id;
  final String name;
  final String? bio;
  final String? photoUrl;
  final DateTime createdAt;
  const Author({
    required this.id,
    required this.name,
    this.bio,
    this.photoUrl,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || bio != null) {
      map['bio'] = Variable<String>(bio);
    }
    if (!nullToAbsent || photoUrl != null) {
      map['photo_url'] = Variable<String>(photoUrl);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AuthorsCompanion toCompanion(bool nullToAbsent) {
    return AuthorsCompanion(
      id: Value(id),
      name: Value(name),
      bio: bio == null && nullToAbsent ? const Value.absent() : Value(bio),
      photoUrl: photoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(photoUrl),
      createdAt: Value(createdAt),
    );
  }

  factory Author.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Author(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      bio: serializer.fromJson<String?>(json['bio']),
      photoUrl: serializer.fromJson<String?>(json['photoUrl']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'bio': serializer.toJson<String?>(bio),
      'photoUrl': serializer.toJson<String?>(photoUrl),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Author copyWith({
    String? id,
    String? name,
    Value<String?> bio = const Value.absent(),
    Value<String?> photoUrl = const Value.absent(),
    DateTime? createdAt,
  }) => Author(
    id: id ?? this.id,
    name: name ?? this.name,
    bio: bio.present ? bio.value : this.bio,
    photoUrl: photoUrl.present ? photoUrl.value : this.photoUrl,
    createdAt: createdAt ?? this.createdAt,
  );
  Author copyWithCompanion(AuthorsCompanion data) {
    return Author(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      bio: data.bio.present ? data.bio.value : this.bio,
      photoUrl: data.photoUrl.present ? data.photoUrl.value : this.photoUrl,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Author(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('bio: $bio, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, bio, photoUrl, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Author &&
          other.id == this.id &&
          other.name == this.name &&
          other.bio == this.bio &&
          other.photoUrl == this.photoUrl &&
          other.createdAt == this.createdAt);
}

class AuthorsCompanion extends UpdateCompanion<Author> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> bio;
  final Value<String?> photoUrl;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const AuthorsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.bio = const Value.absent(),
    this.photoUrl = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AuthorsCompanion.insert({
    required String id,
    required String name,
    this.bio = const Value.absent(),
    this.photoUrl = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<Author> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? bio,
    Expression<String>? photoUrl,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (bio != null) 'bio': bio,
      if (photoUrl != null) 'photo_url': photoUrl,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AuthorsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? bio,
    Value<String?>? photoUrl,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return AuthorsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (bio.present) {
      map['bio'] = Variable<String>(bio.value);
    }
    if (photoUrl.present) {
      map['photo_url'] = Variable<String>(photoUrl.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuthorsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('bio: $bio, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BooksTable extends Books with TableInfo<$BooksTable, Book> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BooksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 1000,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subtitleMeta = const VerificationMeta(
    'subtitle',
  );
  @override
  late final GeneratedColumn<String> subtitle = GeneratedColumn<String>(
    'subtitle',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _originalTitleMeta = const VerificationMeta(
    'originalTitle',
  );
  @override
  late final GeneratedColumn<String> originalTitle = GeneratedColumn<String>(
    'original_title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isbn10Meta = const VerificationMeta('isbn10');
  @override
  late final GeneratedColumn<String> isbn10 = GeneratedColumn<String>(
    'isbn10',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isbn13Meta = const VerificationMeta('isbn13');
  @override
  late final GeneratedColumn<String> isbn13 = GeneratedColumn<String>(
    'isbn13',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pageCountMeta = const VerificationMeta(
    'pageCount',
  );
  @override
  late final GeneratedColumn<int> pageCount = GeneratedColumn<int>(
    'page_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _publisherMeta = const VerificationMeta(
    'publisher',
  );
  @override
  late final GeneratedColumn<String> publisher = GeneratedColumn<String>(
    'publisher',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _publishedDateMeta = const VerificationMeta(
    'publishedDate',
  );
  @override
  late final GeneratedColumn<String> publishedDate = GeneratedColumn<String>(
    'published_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _coverUrlMeta = const VerificationMeta(
    'coverUrl',
  );
  @override
  late final GeneratedColumn<String> coverUrl = GeneratedColumn<String>(
    'cover_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _averageRatingMeta = const VerificationMeta(
    'averageRating',
  );
  @override
  late final GeneratedColumn<double> averageRating = GeneratedColumn<double>(
    'average_rating',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ratingsCountMeta = const VerificationMeta(
    'ratingsCount',
  );
  @override
  late final GeneratedColumn<int> ratingsCount = GeneratedColumn<int>(
    'ratings_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoriesMeta = const VerificationMeta(
    'categories',
  );
  @override
  late final GeneratedColumn<String> categories = GeneratedColumn<String>(
    'categories',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _previewLinkMeta = const VerificationMeta(
    'previewLink',
  );
  @override
  late final GeneratedColumn<String> previewLink = GeneratedColumn<String>(
    'preview_link',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _infoLinkMeta = const VerificationMeta(
    'infoLink',
  );
  @override
  late final GeneratedColumn<String> infoLink = GeneratedColumn<String>(
    'info_link',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    subtitle,
    originalTitle,
    description,
    isbn10,
    isbn13,
    pageCount,
    publisher,
    publishedDate,
    coverUrl,
    language,
    averageRating,
    ratingsCount,
    categories,
    previewLink,
    infoLink,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'books';
  @override
  VerificationContext validateIntegrity(
    Insertable<Book> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('subtitle')) {
      context.handle(
        _subtitleMeta,
        subtitle.isAcceptableOrUnknown(data['subtitle']!, _subtitleMeta),
      );
    }
    if (data.containsKey('original_title')) {
      context.handle(
        _originalTitleMeta,
        originalTitle.isAcceptableOrUnknown(
          data['original_title']!,
          _originalTitleMeta,
        ),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('isbn10')) {
      context.handle(
        _isbn10Meta,
        isbn10.isAcceptableOrUnknown(data['isbn10']!, _isbn10Meta),
      );
    }
    if (data.containsKey('isbn13')) {
      context.handle(
        _isbn13Meta,
        isbn13.isAcceptableOrUnknown(data['isbn13']!, _isbn13Meta),
      );
    }
    if (data.containsKey('page_count')) {
      context.handle(
        _pageCountMeta,
        pageCount.isAcceptableOrUnknown(data['page_count']!, _pageCountMeta),
      );
    }
    if (data.containsKey('publisher')) {
      context.handle(
        _publisherMeta,
        publisher.isAcceptableOrUnknown(data['publisher']!, _publisherMeta),
      );
    }
    if (data.containsKey('published_date')) {
      context.handle(
        _publishedDateMeta,
        publishedDate.isAcceptableOrUnknown(
          data['published_date']!,
          _publishedDateMeta,
        ),
      );
    }
    if (data.containsKey('cover_url')) {
      context.handle(
        _coverUrlMeta,
        coverUrl.isAcceptableOrUnknown(data['cover_url']!, _coverUrlMeta),
      );
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    }
    if (data.containsKey('average_rating')) {
      context.handle(
        _averageRatingMeta,
        averageRating.isAcceptableOrUnknown(
          data['average_rating']!,
          _averageRatingMeta,
        ),
      );
    }
    if (data.containsKey('ratings_count')) {
      context.handle(
        _ratingsCountMeta,
        ratingsCount.isAcceptableOrUnknown(
          data['ratings_count']!,
          _ratingsCountMeta,
        ),
      );
    }
    if (data.containsKey('categories')) {
      context.handle(
        _categoriesMeta,
        categories.isAcceptableOrUnknown(data['categories']!, _categoriesMeta),
      );
    }
    if (data.containsKey('preview_link')) {
      context.handle(
        _previewLinkMeta,
        previewLink.isAcceptableOrUnknown(
          data['preview_link']!,
          _previewLinkMeta,
        ),
      );
    }
    if (data.containsKey('info_link')) {
      context.handle(
        _infoLinkMeta,
        infoLink.isAcceptableOrUnknown(data['info_link']!, _infoLinkMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Book map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Book(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      subtitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subtitle'],
      ),
      originalTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_title'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      isbn10: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}isbn10'],
      ),
      isbn13: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}isbn13'],
      ),
      pageCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page_count'],
      ),
      publisher: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}publisher'],
      ),
      publishedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}published_date'],
      ),
      coverUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_url'],
      ),
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      ),
      averageRating: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}average_rating'],
      ),
      ratingsCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ratings_count'],
      ),
      categories: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}categories'],
      ),
      previewLink: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preview_link'],
      ),
      infoLink: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}info_link'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BooksTable createAlias(String alias) {
    return $BooksTable(attachedDatabase, alias);
  }
}

class Book extends DataClass implements Insertable<Book> {
  final String id;
  final String title;
  final String? subtitle;
  final String? originalTitle;
  final String? description;
  final String? isbn10;
  final String? isbn13;
  final int? pageCount;
  final String? publisher;
  final String? publishedDate;
  final String? coverUrl;
  final String? language;
  final double? averageRating;
  final int? ratingsCount;
  final String? categories;
  final String? previewLink;
  final String? infoLink;
  final DateTime createdAt;
  const Book({
    required this.id,
    required this.title,
    this.subtitle,
    this.originalTitle,
    this.description,
    this.isbn10,
    this.isbn13,
    this.pageCount,
    this.publisher,
    this.publishedDate,
    this.coverUrl,
    this.language,
    this.averageRating,
    this.ratingsCount,
    this.categories,
    this.previewLink,
    this.infoLink,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || subtitle != null) {
      map['subtitle'] = Variable<String>(subtitle);
    }
    if (!nullToAbsent || originalTitle != null) {
      map['original_title'] = Variable<String>(originalTitle);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || isbn10 != null) {
      map['isbn10'] = Variable<String>(isbn10);
    }
    if (!nullToAbsent || isbn13 != null) {
      map['isbn13'] = Variable<String>(isbn13);
    }
    if (!nullToAbsent || pageCount != null) {
      map['page_count'] = Variable<int>(pageCount);
    }
    if (!nullToAbsent || publisher != null) {
      map['publisher'] = Variable<String>(publisher);
    }
    if (!nullToAbsent || publishedDate != null) {
      map['published_date'] = Variable<String>(publishedDate);
    }
    if (!nullToAbsent || coverUrl != null) {
      map['cover_url'] = Variable<String>(coverUrl);
    }
    if (!nullToAbsent || language != null) {
      map['language'] = Variable<String>(language);
    }
    if (!nullToAbsent || averageRating != null) {
      map['average_rating'] = Variable<double>(averageRating);
    }
    if (!nullToAbsent || ratingsCount != null) {
      map['ratings_count'] = Variable<int>(ratingsCount);
    }
    if (!nullToAbsent || categories != null) {
      map['categories'] = Variable<String>(categories);
    }
    if (!nullToAbsent || previewLink != null) {
      map['preview_link'] = Variable<String>(previewLink);
    }
    if (!nullToAbsent || infoLink != null) {
      map['info_link'] = Variable<String>(infoLink);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BooksCompanion toCompanion(bool nullToAbsent) {
    return BooksCompanion(
      id: Value(id),
      title: Value(title),
      subtitle: subtitle == null && nullToAbsent
          ? const Value.absent()
          : Value(subtitle),
      originalTitle: originalTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(originalTitle),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      isbn10: isbn10 == null && nullToAbsent
          ? const Value.absent()
          : Value(isbn10),
      isbn13: isbn13 == null && nullToAbsent
          ? const Value.absent()
          : Value(isbn13),
      pageCount: pageCount == null && nullToAbsent
          ? const Value.absent()
          : Value(pageCount),
      publisher: publisher == null && nullToAbsent
          ? const Value.absent()
          : Value(publisher),
      publishedDate: publishedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(publishedDate),
      coverUrl: coverUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(coverUrl),
      language: language == null && nullToAbsent
          ? const Value.absent()
          : Value(language),
      averageRating: averageRating == null && nullToAbsent
          ? const Value.absent()
          : Value(averageRating),
      ratingsCount: ratingsCount == null && nullToAbsent
          ? const Value.absent()
          : Value(ratingsCount),
      categories: categories == null && nullToAbsent
          ? const Value.absent()
          : Value(categories),
      previewLink: previewLink == null && nullToAbsent
          ? const Value.absent()
          : Value(previewLink),
      infoLink: infoLink == null && nullToAbsent
          ? const Value.absent()
          : Value(infoLink),
      createdAt: Value(createdAt),
    );
  }

  factory Book.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Book(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      subtitle: serializer.fromJson<String?>(json['subtitle']),
      originalTitle: serializer.fromJson<String?>(json['originalTitle']),
      description: serializer.fromJson<String?>(json['description']),
      isbn10: serializer.fromJson<String?>(json['isbn10']),
      isbn13: serializer.fromJson<String?>(json['isbn13']),
      pageCount: serializer.fromJson<int?>(json['pageCount']),
      publisher: serializer.fromJson<String?>(json['publisher']),
      publishedDate: serializer.fromJson<String?>(json['publishedDate']),
      coverUrl: serializer.fromJson<String?>(json['coverUrl']),
      language: serializer.fromJson<String?>(json['language']),
      averageRating: serializer.fromJson<double?>(json['averageRating']),
      ratingsCount: serializer.fromJson<int?>(json['ratingsCount']),
      categories: serializer.fromJson<String?>(json['categories']),
      previewLink: serializer.fromJson<String?>(json['previewLink']),
      infoLink: serializer.fromJson<String?>(json['infoLink']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'subtitle': serializer.toJson<String?>(subtitle),
      'originalTitle': serializer.toJson<String?>(originalTitle),
      'description': serializer.toJson<String?>(description),
      'isbn10': serializer.toJson<String?>(isbn10),
      'isbn13': serializer.toJson<String?>(isbn13),
      'pageCount': serializer.toJson<int?>(pageCount),
      'publisher': serializer.toJson<String?>(publisher),
      'publishedDate': serializer.toJson<String?>(publishedDate),
      'coverUrl': serializer.toJson<String?>(coverUrl),
      'language': serializer.toJson<String?>(language),
      'averageRating': serializer.toJson<double?>(averageRating),
      'ratingsCount': serializer.toJson<int?>(ratingsCount),
      'categories': serializer.toJson<String?>(categories),
      'previewLink': serializer.toJson<String?>(previewLink),
      'infoLink': serializer.toJson<String?>(infoLink),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Book copyWith({
    String? id,
    String? title,
    Value<String?> subtitle = const Value.absent(),
    Value<String?> originalTitle = const Value.absent(),
    Value<String?> description = const Value.absent(),
    Value<String?> isbn10 = const Value.absent(),
    Value<String?> isbn13 = const Value.absent(),
    Value<int?> pageCount = const Value.absent(),
    Value<String?> publisher = const Value.absent(),
    Value<String?> publishedDate = const Value.absent(),
    Value<String?> coverUrl = const Value.absent(),
    Value<String?> language = const Value.absent(),
    Value<double?> averageRating = const Value.absent(),
    Value<int?> ratingsCount = const Value.absent(),
    Value<String?> categories = const Value.absent(),
    Value<String?> previewLink = const Value.absent(),
    Value<String?> infoLink = const Value.absent(),
    DateTime? createdAt,
  }) => Book(
    id: id ?? this.id,
    title: title ?? this.title,
    subtitle: subtitle.present ? subtitle.value : this.subtitle,
    originalTitle: originalTitle.present
        ? originalTitle.value
        : this.originalTitle,
    description: description.present ? description.value : this.description,
    isbn10: isbn10.present ? isbn10.value : this.isbn10,
    isbn13: isbn13.present ? isbn13.value : this.isbn13,
    pageCount: pageCount.present ? pageCount.value : this.pageCount,
    publisher: publisher.present ? publisher.value : this.publisher,
    publishedDate: publishedDate.present
        ? publishedDate.value
        : this.publishedDate,
    coverUrl: coverUrl.present ? coverUrl.value : this.coverUrl,
    language: language.present ? language.value : this.language,
    averageRating: averageRating.present
        ? averageRating.value
        : this.averageRating,
    ratingsCount: ratingsCount.present ? ratingsCount.value : this.ratingsCount,
    categories: categories.present ? categories.value : this.categories,
    previewLink: previewLink.present ? previewLink.value : this.previewLink,
    infoLink: infoLink.present ? infoLink.value : this.infoLink,
    createdAt: createdAt ?? this.createdAt,
  );
  Book copyWithCompanion(BooksCompanion data) {
    return Book(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      subtitle: data.subtitle.present ? data.subtitle.value : this.subtitle,
      originalTitle: data.originalTitle.present
          ? data.originalTitle.value
          : this.originalTitle,
      description: data.description.present
          ? data.description.value
          : this.description,
      isbn10: data.isbn10.present ? data.isbn10.value : this.isbn10,
      isbn13: data.isbn13.present ? data.isbn13.value : this.isbn13,
      pageCount: data.pageCount.present ? data.pageCount.value : this.pageCount,
      publisher: data.publisher.present ? data.publisher.value : this.publisher,
      publishedDate: data.publishedDate.present
          ? data.publishedDate.value
          : this.publishedDate,
      coverUrl: data.coverUrl.present ? data.coverUrl.value : this.coverUrl,
      language: data.language.present ? data.language.value : this.language,
      averageRating: data.averageRating.present
          ? data.averageRating.value
          : this.averageRating,
      ratingsCount: data.ratingsCount.present
          ? data.ratingsCount.value
          : this.ratingsCount,
      categories: data.categories.present
          ? data.categories.value
          : this.categories,
      previewLink: data.previewLink.present
          ? data.previewLink.value
          : this.previewLink,
      infoLink: data.infoLink.present ? data.infoLink.value : this.infoLink,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Book(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('subtitle: $subtitle, ')
          ..write('originalTitle: $originalTitle, ')
          ..write('description: $description, ')
          ..write('isbn10: $isbn10, ')
          ..write('isbn13: $isbn13, ')
          ..write('pageCount: $pageCount, ')
          ..write('publisher: $publisher, ')
          ..write('publishedDate: $publishedDate, ')
          ..write('coverUrl: $coverUrl, ')
          ..write('language: $language, ')
          ..write('averageRating: $averageRating, ')
          ..write('ratingsCount: $ratingsCount, ')
          ..write('categories: $categories, ')
          ..write('previewLink: $previewLink, ')
          ..write('infoLink: $infoLink, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    subtitle,
    originalTitle,
    description,
    isbn10,
    isbn13,
    pageCount,
    publisher,
    publishedDate,
    coverUrl,
    language,
    averageRating,
    ratingsCount,
    categories,
    previewLink,
    infoLink,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Book &&
          other.id == this.id &&
          other.title == this.title &&
          other.subtitle == this.subtitle &&
          other.originalTitle == this.originalTitle &&
          other.description == this.description &&
          other.isbn10 == this.isbn10 &&
          other.isbn13 == this.isbn13 &&
          other.pageCount == this.pageCount &&
          other.publisher == this.publisher &&
          other.publishedDate == this.publishedDate &&
          other.coverUrl == this.coverUrl &&
          other.language == this.language &&
          other.averageRating == this.averageRating &&
          other.ratingsCount == this.ratingsCount &&
          other.categories == this.categories &&
          other.previewLink == this.previewLink &&
          other.infoLink == this.infoLink &&
          other.createdAt == this.createdAt);
}

class BooksCompanion extends UpdateCompanion<Book> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> subtitle;
  final Value<String?> originalTitle;
  final Value<String?> description;
  final Value<String?> isbn10;
  final Value<String?> isbn13;
  final Value<int?> pageCount;
  final Value<String?> publisher;
  final Value<String?> publishedDate;
  final Value<String?> coverUrl;
  final Value<String?> language;
  final Value<double?> averageRating;
  final Value<int?> ratingsCount;
  final Value<String?> categories;
  final Value<String?> previewLink;
  final Value<String?> infoLink;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const BooksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.subtitle = const Value.absent(),
    this.originalTitle = const Value.absent(),
    this.description = const Value.absent(),
    this.isbn10 = const Value.absent(),
    this.isbn13 = const Value.absent(),
    this.pageCount = const Value.absent(),
    this.publisher = const Value.absent(),
    this.publishedDate = const Value.absent(),
    this.coverUrl = const Value.absent(),
    this.language = const Value.absent(),
    this.averageRating = const Value.absent(),
    this.ratingsCount = const Value.absent(),
    this.categories = const Value.absent(),
    this.previewLink = const Value.absent(),
    this.infoLink = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BooksCompanion.insert({
    required String id,
    required String title,
    this.subtitle = const Value.absent(),
    this.originalTitle = const Value.absent(),
    this.description = const Value.absent(),
    this.isbn10 = const Value.absent(),
    this.isbn13 = const Value.absent(),
    this.pageCount = const Value.absent(),
    this.publisher = const Value.absent(),
    this.publishedDate = const Value.absent(),
    this.coverUrl = const Value.absent(),
    this.language = const Value.absent(),
    this.averageRating = const Value.absent(),
    this.ratingsCount = const Value.absent(),
    this.categories = const Value.absent(),
    this.previewLink = const Value.absent(),
    this.infoLink = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title);
  static Insertable<Book> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? subtitle,
    Expression<String>? originalTitle,
    Expression<String>? description,
    Expression<String>? isbn10,
    Expression<String>? isbn13,
    Expression<int>? pageCount,
    Expression<String>? publisher,
    Expression<String>? publishedDate,
    Expression<String>? coverUrl,
    Expression<String>? language,
    Expression<double>? averageRating,
    Expression<int>? ratingsCount,
    Expression<String>? categories,
    Expression<String>? previewLink,
    Expression<String>? infoLink,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (subtitle != null) 'subtitle': subtitle,
      if (originalTitle != null) 'original_title': originalTitle,
      if (description != null) 'description': description,
      if (isbn10 != null) 'isbn10': isbn10,
      if (isbn13 != null) 'isbn13': isbn13,
      if (pageCount != null) 'page_count': pageCount,
      if (publisher != null) 'publisher': publisher,
      if (publishedDate != null) 'published_date': publishedDate,
      if (coverUrl != null) 'cover_url': coverUrl,
      if (language != null) 'language': language,
      if (averageRating != null) 'average_rating': averageRating,
      if (ratingsCount != null) 'ratings_count': ratingsCount,
      if (categories != null) 'categories': categories,
      if (previewLink != null) 'preview_link': previewLink,
      if (infoLink != null) 'info_link': infoLink,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BooksCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String?>? subtitle,
    Value<String?>? originalTitle,
    Value<String?>? description,
    Value<String?>? isbn10,
    Value<String?>? isbn13,
    Value<int?>? pageCount,
    Value<String?>? publisher,
    Value<String?>? publishedDate,
    Value<String?>? coverUrl,
    Value<String?>? language,
    Value<double?>? averageRating,
    Value<int?>? ratingsCount,
    Value<String?>? categories,
    Value<String?>? previewLink,
    Value<String?>? infoLink,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return BooksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      originalTitle: originalTitle ?? this.originalTitle,
      description: description ?? this.description,
      isbn10: isbn10 ?? this.isbn10,
      isbn13: isbn13 ?? this.isbn13,
      pageCount: pageCount ?? this.pageCount,
      publisher: publisher ?? this.publisher,
      publishedDate: publishedDate ?? this.publishedDate,
      coverUrl: coverUrl ?? this.coverUrl,
      language: language ?? this.language,
      averageRating: averageRating ?? this.averageRating,
      ratingsCount: ratingsCount ?? this.ratingsCount,
      categories: categories ?? this.categories,
      previewLink: previewLink ?? this.previewLink,
      infoLink: infoLink ?? this.infoLink,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (subtitle.present) {
      map['subtitle'] = Variable<String>(subtitle.value);
    }
    if (originalTitle.present) {
      map['original_title'] = Variable<String>(originalTitle.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isbn10.present) {
      map['isbn10'] = Variable<String>(isbn10.value);
    }
    if (isbn13.present) {
      map['isbn13'] = Variable<String>(isbn13.value);
    }
    if (pageCount.present) {
      map['page_count'] = Variable<int>(pageCount.value);
    }
    if (publisher.present) {
      map['publisher'] = Variable<String>(publisher.value);
    }
    if (publishedDate.present) {
      map['published_date'] = Variable<String>(publishedDate.value);
    }
    if (coverUrl.present) {
      map['cover_url'] = Variable<String>(coverUrl.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (averageRating.present) {
      map['average_rating'] = Variable<double>(averageRating.value);
    }
    if (ratingsCount.present) {
      map['ratings_count'] = Variable<int>(ratingsCount.value);
    }
    if (categories.present) {
      map['categories'] = Variable<String>(categories.value);
    }
    if (previewLink.present) {
      map['preview_link'] = Variable<String>(previewLink.value);
    }
    if (infoLink.present) {
      map['info_link'] = Variable<String>(infoLink.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BooksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('subtitle: $subtitle, ')
          ..write('originalTitle: $originalTitle, ')
          ..write('description: $description, ')
          ..write('isbn10: $isbn10, ')
          ..write('isbn13: $isbn13, ')
          ..write('pageCount: $pageCount, ')
          ..write('publisher: $publisher, ')
          ..write('publishedDate: $publishedDate, ')
          ..write('coverUrl: $coverUrl, ')
          ..write('language: $language, ')
          ..write('averageRating: $averageRating, ')
          ..write('ratingsCount: $ratingsCount, ')
          ..write('categories: $categories, ')
          ..write('previewLink: $previewLink, ')
          ..write('infoLink: $infoLink, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BookAuthorsTable extends BookAuthors
    with TableInfo<$BookAuthorsTable, BookAuthor> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookAuthorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<String> bookId = GeneratedColumn<String>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorIdMeta = const VerificationMeta(
    'authorId',
  );
  @override
  late final GeneratedColumn<String> authorId = GeneratedColumn<String>(
    'author_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('author'),
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [bookId, authorId, role, orderIndex];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'book_authors';
  @override
  VerificationContext validateIntegrity(
    Insertable<BookAuthor> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('author_id')) {
      context.handle(
        _authorIdMeta,
        authorId.isAcceptableOrUnknown(data['author_id']!, _authorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_authorIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {bookId, authorId};
  @override
  BookAuthor map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BookAuthor(
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}book_id'],
      )!,
      authorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
    );
  }

  @override
  $BookAuthorsTable createAlias(String alias) {
    return $BookAuthorsTable(attachedDatabase, alias);
  }
}

class BookAuthor extends DataClass implements Insertable<BookAuthor> {
  final String bookId;
  final String authorId;
  final String role;
  final int orderIndex;
  const BookAuthor({
    required this.bookId,
    required this.authorId,
    required this.role,
    required this.orderIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['book_id'] = Variable<String>(bookId);
    map['author_id'] = Variable<String>(authorId);
    map['role'] = Variable<String>(role);
    map['order_index'] = Variable<int>(orderIndex);
    return map;
  }

  BookAuthorsCompanion toCompanion(bool nullToAbsent) {
    return BookAuthorsCompanion(
      bookId: Value(bookId),
      authorId: Value(authorId),
      role: Value(role),
      orderIndex: Value(orderIndex),
    );
  }

  factory BookAuthor.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BookAuthor(
      bookId: serializer.fromJson<String>(json['bookId']),
      authorId: serializer.fromJson<String>(json['authorId']),
      role: serializer.fromJson<String>(json['role']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'bookId': serializer.toJson<String>(bookId),
      'authorId': serializer.toJson<String>(authorId),
      'role': serializer.toJson<String>(role),
      'orderIndex': serializer.toJson<int>(orderIndex),
    };
  }

  BookAuthor copyWith({
    String? bookId,
    String? authorId,
    String? role,
    int? orderIndex,
  }) => BookAuthor(
    bookId: bookId ?? this.bookId,
    authorId: authorId ?? this.authorId,
    role: role ?? this.role,
    orderIndex: orderIndex ?? this.orderIndex,
  );
  BookAuthor copyWithCompanion(BookAuthorsCompanion data) {
    return BookAuthor(
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      authorId: data.authorId.present ? data.authorId.value : this.authorId,
      role: data.role.present ? data.role.value : this.role,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BookAuthor(')
          ..write('bookId: $bookId, ')
          ..write('authorId: $authorId, ')
          ..write('role: $role, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(bookId, authorId, role, orderIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BookAuthor &&
          other.bookId == this.bookId &&
          other.authorId == this.authorId &&
          other.role == this.role &&
          other.orderIndex == this.orderIndex);
}

class BookAuthorsCompanion extends UpdateCompanion<BookAuthor> {
  final Value<String> bookId;
  final Value<String> authorId;
  final Value<String> role;
  final Value<int> orderIndex;
  final Value<int> rowid;
  const BookAuthorsCompanion({
    this.bookId = const Value.absent(),
    this.authorId = const Value.absent(),
    this.role = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BookAuthorsCompanion.insert({
    required String bookId,
    required String authorId,
    this.role = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : bookId = Value(bookId),
       authorId = Value(authorId);
  static Insertable<BookAuthor> custom({
    Expression<String>? bookId,
    Expression<String>? authorId,
    Expression<String>? role,
    Expression<int>? orderIndex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (bookId != null) 'book_id': bookId,
      if (authorId != null) 'author_id': authorId,
      if (role != null) 'role': role,
      if (orderIndex != null) 'order_index': orderIndex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BookAuthorsCompanion copyWith({
    Value<String>? bookId,
    Value<String>? authorId,
    Value<String>? role,
    Value<int>? orderIndex,
    Value<int>? rowid,
  }) {
    return BookAuthorsCompanion(
      bookId: bookId ?? this.bookId,
      authorId: authorId ?? this.authorId,
      role: role ?? this.role,
      orderIndex: orderIndex ?? this.orderIndex,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (bookId.present) {
      map['book_id'] = Variable<String>(bookId.value);
    }
    if (authorId.present) {
      map['author_id'] = Variable<String>(authorId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookAuthorsCompanion(')
          ..write('bookId: $bookId, ')
          ..write('authorId: $authorId, ')
          ..write('role: $role, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserBookStatusesTable extends UserBookStatuses
    with TableInfo<$UserBookStatusesTable, UserBookStatuse> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserBookStatusesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<String> bookId = GeneratedColumn<String>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<BookReadingStatus, String>
  status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<BookReadingStatus>($UserBookStatusesTable.$converterstatus);
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<double> rating = GeneratedColumn<double>(
    'rating',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currentPageMeta = const VerificationMeta(
    'currentPage',
  );
  @override
  late final GeneratedColumn<int> currentPage = GeneratedColumn<int>(
    'current_page',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _finishDateMeta = const VerificationMeta(
    'finishDate',
  );
  @override
  late final GeneratedColumn<DateTime> finishDate = GeneratedColumn<DateTime>(
    'finish_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateAddedMeta = const VerificationMeta(
    'dateAdded',
  );
  @override
  late final GeneratedColumn<DateTime> dateAdded = GeneratedColumn<DateTime>(
    'date_added',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _dateUpdatedMeta = const VerificationMeta(
    'dateUpdated',
  );
  @override
  late final GeneratedColumn<DateTime> dateUpdated = GeneratedColumn<DateTime>(
    'date_updated',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    bookId,
    status,
    rating,
    currentPage,
    isFavorite,
    startDate,
    finishDate,
    dateAdded,
    dateUpdated,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_book_statuses';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserBookStatuse> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    }
    if (data.containsKey('current_page')) {
      context.handle(
        _currentPageMeta,
        currentPage.isAcceptableOrUnknown(
          data['current_page']!,
          _currentPageMeta,
        ),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    }
    if (data.containsKey('finish_date')) {
      context.handle(
        _finishDateMeta,
        finishDate.isAcceptableOrUnknown(data['finish_date']!, _finishDateMeta),
      );
    }
    if (data.containsKey('date_added')) {
      context.handle(
        _dateAddedMeta,
        dateAdded.isAcceptableOrUnknown(data['date_added']!, _dateAddedMeta),
      );
    }
    if (data.containsKey('date_updated')) {
      context.handle(
        _dateUpdatedMeta,
        dateUpdated.isAcceptableOrUnknown(
          data['date_updated']!,
          _dateUpdatedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {bookId};
  @override
  UserBookStatuse map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserBookStatuse(
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}book_id'],
      )!,
      status: $UserBookStatusesTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rating'],
      ),
      currentPage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_page'],
      )!,
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      ),
      finishDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}finish_date'],
      ),
      dateAdded: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_added'],
      )!,
      dateUpdated: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_updated'],
      )!,
    );
  }

  @override
  $UserBookStatusesTable createAlias(String alias) {
    return $UserBookStatusesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<BookReadingStatus, String, String>
  $converterstatus = const EnumNameConverter<BookReadingStatus>(
    BookReadingStatus.values,
  );
}

class UserBookStatuse extends DataClass implements Insertable<UserBookStatuse> {
  final String bookId;
  final BookReadingStatus status;
  final double? rating;
  final int currentPage;
  final bool isFavorite;
  final DateTime? startDate;
  final DateTime? finishDate;
  final DateTime dateAdded;
  final DateTime dateUpdated;
  const UserBookStatuse({
    required this.bookId,
    required this.status,
    this.rating,
    required this.currentPage,
    required this.isFavorite,
    this.startDate,
    this.finishDate,
    required this.dateAdded,
    required this.dateUpdated,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['book_id'] = Variable<String>(bookId);
    {
      map['status'] = Variable<String>(
        $UserBookStatusesTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || rating != null) {
      map['rating'] = Variable<double>(rating);
    }
    map['current_page'] = Variable<int>(currentPage);
    map['is_favorite'] = Variable<bool>(isFavorite);
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<DateTime>(startDate);
    }
    if (!nullToAbsent || finishDate != null) {
      map['finish_date'] = Variable<DateTime>(finishDate);
    }
    map['date_added'] = Variable<DateTime>(dateAdded);
    map['date_updated'] = Variable<DateTime>(dateUpdated);
    return map;
  }

  UserBookStatusesCompanion toCompanion(bool nullToAbsent) {
    return UserBookStatusesCompanion(
      bookId: Value(bookId),
      status: Value(status),
      rating: rating == null && nullToAbsent
          ? const Value.absent()
          : Value(rating),
      currentPage: Value(currentPage),
      isFavorite: Value(isFavorite),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      finishDate: finishDate == null && nullToAbsent
          ? const Value.absent()
          : Value(finishDate),
      dateAdded: Value(dateAdded),
      dateUpdated: Value(dateUpdated),
    );
  }

  factory UserBookStatuse.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserBookStatuse(
      bookId: serializer.fromJson<String>(json['bookId']),
      status: $UserBookStatusesTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      rating: serializer.fromJson<double?>(json['rating']),
      currentPage: serializer.fromJson<int>(json['currentPage']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      startDate: serializer.fromJson<DateTime?>(json['startDate']),
      finishDate: serializer.fromJson<DateTime?>(json['finishDate']),
      dateAdded: serializer.fromJson<DateTime>(json['dateAdded']),
      dateUpdated: serializer.fromJson<DateTime>(json['dateUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'bookId': serializer.toJson<String>(bookId),
      'status': serializer.toJson<String>(
        $UserBookStatusesTable.$converterstatus.toJson(status),
      ),
      'rating': serializer.toJson<double?>(rating),
      'currentPage': serializer.toJson<int>(currentPage),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'startDate': serializer.toJson<DateTime?>(startDate),
      'finishDate': serializer.toJson<DateTime?>(finishDate),
      'dateAdded': serializer.toJson<DateTime>(dateAdded),
      'dateUpdated': serializer.toJson<DateTime>(dateUpdated),
    };
  }

  UserBookStatuse copyWith({
    String? bookId,
    BookReadingStatus? status,
    Value<double?> rating = const Value.absent(),
    int? currentPage,
    bool? isFavorite,
    Value<DateTime?> startDate = const Value.absent(),
    Value<DateTime?> finishDate = const Value.absent(),
    DateTime? dateAdded,
    DateTime? dateUpdated,
  }) => UserBookStatuse(
    bookId: bookId ?? this.bookId,
    status: status ?? this.status,
    rating: rating.present ? rating.value : this.rating,
    currentPage: currentPage ?? this.currentPage,
    isFavorite: isFavorite ?? this.isFavorite,
    startDate: startDate.present ? startDate.value : this.startDate,
    finishDate: finishDate.present ? finishDate.value : this.finishDate,
    dateAdded: dateAdded ?? this.dateAdded,
    dateUpdated: dateUpdated ?? this.dateUpdated,
  );
  UserBookStatuse copyWithCompanion(UserBookStatusesCompanion data) {
    return UserBookStatuse(
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      status: data.status.present ? data.status.value : this.status,
      rating: data.rating.present ? data.rating.value : this.rating,
      currentPage: data.currentPage.present
          ? data.currentPage.value
          : this.currentPage,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      finishDate: data.finishDate.present
          ? data.finishDate.value
          : this.finishDate,
      dateAdded: data.dateAdded.present ? data.dateAdded.value : this.dateAdded,
      dateUpdated: data.dateUpdated.present
          ? data.dateUpdated.value
          : this.dateUpdated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserBookStatuse(')
          ..write('bookId: $bookId, ')
          ..write('status: $status, ')
          ..write('rating: $rating, ')
          ..write('currentPage: $currentPage, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('startDate: $startDate, ')
          ..write('finishDate: $finishDate, ')
          ..write('dateAdded: $dateAdded, ')
          ..write('dateUpdated: $dateUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    bookId,
    status,
    rating,
    currentPage,
    isFavorite,
    startDate,
    finishDate,
    dateAdded,
    dateUpdated,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserBookStatuse &&
          other.bookId == this.bookId &&
          other.status == this.status &&
          other.rating == this.rating &&
          other.currentPage == this.currentPage &&
          other.isFavorite == this.isFavorite &&
          other.startDate == this.startDate &&
          other.finishDate == this.finishDate &&
          other.dateAdded == this.dateAdded &&
          other.dateUpdated == this.dateUpdated);
}

class UserBookStatusesCompanion extends UpdateCompanion<UserBookStatuse> {
  final Value<String> bookId;
  final Value<BookReadingStatus> status;
  final Value<double?> rating;
  final Value<int> currentPage;
  final Value<bool> isFavorite;
  final Value<DateTime?> startDate;
  final Value<DateTime?> finishDate;
  final Value<DateTime> dateAdded;
  final Value<DateTime> dateUpdated;
  final Value<int> rowid;
  const UserBookStatusesCompanion({
    this.bookId = const Value.absent(),
    this.status = const Value.absent(),
    this.rating = const Value.absent(),
    this.currentPage = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.startDate = const Value.absent(),
    this.finishDate = const Value.absent(),
    this.dateAdded = const Value.absent(),
    this.dateUpdated = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserBookStatusesCompanion.insert({
    required String bookId,
    required BookReadingStatus status,
    this.rating = const Value.absent(),
    this.currentPage = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.startDate = const Value.absent(),
    this.finishDate = const Value.absent(),
    this.dateAdded = const Value.absent(),
    this.dateUpdated = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : bookId = Value(bookId),
       status = Value(status);
  static Insertable<UserBookStatuse> custom({
    Expression<String>? bookId,
    Expression<String>? status,
    Expression<double>? rating,
    Expression<int>? currentPage,
    Expression<bool>? isFavorite,
    Expression<DateTime>? startDate,
    Expression<DateTime>? finishDate,
    Expression<DateTime>? dateAdded,
    Expression<DateTime>? dateUpdated,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (bookId != null) 'book_id': bookId,
      if (status != null) 'status': status,
      if (rating != null) 'rating': rating,
      if (currentPage != null) 'current_page': currentPage,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (startDate != null) 'start_date': startDate,
      if (finishDate != null) 'finish_date': finishDate,
      if (dateAdded != null) 'date_added': dateAdded,
      if (dateUpdated != null) 'date_updated': dateUpdated,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserBookStatusesCompanion copyWith({
    Value<String>? bookId,
    Value<BookReadingStatus>? status,
    Value<double?>? rating,
    Value<int>? currentPage,
    Value<bool>? isFavorite,
    Value<DateTime?>? startDate,
    Value<DateTime?>? finishDate,
    Value<DateTime>? dateAdded,
    Value<DateTime>? dateUpdated,
    Value<int>? rowid,
  }) {
    return UserBookStatusesCompanion(
      bookId: bookId ?? this.bookId,
      status: status ?? this.status,
      rating: rating ?? this.rating,
      currentPage: currentPage ?? this.currentPage,
      isFavorite: isFavorite ?? this.isFavorite,
      startDate: startDate ?? this.startDate,
      finishDate: finishDate ?? this.finishDate,
      dateAdded: dateAdded ?? this.dateAdded,
      dateUpdated: dateUpdated ?? this.dateUpdated,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (bookId.present) {
      map['book_id'] = Variable<String>(bookId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $UserBookStatusesTable.$converterstatus.toSql(status.value),
      );
    }
    if (rating.present) {
      map['rating'] = Variable<double>(rating.value);
    }
    if (currentPage.present) {
      map['current_page'] = Variable<int>(currentPage.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (finishDate.present) {
      map['finish_date'] = Variable<DateTime>(finishDate.value);
    }
    if (dateAdded.present) {
      map['date_added'] = Variable<DateTime>(dateAdded.value);
    }
    if (dateUpdated.present) {
      map['date_updated'] = Variable<DateTime>(dateUpdated.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserBookStatusesCompanion(')
          ..write('bookId: $bookId, ')
          ..write('status: $status, ')
          ..write('rating: $rating, ')
          ..write('currentPage: $currentPage, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('startDate: $startDate, ')
          ..write('finishDate: $finishDate, ')
          ..write('dateAdded: $dateAdded, ')
          ..write('dateUpdated: $dateUpdated, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReadingSessionsTable extends ReadingSessions
    with TableInfo<$ReadingSessionsTable, ReadingSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReadingSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<String> bookId = GeneratedColumn<String>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _endPageMeta = const VerificationMeta(
    'endPage',
  );
  @override
  late final GeneratedColumn<int> endPage = GeneratedColumn<int>(
    'end_page',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMinutesMeta = const VerificationMeta(
    'durationMinutes',
  );
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
    'duration_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    bookId,
    date,
    endPage,
    durationMinutes,
    notes,
    location,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reading_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReadingSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    }
    if (data.containsKey('end_page')) {
      context.handle(
        _endPageMeta,
        endPage.isAcceptableOrUnknown(data['end_page']!, _endPageMeta),
      );
    } else if (isInserting) {
      context.missing(_endPageMeta);
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
        _durationMinutesMeta,
        durationMinutes.isAcceptableOrUnknown(
          data['duration_minutes']!,
          _durationMinutesMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReadingSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReadingSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}book_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      endPage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_page'],
      )!,
      durationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_minutes'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ReadingSessionsTable createAlias(String alias) {
    return $ReadingSessionsTable(attachedDatabase, alias);
  }
}

class ReadingSession extends DataClass implements Insertable<ReadingSession> {
  final String id;
  final String bookId;
  final DateTime date;
  final int endPage;
  final int durationMinutes;
  final String? notes;
  final String? location;
  final DateTime createdAt;
  const ReadingSession({
    required this.id,
    required this.bookId,
    required this.date,
    required this.endPage,
    required this.durationMinutes,
    this.notes,
    this.location,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['book_id'] = Variable<String>(bookId);
    map['date'] = Variable<DateTime>(date);
    map['end_page'] = Variable<int>(endPage);
    map['duration_minutes'] = Variable<int>(durationMinutes);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ReadingSessionsCompanion toCompanion(bool nullToAbsent) {
    return ReadingSessionsCompanion(
      id: Value(id),
      bookId: Value(bookId),
      date: Value(date),
      endPage: Value(endPage),
      durationMinutes: Value(durationMinutes),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      createdAt: Value(createdAt),
    );
  }

  factory ReadingSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReadingSession(
      id: serializer.fromJson<String>(json['id']),
      bookId: serializer.fromJson<String>(json['bookId']),
      date: serializer.fromJson<DateTime>(json['date']),
      endPage: serializer.fromJson<int>(json['endPage']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      notes: serializer.fromJson<String?>(json['notes']),
      location: serializer.fromJson<String?>(json['location']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'bookId': serializer.toJson<String>(bookId),
      'date': serializer.toJson<DateTime>(date),
      'endPage': serializer.toJson<int>(endPage),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'notes': serializer.toJson<String?>(notes),
      'location': serializer.toJson<String?>(location),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ReadingSession copyWith({
    String? id,
    String? bookId,
    DateTime? date,
    int? endPage,
    int? durationMinutes,
    Value<String?> notes = const Value.absent(),
    Value<String?> location = const Value.absent(),
    DateTime? createdAt,
  }) => ReadingSession(
    id: id ?? this.id,
    bookId: bookId ?? this.bookId,
    date: date ?? this.date,
    endPage: endPage ?? this.endPage,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    notes: notes.present ? notes.value : this.notes,
    location: location.present ? location.value : this.location,
    createdAt: createdAt ?? this.createdAt,
  );
  ReadingSession copyWithCompanion(ReadingSessionsCompanion data) {
    return ReadingSession(
      id: data.id.present ? data.id.value : this.id,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      date: data.date.present ? data.date.value : this.date,
      endPage: data.endPage.present ? data.endPage.value : this.endPage,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      notes: data.notes.present ? data.notes.value : this.notes,
      location: data.location.present ? data.location.value : this.location,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReadingSession(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('date: $date, ')
          ..write('endPage: $endPage, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('notes: $notes, ')
          ..write('location: $location, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    bookId,
    date,
    endPage,
    durationMinutes,
    notes,
    location,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReadingSession &&
          other.id == this.id &&
          other.bookId == this.bookId &&
          other.date == this.date &&
          other.endPage == this.endPage &&
          other.durationMinutes == this.durationMinutes &&
          other.notes == this.notes &&
          other.location == this.location &&
          other.createdAt == this.createdAt);
}

class ReadingSessionsCompanion extends UpdateCompanion<ReadingSession> {
  final Value<String> id;
  final Value<String> bookId;
  final Value<DateTime> date;
  final Value<int> endPage;
  final Value<int> durationMinutes;
  final Value<String?> notes;
  final Value<String?> location;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ReadingSessionsCompanion({
    this.id = const Value.absent(),
    this.bookId = const Value.absent(),
    this.date = const Value.absent(),
    this.endPage = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.notes = const Value.absent(),
    this.location = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReadingSessionsCompanion.insert({
    required String id,
    required String bookId,
    this.date = const Value.absent(),
    required int endPage,
    this.durationMinutes = const Value.absent(),
    this.notes = const Value.absent(),
    this.location = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       bookId = Value(bookId),
       endPage = Value(endPage);
  static Insertable<ReadingSession> custom({
    Expression<String>? id,
    Expression<String>? bookId,
    Expression<DateTime>? date,
    Expression<int>? endPage,
    Expression<int>? durationMinutes,
    Expression<String>? notes,
    Expression<String>? location,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookId != null) 'book_id': bookId,
      if (date != null) 'date': date,
      if (endPage != null) 'end_page': endPage,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (notes != null) 'notes': notes,
      if (location != null) 'location': location,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReadingSessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? bookId,
    Value<DateTime>? date,
    Value<int>? endPage,
    Value<int>? durationMinutes,
    Value<String?>? notes,
    Value<String?>? location,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ReadingSessionsCompanion(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      date: date ?? this.date,
      endPage: endPage ?? this.endPage,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      notes: notes ?? this.notes,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<String>(bookId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (endPage.present) {
      map['end_page'] = Variable<int>(endPage.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReadingSessionsCompanion(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('date: $date, ')
          ..write('endPage: $endPage, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('notes: $notes, ')
          ..write('location: $location, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AuthorsTable authors = $AuthorsTable(this);
  late final $BooksTable books = $BooksTable(this);
  late final $BookAuthorsTable bookAuthors = $BookAuthorsTable(this);
  late final $UserBookStatusesTable userBookStatuses = $UserBookStatusesTable(
    this,
  );
  late final $ReadingSessionsTable readingSessions = $ReadingSessionsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    authors,
    books,
    bookAuthors,
    userBookStatuses,
    readingSessions,
  ];
}

typedef $$AuthorsTableCreateCompanionBuilder =
    AuthorsCompanion Function({
      required String id,
      required String name,
      Value<String?> bio,
      Value<String?> photoUrl,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$AuthorsTableUpdateCompanionBuilder =
    AuthorsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> bio,
      Value<String?> photoUrl,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$AuthorsTableFilterComposer
    extends Composer<_$AppDatabase, $AuthorsTable> {
  $$AuthorsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bio => $composableBuilder(
    column: $table.bio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoUrl => $composableBuilder(
    column: $table.photoUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AuthorsTableOrderingComposer
    extends Composer<_$AppDatabase, $AuthorsTable> {
  $$AuthorsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bio => $composableBuilder(
    column: $table.bio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoUrl => $composableBuilder(
    column: $table.photoUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AuthorsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuthorsTable> {
  $$AuthorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get bio =>
      $composableBuilder(column: $table.bio, builder: (column) => column);

  GeneratedColumn<String> get photoUrl =>
      $composableBuilder(column: $table.photoUrl, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AuthorsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AuthorsTable,
          Author,
          $$AuthorsTableFilterComposer,
          $$AuthorsTableOrderingComposer,
          $$AuthorsTableAnnotationComposer,
          $$AuthorsTableCreateCompanionBuilder,
          $$AuthorsTableUpdateCompanionBuilder,
          (Author, BaseReferences<_$AppDatabase, $AuthorsTable, Author>),
          Author,
          PrefetchHooks Function()
        > {
  $$AuthorsTableTableManager(_$AppDatabase db, $AuthorsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuthorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuthorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuthorsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> bio = const Value.absent(),
                Value<String?> photoUrl = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AuthorsCompanion(
                id: id,
                name: name,
                bio: bio,
                photoUrl: photoUrl,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> bio = const Value.absent(),
                Value<String?> photoUrl = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AuthorsCompanion.insert(
                id: id,
                name: name,
                bio: bio,
                photoUrl: photoUrl,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AuthorsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AuthorsTable,
      Author,
      $$AuthorsTableFilterComposer,
      $$AuthorsTableOrderingComposer,
      $$AuthorsTableAnnotationComposer,
      $$AuthorsTableCreateCompanionBuilder,
      $$AuthorsTableUpdateCompanionBuilder,
      (Author, BaseReferences<_$AppDatabase, $AuthorsTable, Author>),
      Author,
      PrefetchHooks Function()
    >;
typedef $$BooksTableCreateCompanionBuilder =
    BooksCompanion Function({
      required String id,
      required String title,
      Value<String?> subtitle,
      Value<String?> originalTitle,
      Value<String?> description,
      Value<String?> isbn10,
      Value<String?> isbn13,
      Value<int?> pageCount,
      Value<String?> publisher,
      Value<String?> publishedDate,
      Value<String?> coverUrl,
      Value<String?> language,
      Value<double?> averageRating,
      Value<int?> ratingsCount,
      Value<String?> categories,
      Value<String?> previewLink,
      Value<String?> infoLink,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$BooksTableUpdateCompanionBuilder =
    BooksCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String?> subtitle,
      Value<String?> originalTitle,
      Value<String?> description,
      Value<String?> isbn10,
      Value<String?> isbn13,
      Value<int?> pageCount,
      Value<String?> publisher,
      Value<String?> publishedDate,
      Value<String?> coverUrl,
      Value<String?> language,
      Value<double?> averageRating,
      Value<int?> ratingsCount,
      Value<String?> categories,
      Value<String?> previewLink,
      Value<String?> infoLink,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$BooksTableFilterComposer extends Composer<_$AppDatabase, $BooksTable> {
  $$BooksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subtitle => $composableBuilder(
    column: $table.subtitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalTitle => $composableBuilder(
    column: $table.originalTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get isbn10 => $composableBuilder(
    column: $table.isbn10,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get isbn13 => $composableBuilder(
    column: $table.isbn13,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pageCount => $composableBuilder(
    column: $table.pageCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get publisher => $composableBuilder(
    column: $table.publisher,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get publishedDate => $composableBuilder(
    column: $table.publishedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverUrl => $composableBuilder(
    column: $table.coverUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get averageRating => $composableBuilder(
    column: $table.averageRating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ratingsCount => $composableBuilder(
    column: $table.ratingsCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categories => $composableBuilder(
    column: $table.categories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get previewLink => $composableBuilder(
    column: $table.previewLink,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get infoLink => $composableBuilder(
    column: $table.infoLink,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BooksTableOrderingComposer
    extends Composer<_$AppDatabase, $BooksTable> {
  $$BooksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subtitle => $composableBuilder(
    column: $table.subtitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalTitle => $composableBuilder(
    column: $table.originalTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get isbn10 => $composableBuilder(
    column: $table.isbn10,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get isbn13 => $composableBuilder(
    column: $table.isbn13,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pageCount => $composableBuilder(
    column: $table.pageCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get publisher => $composableBuilder(
    column: $table.publisher,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get publishedDate => $composableBuilder(
    column: $table.publishedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverUrl => $composableBuilder(
    column: $table.coverUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get averageRating => $composableBuilder(
    column: $table.averageRating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ratingsCount => $composableBuilder(
    column: $table.ratingsCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categories => $composableBuilder(
    column: $table.categories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get previewLink => $composableBuilder(
    column: $table.previewLink,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get infoLink => $composableBuilder(
    column: $table.infoLink,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BooksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BooksTable> {
  $$BooksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get subtitle =>
      $composableBuilder(column: $table.subtitle, builder: (column) => column);

  GeneratedColumn<String> get originalTitle => $composableBuilder(
    column: $table.originalTitle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get isbn10 =>
      $composableBuilder(column: $table.isbn10, builder: (column) => column);

  GeneratedColumn<String> get isbn13 =>
      $composableBuilder(column: $table.isbn13, builder: (column) => column);

  GeneratedColumn<int> get pageCount =>
      $composableBuilder(column: $table.pageCount, builder: (column) => column);

  GeneratedColumn<String> get publisher =>
      $composableBuilder(column: $table.publisher, builder: (column) => column);

  GeneratedColumn<String> get publishedDate => $composableBuilder(
    column: $table.publishedDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get coverUrl =>
      $composableBuilder(column: $table.coverUrl, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<double> get averageRating => $composableBuilder(
    column: $table.averageRating,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ratingsCount => $composableBuilder(
    column: $table.ratingsCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get categories => $composableBuilder(
    column: $table.categories,
    builder: (column) => column,
  );

  GeneratedColumn<String> get previewLink => $composableBuilder(
    column: $table.previewLink,
    builder: (column) => column,
  );

  GeneratedColumn<String> get infoLink =>
      $composableBuilder(column: $table.infoLink, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$BooksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BooksTable,
          Book,
          $$BooksTableFilterComposer,
          $$BooksTableOrderingComposer,
          $$BooksTableAnnotationComposer,
          $$BooksTableCreateCompanionBuilder,
          $$BooksTableUpdateCompanionBuilder,
          (Book, BaseReferences<_$AppDatabase, $BooksTable, Book>),
          Book,
          PrefetchHooks Function()
        > {
  $$BooksTableTableManager(_$AppDatabase db, $BooksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BooksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BooksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BooksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> subtitle = const Value.absent(),
                Value<String?> originalTitle = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> isbn10 = const Value.absent(),
                Value<String?> isbn13 = const Value.absent(),
                Value<int?> pageCount = const Value.absent(),
                Value<String?> publisher = const Value.absent(),
                Value<String?> publishedDate = const Value.absent(),
                Value<String?> coverUrl = const Value.absent(),
                Value<String?> language = const Value.absent(),
                Value<double?> averageRating = const Value.absent(),
                Value<int?> ratingsCount = const Value.absent(),
                Value<String?> categories = const Value.absent(),
                Value<String?> previewLink = const Value.absent(),
                Value<String?> infoLink = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BooksCompanion(
                id: id,
                title: title,
                subtitle: subtitle,
                originalTitle: originalTitle,
                description: description,
                isbn10: isbn10,
                isbn13: isbn13,
                pageCount: pageCount,
                publisher: publisher,
                publishedDate: publishedDate,
                coverUrl: coverUrl,
                language: language,
                averageRating: averageRating,
                ratingsCount: ratingsCount,
                categories: categories,
                previewLink: previewLink,
                infoLink: infoLink,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String?> subtitle = const Value.absent(),
                Value<String?> originalTitle = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> isbn10 = const Value.absent(),
                Value<String?> isbn13 = const Value.absent(),
                Value<int?> pageCount = const Value.absent(),
                Value<String?> publisher = const Value.absent(),
                Value<String?> publishedDate = const Value.absent(),
                Value<String?> coverUrl = const Value.absent(),
                Value<String?> language = const Value.absent(),
                Value<double?> averageRating = const Value.absent(),
                Value<int?> ratingsCount = const Value.absent(),
                Value<String?> categories = const Value.absent(),
                Value<String?> previewLink = const Value.absent(),
                Value<String?> infoLink = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BooksCompanion.insert(
                id: id,
                title: title,
                subtitle: subtitle,
                originalTitle: originalTitle,
                description: description,
                isbn10: isbn10,
                isbn13: isbn13,
                pageCount: pageCount,
                publisher: publisher,
                publishedDate: publishedDate,
                coverUrl: coverUrl,
                language: language,
                averageRating: averageRating,
                ratingsCount: ratingsCount,
                categories: categories,
                previewLink: previewLink,
                infoLink: infoLink,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BooksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BooksTable,
      Book,
      $$BooksTableFilterComposer,
      $$BooksTableOrderingComposer,
      $$BooksTableAnnotationComposer,
      $$BooksTableCreateCompanionBuilder,
      $$BooksTableUpdateCompanionBuilder,
      (Book, BaseReferences<_$AppDatabase, $BooksTable, Book>),
      Book,
      PrefetchHooks Function()
    >;
typedef $$BookAuthorsTableCreateCompanionBuilder =
    BookAuthorsCompanion Function({
      required String bookId,
      required String authorId,
      Value<String> role,
      Value<int> orderIndex,
      Value<int> rowid,
    });
typedef $$BookAuthorsTableUpdateCompanionBuilder =
    BookAuthorsCompanion Function({
      Value<String> bookId,
      Value<String> authorId,
      Value<String> role,
      Value<int> orderIndex,
      Value<int> rowid,
    });

class $$BookAuthorsTableFilterComposer
    extends Composer<_$AppDatabase, $BookAuthorsTable> {
  $$BookAuthorsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get bookId => $composableBuilder(
    column: $table.bookId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorId => $composableBuilder(
    column: $table.authorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BookAuthorsTableOrderingComposer
    extends Composer<_$AppDatabase, $BookAuthorsTable> {
  $$BookAuthorsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get bookId => $composableBuilder(
    column: $table.bookId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorId => $composableBuilder(
    column: $table.authorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BookAuthorsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BookAuthorsTable> {
  $$BookAuthorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get bookId =>
      $composableBuilder(column: $table.bookId, builder: (column) => column);

  GeneratedColumn<String> get authorId =>
      $composableBuilder(column: $table.authorId, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );
}

class $$BookAuthorsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BookAuthorsTable,
          BookAuthor,
          $$BookAuthorsTableFilterComposer,
          $$BookAuthorsTableOrderingComposer,
          $$BookAuthorsTableAnnotationComposer,
          $$BookAuthorsTableCreateCompanionBuilder,
          $$BookAuthorsTableUpdateCompanionBuilder,
          (
            BookAuthor,
            BaseReferences<_$AppDatabase, $BookAuthorsTable, BookAuthor>,
          ),
          BookAuthor,
          PrefetchHooks Function()
        > {
  $$BookAuthorsTableTableManager(_$AppDatabase db, $BookAuthorsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BookAuthorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BookAuthorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BookAuthorsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> bookId = const Value.absent(),
                Value<String> authorId = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BookAuthorsCompanion(
                bookId: bookId,
                authorId: authorId,
                role: role,
                orderIndex: orderIndex,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String bookId,
                required String authorId,
                Value<String> role = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BookAuthorsCompanion.insert(
                bookId: bookId,
                authorId: authorId,
                role: role,
                orderIndex: orderIndex,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BookAuthorsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BookAuthorsTable,
      BookAuthor,
      $$BookAuthorsTableFilterComposer,
      $$BookAuthorsTableOrderingComposer,
      $$BookAuthorsTableAnnotationComposer,
      $$BookAuthorsTableCreateCompanionBuilder,
      $$BookAuthorsTableUpdateCompanionBuilder,
      (
        BookAuthor,
        BaseReferences<_$AppDatabase, $BookAuthorsTable, BookAuthor>,
      ),
      BookAuthor,
      PrefetchHooks Function()
    >;
typedef $$UserBookStatusesTableCreateCompanionBuilder =
    UserBookStatusesCompanion Function({
      required String bookId,
      required BookReadingStatus status,
      Value<double?> rating,
      Value<int> currentPage,
      Value<bool> isFavorite,
      Value<DateTime?> startDate,
      Value<DateTime?> finishDate,
      Value<DateTime> dateAdded,
      Value<DateTime> dateUpdated,
      Value<int> rowid,
    });
typedef $$UserBookStatusesTableUpdateCompanionBuilder =
    UserBookStatusesCompanion Function({
      Value<String> bookId,
      Value<BookReadingStatus> status,
      Value<double?> rating,
      Value<int> currentPage,
      Value<bool> isFavorite,
      Value<DateTime?> startDate,
      Value<DateTime?> finishDate,
      Value<DateTime> dateAdded,
      Value<DateTime> dateUpdated,
      Value<int> rowid,
    });

class $$UserBookStatusesTableFilterComposer
    extends Composer<_$AppDatabase, $UserBookStatusesTable> {
  $$UserBookStatusesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get bookId => $composableBuilder(
    column: $table.bookId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<BookReadingStatus, BookReadingStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentPage => $composableBuilder(
    column: $table.currentPage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get finishDate => $composableBuilder(
    column: $table.finishDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateAdded => $composableBuilder(
    column: $table.dateAdded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateUpdated => $composableBuilder(
    column: $table.dateUpdated,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserBookStatusesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserBookStatusesTable> {
  $$UserBookStatusesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get bookId => $composableBuilder(
    column: $table.bookId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentPage => $composableBuilder(
    column: $table.currentPage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get finishDate => $composableBuilder(
    column: $table.finishDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateAdded => $composableBuilder(
    column: $table.dateAdded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateUpdated => $composableBuilder(
    column: $table.dateUpdated,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserBookStatusesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserBookStatusesTable> {
  $$UserBookStatusesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get bookId =>
      $composableBuilder(column: $table.bookId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<BookReadingStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<double> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<int> get currentPage => $composableBuilder(
    column: $table.currentPage,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get finishDate => $composableBuilder(
    column: $table.finishDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dateAdded =>
      $composableBuilder(column: $table.dateAdded, builder: (column) => column);

  GeneratedColumn<DateTime> get dateUpdated => $composableBuilder(
    column: $table.dateUpdated,
    builder: (column) => column,
  );
}

class $$UserBookStatusesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserBookStatusesTable,
          UserBookStatuse,
          $$UserBookStatusesTableFilterComposer,
          $$UserBookStatusesTableOrderingComposer,
          $$UserBookStatusesTableAnnotationComposer,
          $$UserBookStatusesTableCreateCompanionBuilder,
          $$UserBookStatusesTableUpdateCompanionBuilder,
          (
            UserBookStatuse,
            BaseReferences<
              _$AppDatabase,
              $UserBookStatusesTable,
              UserBookStatuse
            >,
          ),
          UserBookStatuse,
          PrefetchHooks Function()
        > {
  $$UserBookStatusesTableTableManager(
    _$AppDatabase db,
    $UserBookStatusesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserBookStatusesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserBookStatusesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserBookStatusesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> bookId = const Value.absent(),
                Value<BookReadingStatus> status = const Value.absent(),
                Value<double?> rating = const Value.absent(),
                Value<int> currentPage = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<DateTime?> startDate = const Value.absent(),
                Value<DateTime?> finishDate = const Value.absent(),
                Value<DateTime> dateAdded = const Value.absent(),
                Value<DateTime> dateUpdated = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserBookStatusesCompanion(
                bookId: bookId,
                status: status,
                rating: rating,
                currentPage: currentPage,
                isFavorite: isFavorite,
                startDate: startDate,
                finishDate: finishDate,
                dateAdded: dateAdded,
                dateUpdated: dateUpdated,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String bookId,
                required BookReadingStatus status,
                Value<double?> rating = const Value.absent(),
                Value<int> currentPage = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<DateTime?> startDate = const Value.absent(),
                Value<DateTime?> finishDate = const Value.absent(),
                Value<DateTime> dateAdded = const Value.absent(),
                Value<DateTime> dateUpdated = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserBookStatusesCompanion.insert(
                bookId: bookId,
                status: status,
                rating: rating,
                currentPage: currentPage,
                isFavorite: isFavorite,
                startDate: startDate,
                finishDate: finishDate,
                dateAdded: dateAdded,
                dateUpdated: dateUpdated,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserBookStatusesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserBookStatusesTable,
      UserBookStatuse,
      $$UserBookStatusesTableFilterComposer,
      $$UserBookStatusesTableOrderingComposer,
      $$UserBookStatusesTableAnnotationComposer,
      $$UserBookStatusesTableCreateCompanionBuilder,
      $$UserBookStatusesTableUpdateCompanionBuilder,
      (
        UserBookStatuse,
        BaseReferences<_$AppDatabase, $UserBookStatusesTable, UserBookStatuse>,
      ),
      UserBookStatuse,
      PrefetchHooks Function()
    >;
typedef $$ReadingSessionsTableCreateCompanionBuilder =
    ReadingSessionsCompanion Function({
      required String id,
      required String bookId,
      Value<DateTime> date,
      required int endPage,
      Value<int> durationMinutes,
      Value<String?> notes,
      Value<String?> location,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$ReadingSessionsTableUpdateCompanionBuilder =
    ReadingSessionsCompanion Function({
      Value<String> id,
      Value<String> bookId,
      Value<DateTime> date,
      Value<int> endPage,
      Value<int> durationMinutes,
      Value<String?> notes,
      Value<String?> location,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$ReadingSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $ReadingSessionsTable> {
  $$ReadingSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bookId => $composableBuilder(
    column: $table.bookId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endPage => $composableBuilder(
    column: $table.endPage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReadingSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReadingSessionsTable> {
  $$ReadingSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bookId => $composableBuilder(
    column: $table.bookId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endPage => $composableBuilder(
    column: $table.endPage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReadingSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReadingSessionsTable> {
  $$ReadingSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get bookId =>
      $composableBuilder(column: $table.bookId, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get endPage =>
      $composableBuilder(column: $table.endPage, builder: (column) => column);

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ReadingSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReadingSessionsTable,
          ReadingSession,
          $$ReadingSessionsTableFilterComposer,
          $$ReadingSessionsTableOrderingComposer,
          $$ReadingSessionsTableAnnotationComposer,
          $$ReadingSessionsTableCreateCompanionBuilder,
          $$ReadingSessionsTableUpdateCompanionBuilder,
          (
            ReadingSession,
            BaseReferences<
              _$AppDatabase,
              $ReadingSessionsTable,
              ReadingSession
            >,
          ),
          ReadingSession,
          PrefetchHooks Function()
        > {
  $$ReadingSessionsTableTableManager(
    _$AppDatabase db,
    $ReadingSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReadingSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReadingSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReadingSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> bookId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> endPage = const Value.absent(),
                Value<int> durationMinutes = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReadingSessionsCompanion(
                id: id,
                bookId: bookId,
                date: date,
                endPage: endPage,
                durationMinutes: durationMinutes,
                notes: notes,
                location: location,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String bookId,
                Value<DateTime> date = const Value.absent(),
                required int endPage,
                Value<int> durationMinutes = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReadingSessionsCompanion.insert(
                id: id,
                bookId: bookId,
                date: date,
                endPage: endPage,
                durationMinutes: durationMinutes,
                notes: notes,
                location: location,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReadingSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReadingSessionsTable,
      ReadingSession,
      $$ReadingSessionsTableFilterComposer,
      $$ReadingSessionsTableOrderingComposer,
      $$ReadingSessionsTableAnnotationComposer,
      $$ReadingSessionsTableCreateCompanionBuilder,
      $$ReadingSessionsTableUpdateCompanionBuilder,
      (
        ReadingSession,
        BaseReferences<_$AppDatabase, $ReadingSessionsTable, ReadingSession>,
      ),
      ReadingSession,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AuthorsTableTableManager get authors =>
      $$AuthorsTableTableManager(_db, _db.authors);
  $$BooksTableTableManager get books =>
      $$BooksTableTableManager(_db, _db.books);
  $$BookAuthorsTableTableManager get bookAuthors =>
      $$BookAuthorsTableTableManager(_db, _db.bookAuthors);
  $$UserBookStatusesTableTableManager get userBookStatuses =>
      $$UserBookStatusesTableTableManager(_db, _db.userBookStatuses);
  $$ReadingSessionsTableTableManager get readingSessions =>
      $$ReadingSessionsTableTableManager(_db, _db.readingSessions);
}
