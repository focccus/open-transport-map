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

abstract class TransitAgency
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  TransitAgency._({
    this.id,
    required this.externalId,
    required this.name,
    String? timezone,
    String? countryCode,
    required this.city,
    this.syncedAt,
  }) : timezone = timezone ?? 'Europe/Stockholm',
       countryCode = countryCode ?? 'SE';

  factory TransitAgency({
    int? id,
    required String externalId,
    required String name,
    String? timezone,
    String? countryCode,
    required String city,
    DateTime? syncedAt,
  }) = _TransitAgencyImpl;

  factory TransitAgency.fromJson(Map<String, dynamic> jsonSerialization) {
    return TransitAgency(
      id: jsonSerialization['id'] as int?,
      externalId: jsonSerialization['externalId'] as String,
      name: jsonSerialization['name'] as String,
      timezone: jsonSerialization['timezone'] as String?,
      countryCode: jsonSerialization['countryCode'] as String?,
      city: jsonSerialization['city'] as String,
      syncedAt: jsonSerialization['syncedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['syncedAt']),
    );
  }

  static final t = TransitAgencyTable();

  static const db = TransitAgencyRepository._();

  @override
  int? id;

  String externalId;

  String name;

  String timezone;

  String countryCode;

  String city;

  DateTime? syncedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [TransitAgency]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TransitAgency copyWith({
    int? id,
    String? externalId,
    String? name,
    String? timezone,
    String? countryCode,
    String? city,
    DateTime? syncedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TransitAgency',
      if (id != null) 'id': id,
      'externalId': externalId,
      'name': name,
      'timezone': timezone,
      'countryCode': countryCode,
      'city': city,
      if (syncedAt != null) 'syncedAt': syncedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TransitAgency',
      if (id != null) 'id': id,
      'externalId': externalId,
      'name': name,
      'timezone': timezone,
      'countryCode': countryCode,
      'city': city,
      if (syncedAt != null) 'syncedAt': syncedAt?.toJson(),
    };
  }

  static TransitAgencyInclude include() {
    return TransitAgencyInclude._();
  }

  static TransitAgencyIncludeList includeList({
    _is.WhereExpressionBuilder<TransitAgencyTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TransitAgencyTable>? orderBy,
    _is.OrderByListBuilder<TransitAgencyTable>? orderByList,
    TransitAgencyInclude? include,
  }) {
    return TransitAgencyIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TransitAgency.t),
      orderByList: orderByList?.call(TransitAgency.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TransitAgencyImpl extends TransitAgency {
  _TransitAgencyImpl({
    int? id,
    required String externalId,
    required String name,
    String? timezone,
    String? countryCode,
    required String city,
    DateTime? syncedAt,
  }) : super._(
         id: id,
         externalId: externalId,
         name: name,
         timezone: timezone,
         countryCode: countryCode,
         city: city,
         syncedAt: syncedAt,
       );

  /// Returns a shallow copy of this [TransitAgency]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TransitAgency copyWith({
    Object? id = _Undefined,
    String? externalId,
    String? name,
    String? timezone,
    String? countryCode,
    String? city,
    Object? syncedAt = _Undefined,
  }) {
    return TransitAgency(
      id: id is int? ? id : this.id,
      externalId: externalId ?? this.externalId,
      name: name ?? this.name,
      timezone: timezone ?? this.timezone,
      countryCode: countryCode ?? this.countryCode,
      city: city ?? this.city,
      syncedAt: syncedAt is DateTime? ? syncedAt : this.syncedAt,
    );
  }
}

class TransitAgencyUpdateTable extends _is.UpdateTable<TransitAgencyTable> {
  TransitAgencyUpdateTable(super.table);

  _is.ColumnValue<String, String> externalId(String value) => _is.ColumnValue(
    table.externalId,
    value,
  );

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<String, String> timezone(String value) => _is.ColumnValue(
    table.timezone,
    value,
  );

  _is.ColumnValue<String, String> countryCode(String value) => _is.ColumnValue(
    table.countryCode,
    value,
  );

  _is.ColumnValue<String, String> city(String value) => _is.ColumnValue(
    table.city,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> syncedAt(DateTime? value) =>
      _is.ColumnValue(
        table.syncedAt,
        value,
      );
}

class TransitAgencyTable extends _is.Table<int?> {
  TransitAgencyTable({super.tableRelation})
    : super(tableName: 'transit_agency') {
    updateTable = TransitAgencyUpdateTable(this);
    externalId = _is.ColumnString(
      'externalId',
      this,
    );
    name = _is.ColumnString(
      'name',
      this,
    );
    timezone = _is.ColumnString(
      'timezone',
      this,
      hasDefault: true,
    );
    countryCode = _is.ColumnString(
      'countryCode',
      this,
      hasDefault: true,
    );
    city = _is.ColumnString(
      'city',
      this,
    );
    syncedAt = _is.ColumnDateTime(
      'syncedAt',
      this,
    );
  }

  late final TransitAgencyUpdateTable updateTable;

  late final _is.ColumnString externalId;

  late final _is.ColumnString name;

  late final _is.ColumnString timezone;

  late final _is.ColumnString countryCode;

  late final _is.ColumnString city;

  late final _is.ColumnDateTime syncedAt;

