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

abstract class TransitZone
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int agencyId;

  String externalId;

  String name;

  String? color;

  String? geometryGeoJson;

  /// Returns a shallow copy of this [TransitZone]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
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

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
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
  @_isc.useResult
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
