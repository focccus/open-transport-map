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

abstract class TransitRouteShape
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  TransitRouteShape._({
    this.id,
    required this.routeId,
    this.directionId,
    this.headsign,
    required this.geometryGeoJson,
    this.cachedAt,
  });

  factory TransitRouteShape({
    int? id,
    required int routeId,
    int? directionId,
    String? headsign,
    required String geometryGeoJson,
    DateTime? cachedAt,
  }) = _TransitRouteShapeImpl;

  factory TransitRouteShape.fromJson(Map<String, dynamic> jsonSerialization) {
    return TransitRouteShape(
      id: jsonSerialization['id'] as int?,
      routeId: jsonSerialization['routeId'] as int,
      directionId: jsonSerialization['directionId'] as int?,
      headsign: jsonSerialization['headsign'] as String?,
      geometryGeoJson: jsonSerialization['geometryGeoJson'] as String,
      cachedAt: jsonSerialization['cachedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['cachedAt']),
    );
  }

  static final t = TransitRouteShapeTable();

  static const db = TransitRouteShapeRepository._();

  @override
  int? id;

  int routeId;

  int? directionId;

  String? headsign;

  String geometryGeoJson;

  DateTime? cachedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [TransitRouteShape]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TransitRouteShape copyWith({
    int? id,
    int? routeId,
    int? directionId,
    String? headsign,
    String? geometryGeoJson,
    DateTime? cachedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TransitRouteShape',
      if (id != null) 'id': id,
      'routeId': routeId,
      if (directionId != null) 'directionId': directionId,
      if (headsign != null) 'headsign': headsign,
      'geometryGeoJson': geometryGeoJson,
      if (cachedAt != null) 'cachedAt': cachedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TransitRouteShape',
      if (id != null) 'id': id,
      'routeId': routeId,
      if (directionId != null) 'directionId': directionId,
      if (headsign != null) 'headsign': headsign,
      'geometryGeoJson': geometryGeoJson,
      if (cachedAt != null) 'cachedAt': cachedAt?.toJson(),
    };
  }

  static TransitRouteShapeInclude include() {
    return TransitRouteShapeInclude._();
  }

  static TransitRouteShapeIncludeList includeList({
    _is.WhereExpressionBuilder<TransitRouteShapeTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TransitRouteShapeTable>? orderBy,
    _is.OrderByListBuilder<TransitRouteShapeTable>? orderByList,
    TransitRouteShapeInclude? include,
  }) {
    return TransitRouteShapeIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TransitRouteShape.t),
      orderByList: orderByList?.call(TransitRouteShape.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TransitRouteShapeImpl extends TransitRouteShape {
  _TransitRouteShapeImpl({
    int? id,
    required int routeId,
    int? directionId,
    String? headsign,
    required String geometryGeoJson,
    DateTime? cachedAt,
  }) : super._(
         id: id,
         routeId: routeId,
         directionId: directionId,
         headsign: headsign,
         geometryGeoJson: geometryGeoJson,
         cachedAt: cachedAt,
       );

  /// Returns a shallow copy of this [TransitRouteShape]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TransitRouteShape copyWith({
    Object? id = _Undefined,
    int? routeId,
    Object? directionId = _Undefined,
    Object? headsign = _Undefined,
    String? geometryGeoJson,
    Object? cachedAt = _Undefined,
  }) {
    return TransitRouteShape(
      id: id is int? ? id : this.id,
      routeId: routeId ?? this.routeId,
      directionId: directionId is int? ? directionId : this.directionId,
      headsign: headsign is String? ? headsign : this.headsign,
      geometryGeoJson: geometryGeoJson ?? this.geometryGeoJson,
      cachedAt: cachedAt is DateTime? ? cachedAt : this.cachedAt,
    );
  }
}

