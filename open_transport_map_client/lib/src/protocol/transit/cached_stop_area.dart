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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_database/serverpod_database.dart' as _isd;

abstract class CachedStopArea
    implements _isd.TableRow<int?>, _isc.ProtocolSerialization {
  CachedStopArea._({
    this.id,
    required this.externalId,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.municipality,
    required this.syncedAt,
  });

  factory CachedStopArea({
    int? id,
    required String externalId,
    required String name,
    required double latitude,
    required double longitude,
    String? municipality,
    required DateTime syncedAt,
  }) = _CachedStopAreaImpl;

  factory CachedStopArea.fromJson(Map<String, dynamic> jsonSerialization) {
    return CachedStopArea(
      id: jsonSerialization['id'] as int?,
      externalId: jsonSerialization['externalId'] as String,
      name: jsonSerialization['name'] as String,
      latitude: (jsonSerialization['latitude'] as num).toDouble(),
      longitude: (jsonSerialization['longitude'] as num).toDouble(),
      municipality: jsonSerialization['municipality'] as String?,
      syncedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['syncedAt'],
      ),
    );
  }

  static final t = CachedStopAreaTable();

  static const db = CachedStopAreaRepository._();

  @override
  int? id;

  String externalId;

  String name;

  double latitude;

  double longitude;

  String? municipality;

  DateTime syncedAt;

  @override
  _isd.Table<int?> get table => t;

  /// Returns a shallow copy of this [CachedStopArea]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CachedStopArea copyWith({
    int? id,
    String? externalId,
    String? name,
    double? latitude,
    double? longitude,
    String? municipality,
    DateTime? syncedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CachedStopArea',
      if (id != null) 'id': id,
      'externalId': externalId,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      if (municipality != null) 'municipality': municipality,
      'syncedAt': syncedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CachedStopArea',
      if (id != null) 'id': id,
      'externalId': externalId,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      if (municipality != null) 'municipality': municipality,
      'syncedAt': syncedAt.toJson(),
    };
  }

  static CachedStopAreaInclude include() {
    return CachedStopAreaInclude._();
  }

  static CachedStopAreaIncludeList includeList({
    _isd.WhereExpressionBuilder<CachedStopAreaTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<CachedStopAreaTable>? orderBy,
    _isd.OrderByListBuilder<CachedStopAreaTable>? orderByList,
    CachedStopAreaInclude? include,
  }) {
    return CachedStopAreaIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CachedStopArea.t),
      orderByList: orderByList?.call(CachedStopArea.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CachedStopAreaImpl extends CachedStopArea {
  _CachedStopAreaImpl({
    int? id,
    required String externalId,
    required String name,
    required double latitude,
    required double longitude,
    String? municipality,
    required DateTime syncedAt,
  }) : super._(
         id: id,
         externalId: externalId,
         name: name,
         latitude: latitude,
         longitude: longitude,
         municipality: municipality,
         syncedAt: syncedAt,
       );

  /// Returns a shallow copy of this [CachedStopArea]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CachedStopArea copyWith({
    Object? id = _Undefined,
    String? externalId,
    String? name,
    double? latitude,
    double? longitude,
    Object? municipality = _Undefined,
    DateTime? syncedAt,
  }) {
    return CachedStopArea(
      id: id is int? ? id : this.id,
      externalId: externalId ?? this.externalId,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      municipality: municipality is String? ? municipality : this.municipality,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }
}

class CachedStopAreaUpdateTable extends _isd.UpdateTable<CachedStopAreaTable> {
  CachedStopAreaUpdateTable(super.table);

  _isd.ColumnValue<String, String> externalId(String value) => _isd.ColumnValue(
    table.externalId,
    value,
  );

  _isd.ColumnValue<String, String> name(String value) => _isd.ColumnValue(
    table.name,
    value,
  );

  _isd.ColumnValue<double, double> latitude(double value) => _isd.ColumnValue(
    table.latitude,
    value,
  );

  _isd.ColumnValue<double, double> longitude(double value) => _isd.ColumnValue(
    table.longitude,
    value,
  );

  _isd.ColumnValue<String, String> municipality(String? value) =>
      _isd.ColumnValue(
        table.municipality,
        value,
      );

