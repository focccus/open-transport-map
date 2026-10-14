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

abstract class TransitStopPoint
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  TransitStopPoint._({
    this.id,
    required this.agencyId,
    required this.stopAreaId,
    required this.externalId,
    required this.name,
    this.platform,
    required this.latitude,
    required this.longitude,
    this.designation,
  });

  factory TransitStopPoint({
    int? id,
    required int agencyId,
    required int stopAreaId,
    required String externalId,
    required String name,
    String? platform,
    required double latitude,
    required double longitude,
    String? designation,
  }) = _TransitStopPointImpl;

  factory TransitStopPoint.fromJson(Map<String, dynamic> jsonSerialization) {
    return TransitStopPoint(
      id: jsonSerialization['id'] as int?,
      agencyId: jsonSerialization['agencyId'] as int,
      stopAreaId: jsonSerialization['stopAreaId'] as int,
      externalId: jsonSerialization['externalId'] as String,
      name: jsonSerialization['name'] as String,
      platform: jsonSerialization['platform'] as String?,
      latitude: (jsonSerialization['latitude'] as num).toDouble(),
      longitude: (jsonSerialization['longitude'] as num).toDouble(),
      designation: jsonSerialization['designation'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int agencyId;

  int stopAreaId;

  String externalId;

  String name;

  String? platform;

  double latitude;

  double longitude;

  String? designation;

  /// Returns a shallow copy of this [TransitStopPoint]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  TransitStopPoint copyWith({
    int? id,
    int? agencyId,
    int? stopAreaId,
    String? externalId,
    String? name,
    String? platform,
    double? latitude,
    double? longitude,
    String? designation,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TransitStopPoint',
      if (id != null) 'id': id,
      'agencyId': agencyId,
      'stopAreaId': stopAreaId,
      'externalId': externalId,
      'name': name,
      if (platform != null) 'platform': platform,
      'latitude': latitude,
      'longitude': longitude,
      if (designation != null) 'designation': designation,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TransitStopPoint',
      if (id != null) 'id': id,
      'agencyId': agencyId,
      'stopAreaId': stopAreaId,
      'externalId': externalId,
      'name': name,
      if (platform != null) 'platform': platform,
      'latitude': latitude,
      'longitude': longitude,
      if (designation != null) 'designation': designation,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TransitStopPointImpl extends TransitStopPoint {
  _TransitStopPointImpl({
    int? id,
    required int agencyId,
    required int stopAreaId,
    required String externalId,
    required String name,
    String? platform,
    required double latitude,
    required double longitude,
    String? designation,
  }) : super._(
         id: id,
         agencyId: agencyId,
         stopAreaId: stopAreaId,
         externalId: externalId,
         name: name,
         platform: platform,
         latitude: latitude,
         longitude: longitude,
         designation: designation,
       );

  /// Returns a shallow copy of this [TransitStopPoint]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  TransitStopPoint copyWith({
    Object? id = _Undefined,
    int? agencyId,
    int? stopAreaId,
    String? externalId,
    String? name,
    Object? platform = _Undefined,
    double? latitude,
    double? longitude,
    Object? designation = _Undefined,
  }) {
    return TransitStopPoint(
      id: id is int? ? id : this.id,
      agencyId: agencyId ?? this.agencyId,
      stopAreaId: stopAreaId ?? this.stopAreaId,
      externalId: externalId ?? this.externalId,
      name: name ?? this.name,
      platform: platform is String? ? platform : this.platform,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      designation: designation is String? ? designation : this.designation,
    );
  }
}
