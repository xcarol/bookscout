import 'package:drift/drift.dart';

/// Authors and contributors of literary works.
class Authors extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 500)();
  TextColumn get bio => text().nullable()();
  TextColumn get photoUrl => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
