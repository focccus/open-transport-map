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

abstract class TransitNextStop
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  TransitNextStop._({
    this.id,
    required this.routeId,
    required this.headsign,
    required this.stopPointExternalId,
    required this.nextStopName,
    this.cachedAt,
  });

  factory TransitNextStop({
    int? id,
    required int routeId,
    required String headsign,
    required String stopPointExternalId,
    required String nextStopName,
    DateTime? cachedAt,
  }) = _TransitNextStopImpl;

  factory TransitNextStop.fromJson(Map<String, dynamic> jsonSerialization) {
    return TransitNextStop(
      id: jsonSerialization['id'] as int?,
      routeId: jsonSerialization['routeId'] as int,
      headsign: jsonSerialization['headsign'] as String,
      stopPointExternalId: jsonSerialization['stopPointExternalId'] as String,
      nextStopName: jsonSerialization['nextStopName'] as String,
      cachedAt: jsonSerialization['cachedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['cachedAt']),
    );
  }

  static final t = TransitNextStopTable();

  static const db = TransitNextStopRepository._();

  @override
  int? id;

  int routeId;

  String headsign;

  /// Stop point the departure is observed at. A journey's next call depends on
  /// where you board it, so the cache is keyed per stop point, not just per
  /// route and direction.
  String stopPointExternalId;

  String nextStopName;

  DateTime? cachedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [TransitNextStop]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TransitNextStop copyWith({
    int? id,
    int? routeId,
    String? headsign,
    String? stopPointExternalId,
    String? nextStopName,
    DateTime? cachedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TransitNextStop',
      if (id != null) 'id': id,
      'routeId': routeId,
      'headsign': headsign,
      'stopPointExternalId': stopPointExternalId,
      'nextStopName': nextStopName,
      if (cachedAt != null) 'cachedAt': cachedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TransitNextStop',
      if (id != null) 'id': id,
      'routeId': routeId,
      'headsign': headsign,
      'stopPointExternalId': stopPointExternalId,
      'nextStopName': nextStopName,
      if (cachedAt != null) 'cachedAt': cachedAt?.toJson(),
    };
  }

  static TransitNextStopInclude include() {
    return TransitNextStopInclude._();
  }

  static TransitNextStopIncludeList includeList({
    _is.WhereExpressionBuilder<TransitNextStopTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TransitNextStopTable>? orderBy,
    _is.OrderByListBuilder<TransitNextStopTable>? orderByList,
    TransitNextStopInclude? include,
  }) {
    return TransitNextStopIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TransitNextStop.t),
      orderByList: orderByList?.call(TransitNextStop.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TransitNextStopImpl extends TransitNextStop {
  _TransitNextStopImpl({
    int? id,
    required int routeId,
    required String headsign,
    required String stopPointExternalId,
    required String nextStopName,
    DateTime? cachedAt,
  }) : super._(
         id: id,
         routeId: routeId,
         headsign: headsign,
         stopPointExternalId: stopPointExternalId,
         nextStopName: nextStopName,
         cachedAt: cachedAt,
       );

  /// Returns a shallow copy of this [TransitNextStop]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TransitNextStop copyWith({
    Object? id = _Undefined,
    int? routeId,
    String? headsign,
    String? stopPointExternalId,
    String? nextStopName,
    Object? cachedAt = _Undefined,
  }) {
    return TransitNextStop(
      id: id is int? ? id : this.id,
      routeId: routeId ?? this.routeId,
      headsign: headsign ?? this.headsign,
      stopPointExternalId: stopPointExternalId ?? this.stopPointExternalId,
      nextStopName: nextStopName ?? this.nextStopName,
      cachedAt: cachedAt is DateTime? ? cachedAt : this.cachedAt,
    );
  }
}

class TransitNextStopUpdateTable extends _is.UpdateTable<TransitNextStopTable> {
  TransitNextStopUpdateTable(super.table);

  _is.ColumnValue<int, int> routeId(int value) => _is.ColumnValue(
    table.routeId,
    value,
  );

  _is.ColumnValue<String, String> headsign(String value) => _is.ColumnValue(
    table.headsign,
    value,
  );

  _is.ColumnValue<String, String> stopPointExternalId(String value) =>
      _is.ColumnValue(
        table.stopPointExternalId,
        value,
      );

  _is.ColumnValue<String, String> nextStopName(String value) => _is.ColumnValue(
    table.nextStopName,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> cachedAt(DateTime? value) =>
      _is.ColumnValue(
        table.cachedAt,
        value,
      );
}

class TransitNextStopTable extends _is.Table<int?> {
  TransitNextStopTable({super.tableRelation})
    : super(tableName: 'transit_next_stop') {
    updateTable = TransitNextStopUpdateTable(this);
    routeId = _is.ColumnInt(
      'routeId',
      this,
    );
    headsign = _is.ColumnString(
      'headsign',
      this,
    );
    stopPointExternalId = _is.ColumnString(
      'stopPointExternalId',
      this,
    );
    nextStopName = _is.ColumnString(
      'nextStopName',
      this,
    );
    cachedAt = _is.ColumnDateTime(
      'cachedAt',
      this,
    );
  }

  late final TransitNextStopUpdateTable updateTable;

  late final _is.ColumnInt routeId;

  late final _is.ColumnString headsign;

  /// Stop point the departure is observed at. A journey's next call depends on
  /// where you board it, so the cache is keyed per stop point, not just per
  /// route and direction.
  late final _is.ColumnString stopPointExternalId;

  late final _is.ColumnString nextStopName;

  late final _is.ColumnDateTime cachedAt;

