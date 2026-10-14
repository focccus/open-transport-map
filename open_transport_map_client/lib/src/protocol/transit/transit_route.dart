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

abstract class TransitRoute
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  TransitRoute._({
    this.id,
    required this.agencyId,
    required this.externalId,
    required this.shortName,
    this.longName,
    required this.transportMode,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.cachedAt,
  });

  factory TransitRoute({
    int? id,
    required int agencyId,
    required String externalId,
    required String shortName,
    String? longName,
    required String transportMode,
    String? backgroundColor,
    String? foregroundColor,
    String? borderColor,
    DateTime? cachedAt,
  }) = _TransitRouteImpl;

  factory TransitRoute.fromJson(Map<String, dynamic> jsonSerialization) {
    return TransitRoute(
      id: jsonSerialization['id'] as int?,
      agencyId: jsonSerialization['agencyId'] as int,
      externalId: jsonSerialization['externalId'] as String,
      shortName: jsonSerialization['shortName'] as String,
      longName: jsonSerialization['longName'] as String?,
      transportMode: jsonSerialization['transportMode'] as String,
      backgroundColor: jsonSerialization['backgroundColor'] as String?,
      foregroundColor: jsonSerialization['foregroundColor'] as String?,
      borderColor: jsonSerialization['borderColor'] as String?,
      cachedAt: jsonSerialization['cachedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['cachedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int agencyId;

  String externalId;

  String shortName;

  String? longName;

  String transportMode;

  String? backgroundColor;

  String? foregroundColor;

  String? borderColor;

  DateTime? cachedAt;

  /// Returns a shallow copy of this [TransitRoute]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  TransitRoute copyWith({
    int? id,
    int? agencyId,
    String? externalId,
    String? shortName,
    String? longName,
    String? transportMode,
    String? backgroundColor,
    String? foregroundColor,
    String? borderColor,
    DateTime? cachedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TransitRoute',
      if (id != null) 'id': id,
      'agencyId': agencyId,
      'externalId': externalId,
      'shortName': shortName,
      if (longName != null) 'longName': longName,
      'transportMode': transportMode,
      if (backgroundColor != null) 'backgroundColor': backgroundColor,
      if (foregroundColor != null) 'foregroundColor': foregroundColor,
      if (borderColor != null) 'borderColor': borderColor,
      if (cachedAt != null) 'cachedAt': cachedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TransitRoute',
      if (id != null) 'id': id,
      'agencyId': agencyId,
      'externalId': externalId,
      'shortName': shortName,
      if (longName != null) 'longName': longName,
      'transportMode': transportMode,
      if (backgroundColor != null) 'backgroundColor': backgroundColor,
      if (foregroundColor != null) 'foregroundColor': foregroundColor,
      if (borderColor != null) 'borderColor': borderColor,
      if (cachedAt != null) 'cachedAt': cachedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TransitRouteImpl extends TransitRoute {
  _TransitRouteImpl({
    int? id,
    required int agencyId,
    required String externalId,
    required String shortName,
    String? longName,
    required String transportMode,
    String? backgroundColor,
    String? foregroundColor,
    String? borderColor,
    DateTime? cachedAt,
  }) : super._(
         id: id,
         agencyId: agencyId,
         externalId: externalId,
         shortName: shortName,
         longName: longName,
         transportMode: transportMode,
         backgroundColor: backgroundColor,
         foregroundColor: foregroundColor,
         borderColor: borderColor,
         cachedAt: cachedAt,
       );

  /// Returns a shallow copy of this [TransitRoute]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  TransitRoute copyWith({
    Object? id = _Undefined,
    int? agencyId,
    String? externalId,
    String? shortName,
    Object? longName = _Undefined,
    String? transportMode,
    Object? backgroundColor = _Undefined,
    Object? foregroundColor = _Undefined,
    Object? borderColor = _Undefined,
    Object? cachedAt = _Undefined,
  }) {
    return TransitRoute(
      id: id is int? ? id : this.id,
      agencyId: agencyId ?? this.agencyId,
      externalId: externalId ?? this.externalId,
      shortName: shortName ?? this.shortName,
      longName: longName is String? ? longName : this.longName,
      transportMode: transportMode ?? this.transportMode,
      backgroundColor: backgroundColor is String?
          ? backgroundColor
          : this.backgroundColor,
      foregroundColor: foregroundColor is String?
          ? foregroundColor
          : this.foregroundColor,
      borderColor: borderColor is String? ? borderColor : this.borderColor,
      cachedAt: cachedAt is DateTime? ? cachedAt : this.cachedAt,
    );
  }
}
