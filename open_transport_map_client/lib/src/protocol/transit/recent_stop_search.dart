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

abstract class RecentStopSearch
    implements _isd.TableRow<int?>, _isc.ProtocolSerialization {
  RecentStopSearch._({
    this.id,
    required this.query,
    required this.searchedAt,
  });

  factory RecentStopSearch({
    int? id,
    required String query,
    required DateTime searchedAt,
  }) = _RecentStopSearchImpl;

  factory RecentStopSearch.fromJson(Map<String, dynamic> jsonSerialization) {
    return RecentStopSearch(
      id: jsonSerialization['id'] as int?,
      query: jsonSerialization['query'] as String,
      searchedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['searchedAt'],
      ),
    );
  }

  static final t = RecentStopSearchTable();

  static const db = RecentStopSearchRepository._();

  @override
  int? id;

  String query;

  DateTime searchedAt;

  @override
  _isd.Table<int?> get table => t;

  /// Returns a shallow copy of this [RecentStopSearch]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  RecentStopSearch copyWith({
    int? id,
    String? query,
    DateTime? searchedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RecentStopSearch',
      if (id != null) 'id': id,
      'query': query,
      'searchedAt': searchedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RecentStopSearch',
      if (id != null) 'id': id,
      'query': query,
      'searchedAt': searchedAt.toJson(),
    };
  }

  static RecentStopSearchInclude include() {
    return RecentStopSearchInclude._();
  }

  static RecentStopSearchIncludeList includeList({
    _isd.WhereExpressionBuilder<RecentStopSearchTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<RecentStopSearchTable>? orderBy,
    _isd.OrderByListBuilder<RecentStopSearchTable>? orderByList,
    RecentStopSearchInclude? include,
  }) {
    return RecentStopSearchIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RecentStopSearch.t),
      orderByList: orderByList?.call(RecentStopSearch.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RecentStopSearchImpl extends RecentStopSearch {
  _RecentStopSearchImpl({
    int? id,
    required String query,
    required DateTime searchedAt,
  }) : super._(
         id: id,
         query: query,
         searchedAt: searchedAt,
       );

  /// Returns a shallow copy of this [RecentStopSearch]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  RecentStopSearch copyWith({
    Object? id = _Undefined,
    String? query,
    DateTime? searchedAt,
  }) {
    return RecentStopSearch(
      id: id is int? ? id : this.id,
      query: query ?? this.query,
      searchedAt: searchedAt ?? this.searchedAt,
    );
  }
}

class RecentStopSearchUpdateTable
    extends _isd.UpdateTable<RecentStopSearchTable> {
  RecentStopSearchUpdateTable(super.table);

  _isd.ColumnValue<String, String> query(String value) => _isd.ColumnValue(
    table.query,
    value,
  );

  _isd.ColumnValue<DateTime, DateTime> searchedAt(DateTime value) =>
      _isd.ColumnValue(
        table.searchedAt,
        value,
      );
}

class RecentStopSearchTable extends _isd.Table<int?> {
  RecentStopSearchTable({super.tableRelation})
    : super(tableName: 'recent_stop_search') {
    updateTable = RecentStopSearchUpdateTable(this);
    query = _isd.ColumnString(
      'query',
      this,
    );
    searchedAt = _isd.ColumnDateTime(
      'searchedAt',
      this,
    );
  }

  late final RecentStopSearchUpdateTable updateTable;

  late final _isd.ColumnString query;

  late final _isd.ColumnDateTime searchedAt;

  @override
  List<_isd.Column> get columns => [
    id,
    query,
    searchedAt,
  ];
}

class RecentStopSearchInclude extends _isd.IncludeObject {
  RecentStopSearchInclude._();

  @override
  Map<String, _isd.Include?> get includes => {};

  @override
  _isd.Table<int?> get table => RecentStopSearch.t;
}

class RecentStopSearchIncludeList extends _isd.IncludeList {
  RecentStopSearchIncludeList._({
    _isd.WhereExpressionBuilder<RecentStopSearchTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RecentStopSearch.t);
  }

  @override
  Map<String, _isd.Include?> get includes => include?.includes ?? {};

  @override
  _isd.Table<int?> get table => RecentStopSearch.t;
}

class RecentStopSearchRepository {
  const RecentStopSearchRepository._();