  _isd.ColumnValue<DateTime, DateTime> syncedAt(DateTime value) =>
      _isd.ColumnValue(
        table.syncedAt,
        value,
      );
}

class CachedStopAreaTable extends _isd.Table<int?> {
  CachedStopAreaTable({super.tableRelation})
    : super(tableName: 'cached_stop_area') {
    updateTable = CachedStopAreaUpdateTable(this);
    externalId = _isd.ColumnString(
      'externalId',
      this,
    );
    name = _isd.ColumnString(
      'name',
      this,
    );
    latitude = _isd.ColumnDouble(
      'latitude',
      this,
    );
    longitude = _isd.ColumnDouble(
      'longitude',
      this,
    );
    municipality = _isd.ColumnString(
      'municipality',
      this,
    );
    syncedAt = _isd.ColumnDateTime(
      'syncedAt',
      this,
    );
  }

  late final CachedStopAreaUpdateTable updateTable;

  late final _isd.ColumnString externalId;

  late final _isd.ColumnString name;

  late final _isd.ColumnDouble latitude;

  late final _isd.ColumnDouble longitude;

  late final _isd.ColumnString municipality;

  late final _isd.ColumnDateTime syncedAt;

  @override
  List<_isd.Column> get columns => [
    id,
    externalId,
    name,
    latitude,
    longitude,
    municipality,
    syncedAt,
  ];
}

class CachedStopAreaInclude extends _isd.IncludeObject {
  CachedStopAreaInclude._();

  @override
  Map<String, _isd.Include?> get includes => {};

  @override
  _isd.Table<int?> get table => CachedStopArea.t;
}

class CachedStopAreaIncludeList extends _isd.IncludeList {
  CachedStopAreaIncludeList._({
    _isd.WhereExpressionBuilder<CachedStopAreaTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CachedStopArea.t);
  }

  @override
  Map<String, _isd.Include?> get includes => include?.includes ?? {};

  @override
  _isd.Table<int?> get table => CachedStopArea.t;
}

class CachedStopAreaRepository {
  const CachedStopAreaRepository._();

