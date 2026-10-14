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

abstract class TransitRoute
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  TransitRoute._({
    this.id,
    required this.agencyId,
    required this.externalId,
    required this.shortName,
    this.longName,
    required this.transportMode,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.cachedAt,
  });

  factory TransitRoute({
    int? id,
    required int agencyId,
    required String externalId,
    required String shortName,
    String? longName,
    required String transportMode,
    String? backgroundColor,
    String? foregroundColor,
    String? borderColor,
    DateTime? cachedAt,
  }) = _TransitRouteImpl;

  factory TransitRoute.fromJson(Map<String, dynamic> jsonSerialization) {
    return TransitRoute(
      id: jsonSerialization['id'] as int?,
      agencyId: jsonSerialization['agencyId'] as int,
      externalId: jsonSerialization['externalId'] as String,
      shortName: jsonSerialization['shortName'] as String,
      longName: jsonSerialization['longName'] as String?,
      transportMode: jsonSerialization['transportMode'] as String,
      backgroundColor: jsonSerialization['backgroundColor'] as String?,
      foregroundColor: jsonSerialization['foregroundColor'] as String?,
      borderColor: jsonSerialization['borderColor'] as String?,
      cachedAt: jsonSerialization['cachedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['cachedAt']),
    );
  }

  static final t = TransitRouteTable();

  static const db = TransitRouteRepository._();

  @override
  int? id;

  int agencyId;

  String externalId;

  String shortName;

  String? longName;

  String transportMode;

  String? backgroundColor;

  String? foregroundColor;

  String? borderColor;

  DateTime? cachedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [TransitRoute]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TransitRoute copyWith({
    int? id,
    int? agencyId,
    String? externalId,
    String? shortName,
    String? longName,
    String? transportMode,
    String? backgroundColor,
    String? foregroundColor,
    String? borderColor,
    DateTime? cachedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TransitRoute',
      if (id != null) 'id': id,
      'agencyId': agencyId,
      'externalId': externalId,
      'shortName': shortName,
      if (longName != null) 'longName': longName,
      'transportMode': transportMode,
      if (backgroundColor != null) 'backgroundColor': backgroundColor,
      if (foregroundColor != null) 'foregroundColor': foregroundColor,
      if (borderColor != null) 'borderColor': borderColor,
      if (cachedAt != null) 'cachedAt': cachedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TransitRoute',
      if (id != null) 'id': id,
      'agencyId': agencyId,
      'externalId': externalId,
      'shortName': shortName,
      if (longName != null) 'longName': longName,
      'transportMode': transportMode,
      if (backgroundColor != null) 'backgroundColor': backgroundColor,
      if (foregroundColor != null) 'foregroundColor': foregroundColor,
      if (borderColor != null) 'borderColor': borderColor,
      if (cachedAt != null) 'cachedAt': cachedAt?.toJson(),
    };
  }

  static TransitRouteInclude include() {
    return TransitRouteInclude._();
  }

  static TransitRouteIncludeList includeList({
    _is.WhereExpressionBuilder<TransitRouteTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TransitRouteTable>? orderBy,
    _is.OrderByListBuilder<TransitRouteTable>? orderByList,
    TransitRouteInclude? include,
  }) {
    return TransitRouteIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TransitRoute.t),
      orderByList: orderByList?.call(TransitRoute.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TransitRouteImpl extends TransitRoute {
  _TransitRouteImpl({
    int? id,
    required int agencyId,
    required String externalId,
    required String shortName,
    String? longName,
    required String transportMode,
    String? backgroundColor,
    String? foregroundColor,
    String? borderColor,
    DateTime? cachedAt,
  }) : super._(
         id: id,
         agencyId: agencyId,
         externalId: externalId,
         shortName: shortName,
         longName: longName,
         transportMode: transportMode,
         backgroundColor: backgroundColor,
         foregroundColor: foregroundColor,
         borderColor: borderColor,
         cachedAt: cachedAt,
       );

  /// Returns a shallow copy of this [TransitRoute]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TransitRoute copyWith({
    Object? id = _Undefined,
    int? agencyId,
    String? externalId,
    String? shortName,
    Object? longName = _Undefined,
    String? transportMode,
    Object? backgroundColor = _Undefined,
    Object? foregroundColor = _Undefined,
    Object? borderColor = _Undefined,
    Object? cachedAt = _Undefined,
  }) {
    return TransitRoute(
      id: id is int? ? id : this.id,
      agencyId: agencyId ?? this.agencyId,
      externalId: externalId ?? this.externalId,
      shortName: shortName ?? this.shortName,
      longName: longName is String? ? longName : this.longName,
      transportMode: transportMode ?? this.transportMode,
      backgroundColor: backgroundColor is String?
          ? backgroundColor
          : this.backgroundColor,
      foregroundColor: foregroundColor is String?
          ? foregroundColor
          : this.foregroundColor,
      borderColor: borderColor is String? ? borderColor : this.borderColor,
      cachedAt: cachedAt is DateTime? ? cachedAt : this.cachedAt,
    );
  }
}

