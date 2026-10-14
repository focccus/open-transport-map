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

abstract class TransitZone
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  TransitZone._({
    this.id,
    required this.agencyId,
    required this.externalId,
    required this.name,
    this.color,
    this.geometryGeoJson,
  });

  factory TransitZone({
    int? id,
    required int agencyId,
    required String externalId,
    required String name,
    String? color,
    String? geometryGeoJson,
  }) = _TransitZoneImpl;

  factory TransitZone.fromJson(Map<String, dynamic> jsonSerialization) {
    return TransitZone(
      id: jsonSerialization['id'] as int?,
      agencyId: jsonSerialization['agencyId'] as int,
      externalId: jsonSerialization['externalId'] as String,
      name: jsonSerialization['name'] as String,
      color: jsonSerialization['color'] as String?,
      geometryGeoJson: jsonSerialization['geometryGeoJson'] as String?,
    );
  }

  static final t = TransitZoneTable();

  static const db = TransitZoneRepository._();

  @override
  int? id;

  int agencyId;

  String externalId;

  String name;

  String? color;

  String? geometryGeoJson;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [TransitZone]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TransitZone copyWith({
    int? id,
    int? agencyId,
    String? externalId,
    String? name,
    String? color,
    String? geometryGeoJson,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TransitZone',
      if (id != null) 'id': id,
      'agencyId': agencyId,
      'externalId': externalId,
      'name': name,
      if (color != null) 'color': color,
      if (geometryGeoJson != null) 'geometryGeoJson': geometryGeoJson,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TransitZone',
      if (id != null) 'id': id,
      'agencyId': agencyId,
      'externalId': externalId,
      'name': name,
      if (color != null) 'color': color,
      if (geometryGeoJson != null) 'geometryGeoJson': geometryGeoJson,
    };
  }

  static TransitZoneInclude include() {
    return TransitZoneInclude._();
  }

  static TransitZoneIncludeList includeList({
    _is.WhereExpressionBuilder<TransitZoneTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TransitZoneTable>? orderBy,
    _is.OrderByListBuilder<TransitZoneTable>? orderByList,
    TransitZoneInclude? include,
  }) {
    return TransitZoneIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TransitZone.t),
      orderByList: orderByList?.call(TransitZone.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TransitZoneImpl extends TransitZone {
  _TransitZoneImpl({
    int? id,
    required int agencyId,
    required String externalId,
    required String name,
    String? color,
    String? geometryGeoJson,
  }) : super._(
         id: id,
         agencyId: agencyId,
         externalId: externalId,
         name: name,
         color: color,
         geometryGeoJson: geometryGeoJson,
       );

  /// Returns a shallow copy of this [TransitZone]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TransitZone copyWith({
    Object? id = _Undefined,
    int? agencyId,
    String? externalId,
    String? name,
    Object? color = _Undefined,
    Object? geometryGeoJson = _Undefined,
  }) {
    return TransitZone(
      id: id is int? ? id : this.id,
      agencyId: agencyId ?? this.agencyId,
      externalId: externalId ?? this.externalId,
      name: name ?? this.name,
      color: color is String? ? color : this.color,
      geometryGeoJson: geometryGeoJson is String?
          ? geometryGeoJson
          : this.geometryGeoJson,
    );
  }
}

class TransitZoneUpdateTable extends _is.UpdateTable<TransitZoneTable> {
  TransitZoneUpdateTable(super.table);

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

  _is.ColumnValue<String, String> color(String? value) => _is.ColumnValue(
    table.color,
    value,
  );

  _is.ColumnValue<String, String> geometryGeoJson(String? value) =>
      _is.ColumnValue(
        table.geometryGeoJson,
        value,
      );
}

class TransitZoneTable extends _is.Table<int?> {
  TransitZoneTable({super.tableRelation}) : super(tableName: 'transit_zone') {
    updateTable = TransitZoneUpdateTable(this);
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
    color = _is.ColumnString(
      'color',
      this,
    );
    geometryGeoJson = _is.ColumnString(
      'geometryGeoJson',
      this,
    );
  }

  late final TransitZoneUpdateTable updateTable;

  late final _is.ColumnInt agencyId;

  late final _is.ColumnString externalId;

  late final _is.ColumnString name;

  late final _is.ColumnString color;

  late final _is.ColumnString geometryGeoJson;

  @override
  List<_is.Column> get columns => [
    id,
    agencyId,
    externalId,
    name,
    color,
    geometryGeoJson,
  ];
}

class TransitZoneInclude extends _is.IncludeObject {
  TransitZoneInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => TransitZone.t;
}

