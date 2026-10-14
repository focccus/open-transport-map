/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:open_transport_map_client/src/protocol/transit/service_journey_call.dart'
    as _ilj1lx3c;
import 'package:open_transport_map_client/src/protocol/transit/transit_route_shape.dart'
    as _i6gu4vwk;
import 'package:open_transport_map_client/src/protocol/transit/transit_stop_area.dart'
    as _isa4rit7;
import 'package:open_transport_map_client/src/protocol/transit/transit_stop_point.dart'
    as _iemyo4bi;
import 'package:open_transport_map_client/src/protocol/transit/transit_zone.dart'
    as _i453y01z;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_database/serverpod_database.dart' as _isd;
import 'transit/cached_stop_area.dart' as _is9newlb;
import 'transit/departure_item.dart' as _itpp73iw;
import 'transit/recent_stop_search.dart' as _i59x0glc;
import 'transit/service_journey_call.dart' as _ino4w0ds;
import 'transit/stop_departures_response.dart' as _i2xnbyuw;
import 'transit/transit_agency.dart' as _ir0riz23;
import 'transit/transit_next_stop.dart' as _i8frnuhu;
import 'transit/transit_route.dart' as _i2vp4lwc;
import 'transit/transit_route_shape.dart' as _i01e529e;
import 'transit/transit_route_stop.dart' as _isu0uk30;
import 'transit/transit_stop_area.dart' as _io3v2zrm;
import 'transit/transit_stop_point.dart' as _it4fmahh;
import 'transit/transit_zone.dart' as _ixsh3gmj;
import 'vehicles/vehicle_delta.dart' as _i7guzaq2;
import 'vehicles/vehicle_position.dart' as _isvxezb0;
export 'transit/cached_stop_area.dart';
export 'transit/departure_item.dart';
export 'transit/recent_stop_search.dart';
export 'transit/service_journey_call.dart';
export 'transit/stop_departures_response.dart';
export 'transit/transit_agency.dart';
export 'transit/transit_next_stop.dart';
export 'transit/transit_route.dart';
export 'transit/transit_route_shape.dart';
export 'transit/transit_route_stop.dart';
export 'transit/transit_stop_area.dart';
export 'transit/transit_stop_point.dart';
export 'transit/transit_zone.dart';
export 'vehicles/vehicle_delta.dart';
export 'vehicles/vehicle_position.dart';
export 'client.dart';

