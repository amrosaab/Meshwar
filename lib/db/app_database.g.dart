// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CachedPlacesTable extends CachedPlaces
    with TableInfo<$CachedPlacesTable, CachedPlace> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedPlacesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _orderIdMeta =
      const VerificationMeta('orderId');
  @override
  late final GeneratedColumn<String> orderId = GeneratedColumn<String>(
      'order_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
      'lat', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _lngMeta = const VerificationMeta('lng');
  @override
  late final GeneratedColumn<double> lng = GeneratedColumn<double>(
      'lng', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _pickupMeta = const VerificationMeta('pickup');
  @override
  late final GeneratedColumn<bool> pickup = GeneratedColumn<bool>(
      'pickup', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("pickup" IN (0, 1))'));
  static const VerificationMeta _isAirportLocationMeta =
      const VerificationMeta('isAirportLocation');
  @override
  late final GeneratedColumn<bool> isAirportLocation = GeneratedColumn<bool>(
      'is_airport_location', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_airport_location" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns =>
      [orderId, address, lat, lng, pickup, isAirportLocation];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_places';
  @override
  VerificationContext validateIntegrity(Insertable<CachedPlace> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('order_id')) {
      context.handle(_orderIdMeta,
          orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta));
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('lat')) {
      context.handle(
          _latMeta, lat.isAcceptableOrUnknown(data['lat']!, _latMeta));
    } else if (isInserting) {
      context.missing(_latMeta);
    }
    if (data.containsKey('lng')) {
      context.handle(
          _lngMeta, lng.isAcceptableOrUnknown(data['lng']!, _lngMeta));
    } else if (isInserting) {
      context.missing(_lngMeta);
    }
    if (data.containsKey('pickup')) {
      context.handle(_pickupMeta,
          pickup.isAcceptableOrUnknown(data['pickup']!, _pickupMeta));
    } else if (isInserting) {
      context.missing(_pickupMeta);
    }
    if (data.containsKey('is_airport_location')) {
      context.handle(
          _isAirportLocationMeta,
          isAirportLocation.isAcceptableOrUnknown(
              data['is_airport_location']!, _isAirportLocationMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  CachedPlace map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedPlace(
      orderId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}order_id'])!,
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address'])!,
      lat: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}lat'])!,
      lng: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}lng'])!,
      pickup: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}pickup'])!,
      isAirportLocation: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}is_airport_location']),
    );
  }

  @override
  $CachedPlacesTable createAlias(String alias) {
    return $CachedPlacesTable(attachedDatabase, alias);
  }
}

