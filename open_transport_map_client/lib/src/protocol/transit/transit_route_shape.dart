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

abstract class TransitRouteShape
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['cachedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int routeId;

  int? directionId;

  String? headsign;

  String geometryGeoJson;

  DateTime? cachedAt;

  /// Returns a shallow copy of this [TransitRouteShape]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
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

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
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
  @_isc.useResult
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
