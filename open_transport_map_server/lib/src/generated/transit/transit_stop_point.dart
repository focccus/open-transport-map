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

abstract class TransitStopPoint
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  TransitStopPoint._({
    this.id,
    required this.agencyId,
    required this.stopAreaId,
    required this.externalId,
    required this.name,
    this.platform,
    required this.latitude,
    required this.longitude,
    this.designation,
  });

  factory TransitStopPoint({
    int? id,
    required int agencyId,
    required int stopAreaId,
    required String externalId,
    required String name,
    String? platform,
    required double latitude,
    required double longitude,
    String? designation,
  }) = _TransitStopPointImpl;

  factory TransitStopPoint.fromJson(Map<String, dynamic> jsonSerialization) {
    return TransitStopPoint(
      id: jsonSerialization['id'] as int?,
      agencyId: jsonSerialization['agencyId'] as int,
      stopAreaId: jsonSerialization['stopAreaId'] as int,
      externalId: jsonSerialization['externalId'] as String,
      name: jsonSerialization['name'] as String,
      platform: jsonSerialization['platform'] as String?,
      latitude: (jsonSerialization['latitude'] as num).toDouble(),
      longitude: (jsonSerialization['longitude'] as num).toDouble(),
      designation: jsonSerialization['designation'] as String?,
    );
  }

  static final t = TransitStopPointTable();

  static const db = TransitStopPointRepository._();

  @override
  int? id;

  int agencyId;

  int stopAreaId;

  String externalId;

  String name;

  String? platform;

  double latitude;

  double longitude;

  String? designation;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [TransitStopPoint]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TransitStopPoint copyWith({
    int? id,
    int? agencyId,
    int? stopAreaId,
    String? externalId,
    String? name,
    String? platform,
    double? latitude,
    double? longitude,
    String? designation,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TransitStopPoint',
      if (id != null) 'id': id,
      'agencyId': agencyId,
      'stopAreaId': stopAreaId,
      'externalId': externalId,
      'name': name,
      if (platform != null) 'platform': platform,
      'latitude': latitude,
      'longitude': longitude,
      if (designation != null) 'designation': designation,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TransitStopPoint',
      if (id != null) 'id': id,
      'agencyId': agencyId,
      'stopAreaId': stopAreaId,
      'externalId': externalId,
      'name': name,
      if (platform != null) 'platform': platform,
      'latitude': latitude,
      'longitude': longitude,
      if (designation != null) 'designation': designation,
    };
  }

  static TransitStopPointInclude include() {
    return TransitStopPointInclude._();
  }

  static TransitStopPointIncludeList includeList({
    _is.WhereExpressionBuilder<TransitStopPointTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TransitStopPointTable>? orderBy,
    _is.OrderByListBuilder<TransitStopPointTable>? orderByList,
    TransitStopPointInclude? include,
  }) {
    return TransitStopPointIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TransitStopPoint.t),
      orderByList: orderByList?.call(TransitStopPoint.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TransitStopPointImpl extends TransitStopPoint {
  _TransitStopPointImpl({
    int? id,
    required int agencyId,
    required int stopAreaId,
    required String externalId,
    required String name,
    String? platform,
    required double latitude,
    required double longitude,
    String? designation,
  }) : super._(
         id: id,
         agencyId: agencyId,
         stopAreaId: stopAreaId,
         externalId: externalId,
         name: name,
         platform: platform,
         latitude: latitude,
         longitude: longitude,
         designation: designation,
       );

  /// Returns a shallow copy of this [TransitStopPoint]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TransitStopPoint copyWith({
    Object? id = _Undefined,
    int? agencyId,
    int? stopAreaId,
    String? externalId,
    String? name,
    Object? platform = _Undefined,
    double? latitude,
    double? longitude,
    Object? designation = _Undefined,
  }) {
    return TransitStopPoint(
      id: id is int? ? id : this.id,
      agencyId: agencyId ?? this.agencyId,
      stopAreaId: stopAreaId ?? this.stopAreaId,
      externalId: externalId ?? this.externalId,
      name: name ?? this.name,
      platform: platform is String? ? platform : this.platform,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      designation: designation is String? ? designation : this.designation,
    );
  }
}

