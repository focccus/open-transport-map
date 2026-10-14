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
import 'package:open_transport_map_server/src/generated/transit/service_journey_call.dart'
    as _ilv2yn39;
import 'package:open_transport_map_server/src/generated/transit/transit_route_shape.dart'
    as _i32ru7g2;
import 'package:open_transport_map_server/src/generated/transit/transit_stop_area.dart'
    as _ic92egf6;
import 'package:open_transport_map_server/src/generated/transit/transit_stop_point.dart'
    as _ikyw9wov;
import 'package:open_transport_map_server/src/generated/transit/transit_zone.dart'
    as _i313ktem;
import 'package:serverpod/protocol.dart' as _isp;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
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

class Protocol extends _is.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static List<_isp.TableDefinition> get targetTableDefinitions => [
    _isp.TableDefinition(
      name: 'transit_agency',
      dartName: 'TransitAgency',
      schema: 'public',
      module: 'open_transport_map',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'externalId',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'timezone',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'Europe/Stockholm\'',
        ),
        _isp.ColumnDefinition(
          name: 'countryCode',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'SE\'',
        ),
        _isp.ColumnDefinition(
          name: 'city',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'syncedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'transit_agency_external_id_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
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
    _isp.TableDefinition(
      name: 'transit_next_stop',
      dartName: 'TransitNextStop',
      schema: 'public',
      module: 'open_transport_map',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'routeId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'headsign',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'stopPointExternalId',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'nextStopName',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'cachedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'transit_next_stop_fk_0',
          columns: ['routeId'],
          referenceTable: 'transit_route',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'transit_next_stop_lookup_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'routeId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'headsign',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'stopPointExternalId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'transit_route',
      dartName: 'TransitRoute',
      schema: 'public',
      module: 'open_transport_map',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'agencyId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'externalId',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'shortName',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'longName',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'transportMode',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'backgroundColor',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'foregroundColor',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'borderColor',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'cachedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'transit_route_fk_0',
          columns: ['agencyId'],
          referenceTable: 'transit_agency',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'transit_route_agency_ext_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'agencyId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'externalId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'transit_route_mode_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'transportMode',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'transit_route_shape',
      dartName: 'TransitRouteShape',
      schema: 'public',
      module: 'open_transport_map',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'routeId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'directionId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'headsign',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'geometryGeoJson',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'cachedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'transit_route_shape_fk_0',
          columns: ['routeId'],
          referenceTable: 'transit_route',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'transit_route_shape_route_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'routeId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'transit_route_shape_lookup_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'routeId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'headsign',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'transit_route_stop',
      dartName: 'TransitRouteStop',
      schema: 'public',
      module: 'open_transport_map',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'routeShapeId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'stopPointId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'stopSequence',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'transit_route_stop_fk_0',
          columns: ['routeShapeId'],
          referenceTable: 'transit_route_shape',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'transit_route_stop_fk_1',
          columns: ['stopPointId'],
          referenceTable: 'transit_stop_point',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'transit_route_stop_seq_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'routeShapeId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'stopSequence',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'transit_route_stop_point_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'stopPointId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'transit_stop_area',
      dartName: 'TransitStopArea',
      schema: 'public',
      module: 'open_transport_map',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'agencyId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'externalId',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'latitude',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'longitude',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'municipality',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'tariffZoneId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'transit_stop_area_fk_0',
          columns: ['agencyId'],
          referenceTable: 'transit_agency',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'transit_stop_area_fk_1',
          columns: ['tariffZoneId'],
          referenceTable: 'transit_zone',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.setNull,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'transit_stop_area_agency_ext_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'agencyId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'externalId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'transit_stop_area_coords_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'latitude',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'longitude',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'transit_stop_point',
      dartName: 'TransitStopPoint',
      schema: 'public',
      module: 'open_transport_map',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'agencyId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'stopAreaId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'externalId',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'platform',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'latitude',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'longitude',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'designation',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'transit_stop_point_fk_0',
          columns: ['agencyId'],
          referenceTable: 'transit_agency',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'transit_stop_point_fk_1',
          columns: ['stopAreaId'],
          referenceTable: 'transit_stop_area',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'transit_stop_point_agency_ext_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'agencyId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'externalId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'transit_stop_point_area_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'stopAreaId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'transit_stop_point_coords_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'latitude',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'longitude',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'transit_zone',
      dartName: 'TransitZone',
      schema: 'public',
      module: 'open_transport_map',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'agencyId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'externalId',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'color',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'geometryGeoJson',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'transit_zone_fk_0',
          columns: ['agencyId'],
          referenceTable: 'transit_agency',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'transit_zone_agency_ext_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'agencyId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
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
    ..._iais.Protocol.targetTableDefinitions,
    ..._iacs.Protocol.targetTableDefinitions,
    ..._isp.Protocol.targetTableDefinitions,
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
      } on _is.DeserializationClassNameNotFoundException catch (_) {
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
    if (t == _is.getType<_is9newlb.CachedStopArea?>()) {
      return (data != null ? _is9newlb.CachedStopArea.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_itpp73iw.DepartureItem?>()) {
      return (data != null ? _itpp73iw.DepartureItem.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i59x0glc.RecentStopSearch?>()) {
      return (data != null ? _i59x0glc.RecentStopSearch.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ino4w0ds.ServiceJourneyCall?>()) {
      return (data != null ? _ino4w0ds.ServiceJourneyCall.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i2xnbyuw.StopDeparturesResponse?>()) {
      return (data != null
              ? _i2xnbyuw.StopDeparturesResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ir0riz23.TransitAgency?>()) {
      return (data != null ? _ir0riz23.TransitAgency.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i8frnuhu.TransitNextStop?>()) {
      return (data != null ? _i8frnuhu.TransitNextStop.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i2vp4lwc.TransitRoute?>()) {
      return (data != null ? _i2vp4lwc.TransitRoute.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i01e529e.TransitRouteShape?>()) {
      return (data != null ? _i01e529e.TransitRouteShape.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_isu0uk30.TransitRouteStop?>()) {
      return (data != null ? _isu0uk30.TransitRouteStop.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_io3v2zrm.TransitStopArea?>()) {
      return (data != null ? _io3v2zrm.TransitStopArea.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_it4fmahh.TransitStopPoint?>()) {
      return (data != null ? _it4fmahh.TransitStopPoint.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ixsh3gmj.TransitZone?>()) {
      return (data != null ? _ixsh3gmj.TransitZone.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i7guzaq2.VehicleDelta?>()) {
      return (data != null ? _i7guzaq2.VehicleDelta.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_isvxezb0.VehiclePosition?>()) {
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
    if (t == List<_ic92egf6.TransitStopArea>) {
      return (data as List)
              .map((e) => deserialize<_ic92egf6.TransitStopArea>(e))
              .toList()
          as T;
    }
    if (t == List<_ikyw9wov.TransitStopPoint>) {
      return (data as List)
              .map((e) => deserialize<_ikyw9wov.TransitStopPoint>(e))
              .toList()
          as T;
    }
    if (t == List<_i32ru7g2.TransitRouteShape>) {
      return (data as List)
              .map((e) => deserialize<_i32ru7g2.TransitRouteShape>(e))
              .toList()
          as T;
    }
    if (t == List<_ilv2yn39.ServiceJourneyCall>) {
      return (data as List)
              .map((e) => deserialize<_ilv2yn39.ServiceJourneyCall>(e))
              .toList()
          as T;
    }
    if (t == List<_i313ktem.TransitZone>) {
      return (data as List)
              .map((e) => deserialize<_i313ktem.TransitZone>(e))
              .toList()
          as T;
    }
    try {
      return _iais.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacs.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _isp.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
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
    className = _iais.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacs.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    className = _isp.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod.$className';
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
      return _iais.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacs.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _isp.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iais.Protocol().registerHostProtocol('open_transport_map', this);
    _iacs.Protocol().registerHostProtocol('open_transport_map', this);
  }

  @override
  _is.Table? getTableForType(Type t) {
    {
      var table = _iais.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _iacs.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _isp.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _ir0riz23.TransitAgency:
        return _ir0riz23.TransitAgency.t;
      case _i8frnuhu.TransitNextStop:
        return _i8frnuhu.TransitNextStop.t;
      case _i2vp4lwc.TransitRoute:
        return _i2vp4lwc.TransitRoute.t;
      case _i01e529e.TransitRouteShape:
        return _i01e529e.TransitRouteShape.t;
      case _isu0uk30.TransitRouteStop:
        return _isu0uk30.TransitRouteStop.t;
      case _io3v2zrm.TransitStopArea:
        return _io3v2zrm.TransitStopArea.t;
      case _it4fmahh.TransitStopPoint:
        return _it4fmahh.TransitStopPoint.t;
      case _ixsh3gmj.TransitZone:
        return _ixsh3gmj.TransitZone.t;
    }
    return null;
  }

  @override
  List<_isp.TableDefinition> getTargetTableDefinitions() =>
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
      return _iais.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacs.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