  @override
  List<_is.Column> get columns => [
    id,
    externalId,
    name,
    timezone,
    countryCode,
    city,
    syncedAt,
  ];
}

class TransitAgencyInclude extends _is.IncludeObject {
  TransitAgencyInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => TransitAgency.t;
}

class TransitAgencyIncludeList extends _is.IncludeList {
  TransitAgencyIncludeList._({
    _is.WhereExpressionBuilder<TransitAgencyTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TransitAgency.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => TransitAgency.t;
}

class TransitAgencyRepository {
  const TransitAgencyRepository._();

  /// Returns a list of [TransitAgency]s matching the given query parameters.
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
  Future<List<TransitAgency>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TransitAgencyTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TransitAgencyTable>? orderBy,
    _is.OrderByListBuilder<TransitAgencyTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<TransitAgency>(
      where: where?.call(TransitAgency.t),
      orderBy: orderBy?.call(TransitAgency.t),
      orderByList: orderByList?.call(TransitAgency.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [TransitAgency] matching the given query parameters.
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
  Future<TransitAgency?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TransitAgencyTable>? where,
    int? offset,
    _is.OrderByBuilder<TransitAgencyTable>? orderBy,
    _is.OrderByListBuilder<TransitAgencyTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<TransitAgency>(
      where: where?.call(TransitAgency.t),
      orderBy: orderBy?.call(TransitAgency.t),
      orderByList: orderByList?.call(TransitAgency.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [TransitAgency] by its [id] or null if no such row exists.
  Future<TransitAgency?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<TransitAgency>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [TransitAgency]s in the list and returns the inserted rows.
  ///
  /// The returned [TransitAgency]s will have their `id` fields set.
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
  Future<List<TransitAgency>> insert(
    _is.DatabaseSession session,
    List<TransitAgency> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<TransitAgency>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [TransitAgency] and returns the inserted row.
  ///
  /// The returned [TransitAgency] will have its `id` field set.
  Future<TransitAgency> insertRow(
    _is.DatabaseSession session,
    TransitAgency row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<TransitAgency>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [TransitAgency]s in the list and returns the resulting rows.
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
  /// The returned [TransitAgency]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TransitAgency>> upsert(
    _is.DatabaseSession session,
    List<TransitAgency> rows, {
    required _is.ColumnSelections<TransitAgencyTable> conflictColumns,
    _is.ColumnSelections<TransitAgencyTable>? updateColumns,
    _is.WhereExpressionBuilder<TransitAgencyTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<TransitAgency>(
      rows,
      conflictColumns: conflictColumns(TransitAgency.t),
      updateColumns: updateColumns?.call(TransitAgency.t),
      updateWhere: updateWhere?.call(TransitAgency.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [TransitAgency] and returns the resulting row.
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
  /// The returned [TransitAgency] will have its `id` field set.
  Future<TransitAgency?> upsertRow(
    _is.DatabaseSession session,
    TransitAgency row, {
    required _is.ColumnSelections<TransitAgencyTable> conflictColumns,
    _is.ColumnSelections<TransitAgencyTable>? updateColumns,
    _is.WhereExpressionBuilder<TransitAgencyTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<TransitAgency>(
      row,
      conflictColumns: conflictColumns(TransitAgency.t),
      updateColumns: updateColumns?.call(TransitAgency.t),
      updateWhere: updateWhere?.call(TransitAgency.t),
      transaction: transaction,
    );
  }

  /// Updates all [TransitAgency]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TransitAgency>> update(
    _is.DatabaseSession session,
    List<TransitAgency> rows, {
    _is.ColumnSelections<TransitAgencyTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<TransitAgency>(
      rows,
      columns: columns?.call(TransitAgency.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [TransitAgency]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TransitAgency> updateRow(
    _is.DatabaseSession session,
    TransitAgency row, {
    _is.ColumnSelections<TransitAgencyTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<TransitAgency>(
      row,
      columns: columns?.call(TransitAgency.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TransitAgency] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TransitAgency?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<TransitAgencyUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<TransitAgency>(
      id,
      columnValues: columnValues(TransitAgency.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TransitAgency]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TransitAgency>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<TransitAgencyUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<TransitAgencyTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TransitAgencyTable>? orderBy,
    _is.OrderByListBuilder<TransitAgencyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<TransitAgency>(
      columnValues: columnValues(TransitAgency.t.updateTable),
      where: where(TransitAgency.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TransitAgency.t),
      orderByList: orderByList?.call(TransitAgency.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [TransitAgency]s in the list and returns the deleted rows.
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
  Future<List<TransitAgency>> delete(
    _is.DatabaseSession session,
    List<TransitAgency> rows, {
    _is.OrderByBuilder<TransitAgencyTable>? orderBy,
    _is.OrderByListBuilder<TransitAgencyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<TransitAgency>(
      rows,
      orderBy: orderBy?.call(TransitAgency.t),
      orderByList: orderByList?.call(TransitAgency.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [TransitAgency].
  Future<TransitAgency> deleteRow(
    _is.DatabaseSession session,
    TransitAgency row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TransitAgency>(
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
  Future<List<TransitAgency>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TransitAgencyTable> where,
    _is.OrderByBuilder<TransitAgencyTable>? orderBy,
    _is.OrderByListBuilder<TransitAgencyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<TransitAgency>(
      where: where(TransitAgency.t),
      orderBy: orderBy?.call(TransitAgency.t),
      orderByList: orderByList?.call(TransitAgency.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TransitAgencyTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<TransitAgency>(
      where: where?.call(TransitAgency.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [TransitAgency] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TransitAgencyTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<TransitAgency>(
      where: where(TransitAgency.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