class CachedPlace extends DataClass implements Insertable<CachedPlace> {
  final String orderId;
  final String address;
  final double lat;
  final double lng;
  final bool pickup;
  final bool? isAirportLocation;
  const CachedPlace(
      {required this.orderId,
      required this.address,
      required this.lat,
      required this.lng,
      required this.pickup,
      this.isAirportLocation});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['order_id'] = Variable<String>(orderId);
    map['address'] = Variable<String>(address);
    map['lat'] = Variable<double>(lat);
    map['lng'] = Variable<double>(lng);
    map['pickup'] = Variable<bool>(pickup);
    if (!nullToAbsent || isAirportLocation != null) {
      map['is_airport_location'] = Variable<bool>(isAirportLocation);
    }
    return map;
  }

  CachedPlacesCompanion toCompanion(bool nullToAbsent) {
    return CachedPlacesCompanion(
      orderId: Value(orderId),
      address: Value(address),
      lat: Value(lat),
      lng: Value(lng),
      pickup: Value(pickup),
      isAirportLocation: isAirportLocation == null && nullToAbsent
          ? const Value.absent()
          : Value(isAirportLocation),
    );
  }

  factory CachedPlace.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedPlace(
      orderId: serializer.fromJson<String>(json['orderId']),
      address: serializer.fromJson<String>(json['address']),
      lat: serializer.fromJson<double>(json['lat']),
      lng: serializer.fromJson<double>(json['lng']),
      pickup: serializer.fromJson<bool>(json['pickup']),
      isAirportLocation: serializer.fromJson<bool?>(json['isAirportLocation']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'orderId': serializer.toJson<String>(orderId),
      'address': serializer.toJson<String>(address),
      'lat': serializer.toJson<double>(lat),
      'lng': serializer.toJson<double>(lng),
      'pickup': serializer.toJson<bool>(pickup),
      'isAirportLocation': serializer.toJson<bool?>(isAirportLocation),
    };
  }

  CachedPlace copyWith(
          {String? orderId,
          String? address,
          double? lat,
          double? lng,
          bool? pickup,
          Value<bool?> isAirportLocation = const Value.absent()}) =>
      CachedPlace(
        orderId: orderId ?? this.orderId,
        address: address ?? this.address,
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
        pickup: pickup ?? this.pickup,
        isAirportLocation: isAirportLocation.present
            ? isAirportLocation.value
            : this.isAirportLocation,
      );
  CachedPlace copyWithCompanion(CachedPlacesCompanion data) {
    return CachedPlace(
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      address: data.address.present ? data.address.value : this.address,
      lat: data.lat.present ? data.lat.value : this.lat,
      lng: data.lng.present ? data.lng.value : this.lng,
      pickup: data.pickup.present ? data.pickup.value : this.pickup,
      isAirportLocation: data.isAirportLocation.present
          ? data.isAirportLocation.value
          : this.isAirportLocation,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedPlace(')
          ..write('orderId: $orderId, ')
          ..write('address: $address, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('pickup: $pickup, ')
          ..write('isAirportLocation: $isAirportLocation')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(orderId, address, lat, lng, pickup, isAirportLocation);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedPlace &&
          other.orderId == this.orderId &&
          other.address == this.address &&
          other.lat == this.lat &&
          other.lng == this.lng &&
          other.pickup == this.pickup &&
          other.isAirportLocation == this.isAirportLocation);
}

class CachedPlacesCompanion extends UpdateCompanion<CachedPlace> {
  final Value<String> orderId;
  final Value<String> address;
  final Value<double> lat;
  final Value<double> lng;
  final Value<bool> pickup;
  final Value<bool?> isAirportLocation;
  final Value<int> rowid;
  const CachedPlacesCompanion({
    this.orderId = const Value.absent(),
    this.address = const Value.absent(),
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.pickup = const Value.absent(),
    this.isAirportLocation = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedPlacesCompanion.insert({
    required String orderId,
    required String address,
    required double lat,
    required double lng,
    required bool pickup,
    this.isAirportLocation = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : orderId = Value(orderId),
        address = Value(address),
        lat = Value(lat),
        lng = Value(lng),
        pickup = Value(pickup);
  static Insertable<CachedPlace> custom({
    Expression<String>? orderId,
    Expression<String>? address,
    Expression<double>? lat,
    Expression<double>? lng,
    Expression<bool>? pickup,
    Expression<bool>? isAirportLocation,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (orderId != null) 'order_id': orderId,
      if (address != null) 'address': address,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (pickup != null) 'pickup': pickup,
      if (isAirportLocation != null) 'is_airport_location': isAirportLocation,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedPlacesCompanion copyWith(
      {Value<String>? orderId,
      Value<String>? address,
      Value<double>? lat,
      Value<double>? lng,
      Value<bool>? pickup,
      Value<bool?>? isAirportLocation,
      Value<int>? rowid}) {
    return CachedPlacesCompanion(
      orderId: orderId ?? this.orderId,
      address: address ?? this.address,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      pickup: pickup ?? this.pickup,
      isAirportLocation: isAirportLocation ?? this.isAirportLocation,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (orderId.present) {
      map['order_id'] = Variable<String>(orderId.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lng.present) {
      map['lng'] = Variable<double>(lng.value);
    }
    if (pickup.present) {
      map['pickup'] = Variable<bool>(pickup.value);
    }
    if (isAirportLocation.present) {
      map['is_airport_location'] = Variable<bool>(isAirportLocation.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedPlacesCompanion(')
          ..write('orderId: $orderId, ')
          ..write('address: $address, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('pickup: $pickup, ')
          ..write('isAirportLocation: $isAirportLocation, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CachedPlacesTable cachedPlaces = $CachedPlacesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [cachedPlaces];
}

typedef $$CachedPlacesTableCreateCompanionBuilder = CachedPlacesCompanion
    Function({
  required String orderId,
  required String address,
  required double lat,
  required double lng,
  required bool pickup,
  Value<bool?> isAirportLocation,
  Value<int> rowid,
});
typedef $$CachedPlacesTableUpdateCompanionBuilder = CachedPlacesCompanion
    Function({
  Value<String> orderId,
  Value<String> address,
  Value<double> lat,
  Value<double> lng,
  Value<bool> pickup,
  Value<bool?> isAirportLocation,
  Value<int> rowid,
});

class $$CachedPlacesTableFilterComposer
    extends Composer<_$AppDatabase, $CachedPlacesTable> {
  $$CachedPlacesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get orderId => $composableBuilder(
      column: $table.orderId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get lat => $composableBuilder(
      column: $table.lat, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get lng => $composableBuilder(
      column: $table.lng, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get pickup => $composableBuilder(
      column: $table.pickup, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isAirportLocation => $composableBuilder(
      column: $table.isAirportLocation,
      builder: (column) => ColumnFilters(column));
}

class $$CachedPlacesTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedPlacesTable> {
  $$CachedPlacesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get orderId => $composableBuilder(
      column: $table.orderId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get lat => $composableBuilder(
      column: $table.lat, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get lng => $composableBuilder(
      column: $table.lng, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get pickup => $composableBuilder(
      column: $table.pickup, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isAirportLocation => $composableBuilder(
      column: $table.isAirportLocation,
      builder: (column) => ColumnOrderings(column));
}

class $$CachedPlacesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedPlacesTable> {
  $$CachedPlacesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get orderId =>
      $composableBuilder(column: $table.orderId, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lng =>
      $composableBuilder(column: $table.lng, builder: (column) => column);

  GeneratedColumn<bool> get pickup =>
      $composableBuilder(column: $table.pickup, builder: (column) => column);

  GeneratedColumn<bool> get isAirportLocation => $composableBuilder(
      column: $table.isAirportLocation, builder: (column) => column);
}

class $$CachedPlacesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CachedPlacesTable,
    CachedPlace,
    $$CachedPlacesTableFilterComposer,
    $$CachedPlacesTableOrderingComposer,
    $$CachedPlacesTableAnnotationComposer,
    $$CachedPlacesTableCreateCompanionBuilder,
    $$CachedPlacesTableUpdateCompanionBuilder,
    (
      CachedPlace,
      BaseReferences<_$AppDatabase, $CachedPlacesTable, CachedPlace>
    ),
    CachedPlace,
    PrefetchHooks Function()> {
  $$CachedPlacesTableTableManager(_$AppDatabase db, $CachedPlacesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedPlacesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedPlacesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedPlacesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> orderId = const Value.absent(),
            Value<String> address = const Value.absent(),
            Value<double> lat = const Value.absent(),
            Value<double> lng = const Value.absent(),
            Value<bool> pickup = const Value.absent(),
            Value<bool?> isAirportLocation = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CachedPlacesCompanion(
            orderId: orderId,
            address: address,
            lat: lat,
            lng: lng,
            pickup: pickup,
            isAirportLocation: isAirportLocation,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String orderId,
            required String address,
            required double lat,
            required double lng,
            required bool pickup,
            Value<bool?> isAirportLocation = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CachedPlacesCompanion.insert(
            orderId: orderId,
            address: address,
            lat: lat,
            lng: lng,
            pickup: pickup,
            isAirportLocation: isAirportLocation,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CachedPlacesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CachedPlacesTable,
    CachedPlace,
    $$CachedPlacesTableFilterComposer,
    $$CachedPlacesTableOrderingComposer,
    $$CachedPlacesTableAnnotationComposer,
    $$CachedPlacesTableCreateCompanionBuilder,
    $$CachedPlacesTableUpdateCompanionBuilder,
    (
      CachedPlace,
      BaseReferences<_$AppDatabase, $CachedPlacesTable, CachedPlace>
    ),
    CachedPlace,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CachedPlacesTableTableManager get cachedPlaces =>
      $$CachedPlacesTableTableManager(_db, _db.cachedPlaces);
}