  /// Returns a list of [CachedStopArea]s matching the given query parameters.
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
  Future<List<CachedStopArea>> find(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<CachedStopAreaTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<CachedStopAreaTable>? orderBy,
    _isd.OrderByListBuilder<CachedStopAreaTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CachedStopArea>(
      where: where?.call(CachedStopArea.t),
      orderBy: orderBy?.call(CachedStopArea.t),
      orderByList: orderByList?.call(CachedStopArea.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CachedStopArea] matching the given query parameters.
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
  Future<CachedStopArea?> findFirstRow(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<CachedStopAreaTable>? where,
    int? offset,
    _isd.OrderByBuilder<CachedStopAreaTable>? orderBy,
    _isd.OrderByListBuilder<CachedStopAreaTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CachedStopArea>(
      where: where?.call(CachedStopArea.t),
      orderBy: orderBy?.call(CachedStopArea.t),
      orderByList: orderByList?.call(CachedStopArea.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CachedStopArea] by its [id] or null if no such row exists.
  Future<CachedStopArea?> findById(
    _isd.DatabaseSession session,
    int id, {
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CachedStopArea>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CachedStopArea]s in the list and returns the inserted rows.
  ///
  /// The returned [CachedStopArea]s will have their `id` fields set.
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
  Future<List<CachedStopArea>> insert(
    _isd.DatabaseSession session,
    List<CachedStopArea> rows, {
    _isd.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<CachedStopArea>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [CachedStopArea] and returns the inserted row.
  ///
  /// The returned [CachedStopArea] will have its `id` field set.
  Future<CachedStopArea> insertRow(
    _isd.DatabaseSession session,
    CachedStopArea row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.insertRow<CachedStopArea>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [CachedStopArea]s in the list and returns the resulting rows.
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
  /// The returned [CachedStopArea]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CachedStopArea>> upsert(
    _isd.DatabaseSession session,
    List<CachedStopArea> rows, {
    required _isd.ColumnSelections<CachedStopAreaTable> conflictColumns,
    _isd.ColumnSelections<CachedStopAreaTable>? updateColumns,
    _isd.WhereExpressionBuilder<CachedStopAreaTable>? updateWhere,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<CachedStopArea>(
      rows,
      conflictColumns: conflictColumns(CachedStopArea.t),
      updateColumns: updateColumns?.call(CachedStopArea.t),
      updateWhere: updateWhere?.call(CachedStopArea.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [CachedStopArea] and returns the resulting row.
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
  /// The returned [CachedStopArea] will have its `id` field set.
  Future<CachedStopArea?> upsertRow(
    _isd.DatabaseSession session,
    CachedStopArea row, {
    required _isd.ColumnSelections<CachedStopAreaTable> conflictColumns,
    _isd.ColumnSelections<CachedStopAreaTable>? updateColumns,
    _isd.WhereExpressionBuilder<CachedStopAreaTable>? updateWhere,
    _isd.Transaction? transaction,
  }) async {
    return session.db.upsertRow<CachedStopArea>(
      row,
      conflictColumns: conflictColumns(CachedStopArea.t),
      updateColumns: updateColumns?.call(CachedStopArea.t),
      updateWhere: updateWhere?.call(CachedStopArea.t),
      transaction: transaction,
    );
  }

  /// Updates all [CachedStopArea]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CachedStopArea>> update(
    _isd.DatabaseSession session,
    List<CachedStopArea> rows, {
    _isd.ColumnSelections<CachedStopAreaTable>? columns,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<CachedStopArea>(
      rows,
      columns: columns?.call(CachedStopArea.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [CachedStopArea]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CachedStopArea> updateRow(
    _isd.DatabaseSession session,
    CachedStopArea row, {
    _isd.ColumnSelections<CachedStopAreaTable>? columns,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateRow<CachedStopArea>(
      row,
      columns: columns?.call(CachedStopArea.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CachedStopArea] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CachedStopArea?> updateById(
    _isd.DatabaseSession session,
    int id, {
    required _isd.ColumnValueListBuilder<CachedStopAreaUpdateTable>
    columnValues,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateById<CachedStopArea>(
      id,
      columnValues: columnValues(CachedStopArea.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CachedStopArea]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CachedStopArea>> updateWhere(
    _isd.DatabaseSession session, {
    required _isd.ColumnValueListBuilder<CachedStopAreaUpdateTable>
    columnValues,
    required _isd.WhereExpressionBuilder<CachedStopAreaTable> where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<CachedStopAreaTable>? orderBy,
    _isd.OrderByListBuilder<CachedStopAreaTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<CachedStopArea>(
      columnValues: columnValues(CachedStopArea.t.updateTable),
      where: where(CachedStopArea.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CachedStopArea.t),
      orderByList: orderByList?.call(CachedStopArea.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [CachedStopArea]s in the list and returns the deleted rows.
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
  Future<List<CachedStopArea>> delete(
    _isd.DatabaseSession session,
    List<CachedStopArea> rows, {
    _isd.OrderByBuilder<CachedStopAreaTable>? orderBy,
    _isd.OrderByListBuilder<CachedStopAreaTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<CachedStopArea>(
      rows,
      orderBy: orderBy?.call(CachedStopArea.t),
      orderByList: orderByList?.call(CachedStopArea.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [CachedStopArea].
  Future<CachedStopArea> deleteRow(
    _isd.DatabaseSession session,
    CachedStopArea row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CachedStopArea>(
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
  Future<List<CachedStopArea>> deleteWhere(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<CachedStopAreaTable> where,
    _isd.OrderByBuilder<CachedStopAreaTable>? orderBy,
    _isd.OrderByListBuilder<CachedStopAreaTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<CachedStopArea>(
      where: where(CachedStopArea.t),
      orderBy: orderBy?.call(CachedStopArea.t),
      orderByList: orderByList?.call(CachedStopArea.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<CachedStopAreaTable>? where,
    int? limit,
    _isd.Transaction? transaction,
  }) async {
    return session.db.count<CachedStopArea>(
      where: where?.call(CachedStopArea.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CachedStopArea] rows matching the [where] expression.
  Future<void> lockRows(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<CachedStopAreaTable> where,
    required _isd.LockMode lockMode,
    required _isd.Transaction transaction,
    _isd.LockBehavior lockBehavior = _isd.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CachedStopArea>(
      where: where(CachedStopArea.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