class Protocol extends _isd.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static List<_isd.TableDefinition> get targetTableDefinitions => [
    _isd.TableDefinition(
      name: 'cached_stop_area',
      dartName: 'CachedStopArea',
      schema: 'public',
      module: 'open_transport_map',
      columns: [
        _isd.ColumnDefinition(
          name: 'id',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isd.ColumnDefinition(
          name: 'externalId',
          columnType: _isd.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isd.ColumnDefinition(
          name: 'name',
          columnType: _isd.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isd.ColumnDefinition(
          name: 'latitude',
          columnType: _isd.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isd.ColumnDefinition(
          name: 'longitude',
          columnType: _isd.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isd.ColumnDefinition(
          name: 'municipality',
          columnType: _isd.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isd.ColumnDefinition(
          name: 'syncedAt',
          columnType: _isd.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isd.IndexDefinition(
          indexName: 'cached_stop_area_external_id_idx',
          tableSpace: null,
          elements: [
            _isd.IndexElementDefinition(
              type: _isd.IndexElementDefinitionType.column,
              definition: 'externalId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isd.TableDefinition(
      name: 'recent_stop_search',
      dartName: 'RecentStopSearch',
      schema: 'public',
      module: 'open_transport_map',
      columns: [
        _isd.ColumnDefinition(
          name: 'id',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isd.ColumnDefinition(
          name: 'query',
          columnType: _isd.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isd.ColumnDefinition(
          name: 'searchedAt',
          columnType: _isd.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isd.IndexDefinition(
          indexName: 'recent_stop_search_query_idx',
          tableSpace: null,
          elements: [
            _isd.IndexElementDefinition(
              type: _isd.IndexElementDefinitionType.column,
              definition: 'query',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    ..._iaic.Protocol() is _isd.DatabaseSerializationManager
        ? (_iaic.Protocol() as _isd.DatabaseSerializationManager)
              .getTargetTableDefinitions()
        : [],
    ..._iacc.Protocol() is _isd.DatabaseSerializationManager
        ? (_iacc.Protocol() as _isd.DatabaseSerializationManager)
              .getTargetTableDefinitions()
        : [],
  ];

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _isc.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _is9newlb.CachedStopArea) {
      return _is9newlb.CachedStopArea.fromJson(data) as T;
    }
    if (t == _itpp73iw.DepartureItem) {
      return _itpp73iw.DepartureItem.fromJson(data) as T;
    }
    if (t == _i59x0glc.RecentStopSearch) {
      return _i59x0glc.RecentStopSearch.fromJson(data) as T;
    }
    if (t == _ino4w0ds.ServiceJourneyCall) {
      return _ino4w0ds.ServiceJourneyCall.fromJson(data) as T;
    }
    if (t == _i2xnbyuw.StopDeparturesResponse) {
      return _i2xnbyuw.StopDeparturesResponse.fromJson(data) as T;
    }
    if (t == _ir0riz23.TransitAgency) {
      return _ir0riz23.TransitAgency.fromJson(data) as T;
    }
    if (t == _i8frnuhu.TransitNextStop) {
      return _i8frnuhu.TransitNextStop.fromJson(data) as T;
    }
    if (t == _i2vp4lwc.TransitRoute) {
      return _i2vp4lwc.TransitRoute.fromJson(data) as T;
    }
    if (t == _i01e529e.TransitRouteShape) {
      return _i01e529e.TransitRouteShape.fromJson(data) as T;
    }
    if (t == _isu0uk30.TransitRouteStop) {
      return _isu0uk30.TransitRouteStop.fromJson(data) as T;
    }
    if (t == _io3v2zrm.TransitStopArea) {
      return _io3v2zrm.TransitStopArea.fromJson(data) as T;
    }
    if (t == _it4fmahh.TransitStopPoint) {
      return _it4fmahh.TransitStopPoint.fromJson(data) as T;
    }
    if (t == _ixsh3gmj.TransitZone) {
      return _ixsh3gmj.TransitZone.fromJson(data) as T;
    }
    if (t == _i7guzaq2.VehicleDelta) {
      return _i7guzaq2.VehicleDelta.fromJson(data) as T;
    }
    if (t == _isvxezb0.VehiclePosition) {
      return _isvxezb0.VehiclePosition.fromJson(data) as T;
    }
    if (t == _isc.getType<_is9newlb.CachedStopArea?>()) {
      return (data != null ? _is9newlb.CachedStopArea.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_itpp73iw.DepartureItem?>()) {
      return (data != null ? _itpp73iw.DepartureItem.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i59x0glc.RecentStopSearch?>()) {
      return (data != null ? _i59x0glc.RecentStopSearch.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ino4w0ds.ServiceJourneyCall?>()) {
      return (data != null ? _ino4w0ds.ServiceJourneyCall.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i2xnbyuw.StopDeparturesResponse?>()) {
      return (data != null
              ? _i2xnbyuw.StopDeparturesResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ir0riz23.TransitAgency?>()) {
      return (data != null ? _ir0riz23.TransitAgency.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i8frnuhu.TransitNextStop?>()) {
      return (data != null ? _i8frnuhu.TransitNextStop.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i2vp4lwc.TransitRoute?>()) {
      return (data != null ? _i2vp4lwc.TransitRoute.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i01e529e.TransitRouteShape?>()) {
      return (data != null ? _i01e529e.TransitRouteShape.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_isu0uk30.TransitRouteStop?>()) {
      return (data != null ? _isu0uk30.TransitRouteStop.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_io3v2zrm.TransitStopArea?>()) {
      return (data != null ? _io3v2zrm.TransitStopArea.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_it4fmahh.TransitStopPoint?>()) {
      return (data != null ? _it4fmahh.TransitStopPoint.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ixsh3gmj.TransitZone?>()) {
      return (data != null ? _ixsh3gmj.TransitZone.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i7guzaq2.VehicleDelta?>()) {
      return (data != null ? _i7guzaq2.VehicleDelta.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_isvxezb0.VehiclePosition?>()) {
      return (data != null ? _isvxezb0.VehiclePosition.fromJson(data) : null)
          as T;
    }
    if (t == List<_itpp73iw.DepartureItem>) {
      return (data as List)
              .map((e) => deserialize<_itpp73iw.DepartureItem>(e))
              .toList()
          as T;
    }
    if (t == List<_isvxezb0.VehiclePosition>) {
      return (data as List)
              .map((e) => deserialize<_isvxezb0.VehiclePosition>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_isa4rit7.TransitStopArea>) {
      return (data as List)
              .map((e) => deserialize<_isa4rit7.TransitStopArea>(e))
              .toList()
          as T;
    }
    if (t == List<_iemyo4bi.TransitStopPoint>) {
      return (data as List)
              .map((e) => deserialize<_iemyo4bi.TransitStopPoint>(e))
              .toList()
          as T;
    }
    if (t == List<_i6gu4vwk.TransitRouteShape>) {
      return (data as List)
              .map((e) => deserialize<_i6gu4vwk.TransitRouteShape>(e))
              .toList()
          as T;
    }
    if (t == List<_ilj1lx3c.ServiceJourneyCall>) {
      return (data as List)
              .map((e) => deserialize<_ilj1lx3c.ServiceJourneyCall>(e))
              .toList()
          as T;
    }
    if (t == List<_i453y01z.TransitZone>) {
      return (data as List)
              .map((e) => deserialize<_i453y01z.TransitZone>(e))
              .toList()
          as T;
    }
    try {
      return _iaic.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacc.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _is9newlb.CachedStopArea => 'CachedStopArea',
      _itpp73iw.DepartureItem => 'DepartureItem',
      _i59x0glc.RecentStopSearch => 'RecentStopSearch',
      _ino4w0ds.ServiceJourneyCall => 'ServiceJourneyCall',
      _i2xnbyuw.StopDeparturesResponse => 'StopDeparturesResponse',
      _ir0riz23.TransitAgency => 'TransitAgency',
      _i8frnuhu.TransitNextStop => 'TransitNextStop',
      _i2vp4lwc.TransitRoute => 'TransitRoute',
      _i01e529e.TransitRouteShape => 'TransitRouteShape',
      _isu0uk30.TransitRouteStop => 'TransitRouteStop',
      _io3v2zrm.TransitStopArea => 'TransitStopArea',
      _it4fmahh.TransitStopPoint => 'TransitStopPoint',
      _ixsh3gmj.TransitZone => 'TransitZone',
      _i7guzaq2.VehicleDelta => 'VehicleDelta',
      _isvxezb0.VehiclePosition => 'VehiclePosition',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst(
        'open_transport_map.',
        '',
      );
    }

    switch (data) {
      case _is9newlb.CachedStopArea():
        return 'CachedStopArea';
      case _itpp73iw.DepartureItem():
        return 'DepartureItem';
      case _i59x0glc.RecentStopSearch():
        return 'RecentStopSearch';
      case _ino4w0ds.ServiceJourneyCall():
        return 'ServiceJourneyCall';
      case _i2xnbyuw.StopDeparturesResponse():
        return 'StopDeparturesResponse';
      case _ir0riz23.TransitAgency():
        return 'TransitAgency';
      case _i8frnuhu.TransitNextStop():
        return 'TransitNextStop';
      case _i2vp4lwc.TransitRoute():
        return 'TransitRoute';
      case _i01e529e.TransitRouteShape():
        return 'TransitRouteShape';
      case _isu0uk30.TransitRouteStop():
        return 'TransitRouteStop';
      case _io3v2zrm.TransitStopArea():
        return 'TransitStopArea';
      case _it4fmahh.TransitStopPoint():
        return 'TransitStopPoint';
      case _ixsh3gmj.TransitZone():
        return 'TransitZone';
      case _i7guzaq2.VehicleDelta():
        return 'VehicleDelta';
      case _isvxezb0.VehiclePosition():
        return 'VehiclePosition';
    }
    className = _iaic.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacc.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'CachedStopArea') {
      return deserialize<_is9newlb.CachedStopArea>(data['data']);
    }
    if (dataClassName == 'DepartureItem') {
      return deserialize<_itpp73iw.DepartureItem>(data['data']);
    }
    if (dataClassName == 'RecentStopSearch') {
      return deserialize<_i59x0glc.RecentStopSearch>(data['data']);
    }
    if (dataClassName == 'ServiceJourneyCall') {
      return deserialize<_ino4w0ds.ServiceJourneyCall>(data['data']);
    }
    if (dataClassName == 'StopDeparturesResponse') {
      return deserialize<_i2xnbyuw.StopDeparturesResponse>(data['data']);
    }
    if (dataClassName == 'TransitAgency') {
      return deserialize<_ir0riz23.TransitAgency>(data['data']);
    }
    if (dataClassName == 'TransitNextStop') {
      return deserialize<_i8frnuhu.TransitNextStop>(data['data']);
    }
    if (dataClassName == 'TransitRoute') {
      return deserialize<_i2vp4lwc.TransitRoute>(data['data']);
    }
    if (dataClassName == 'TransitRouteShape') {
      return deserialize<_i01e529e.TransitRouteShape>(data['data']);
    }
    if (dataClassName == 'TransitRouteStop') {
      return deserialize<_isu0uk30.TransitRouteStop>(data['data']);
    }
    if (dataClassName == 'TransitStopArea') {
      return deserialize<_io3v2zrm.TransitStopArea>(data['data']);
    }
    if (dataClassName == 'TransitStopPoint') {
      return deserialize<_it4fmahh.TransitStopPoint>(data['data']);
    }
    if (dataClassName == 'TransitZone') {
      return deserialize<_ixsh3gmj.TransitZone>(data['data']);
    }
    if (dataClassName == 'VehicleDelta') {
      return deserialize<_i7guzaq2.VehicleDelta>(data['data']);
    }
    if (dataClassName == 'VehiclePosition') {
      return deserialize<_isvxezb0.VehiclePosition>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _iaic.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacc.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iaic.Protocol().registerHostProtocol('open_transport_map', this);
    _iacc.Protocol().registerHostProtocol('open_transport_map', this);
  }

  @override
  _isd.Table? getTableForType(Type t) {
    {
      var protocol = _iaic.Protocol();
      var table = protocol is _isd.DatabaseSerializationManager
          ? (protocol as _isd.DatabaseSerializationManager).getTableForType(t)
          : null;
      if (table != null) {
        return table;
      }
    }
    {
      var protocol = _iacc.Protocol();
      var table = protocol is _isd.DatabaseSerializationManager
          ? (protocol as _isd.DatabaseSerializationManager).getTableForType(t)
          : null;
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _is9newlb.CachedStopArea:
        return _is9newlb.CachedStopArea.t;
      case _i59x0glc.RecentStopSearch:
        return _i59x0glc.RecentStopSearch.t;
    }
    return null;
  }

  @override
  List<_isd.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'open_transport_map';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _iaic.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacc.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
