/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;

abstract class TransitStopArea
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  TransitStopArea._({
    this.id,
    required this.agencyId,
    required this.externalId,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.municipality,
    this.tariffZoneId,
  });

  factory TransitStopArea({
    int? id,
    required int agencyId,
    required String externalId,
    required String name,
    required double latitude,
    required double longitude,
    String? municipality,
    int? tariffZoneId,
  }) = _TransitStopAreaImpl;

  factory TransitStopArea.fromJson(Map<String, dynamic> jsonSerialization) {
    return TransitStopArea(
      id: jsonSerialization['id'] as int?,
      agencyId: jsonSerialization['agencyId'] as int,
      externalId: jsonSerialization['externalId'] as String,
      name: jsonSerialization['name'] as String,
      latitude: (jsonSerialization['latitude'] as num).toDouble(),
      longitude: (jsonSerialization['longitude'] as num).toDouble(),
      municipality: jsonSerialization['municipality'] as String?,
      tariffZoneId: jsonSerialization['tariffZoneId'] as int?,
    );
  }

  static final t = TransitStopAreaTable();

  static const db = TransitStopAreaRepository._();

  @override
  int? id;

  int agencyId;

  String externalId;

  String name;

  double latitude;

  double longitude;

  String? municipality;

  int? tariffZoneId;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [TransitStopArea]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TransitStopArea copyWith({
    int? id,
    int? agencyId,
    String? externalId,
    String? name,
    double? latitude,
    double? longitude,
    String? municipality,
    int? tariffZoneId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TransitStopArea',
      if (id != null) 'id': id,
      'agencyId': agencyId,
      'externalId': externalId,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      if (municipality != null) 'municipality': municipality,
      if (tariffZoneId != null) 'tariffZoneId': tariffZoneId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TransitStopArea',
      if (id != null) 'id': id,
      'agencyId': agencyId,
      'externalId': externalId,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      if (municipality != null) 'municipality': municipality,
      if (tariffZoneId != null) 'tariffZoneId': tariffZoneId,
    };
  }

  static TransitStopAreaInclude include() {
    return TransitStopAreaInclude._();
  }

  static TransitStopAreaIncludeList includeList({
    _is.WhereExpressionBuilder<TransitStopAreaTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TransitStopAreaTable>? orderBy,
    _is.OrderByListBuilder<TransitStopAreaTable>? orderByList,
    TransitStopAreaInclude? include,
  }) {
    return TransitStopAreaIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TransitStopArea.t),
      orderByList: orderByList?.call(TransitStopArea.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TransitStopAreaImpl extends TransitStopArea {
  _TransitStopAreaImpl({
    int? id,
    required int agencyId,
    required String externalId,
    required String name,
    required double latitude,
    required double longitude,
    String? municipality,
    int? tariffZoneId,
  }) : super._(
         id: id,
         agencyId: agencyId,
         externalId: externalId,
         name: name,
         latitude: latitude,
         longitude: longitude,
         municipality: municipality,
         tariffZoneId: tariffZoneId,
       );

  /// Returns a shallow copy of this [TransitStopArea]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TransitStopArea copyWith({
    Object? id = _Undefined,
    int? agencyId,
    String? externalId,
    String? name,
    double? latitude,
    double? longitude,
    Object? municipality = _Undefined,
    Object? tariffZoneId = _Undefined,
  }) {
    return TransitStopArea(
      id: id is int? ? id : this.id,
      agencyId: agencyId ?? this.agencyId,
      externalId: externalId ?? this.externalId,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      municipality: municipality is String? ? municipality : this.municipality,
      tariffZoneId: tariffZoneId is int? ? tariffZoneId : this.tariffZoneId,
    );
  }
}

class TransitStopAreaUpdateTable extends _is.UpdateTable<TransitStopAreaTable> {
  TransitStopAreaUpdateTable(super.table);

  _is.ColumnValue<int, int> agencyId(int value) => _is.ColumnValue(
    table.agencyId,
    value,
  );

  _is.ColumnValue<String, String> externalId(String value) => _is.ColumnValue(
    table.externalId,
    value,
  );

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<double, double> latitude(double value) => _is.ColumnValue(
    table.latitude,
    value,
  );

  _is.ColumnValue<double, double> longitude(double value) => _is.ColumnValue(
    table.longitude,
    value,
  );

  _is.ColumnValue<String, String> municipality(String? value) =>
      _is.ColumnValue(
        table.municipality,
        value,
      );

  _is.ColumnValue<int, int> tariffZoneId(int? value) => _is.ColumnValue(
    table.tariffZoneId,
    value,
  );
}

class TransitStopAreaTable extends _is.Table<int?> {
  TransitStopAreaTable({super.tableRelation})
    : super(tableName: 'transit_stop_area') {
    updateTable = TransitStopAreaUpdateTable(this);
    agencyId = _is.ColumnInt(
      'agencyId',
      this,
    );
    externalId = _is.ColumnString(
      'externalId',
      this,
    );
    name = _is.ColumnString(
      'name',
      this,
    );
    latitude = _is.ColumnDouble(
      'latitude',
      this,
    );
    longitude = _is.ColumnDouble(
      'longitude',
      this,
    );
    municipality = _is.ColumnString(
      'municipality',
      this,
    );
    tariffZoneId = _is.ColumnInt(
      'tariffZoneId',
      this,
    );
  }

  late final TransitStopAreaUpdateTable updateTable;

  late final _is.ColumnInt agencyId;

  late final _is.ColumnString externalId;

  late final _is.ColumnString name;

  late final _is.ColumnDouble latitude;

  late final _is.ColumnDouble longitude;

  late final _is.ColumnString municipality;

  late final _is.ColumnInt tariffZoneId;