class TransitZoneIncludeList extends _is.IncludeList {
  TransitZoneIncludeList._({
    _is.WhereExpressionBuilder<TransitZoneTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TransitZone.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => TransitZone.t;
}

class TransitZoneRepository {
  const TransitZoneRepository._();

  /// Returns a list of [TransitZone]s matching the given query parameters.
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
  Future<List<TransitZone>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TransitZoneTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TransitZoneTable>? orderBy,
    _is.OrderByListBuilder<TransitZoneTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<TransitZone>(
      where: where?.call(TransitZone.t),
      orderBy: orderBy?.call(TransitZone.t),
      orderByList: orderByList?.call(TransitZone.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [TransitZone] matching the given query parameters.
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
  Future<TransitZone?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TransitZoneTable>? where,
    int? offset,
    _is.OrderByBuilder<TransitZoneTable>? orderBy,
    _is.OrderByListBuilder<TransitZoneTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<TransitZone>(
      where: where?.call(TransitZone.t),
      orderBy: orderBy?.call(TransitZone.t),
      orderByList: orderByList?.call(TransitZone.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [TransitZone] by its [id] or null if no such row exists.
  Future<TransitZone?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<TransitZone>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [TransitZone]s in the list and returns the inserted rows.
  ///
  /// The returned [TransitZone]s will have their `id` fields set.
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
  Future<List<TransitZone>> insert(
    _is.DatabaseSession session,
    List<TransitZone> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<TransitZone>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [TransitZone] and returns the inserted row.
  ///
  /// The returned [TransitZone] will have its `id` field set.
  Future<TransitZone> insertRow(
    _is.DatabaseSession session,
    TransitZone row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<TransitZone>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [TransitZone]s in the list and returns the resulting rows.
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
  /// The returned [TransitZone]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TransitZone>> upsert(
    _is.DatabaseSession session,
    List<TransitZone> rows, {
    required _is.ColumnSelections<TransitZoneTable> conflictColumns,
    _is.ColumnSelections<TransitZoneTable>? updateColumns,
    _is.WhereExpressionBuilder<TransitZoneTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<TransitZone>(
      rows,
      conflictColumns: conflictColumns(TransitZone.t),
      updateColumns: updateColumns?.call(TransitZone.t),
      updateWhere: updateWhere?.call(TransitZone.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [TransitZone] and returns the resulting row.
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
  /// The returned [TransitZone] will have its `id` field set.
  Future<TransitZone?> upsertRow(
    _is.DatabaseSession session,
    TransitZone row, {
    required _is.ColumnSelections<TransitZoneTable> conflictColumns,
    _is.ColumnSelections<TransitZoneTable>? updateColumns,
    _is.WhereExpressionBuilder<TransitZoneTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<TransitZone>(
      row,
      conflictColumns: conflictColumns(TransitZone.t),
      updateColumns: updateColumns?.call(TransitZone.t),
      updateWhere: updateWhere?.call(TransitZone.t),
      transaction: transaction,
    );
  }

  /// Updates all [TransitZone]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TransitZone>> update(
    _is.DatabaseSession session,
    List<TransitZone> rows, {
    _is.ColumnSelections<TransitZoneTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<TransitZone>(
      rows,
      columns: columns?.call(TransitZone.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [TransitZone]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TransitZone> updateRow(
    _is.DatabaseSession session,
    TransitZone row, {
    _is.ColumnSelections<TransitZoneTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<TransitZone>(
      row,
      columns: columns?.call(TransitZone.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TransitZone] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TransitZone?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<TransitZoneUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<TransitZone>(
      id,
      columnValues: columnValues(TransitZone.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TransitZone]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TransitZone>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<TransitZoneUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<TransitZoneTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TransitZoneTable>? orderBy,
    _is.OrderByListBuilder<TransitZoneTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<TransitZone>(
      columnValues: columnValues(TransitZone.t.updateTable),
      where: where(TransitZone.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TransitZone.t),
      orderByList: orderByList?.call(TransitZone.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [TransitZone]s in the list and returns the deleted rows.
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
  Future<List<TransitZone>> delete(
    _is.DatabaseSession session,
    List<TransitZone> rows, {
    _is.OrderByBuilder<TransitZoneTable>? orderBy,
    _is.OrderByListBuilder<TransitZoneTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<TransitZone>(
      rows,
      orderBy: orderBy?.call(TransitZone.t),
      orderByList: orderByList?.call(TransitZone.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [TransitZone].
  Future<TransitZone> deleteRow(
    _is.DatabaseSession session,
    TransitZone row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TransitZone>(
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
  Future<List<TransitZone>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TransitZoneTable> where,
    _is.OrderByBuilder<TransitZoneTable>? orderBy,
    _is.OrderByListBuilder<TransitZoneTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<TransitZone>(
      where: where(TransitZone.t),
      orderBy: orderBy?.call(TransitZone.t),
      orderByList: orderByList?.call(TransitZone.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TransitZoneTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<TransitZone>(
      where: where?.call(TransitZone.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [TransitZone] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TransitZoneTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<TransitZone>(
      where: where(TransitZone.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
