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

abstract class TransitRouteStop
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  TransitRouteStop._({
    this.id,
    required this.routeShapeId,
    required this.stopPointId,
    required this.stopSequence,
  });

  factory TransitRouteStop({
    int? id,
    required int routeShapeId,
    required int stopPointId,
    required int stopSequence,
  }) = _TransitRouteStopImpl;

  factory TransitRouteStop.fromJson(Map<String, dynamic> jsonSerialization) {
    return TransitRouteStop(
      id: jsonSerialization['id'] as int?,
      routeShapeId: jsonSerialization['routeShapeId'] as int,
      stopPointId: jsonSerialization['stopPointId'] as int,
      stopSequence: jsonSerialization['stopSequence'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int routeShapeId;

  int stopPointId;

  int stopSequence;

  /// Returns a shallow copy of this [TransitRouteStop]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  TransitRouteStop copyWith({
    int? id,
    int? routeShapeId,
    int? stopPointId,
    int? stopSequence,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TransitRouteStop',
      if (id != null) 'id': id,
      'routeShapeId': routeShapeId,
      'stopPointId': stopPointId,
      'stopSequence': stopSequence,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TransitRouteStop',
      if (id != null) 'id': id,
      'routeShapeId': routeShapeId,
      'stopPointId': stopPointId,
      'stopSequence': stopSequence,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TransitRouteStopImpl extends TransitRouteStop {
  _TransitRouteStopImpl({
    int? id,
    required int routeShapeId,
    required int stopPointId,
    required int stopSequence,
  }) : super._(
         id: id,
         routeShapeId: routeShapeId,
         stopPointId: stopPointId,
         stopSequence: stopSequence,
       );

  /// Returns a shallow copy of this [TransitRouteStop]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  TransitRouteStop copyWith({
    Object? id = _Undefined,
    int? routeShapeId,
    int? stopPointId,
    int? stopSequence,
  }) {
    return TransitRouteStop(
      id: id is int? ? id : this.id,
      routeShapeId: routeShapeId ?? this.routeShapeId,
      stopPointId: stopPointId ?? this.stopPointId,
      stopSequence: stopSequence ?? this.stopSequence,
    );
  }
}