  @override
  List<_is.Column> get columns => [
    id,
    agencyId,
    externalId,
    name,
    latitude,
    longitude,
    municipality,
    tariffZoneId,
  ];
}

class TransitStopAreaInclude extends _is.IncludeObject {
  TransitStopAreaInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => TransitStopArea.t;
}

class TransitStopAreaIncludeList extends _is.IncludeList {
  TransitStopAreaIncludeList._({
    _is.WhereExpressionBuilder<TransitStopAreaTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TransitStopArea.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => TransitStopArea.t;
}

class TransitStopAreaRepository {
  const TransitStopAreaRepository._();

  /// Returns a list of [TransitStopArea]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<TransitStopArea>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TransitStopAreaTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TransitStopAreaTable>? orderBy,
    _is.OrderByListBuilder<TransitStopAreaTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<TransitStopArea>(
      where: where?.call(TransitStopArea.t),
      orderBy: orderBy?.call(TransitStopArea.t),
      orderByList: orderByList?.call(TransitStopArea.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [TransitStopArea] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<TransitStopArea?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TransitStopAreaTable>? where,
    int? offset,
    _is.OrderByBuilder<TransitStopAreaTable>? orderBy,
    _is.OrderByListBuilder<TransitStopAreaTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<TransitStopArea>(
      where: where?.call(TransitStopArea.t),
      orderBy: orderBy?.call(TransitStopArea.t),
      orderByList: orderByList?.call(TransitStopArea.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [TransitStopArea] by its [id] or null if no such row exists.
  Future<TransitStopArea?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<TransitStopArea>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [TransitStopArea]s in the list and returns the inserted rows.
  ///
  /// The returned [TransitStopArea]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TransitStopArea>> insert(
    _is.DatabaseSession session,
    List<TransitStopArea> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<TransitStopArea>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [TransitStopArea] and returns the inserted row.
  ///
  /// The returned [TransitStopArea] will have its `id` field set.
  Future<TransitStopArea> insertRow(
    _is.DatabaseSession session,
    TransitStopArea row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<TransitStopArea>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [TransitStopArea]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [TransitStopArea]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TransitStopArea>> upsert(
    _is.DatabaseSession session,
    List<TransitStopArea> rows, {
    required _is.ColumnSelections<TransitStopAreaTable> conflictColumns,
    _is.ColumnSelections<TransitStopAreaTable>? updateColumns,
    _is.WhereExpressionBuilder<TransitStopAreaTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<TransitStopArea>(
      rows,
      conflictColumns: conflictColumns(TransitStopArea.t),
      updateColumns: updateColumns?.call(TransitStopArea.t),
      updateWhere: updateWhere?.call(TransitStopArea.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [TransitStopArea] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [TransitStopArea] will have its `id` field set.
  Future<TransitStopArea?> upsertRow(
    _is.DatabaseSession session,
    TransitStopArea row, {
    required _is.ColumnSelections<TransitStopAreaTable> conflictColumns,
    _is.ColumnSelections<TransitStopAreaTable>? updateColumns,
    _is.WhereExpressionBuilder<TransitStopAreaTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<TransitStopArea>(
      row,
      conflictColumns: conflictColumns(TransitStopArea.t),
      updateColumns: updateColumns?.call(TransitStopArea.t),
      updateWhere: updateWhere?.call(TransitStopArea.t),
      transaction: transaction,
    );
  }

  /// Updates all [TransitStopArea]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TransitStopArea>> update(
    _is.DatabaseSession session,
    List<TransitStopArea> rows, {
    _is.ColumnSelections<TransitStopAreaTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<TransitStopArea>(
      rows,
      columns: columns?.call(TransitStopArea.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [TransitStopArea]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TransitStopArea> updateRow(
    _is.DatabaseSession session,
    TransitStopArea row, {
    _is.ColumnSelections<TransitStopAreaTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<TransitStopArea>(
      row,
      columns: columns?.call(TransitStopArea.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TransitStopArea] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TransitStopArea?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<TransitStopAreaUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<TransitStopArea>(
      id,
      columnValues: columnValues(TransitStopArea.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TransitStopArea]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TransitStopArea>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<TransitStopAreaUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<TransitStopAreaTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TransitStopAreaTable>? orderBy,
    _is.OrderByListBuilder<TransitStopAreaTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<TransitStopArea>(
      columnValues: columnValues(TransitStopArea.t.updateTable),
      where: where(TransitStopArea.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TransitStopArea.t),
      orderByList: orderByList?.call(TransitStopArea.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [TransitStopArea]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TransitStopArea>> delete(
    _is.DatabaseSession session,
    List<TransitStopArea> rows, {
    _is.OrderByBuilder<TransitStopAreaTable>? orderBy,
    _is.OrderByListBuilder<TransitStopAreaTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<TransitStopArea>(
      rows,
      orderBy: orderBy?.call(TransitStopArea.t),
      orderByList: orderByList?.call(TransitStopArea.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [TransitStopArea].
  Future<TransitStopArea> deleteRow(
    _is.DatabaseSession session,
    TransitStopArea row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TransitStopArea>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TransitStopArea>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TransitStopAreaTable> where,
    _is.OrderByBuilder<TransitStopAreaTable>? orderBy,
    _is.OrderByListBuilder<TransitStopAreaTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<TransitStopArea>(
      where: where(TransitStopArea.t),
      orderBy: orderBy?.call(TransitStopArea.t),
      orderByList: orderByList?.call(TransitStopArea.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TransitStopAreaTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<TransitStopArea>(
      where: where?.call(TransitStopArea.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [TransitStopArea] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TransitStopAreaTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<TransitStopArea>(
      where: where(TransitStopArea.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
