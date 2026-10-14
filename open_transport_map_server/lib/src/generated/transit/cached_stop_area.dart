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

abstract class CachedStopArea
    implements _is.SerializableModel, _is.ProtocolSerialization {
  CachedStopArea._({
    this.id,
    required this.externalId,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.municipality,
    required this.syncedAt,
  });

  factory CachedStopArea({
    int? id,
    required String externalId,
    required String name,
    required double latitude,
    required double longitude,
    String? municipality,
    required DateTime syncedAt,
  }) = _CachedStopAreaImpl;

  factory CachedStopArea.fromJson(Map<String, dynamic> jsonSerialization) {
    return CachedStopArea(
      id: jsonSerialization['id'] as int?,
      externalId: jsonSerialization['externalId'] as String,
      name: jsonSerialization['name'] as String,
      latitude: (jsonSerialization['latitude'] as num).toDouble(),
      longitude: (jsonSerialization['longitude'] as num).toDouble(),
      municipality: jsonSerialization['municipality'] as String?,
      syncedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['syncedAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String externalId;

  String name;

  double latitude;

  double longitude;

  String? municipality;

  DateTime syncedAt;

  /// Returns a shallow copy of this [CachedStopArea]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CachedStopArea copyWith({
    int? id,
    String? externalId,
    String? name,
    double? latitude,
    double? longitude,
    String? municipality,
    DateTime? syncedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CachedStopArea',
      if (id != null) 'id': id,
      'externalId': externalId,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      if (municipality != null) 'municipality': municipality,
      'syncedAt': syncedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CachedStopArea',
      if (id != null) 'id': id,
      'externalId': externalId,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      if (municipality != null) 'municipality': municipality,
      'syncedAt': syncedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CachedStopAreaImpl extends CachedStopArea {
  _CachedStopAreaImpl({
    int? id,
    required String externalId,
    required String name,
    required double latitude,
    required double longitude,
    String? municipality,
    required DateTime syncedAt,
  }) : super._(
         id: id,
         externalId: externalId,
         name: name,
         latitude: latitude,
         longitude: longitude,
         municipality: municipality,
         syncedAt: syncedAt,
       );

  /// Returns a shallow copy of this [CachedStopArea]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CachedStopArea copyWith({
    Object? id = _Undefined,
    String? externalId,
    String? name,
    double? latitude,
    double? longitude,
    Object? municipality = _Undefined,
    DateTime? syncedAt,
  }) {
    return CachedStopArea(
      id: id is int? ? id : this.id,
      externalId: externalId ?? this.externalId,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      municipality: municipality is String? ? municipality : this.municipality,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }
}