class TransitRouteUpdateTable extends _is.UpdateTable<TransitRouteTable> {
  TransitRouteUpdateTable(super.table);

  _is.ColumnValue<int, int> agencyId(int value) => _is.ColumnValue(
    table.agencyId,
    value,
  );

  _is.ColumnValue<String, String> externalId(String value) => _is.ColumnValue(
    table.externalId,
    value,
  );

  _is.ColumnValue<String, String> shortName(String value) => _is.ColumnValue(
    table.shortName,
    value,
  );

  _is.ColumnValue<String, String> longName(String? value) => _is.ColumnValue(
    table.longName,
    value,
  );

  _is.ColumnValue<String, String> transportMode(String value) =>
      _is.ColumnValue(
        table.transportMode,
        value,
      );

  _is.ColumnValue<String, String> backgroundColor(String? value) =>
      _is.ColumnValue(
        table.backgroundColor,
        value,
      );

  _is.ColumnValue<String, String> foregroundColor(String? value) =>
      _is.ColumnValue(
        table.foregroundColor,
        value,
      );

  _is.ColumnValue<String, String> borderColor(String? value) => _is.ColumnValue(
    table.borderColor,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> cachedAt(DateTime? value) =>
      _is.ColumnValue(
        table.cachedAt,
        value,
      );
}

class TransitRouteTable extends _is.Table<int?> {
  TransitRouteTable({super.tableRelation}) : super(tableName: 'transit_route') {
    updateTable = TransitRouteUpdateTable(this);
    agencyId = _is.ColumnInt(
      'agencyId',
      this,
    );
    externalId = _is.ColumnString(
      'externalId',
      this,
    );
    shortName = _is.ColumnString(
      'shortName',
      this,
    );
    longName = _is.ColumnString(
      'longName',
      this,
    );
    transportMode = _is.ColumnString(
      'transportMode',
      this,
    );
    backgroundColor = _is.ColumnString(
      'backgroundColor',
      this,
    );
    foregroundColor = _is.ColumnString(
      'foregroundColor',
      this,
    );
    borderColor = _is.ColumnString(
      'borderColor',
      this,
    );
    cachedAt = _is.ColumnDateTime(
      'cachedAt',
      this,
    );
  }

  late final TransitRouteUpdateTable updateTable;

  late final _is.ColumnInt agencyId;

  late final _is.ColumnString externalId;

  late final _is.ColumnString shortName;

  late final _is.ColumnString longName;

  late final _is.ColumnString transportMode;

  late final _is.ColumnString backgroundColor;

  late final _is.ColumnString foregroundColor;

  late final _is.ColumnString borderColor;

  late final _is.ColumnDateTime cachedAt;

