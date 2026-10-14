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

abstract class TransitRouteStop
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  TransitRouteStop._({
    this.id,
    required this.routeShapeId,
    required this.stopPointId,
    required this.stopSequence,
  });

  factory TransitRouteStop({
    int? id,
    required int routeShapeId,
    required int stopPointId,
    required int stopSequence,
  }) = _TransitRouteStopImpl;

  factory TransitRouteStop.fromJson(Map<String, dynamic> jsonSerialization) {
    return TransitRouteStop(
      id: jsonSerialization['id'] as int?,
      routeShapeId: jsonSerialization['routeShapeId'] as int,
      stopPointId: jsonSerialization['stopPointId'] as int,
      stopSequence: jsonSerialization['stopSequence'] as int,
    );
  }

  static final t = TransitRouteStopTable();

  static const db = TransitRouteStopRepository._();

  @override
  int? id;

  int routeShapeId;

  int stopPointId;

  int stopSequence;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [TransitRouteStop]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TransitRouteStop copyWith({
    int? id,
    int? routeShapeId,
    int? stopPointId,
    int? stopSequence,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TransitRouteStop',
      if (id != null) 'id': id,
      'routeShapeId': routeShapeId,
      'stopPointId': stopPointId,
      'stopSequence': stopSequence,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TransitRouteStop',
      if (id != null) 'id': id,
      'routeShapeId': routeShapeId,
      'stopPointId': stopPointId,
      'stopSequence': stopSequence,
    };
  }

  static TransitRouteStopInclude include() {
    return TransitRouteStopInclude._();
  }

  static TransitRouteStopIncludeList includeList({
    _is.WhereExpressionBuilder<TransitRouteStopTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TransitRouteStopTable>? orderBy,
    _is.OrderByListBuilder<TransitRouteStopTable>? orderByList,
    TransitRouteStopInclude? include,
  }) {
    return TransitRouteStopIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TransitRouteStop.t),
      orderByList: orderByList?.call(TransitRouteStop.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TransitRouteStopImpl extends TransitRouteStop {
  _TransitRouteStopImpl({
    int? id,
    required int routeShapeId,
    required int stopPointId,
    required int stopSequence,
  }) : super._(
         id: id,
         routeShapeId: routeShapeId,
         stopPointId: stopPointId,
         stopSequence: stopSequence,
       );

  /// Returns a shallow copy of this [TransitRouteStop]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TransitRouteStop copyWith({
    Object? id = _Undefined,
    int? routeShapeId,
    int? stopPointId,
    int? stopSequence,
  }) {
    return TransitRouteStop(
      id: id is int? ? id : this.id,
      routeShapeId: routeShapeId ?? this.routeShapeId,
      stopPointId: stopPointId ?? this.stopPointId,
      stopSequence: stopSequence ?? this.stopSequence,
    );
  }
}

class TransitRouteStopUpdateTable
    extends _is.UpdateTable<TransitRouteStopTable> {
  TransitRouteStopUpdateTable(super.table);

  _is.ColumnValue<int, int> routeShapeId(int value) => _is.ColumnValue(
    table.routeShapeId,
    value,
  );

  _is.ColumnValue<int, int> stopPointId(int value) => _is.ColumnValue(
    table.stopPointId,
    value,
  );

  _is.ColumnValue<int, int> stopSequence(int value) => _is.ColumnValue(
    table.stopSequence,
    value,
  );
}

class TransitRouteStopTable extends _is.Table<int?> {
  TransitRouteStopTable({super.tableRelation})
    : super(tableName: 'transit_route_stop') {
    updateTable = TransitRouteStopUpdateTable(this);
    routeShapeId = _is.ColumnInt(
      'routeShapeId',
      this,
    );
    stopPointId = _is.ColumnInt(
      'stopPointId',
      this,
    );
    stopSequence = _is.ColumnInt(
      'stopSequence',
      this,
    );
  }

  late final TransitRouteStopUpdateTable updateTable;

  late final _is.ColumnInt routeShapeId;

  late final _is.ColumnInt stopPointId;

  late final _is.ColumnInt stopSequence;

  @override
  List<_is.Column> get columns => [
    id,
    routeShapeId,
    stopPointId,
    stopSequence,
  ];
}

class TransitRouteStopInclude extends _is.IncludeObject {
  TransitRouteStopInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => TransitRouteStop.t;
}