class TransitRouteShapeUpdateTable
    extends _is.UpdateTable<TransitRouteShapeTable> {
  TransitRouteShapeUpdateTable(super.table);

  _is.ColumnValue<int, int> routeId(int value) => _is.ColumnValue(
    table.routeId,
    value,
  );

  _is.ColumnValue<int, int> directionId(int? value) => _is.ColumnValue(
    table.directionId,
    value,
  );

  _is.ColumnValue<String, String> headsign(String? value) => _is.ColumnValue(
    table.headsign,
    value,
  );

  _is.ColumnValue<String, String> geometryGeoJson(String value) =>
      _is.ColumnValue(
        table.geometryGeoJson,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> cachedAt(DateTime? value) =>
      _is.ColumnValue(
        table.cachedAt,
        value,
      );
}

class TransitRouteShapeTable extends _is.Table<int?> {
  TransitRouteShapeTable({super.tableRelation})
    : super(tableName: 'transit_route_shape') {
    updateTable = TransitRouteShapeUpdateTable(this);
    routeId = _is.ColumnInt(
      'routeId',
      this,
    );
    directionId = _is.ColumnInt(
      'directionId',
      this,
    );
    headsign = _is.ColumnString(
      'headsign',
      this,
    );
    geometryGeoJson = _is.ColumnString(
      'geometryGeoJson',
      this,
    );
    cachedAt = _is.ColumnDateTime(
      'cachedAt',
      this,
    );
  }

  late final TransitRouteShapeUpdateTable updateTable;

  late final _is.ColumnInt routeId;

  late final _is.ColumnInt directionId;

  late final _is.ColumnString headsign;

  late final _is.ColumnString geometryGeoJson;

  late final _is.ColumnDateTime cachedAt;

  @override
  List<_is.Column> get columns => [
    id,
    routeId,
    directionId,
    headsign,
    geometryGeoJson,
    cachedAt,
  ];
}

class TransitRouteShapeInclude extends _is.IncludeObject {
  TransitRouteShapeInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => TransitRouteShape.t;
}

class TransitRouteShapeIncludeList extends _is.IncludeList {
  TransitRouteShapeIncludeList._({
    _is.WhereExpressionBuilder<TransitRouteShapeTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TransitRouteShape.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => TransitRouteShape.t;
}

class TransitRouteShapeRepository {
  const TransitRouteShapeRepository._();

  /// Returns a list of [TransitRouteShape]s matching the given query parameters.
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
  Future<List<TransitRouteShape>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TransitRouteShapeTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TransitRouteShapeTable>? orderBy,
    _is.OrderByListBuilder<TransitRouteShapeTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<TransitRouteShape>(
      where: where?.call(TransitRouteShape.t),
      orderBy: orderBy?.call(TransitRouteShape.t),
      orderByList: orderByList?.call(TransitRouteShape.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [TransitRouteShape] matching the given query parameters.
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
  Future<TransitRouteShape?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TransitRouteShapeTable>? where,
    int? offset,
    _is.OrderByBuilder<TransitRouteShapeTable>? orderBy,
    _is.OrderByListBuilder<TransitRouteShapeTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<TransitRouteShape>(
      where: where?.call(TransitRouteShape.t),
      orderBy: orderBy?.call(TransitRouteShape.t),
      orderByList: orderByList?.call(TransitRouteShape.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [TransitRouteShape] by its [id] or null if no such row exists.
  Future<TransitRouteShape?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<TransitRouteShape>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [TransitRouteShape]s in the list and returns the inserted rows.
  ///
  /// The returned [TransitRouteShape]s will have their `id` fields set.
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
  Future<List<TransitRouteShape>> insert(
    _is.DatabaseSession session,
    List<TransitRouteShape> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<TransitRouteShape>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [TransitRouteShape] and returns the inserted row.
  ///
  /// The returned [TransitRouteShape] will have its `id` field set.
  Future<TransitRouteShape> insertRow(
    _is.DatabaseSession session,
    TransitRouteShape row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<TransitRouteShape>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [TransitRouteShape]s in the list and returns the resulting rows.
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
  /// The returned [TransitRouteShape]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TransitRouteShape>> upsert(
    _is.DatabaseSession session,
    List<TransitRouteShape> rows, {
    required _is.ColumnSelections<TransitRouteShapeTable> conflictColumns,
    _is.ColumnSelections<TransitRouteShapeTable>? updateColumns,
    _is.WhereExpressionBuilder<TransitRouteShapeTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<TransitRouteShape>(
      rows,
      conflictColumns: conflictColumns(TransitRouteShape.t),
      updateColumns: updateColumns?.call(TransitRouteShape.t),
      updateWhere: updateWhere?.call(TransitRouteShape.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [TransitRouteShape] and returns the resulting row.
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
  /// The returned [TransitRouteShape] will have its `id` field set.
  Future<TransitRouteShape?> upsertRow(
    _is.DatabaseSession session,
    TransitRouteShape row, {
    required _is.ColumnSelections<TransitRouteShapeTable> conflictColumns,
    _is.ColumnSelections<TransitRouteShapeTable>? updateColumns,
    _is.WhereExpressionBuilder<TransitRouteShapeTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<TransitRouteShape>(
      row,
      conflictColumns: conflictColumns(TransitRouteShape.t),
      updateColumns: updateColumns?.call(TransitRouteShape.t),
      updateWhere: updateWhere?.call(TransitRouteShape.t),
      transaction: transaction,
    );
  }

  /// Updates all [TransitRouteShape]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TransitRouteShape>> update(
    _is.DatabaseSession session,
    List<TransitRouteShape> rows, {
    _is.ColumnSelections<TransitRouteShapeTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<TransitRouteShape>(
      rows,
      columns: columns?.call(TransitRouteShape.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [TransitRouteShape]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TransitRouteShape> updateRow(
    _is.DatabaseSession session,
    TransitRouteShape row, {
    _is.ColumnSelections<TransitRouteShapeTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<TransitRouteShape>(
      row,
      columns: columns?.call(TransitRouteShape.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TransitRouteShape] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TransitRouteShape?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<TransitRouteShapeUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<TransitRouteShape>(
      id,
      columnValues: columnValues(TransitRouteShape.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TransitRouteShape]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TransitRouteShape>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<TransitRouteShapeUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<TransitRouteShapeTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TransitRouteShapeTable>? orderBy,
    _is.OrderByListBuilder<TransitRouteShapeTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<TransitRouteShape>(
      columnValues: columnValues(TransitRouteShape.t.updateTable),
      where: where(TransitRouteShape.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TransitRouteShape.t),
      orderByList: orderByList?.call(TransitRouteShape.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [TransitRouteShape]s in the list and returns the deleted rows.
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
  Future<List<TransitRouteShape>> delete(
    _is.DatabaseSession session,
    List<TransitRouteShape> rows, {
    _is.OrderByBuilder<TransitRouteShapeTable>? orderBy,
    _is.OrderByListBuilder<TransitRouteShapeTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<TransitRouteShape>(
      rows,
      orderBy: orderBy?.call(TransitRouteShape.t),
      orderByList: orderByList?.call(TransitRouteShape.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [TransitRouteShape].
  Future<TransitRouteShape> deleteRow(
    _is.DatabaseSession session,
    TransitRouteShape row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TransitRouteShape>(
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
  Future<List<TransitRouteShape>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TransitRouteShapeTable> where,
    _is.OrderByBuilder<TransitRouteShapeTable>? orderBy,
    _is.OrderByListBuilder<TransitRouteShapeTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<TransitRouteShape>(
      where: where(TransitRouteShape.t),
      orderBy: orderBy?.call(TransitRouteShape.t),
      orderByList: orderByList?.call(TransitRouteShape.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TransitRouteShapeTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<TransitRouteShape>(
      where: where?.call(TransitRouteShape.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [TransitRouteShape] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TransitRouteShapeTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<TransitRouteShape>(
      where: where(TransitRouteShape.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
