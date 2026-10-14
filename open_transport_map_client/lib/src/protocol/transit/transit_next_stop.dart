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

abstract class TransitNextStop
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  TransitNextStop._({
    this.id,
    required this.routeId,
    required this.headsign,
    required this.stopPointExternalId,
    required this.nextStopName,
    this.cachedAt,
  });

  factory TransitNextStop({
    int? id,
    required int routeId,
    required String headsign,
    required String stopPointExternalId,
    required String nextStopName,
    DateTime? cachedAt,
  }) = _TransitNextStopImpl;

  factory TransitNextStop.fromJson(Map<String, dynamic> jsonSerialization) {
    return TransitNextStop(
      id: jsonSerialization['id'] as int?,
      routeId: jsonSerialization['routeId'] as int,
      headsign: jsonSerialization['headsign'] as String,
      stopPointExternalId: jsonSerialization['stopPointExternalId'] as String,
      nextStopName: jsonSerialization['nextStopName'] as String,
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

  String headsign;

  /// Stop point the departure is observed at. A journey's next call depends on
  /// where you board it, so the cache is keyed per stop point, not just per
  /// route and direction.
  String stopPointExternalId;

  String nextStopName;

  DateTime? cachedAt;

  /// Returns a shallow copy of this [TransitNextStop]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  TransitNextStop copyWith({
    int? id,
    int? routeId,
    String? headsign,
    String? stopPointExternalId,
    String? nextStopName,
    DateTime? cachedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TransitNextStop',
      if (id != null) 'id': id,
      'routeId': routeId,
      'headsign': headsign,
      'stopPointExternalId': stopPointExternalId,
      'nextStopName': nextStopName,
      if (cachedAt != null) 'cachedAt': cachedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TransitNextStop',
      if (id != null) 'id': id,
      'routeId': routeId,
      'headsign': headsign,
      'stopPointExternalId': stopPointExternalId,
      'nextStopName': nextStopName,
      if (cachedAt != null) 'cachedAt': cachedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TransitNextStopImpl extends TransitNextStop {
  _TransitNextStopImpl({
    int? id,
    required int routeId,
    required String headsign,
    required String stopPointExternalId,
    required String nextStopName,
    DateTime? cachedAt,
  }) : super._(
         id: id,
         routeId: routeId,
         headsign: headsign,
         stopPointExternalId: stopPointExternalId,
         nextStopName: nextStopName,
         cachedAt: cachedAt,
       );

  /// Returns a shallow copy of this [TransitNextStop]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  TransitNextStop copyWith({
    Object? id = _Undefined,
    int? routeId,
    String? headsign,
    String? stopPointExternalId,
    String? nextStopName,
    Object? cachedAt = _Undefined,
  }) {
    return TransitNextStop(
      id: id is int? ? id : this.id,
      routeId: routeId ?? this.routeId,
      headsign: headsign ?? this.headsign,
      stopPointExternalId: stopPointExternalId ?? this.stopPointExternalId,
      nextStopName: nextStopName ?? this.nextStopName,
      cachedAt: cachedAt is DateTime? ? cachedAt : this.cachedAt,
    );
  }
}