class TransitStopPointUpdateTable
    extends _is.UpdateTable<TransitStopPointTable> {
  TransitStopPointUpdateTable(super.table);

  _is.ColumnValue<int, int> agencyId(int value) => _is.ColumnValue(
    table.agencyId,
    value,
  );

  _is.ColumnValue<int, int> stopAreaId(int value) => _is.ColumnValue(
    table.stopAreaId,
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

  _is.ColumnValue<String, String> platform(String? value) => _is.ColumnValue(
    table.platform,
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

  _is.ColumnValue<String, String> designation(String? value) => _is.ColumnValue(
    table.designation,
    value,
  );
}

class TransitStopPointTable extends _is.Table<int?> {
  TransitStopPointTable({super.tableRelation})
    : super(tableName: 'transit_stop_point') {
    updateTable = TransitStopPointUpdateTable(this);
    agencyId = _is.ColumnInt(
      'agencyId',
      this,
    );
    stopAreaId = _is.ColumnInt(
      'stopAreaId',
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
    platform = _is.ColumnString(
      'platform',
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
    designation = _is.ColumnString(
      'designation',
      this,
    );
  }

  late final TransitStopPointUpdateTable updateTable;

  late final _is.ColumnInt agencyId;

  late final _is.ColumnInt stopAreaId;

  late final _is.ColumnString externalId;

  late final _is.ColumnString name;

  late final _is.ColumnString platform;

  late final _is.ColumnDouble latitude;

  late final _is.ColumnDouble longitude;

  late final _is.ColumnString designation;

  @override
  List<_is.Column> get columns => [
    id,
    agencyId,
    stopAreaId,
    externalId,
    name,
    platform,
    latitude,
    longitude,
    designation,
  ];
}

class TransitStopPointInclude extends _is.IncludeObject {
  TransitStopPointInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => TransitStopPoint.t;
}

class TransitStopPointIncludeList extends _is.IncludeList {
  TransitStopPointIncludeList._({
    _is.WhereExpressionBuilder<TransitStopPointTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TransitStopPoint.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => TransitStopPoint.t;
}

class TransitStopPointRepository {
  const TransitStopPointRepository._();

  /// Returns a list of [TransitStopPoint]s matching the given query parameters.
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
  Future<List<TransitStopPoint>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TransitStopPointTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TransitStopPointTable>? orderBy,
    _is.OrderByListBuilder<TransitStopPointTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<TransitStopPoint>(
      where: where?.call(TransitStopPoint.t),
      orderBy: orderBy?.call(TransitStopPoint.t),
      orderByList: orderByList?.call(TransitStopPoint.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [TransitStopPoint] matching the given query parameters.
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
  Future<TransitStopPoint?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TransitStopPointTable>? where,
    int? offset,
    _is.OrderByBuilder<TransitStopPointTable>? orderBy,
    _is.OrderByListBuilder<TransitStopPointTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<TransitStopPoint>(
      where: where?.call(TransitStopPoint.t),
      orderBy: orderBy?.call(TransitStopPoint.t),
      orderByList: orderByList?.call(TransitStopPoint.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [TransitStopPoint] by its [id] or null if no such row exists.
  Future<TransitStopPoint?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<TransitStopPoint>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [TransitStopPoint]s in the list and returns the inserted rows.
  ///
  /// The returned [TransitStopPoint]s will have their `id` fields set.
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
  Future<List<TransitStopPoint>> insert(
    _is.DatabaseSession session,
    List<TransitStopPoint> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<TransitStopPoint>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [TransitStopPoint] and returns the inserted row.
  ///
  /// The returned [TransitStopPoint] will have its `id` field set.
  Future<TransitStopPoint> insertRow(
    _is.DatabaseSession session,
    TransitStopPoint row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<TransitStopPoint>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [TransitStopPoint]s in the list and returns the resulting rows.
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
  /// The returned [TransitStopPoint]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TransitStopPoint>> upsert(
    _is.DatabaseSession session,
    List<TransitStopPoint> rows, {
    required _is.ColumnSelections<TransitStopPointTable> conflictColumns,
    _is.ColumnSelections<TransitStopPointTable>? updateColumns,
    _is.WhereExpressionBuilder<TransitStopPointTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<TransitStopPoint>(
      rows,
      conflictColumns: conflictColumns(TransitStopPoint.t),
      updateColumns: updateColumns?.call(TransitStopPoint.t),
      updateWhere: updateWhere?.call(TransitStopPoint.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [TransitStopPoint] and returns the resulting row.
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
  /// The returned [TransitStopPoint] will have its `id` field set.
  Future<TransitStopPoint?> upsertRow(
    _is.DatabaseSession session,
    TransitStopPoint row, {
    required _is.ColumnSelections<TransitStopPointTable> conflictColumns,
    _is.ColumnSelections<TransitStopPointTable>? updateColumns,
    _is.WhereExpressionBuilder<TransitStopPointTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<TransitStopPoint>(
      row,
      conflictColumns: conflictColumns(TransitStopPoint.t),
      updateColumns: updateColumns?.call(TransitStopPoint.t),
      updateWhere: updateWhere?.call(TransitStopPoint.t),
      transaction: transaction,
    );
  }

  /// Updates all [TransitStopPoint]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TransitStopPoint>> update(
    _is.DatabaseSession session,
    List<TransitStopPoint> rows, {
    _is.ColumnSelections<TransitStopPointTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<TransitStopPoint>(
      rows,
      columns: columns?.call(TransitStopPoint.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [TransitStopPoint]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TransitStopPoint> updateRow(
    _is.DatabaseSession session,
    TransitStopPoint row, {
    _is.ColumnSelections<TransitStopPointTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<TransitStopPoint>(
      row,
      columns: columns?.call(TransitStopPoint.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TransitStopPoint] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TransitStopPoint?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<TransitStopPointUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<TransitStopPoint>(
      id,
      columnValues: columnValues(TransitStopPoint.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TransitStopPoint]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TransitStopPoint>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<TransitStopPointUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<TransitStopPointTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TransitStopPointTable>? orderBy,
    _is.OrderByListBuilder<TransitStopPointTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<TransitStopPoint>(
      columnValues: columnValues(TransitStopPoint.t.updateTable),
      where: where(TransitStopPoint.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TransitStopPoint.t),
      orderByList: orderByList?.call(TransitStopPoint.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [TransitStopPoint]s in the list and returns the deleted rows.
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
  Future<List<TransitStopPoint>> delete(
    _is.DatabaseSession session,
    List<TransitStopPoint> rows, {
    _is.OrderByBuilder<TransitStopPointTable>? orderBy,
    _is.OrderByListBuilder<TransitStopPointTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<TransitStopPoint>(
      rows,
      orderBy: orderBy?.call(TransitStopPoint.t),
      orderByList: orderByList?.call(TransitStopPoint.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [TransitStopPoint].
  Future<TransitStopPoint> deleteRow(
    _is.DatabaseSession session,
    TransitStopPoint row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TransitStopPoint>(
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
  Future<List<TransitStopPoint>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TransitStopPointTable> where,
    _is.OrderByBuilder<TransitStopPointTable>? orderBy,
    _is.OrderByListBuilder<TransitStopPointTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<TransitStopPoint>(
      where: where(TransitStopPoint.t),
      orderBy: orderBy?.call(TransitStopPoint.t),
      orderByList: orderByList?.call(TransitStopPoint.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TransitStopPointTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<TransitStopPoint>(
      where: where?.call(TransitStopPoint.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [TransitStopPoint] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TransitStopPointTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<TransitStopPoint>(
      where: where(TransitStopPoint.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