class TransitRouteStopIncludeList extends _is.IncludeList {
  TransitRouteStopIncludeList._({
    _is.WhereExpressionBuilder<TransitRouteStopTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TransitRouteStop.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => TransitRouteStop.t;
}

class TransitRouteStopRepository {
  const TransitRouteStopRepository._();

  /// Returns a list of [TransitRouteStop]s matching the given query parameters.
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
  Future<List<TransitRouteStop>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TransitRouteStopTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TransitRouteStopTable>? orderBy,
    _is.OrderByListBuilder<TransitRouteStopTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<TransitRouteStop>(
      where: where?.call(TransitRouteStop.t),
      orderBy: orderBy?.call(TransitRouteStop.t),
      orderByList: orderByList?.call(TransitRouteStop.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [TransitRouteStop] matching the given query parameters.
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
  Future<TransitRouteStop?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TransitRouteStopTable>? where,
    int? offset,
    _is.OrderByBuilder<TransitRouteStopTable>? orderBy,
    _is.OrderByListBuilder<TransitRouteStopTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<TransitRouteStop>(
      where: where?.call(TransitRouteStop.t),
      orderBy: orderBy?.call(TransitRouteStop.t),
      orderByList: orderByList?.call(TransitRouteStop.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [TransitRouteStop] by its [id] or null if no such row exists.
  Future<TransitRouteStop?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<TransitRouteStop>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [TransitRouteStop]s in the list and returns the inserted rows.
  ///
  /// The returned [TransitRouteStop]s will have their `id` fields set.
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
  Future<List<TransitRouteStop>> insert(
    _is.DatabaseSession session,
    List<TransitRouteStop> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<TransitRouteStop>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [TransitRouteStop] and returns the inserted row.
  ///
  /// The returned [TransitRouteStop] will have its `id` field set.
  Future<TransitRouteStop> insertRow(
    _is.DatabaseSession session,
    TransitRouteStop row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<TransitRouteStop>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [TransitRouteStop]s in the list and returns the resulting rows.
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
  /// The returned [TransitRouteStop]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TransitRouteStop>> upsert(
    _is.DatabaseSession session,
    List<TransitRouteStop> rows, {
    required _is.ColumnSelections<TransitRouteStopTable> conflictColumns,
    _is.ColumnSelections<TransitRouteStopTable>? updateColumns,
    _is.WhereExpressionBuilder<TransitRouteStopTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<TransitRouteStop>(
      rows,
      conflictColumns: conflictColumns(TransitRouteStop.t),
      updateColumns: updateColumns?.call(TransitRouteStop.t),
      updateWhere: updateWhere?.call(TransitRouteStop.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [TransitRouteStop] and returns the resulting row.
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
  /// The returned [TransitRouteStop] will have its `id` field set.
  Future<TransitRouteStop?> upsertRow(
    _is.DatabaseSession session,
    TransitRouteStop row, {
    required _is.ColumnSelections<TransitRouteStopTable> conflictColumns,
    _is.ColumnSelections<TransitRouteStopTable>? updateColumns,
    _is.WhereExpressionBuilder<TransitRouteStopTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<TransitRouteStop>(
      row,
      conflictColumns: conflictColumns(TransitRouteStop.t),
      updateColumns: updateColumns?.call(TransitRouteStop.t),
      updateWhere: updateWhere?.call(TransitRouteStop.t),
      transaction: transaction,
    );
  }

  /// Updates all [TransitRouteStop]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TransitRouteStop>> update(
    _is.DatabaseSession session,
    List<TransitRouteStop> rows, {
    _is.ColumnSelections<TransitRouteStopTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<TransitRouteStop>(
      rows,
      columns: columns?.call(TransitRouteStop.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [TransitRouteStop]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TransitRouteStop> updateRow(
    _is.DatabaseSession session,
    TransitRouteStop row, {
    _is.ColumnSelections<TransitRouteStopTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<TransitRouteStop>(
      row,
      columns: columns?.call(TransitRouteStop.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TransitRouteStop] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TransitRouteStop?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<TransitRouteStopUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<TransitRouteStop>(
      id,
      columnValues: columnValues(TransitRouteStop.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TransitRouteStop]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TransitRouteStop>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<TransitRouteStopUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<TransitRouteStopTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TransitRouteStopTable>? orderBy,
    _is.OrderByListBuilder<TransitRouteStopTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<TransitRouteStop>(
      columnValues: columnValues(TransitRouteStop.t.updateTable),
      where: where(TransitRouteStop.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TransitRouteStop.t),
      orderByList: orderByList?.call(TransitRouteStop.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [TransitRouteStop]s in the list and returns the deleted rows.
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
  Future<List<TransitRouteStop>> delete(
    _is.DatabaseSession session,
    List<TransitRouteStop> rows, {
    _is.OrderByBuilder<TransitRouteStopTable>? orderBy,
    _is.OrderByListBuilder<TransitRouteStopTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<TransitRouteStop>(
      rows,
      orderBy: orderBy?.call(TransitRouteStop.t),
      orderByList: orderByList?.call(TransitRouteStop.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [TransitRouteStop].
  Future<TransitRouteStop> deleteRow(
    _is.DatabaseSession session,
    TransitRouteStop row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TransitRouteStop>(
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
  Future<List<TransitRouteStop>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TransitRouteStopTable> where,
    _is.OrderByBuilder<TransitRouteStopTable>? orderBy,
    _is.OrderByListBuilder<TransitRouteStopTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<TransitRouteStop>(
      where: where(TransitRouteStop.t),
      orderBy: orderBy?.call(TransitRouteStop.t),
      orderByList: orderByList?.call(TransitRouteStop.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TransitRouteStopTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<TransitRouteStop>(
      where: where?.call(TransitRouteStop.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [TransitRouteStop] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TransitRouteStopTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<TransitRouteStop>(
      where: where(TransitRouteStop.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
