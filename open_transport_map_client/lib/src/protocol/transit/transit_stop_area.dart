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

abstract class TransitStopArea
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  TransitStopArea._({
    this.id,
    required this.agencyId,
    required this.externalId,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.municipality,
    this.tariffZoneId,
  });

  factory TransitStopArea({
    int? id,
    required int agencyId,
    required String externalId,
    required String name,
    required double latitude,
    required double longitude,
    String? municipality,
    int? tariffZoneId,
  }) = _TransitStopAreaImpl;

  factory TransitStopArea.fromJson(Map<String, dynamic> jsonSerialization) {
    return TransitStopArea(
      id: jsonSerialization['id'] as int?,
      agencyId: jsonSerialization['agencyId'] as int,
      externalId: jsonSerialization['externalId'] as String,
      name: jsonSerialization['name'] as String,
      latitude: (jsonSerialization['latitude'] as num).toDouble(),
      longitude: (jsonSerialization['longitude'] as num).toDouble(),
      municipality: jsonSerialization['municipality'] as String?,
      tariffZoneId: jsonSerialization['tariffZoneId'] as int?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int agencyId;

  String externalId;

  String name;

  double latitude;

  double longitude;

  String? municipality;

  int? tariffZoneId;

  /// Returns a shallow copy of this [TransitStopArea]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  TransitStopArea copyWith({
    int? id,
    int? agencyId,
    String? externalId,
    String? name,
    double? latitude,
    double? longitude,
    String? municipality,
    int? tariffZoneId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TransitStopArea',
      if (id != null) 'id': id,
      'agencyId': agencyId,
      'externalId': externalId,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      if (municipality != null) 'municipality': municipality,
      if (tariffZoneId != null) 'tariffZoneId': tariffZoneId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TransitStopArea',
      if (id != null) 'id': id,
      'agencyId': agencyId,
      'externalId': externalId,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      if (municipality != null) 'municipality': municipality,
      if (tariffZoneId != null) 'tariffZoneId': tariffZoneId,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TransitStopAreaImpl extends TransitStopArea {
  _TransitStopAreaImpl({
    int? id,
    required int agencyId,
    required String externalId,
    required String name,
    required double latitude,
    required double longitude,
    String? municipality,
    int? tariffZoneId,
  }) : super._(
         id: id,
         agencyId: agencyId,
         externalId: externalId,
         name: name,
         latitude: latitude,
         longitude: longitude,
         municipality: municipality,
         tariffZoneId: tariffZoneId,
       );

  /// Returns a shallow copy of this [TransitStopArea]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  TransitStopArea copyWith({
    Object? id = _Undefined,
    int? agencyId,
    String? externalId,
    String? name,
    double? latitude,
    double? longitude,
    Object? municipality = _Undefined,
    Object? tariffZoneId = _Undefined,
  }) {
    return TransitStopArea(
      id: id is int? ? id : this.id,
      agencyId: agencyId ?? this.agencyId,
      externalId: externalId ?? this.externalId,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      municipality: municipality is String? ? municipality : this.municipality,
      tariffZoneId: tariffZoneId is int? ? tariffZoneId : this.tariffZoneId,
    );
  }
}