  @override
  List<_is.Column> get columns => [
    id,
    agencyId,
    externalId,
    shortName,
    longName,
    transportMode,
    backgroundColor,
    foregroundColor,
    borderColor,
    cachedAt,
  ];
}

class TransitRouteInclude extends _is.IncludeObject {
  TransitRouteInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => TransitRoute.t;
}

class TransitRouteIncludeList extends _is.IncludeList {
  TransitRouteIncludeList._({
    _is.WhereExpressionBuilder<TransitRouteTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TransitRoute.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => TransitRoute.t;
}

class TransitRouteRepository {
  const TransitRouteRepository._();

  /// Returns a list of [TransitRoute]s matching the given query parameters.
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
  Future<List<TransitRoute>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TransitRouteTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TransitRouteTable>? orderBy,
    _is.OrderByListBuilder<TransitRouteTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<TransitRoute>(
      where: where?.call(TransitRoute.t),
      orderBy: orderBy?.call(TransitRoute.t),
      orderByList: orderByList?.call(TransitRoute.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [TransitRoute] matching the given query parameters.
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
  Future<TransitRoute?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TransitRouteTable>? where,
    int? offset,
    _is.OrderByBuilder<TransitRouteTable>? orderBy,
    _is.OrderByListBuilder<TransitRouteTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<TransitRoute>(
      where: where?.call(TransitRoute.t),
      orderBy: orderBy?.call(TransitRoute.t),
      orderByList: orderByList?.call(TransitRoute.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [TransitRoute] by its [id] or null if no such row exists.
  Future<TransitRoute?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<TransitRoute>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [TransitRoute]s in the list and returns the inserted rows.
  ///
  /// The returned [TransitRoute]s will have their `id` fields set.
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
  Future<List<TransitRoute>> insert(
    _is.DatabaseSession session,
    List<TransitRoute> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<TransitRoute>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [TransitRoute] and returns the inserted row.
  ///
  /// The returned [TransitRoute] will have its `id` field set.
  Future<TransitRoute> insertRow(
    _is.DatabaseSession session,
    TransitRoute row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<TransitRoute>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [TransitRoute]s in the list and returns the resulting rows.
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
  /// The returned [TransitRoute]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TransitRoute>> upsert(
    _is.DatabaseSession session,
    List<TransitRoute> rows, {
    required _is.ColumnSelections<TransitRouteTable> conflictColumns,
    _is.ColumnSelections<TransitRouteTable>? updateColumns,
    _is.WhereExpressionBuilder<TransitRouteTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<TransitRoute>(
      rows,
      conflictColumns: conflictColumns(TransitRoute.t),
      updateColumns: updateColumns?.call(TransitRoute.t),
      updateWhere: updateWhere?.call(TransitRoute.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [TransitRoute] and returns the resulting row.
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
  /// The returned [TransitRoute] will have its `id` field set.
  Future<TransitRoute?> upsertRow(
    _is.DatabaseSession session,
    TransitRoute row, {
    required _is.ColumnSelections<TransitRouteTable> conflictColumns,
    _is.ColumnSelections<TransitRouteTable>? updateColumns,
    _is.WhereExpressionBuilder<TransitRouteTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<TransitRoute>(
      row,
      conflictColumns: conflictColumns(TransitRoute.t),
      updateColumns: updateColumns?.call(TransitRoute.t),
      updateWhere: updateWhere?.call(TransitRoute.t),
      transaction: transaction,
    );
  }

  /// Updates all [TransitRoute]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TransitRoute>> update(
    _is.DatabaseSession session,
    List<TransitRoute> rows, {
    _is.ColumnSelections<TransitRouteTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<TransitRoute>(
      rows,
      columns: columns?.call(TransitRoute.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [TransitRoute]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TransitRoute> updateRow(
    _is.DatabaseSession session,
    TransitRoute row, {
    _is.ColumnSelections<TransitRouteTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<TransitRoute>(
      row,
      columns: columns?.call(TransitRoute.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TransitRoute] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TransitRoute?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<TransitRouteUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<TransitRoute>(
      id,
      columnValues: columnValues(TransitRoute.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TransitRoute]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TransitRoute>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<TransitRouteUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<TransitRouteTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TransitRouteTable>? orderBy,
    _is.OrderByListBuilder<TransitRouteTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<TransitRoute>(
      columnValues: columnValues(TransitRoute.t.updateTable),
      where: where(TransitRoute.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TransitRoute.t),
      orderByList: orderByList?.call(TransitRoute.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [TransitRoute]s in the list and returns the deleted rows.
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
  Future<List<TransitRoute>> delete(
    _is.DatabaseSession session,
    List<TransitRoute> rows, {
    _is.OrderByBuilder<TransitRouteTable>? orderBy,
    _is.OrderByListBuilder<TransitRouteTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<TransitRoute>(
      rows,
      orderBy: orderBy?.call(TransitRoute.t),
      orderByList: orderByList?.call(TransitRoute.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [TransitRoute].
  Future<TransitRoute> deleteRow(
    _is.DatabaseSession session,
    TransitRoute row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TransitRoute>(
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
  Future<List<TransitRoute>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TransitRouteTable> where,
    _is.OrderByBuilder<TransitRouteTable>? orderBy,
    _is.OrderByListBuilder<TransitRouteTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<TransitRoute>(
      where: where(TransitRoute.t),
      orderBy: orderBy?.call(TransitRoute.t),
      orderByList: orderByList?.call(TransitRoute.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TransitRouteTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<TransitRoute>(
      where: where?.call(TransitRoute.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [TransitRoute] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TransitRouteTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<TransitRoute>(
      where: where(TransitRoute.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