  /// Returns a list of [RecentStopSearch]s matching the given query parameters.
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
  Future<List<RecentStopSearch>> find(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<RecentStopSearchTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<RecentStopSearchTable>? orderBy,
    _isd.OrderByListBuilder<RecentStopSearchTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<RecentStopSearch>(
      where: where?.call(RecentStopSearch.t),
      orderBy: orderBy?.call(RecentStopSearch.t),
      orderByList: orderByList?.call(RecentStopSearch.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [RecentStopSearch] matching the given query parameters.
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
  Future<RecentStopSearch?> findFirstRow(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<RecentStopSearchTable>? where,
    int? offset,
    _isd.OrderByBuilder<RecentStopSearchTable>? orderBy,
    _isd.OrderByListBuilder<RecentStopSearchTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<RecentStopSearch>(
      where: where?.call(RecentStopSearch.t),
      orderBy: orderBy?.call(RecentStopSearch.t),
      orderByList: orderByList?.call(RecentStopSearch.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [RecentStopSearch] by its [id] or null if no such row exists.
  Future<RecentStopSearch?> findById(
    _isd.DatabaseSession session,
    int id, {
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<RecentStopSearch>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [RecentStopSearch]s in the list and returns the inserted rows.
  ///
  /// The returned [RecentStopSearch]s will have their `id` fields set.
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
  Future<List<RecentStopSearch>> insert(
    _isd.DatabaseSession session,
    List<RecentStopSearch> rows, {
    _isd.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<RecentStopSearch>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [RecentStopSearch] and returns the inserted row.
  ///
  /// The returned [RecentStopSearch] will have its `id` field set.
  Future<RecentStopSearch> insertRow(
    _isd.DatabaseSession session,
    RecentStopSearch row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.insertRow<RecentStopSearch>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [RecentStopSearch]s in the list and returns the resulting rows.
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
  /// The returned [RecentStopSearch]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RecentStopSearch>> upsert(
    _isd.DatabaseSession session,
    List<RecentStopSearch> rows, {
    required _isd.ColumnSelections<RecentStopSearchTable> conflictColumns,
    _isd.ColumnSelections<RecentStopSearchTable>? updateColumns,
    _isd.WhereExpressionBuilder<RecentStopSearchTable>? updateWhere,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<RecentStopSearch>(
      rows,
      conflictColumns: conflictColumns(RecentStopSearch.t),
      updateColumns: updateColumns?.call(RecentStopSearch.t),
      updateWhere: updateWhere?.call(RecentStopSearch.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [RecentStopSearch] and returns the resulting row.
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
  /// The returned [RecentStopSearch] will have its `id` field set.
  Future<RecentStopSearch?> upsertRow(
    _isd.DatabaseSession session,
    RecentStopSearch row, {
    required _isd.ColumnSelections<RecentStopSearchTable> conflictColumns,
    _isd.ColumnSelections<RecentStopSearchTable>? updateColumns,
    _isd.WhereExpressionBuilder<RecentStopSearchTable>? updateWhere,
    _isd.Transaction? transaction,
  }) async {
    return session.db.upsertRow<RecentStopSearch>(
      row,
      conflictColumns: conflictColumns(RecentStopSearch.t),
      updateColumns: updateColumns?.call(RecentStopSearch.t),
      updateWhere: updateWhere?.call(RecentStopSearch.t),
      transaction: transaction,
    );
  }

  /// Updates all [RecentStopSearch]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RecentStopSearch>> update(
    _isd.DatabaseSession session,
    List<RecentStopSearch> rows, {
    _isd.ColumnSelections<RecentStopSearchTable>? columns,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<RecentStopSearch>(
      rows,
      columns: columns?.call(RecentStopSearch.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [RecentStopSearch]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RecentStopSearch> updateRow(
    _isd.DatabaseSession session,
    RecentStopSearch row, {
    _isd.ColumnSelections<RecentStopSearchTable>? columns,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateRow<RecentStopSearch>(
      row,
      columns: columns?.call(RecentStopSearch.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RecentStopSearch] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<RecentStopSearch?> updateById(
    _isd.DatabaseSession session,
    int id, {
    required _isd.ColumnValueListBuilder<RecentStopSearchUpdateTable>
    columnValues,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateById<RecentStopSearch>(
      id,
      columnValues: columnValues(RecentStopSearch.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [RecentStopSearch]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RecentStopSearch>> updateWhere(
    _isd.DatabaseSession session, {
    required _isd.ColumnValueListBuilder<RecentStopSearchUpdateTable>
    columnValues,
    required _isd.WhereExpressionBuilder<RecentStopSearchTable> where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<RecentStopSearchTable>? orderBy,
    _isd.OrderByListBuilder<RecentStopSearchTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<RecentStopSearch>(
      columnValues: columnValues(RecentStopSearch.t.updateTable),
      where: where(RecentStopSearch.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RecentStopSearch.t),
      orderByList: orderByList?.call(RecentStopSearch.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [RecentStopSearch]s in the list and returns the deleted rows.
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
  Future<List<RecentStopSearch>> delete(
    _isd.DatabaseSession session,
    List<RecentStopSearch> rows, {
    _isd.OrderByBuilder<RecentStopSearchTable>? orderBy,
    _isd.OrderByListBuilder<RecentStopSearchTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<RecentStopSearch>(
      rows,
      orderBy: orderBy?.call(RecentStopSearch.t),
      orderByList: orderByList?.call(RecentStopSearch.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [RecentStopSearch].
  Future<RecentStopSearch> deleteRow(
    _isd.DatabaseSession session,
    RecentStopSearch row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RecentStopSearch>(
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
  Future<List<RecentStopSearch>> deleteWhere(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<RecentStopSearchTable> where,
    _isd.OrderByBuilder<RecentStopSearchTable>? orderBy,
    _isd.OrderByListBuilder<RecentStopSearchTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<RecentStopSearch>(
      where: where(RecentStopSearch.t),
      orderBy: orderBy?.call(RecentStopSearch.t),
      orderByList: orderByList?.call(RecentStopSearch.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<RecentStopSearchTable>? where,
    int? limit,
    _isd.Transaction? transaction,
  }) async {
    return session.db.count<RecentStopSearch>(
      where: where?.call(RecentStopSearch.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [RecentStopSearch] rows matching the [where] expression.
  Future<void> lockRows(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<RecentStopSearchTable> where,
    required _isd.LockMode lockMode,
    required _isd.Transaction transaction,
    _isd.LockBehavior lockBehavior = _isd.LockBehavior.wait,
  }) async {
    return session.db.lockRows<RecentStopSearch>(
      where: where(RecentStopSearch.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
