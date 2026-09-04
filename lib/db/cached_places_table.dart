import 'package:drift/drift.dart';

class CachedPlaces extends Table {
  TextColumn get orderId => text()();
  TextColumn get address => text()();
  RealColumn get lat => real()();
  RealColumn get lng => real()();
  BoolColumn get pickup => boolean()();
  BoolColumn get isAirportLocation => boolean().nullable()();
}
