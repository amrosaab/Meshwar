// ignore_for_file: depend_on_referenced_packages

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'cached_places_table.dart';
part 'app_database.g.dart';

@DriftDatabase(tables: [CachedPlaces])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<CachedPlace>> getCachedPlaces() => select(cachedPlaces).get();
  Future<void> insertCachedPlace(CachedPlace place) =>
      into(cachedPlaces).insert(place);
  Future<void> clearCachedPlaces() => delete(cachedPlaces).go();
  Future<void> deleteCachedPlaces(String eventOrderId) {
    return (delete(cachedPlaces)..where((t) => t.orderId.equals(eventOrderId)))
        .go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