  @override
  List<_is.Column> get columns => [
    id,
    routeId,
    headsign,
    stopPointExternalId,
    nextStopName,
    cachedAt,
  ];
}

class TransitNextStopInclude extends _is.IncludeObject {
  TransitNextStopInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => TransitNextStop.t;
}

class TransitNextStopIncludeList extends _is.IncludeList {
  TransitNextStopIncludeList._({
    _is.WhereExpressionBuilder<TransitNextStopTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TransitNextStop.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => TransitNextStop.t;
}

class TransitNextStopRepository {
  const TransitNextStopRepository._();

  /// Returns a list of [TransitNextStop]s matching the given query parameters.
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
  Future<List<TransitNextStop>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TransitNextStopTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TransitNextStopTable>? orderBy,
    _is.OrderByListBuilder<TransitNextStopTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<TransitNextStop>(
      where: where?.call(TransitNextStop.t),
      orderBy: orderBy?.call(TransitNextStop.t),
      orderByList: orderByList?.call(TransitNextStop.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [TransitNextStop] matching the given query parameters.
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
  Future<TransitNextStop?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TransitNextStopTable>? where,
    int? offset,
    _is.OrderByBuilder<TransitNextStopTable>? orderBy,
    _is.OrderByListBuilder<TransitNextStopTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<TransitNextStop>(
      where: where?.call(TransitNextStop.t),
      orderBy: orderBy?.call(TransitNextStop.t),
      orderByList: orderByList?.call(TransitNextStop.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [TransitNextStop] by its [id] or null if no such row exists.
  Future<TransitNextStop?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<TransitNextStop>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [TransitNextStop]s in the list and returns the inserted rows.
  ///
  /// The returned [TransitNextStop]s will have their `id` fields set.
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
  Future<List<TransitNextStop>> insert(
    _is.DatabaseSession session,
    List<TransitNextStop> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<TransitNextStop>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [TransitNextStop] and returns the inserted row.
  ///
  /// The returned [TransitNextStop] will have its `id` field set.
  Future<TransitNextStop> insertRow(
    _is.DatabaseSession session,
    TransitNextStop row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<TransitNextStop>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [TransitNextStop]s in the list and returns the resulting rows.
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
  /// The returned [TransitNextStop]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TransitNextStop>> upsert(
    _is.DatabaseSession session,
    List<TransitNextStop> rows, {
    required _is.ColumnSelections<TransitNextStopTable> conflictColumns,
    _is.ColumnSelections<TransitNextStopTable>? updateColumns,
    _is.WhereExpressionBuilder<TransitNextStopTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<TransitNextStop>(
      rows,
      conflictColumns: conflictColumns(TransitNextStop.t),
      updateColumns: updateColumns?.call(TransitNextStop.t),
      updateWhere: updateWhere?.call(TransitNextStop.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [TransitNextStop] and returns the resulting row.
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
  /// The returned [TransitNextStop] will have its `id` field set.
  Future<TransitNextStop?> upsertRow(
    _is.DatabaseSession session,
    TransitNextStop row, {
    required _is.ColumnSelections<TransitNextStopTable> conflictColumns,
    _is.ColumnSelections<TransitNextStopTable>? updateColumns,
    _is.WhereExpressionBuilder<TransitNextStopTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<TransitNextStop>(
      row,
      conflictColumns: conflictColumns(TransitNextStop.t),
      updateColumns: updateColumns?.call(TransitNextStop.t),
      updateWhere: updateWhere?.call(TransitNextStop.t),
      transaction: transaction,
    );
  }

  /// Updates all [TransitNextStop]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TransitNextStop>> update(
    _is.DatabaseSession session,
    List<TransitNextStop> rows, {
    _is.ColumnSelections<TransitNextStopTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<TransitNextStop>(
      rows,
      columns: columns?.call(TransitNextStop.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [TransitNextStop]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TransitNextStop> updateRow(
    _is.DatabaseSession session,
    TransitNextStop row, {
    _is.ColumnSelections<TransitNextStopTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<TransitNextStop>(
      row,
      columns: columns?.call(TransitNextStop.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TransitNextStop] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TransitNextStop?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<TransitNextStopUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<TransitNextStop>(
      id,
      columnValues: columnValues(TransitNextStop.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TransitNextStop]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TransitNextStop>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<TransitNextStopUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<TransitNextStopTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TransitNextStopTable>? orderBy,
    _is.OrderByListBuilder<TransitNextStopTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<TransitNextStop>(
      columnValues: columnValues(TransitNextStop.t.updateTable),
      where: where(TransitNextStop.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TransitNextStop.t),
      orderByList: orderByList?.call(TransitNextStop.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [TransitNextStop]s in the list and returns the deleted rows.
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
  Future<List<TransitNextStop>> delete(
    _is.DatabaseSession session,
    List<TransitNextStop> rows, {
    _is.OrderByBuilder<TransitNextStopTable>? orderBy,
    _is.OrderByListBuilder<TransitNextStopTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<TransitNextStop>(
      rows,
      orderBy: orderBy?.call(TransitNextStop.t),
      orderByList: orderByList?.call(TransitNextStop.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [TransitNextStop].
  Future<TransitNextStop> deleteRow(
    _is.DatabaseSession session,
    TransitNextStop row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TransitNextStop>(
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
  Future<List<TransitNextStop>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TransitNextStopTable> where,
    _is.OrderByBuilder<TransitNextStopTable>? orderBy,
    _is.OrderByListBuilder<TransitNextStopTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<TransitNextStop>(
      where: where(TransitNextStop.t),
      orderBy: orderBy?.call(TransitNextStop.t),
      orderByList: orderByList?.call(TransitNextStop.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TransitNextStopTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<TransitNextStop>(
      where: where?.call(TransitNextStop.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [TransitNextStop] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TransitNextStopTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<TransitNextStop>(
      where: where(TransitNextStop.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
