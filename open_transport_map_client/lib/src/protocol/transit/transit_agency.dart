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

abstract class TransitAgency
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  TransitAgency._({
    this.id,
    required this.externalId,
    required this.name,
    String? timezone,
    String? countryCode,
    required this.city,
    this.syncedAt,
  }) : timezone = timezone ?? 'Europe/Stockholm',
       countryCode = countryCode ?? 'SE';

  factory TransitAgency({
    int? id,
    required String externalId,
    required String name,
    String? timezone,
    String? countryCode,
    required String city,
    DateTime? syncedAt,
  }) = _TransitAgencyImpl;

  factory TransitAgency.fromJson(Map<String, dynamic> jsonSerialization) {
    return TransitAgency(
      id: jsonSerialization['id'] as int?,
      externalId: jsonSerialization['externalId'] as String,
      name: jsonSerialization['name'] as String,
      timezone: jsonSerialization['timezone'] as String?,
      countryCode: jsonSerialization['countryCode'] as String?,
      city: jsonSerialization['city'] as String,
      syncedAt: jsonSerialization['syncedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['syncedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String externalId;

  String name;

  String timezone;

  String countryCode;

  String city;

  DateTime? syncedAt;

  /// Returns a shallow copy of this [TransitAgency]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  TransitAgency copyWith({
    int? id,
    String? externalId,
    String? name,
    String? timezone,
    String? countryCode,
    String? city,
    DateTime? syncedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TransitAgency',
      if (id != null) 'id': id,
      'externalId': externalId,
      'name': name,
      'timezone': timezone,
      'countryCode': countryCode,
      'city': city,
      if (syncedAt != null) 'syncedAt': syncedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TransitAgency',
      if (id != null) 'id': id,
      'externalId': externalId,
      'name': name,
      'timezone': timezone,
      'countryCode': countryCode,
      'city': city,
      if (syncedAt != null) 'syncedAt': syncedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TransitAgencyImpl extends TransitAgency {
  _TransitAgencyImpl({
    int? id,
    required String externalId,
    required String name,
    String? timezone,
    String? countryCode,
    required String city,
    DateTime? syncedAt,
  }) : super._(
         id: id,
         externalId: externalId,
         name: name,
         timezone: timezone,
         countryCode: countryCode,
         city: city,
         syncedAt: syncedAt,
       );

  /// Returns a shallow copy of this [TransitAgency]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  TransitAgency copyWith({
    Object? id = _Undefined,
    String? externalId,
    String? name,
    String? timezone,
    String? countryCode,
    String? city,
    Object? syncedAt = _Undefined,
  }) {
    return TransitAgency(
      id: id is int? ? id : this.id,
      externalId: externalId ?? this.externalId,
      name: name ?? this.name,
      timezone: timezone ?? this.timezone,
      countryCode: countryCode ?? this.countryCode,
      city: city ?? this.city,
      syncedAt: syncedAt is DateTime? ? syncedAt : this.syncedAt,
    );
  }
}
