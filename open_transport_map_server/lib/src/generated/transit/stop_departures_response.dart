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
import 'package:open_transport_map_server/src/generated/protocol.dart'
    as _imkmox2w;
import 'package:serverpod/serverpod.dart' as _is;
import '../transit/departure_item.dart' as _ixv7l6lq;

abstract class StopDeparturesResponse
    implements _is.SerializableModel, _is.ProtocolSerialization {
  StopDeparturesResponse._({
    required this.stopGid,
    required this.stopName,
    required this.isStopArea,
    this.stopAreaGid,
    this.municipality,
    this.platform,
    required this.departures,
    required this.routeShapesGeoJson,
  });

  factory StopDeparturesResponse({
    required String stopGid,
    required String stopName,
    required bool isStopArea,
    String? stopAreaGid,
    String? municipality,
    String? platform,
    required List<_ixv7l6lq.DepartureItem> departures,
    required String routeShapesGeoJson,
  }) = _StopDeparturesResponseImpl;

  factory StopDeparturesResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return StopDeparturesResponse(
      stopGid: jsonSerialization['stopGid'] as String,
      stopName: jsonSerialization['stopName'] as String,
      isStopArea: _is.BoolJsonExtension.fromJson(
        jsonSerialization['isStopArea'],
      ),
      stopAreaGid: jsonSerialization['stopAreaGid'] as String?,
      municipality: jsonSerialization['municipality'] as String?,
      platform: jsonSerialization['platform'] as String?,
      departures: _imkmox2w.Protocol()
          .deserialize<List<_ixv7l6lq.DepartureItem>>(
            jsonSerialization['departures'],
          ),
      routeShapesGeoJson: jsonSerialization['routeShapesGeoJson'] as String,
    );
  }

  String stopGid;

  String stopName;

  bool isStopArea;

  String? stopAreaGid;

  String? municipality;

  String? platform;

  List<_ixv7l6lq.DepartureItem> departures;

  String routeShapesGeoJson;

  /// Returns a shallow copy of this [StopDeparturesResponse]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  StopDeparturesResponse copyWith({
    String? stopGid,
    String? stopName,
    bool? isStopArea,
    String? stopAreaGid,
    String? municipality,
    String? platform,
    List<_ixv7l6lq.DepartureItem>? departures,
    String? routeShapesGeoJson,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StopDeparturesResponse',
      'stopGid': stopGid,
      'stopName': stopName,
      'isStopArea': isStopArea,
      if (stopAreaGid != null) 'stopAreaGid': stopAreaGid,
      if (municipality != null) 'municipality': municipality,
      if (platform != null) 'platform': platform,
      'departures': departures.toJson(valueToJson: (v) => v.toJson()),
      'routeShapesGeoJson': routeShapesGeoJson,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StopDeparturesResponse',
      'stopGid': stopGid,
      'stopName': stopName,
      'isStopArea': isStopArea,
      if (stopAreaGid != null) 'stopAreaGid': stopAreaGid,
      if (municipality != null) 'municipality': municipality,
      if (platform != null) 'platform': platform,
      'departures': departures.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'routeShapesGeoJson': routeShapesGeoJson,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StopDeparturesResponseImpl extends StopDeparturesResponse {
  _StopDeparturesResponseImpl({
    required String stopGid,
    required String stopName,
    required bool isStopArea,
    String? stopAreaGid,
    String? municipality,
    String? platform,
    required List<_ixv7l6lq.DepartureItem> departures,
    required String routeShapesGeoJson,
  }) : super._(
         stopGid: stopGid,
         stopName: stopName,
         isStopArea: isStopArea,
         stopAreaGid: stopAreaGid,
         municipality: municipality,
         platform: platform,
         departures: departures,
         routeShapesGeoJson: routeShapesGeoJson,
       );

  /// Returns a shallow copy of this [StopDeparturesResponse]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  StopDeparturesResponse copyWith({
    String? stopGid,
    String? stopName,
    bool? isStopArea,
    Object? stopAreaGid = _Undefined,
    Object? municipality = _Undefined,
    Object? platform = _Undefined,
    List<_ixv7l6lq.DepartureItem>? departures,
    String? routeShapesGeoJson,
  }) {
    return StopDeparturesResponse(
      stopGid: stopGid ?? this.stopGid,
      stopName: stopName ?? this.stopName,
      isStopArea: isStopArea ?? this.isStopArea,
      stopAreaGid: stopAreaGid is String? ? stopAreaGid : this.stopAreaGid,
      municipality: municipality is String? ? municipality : this.municipality,
      platform: platform is String? ? platform : this.platform,
      departures:
          departures ?? this.departures.map((e0) => e0.copyWith()).toList(),
      routeShapesGeoJson: routeShapesGeoJson ?? this.routeShapesGeoJson,
    );
  }
}
