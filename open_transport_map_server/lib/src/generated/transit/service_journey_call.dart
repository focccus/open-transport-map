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

abstract class ServiceJourneyCall
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ServiceJourneyCall._({
    required this.stopPointGid,
    required this.name,
    this.latitude,
    this.longitude,
    this.platform,
    this.plannedArrivalTime,
    this.estimatedArrivalTime,
    this.plannedDepartureTime,
    this.estimatedDepartureTime,
    required this.isCancelled,
  });

  factory ServiceJourneyCall({
    required String stopPointGid,
    required String name,
    double? latitude,
    double? longitude,
    String? platform,
    DateTime? plannedArrivalTime,
    DateTime? estimatedArrivalTime,
    DateTime? plannedDepartureTime,
    DateTime? estimatedDepartureTime,
    required bool isCancelled,
  }) = _ServiceJourneyCallImpl;

  factory ServiceJourneyCall.fromJson(Map<String, dynamic> jsonSerialization) {
    return ServiceJourneyCall(
      stopPointGid: jsonSerialization['stopPointGid'] as String,
      name: jsonSerialization['name'] as String,
      latitude: (jsonSerialization['latitude'] as num?)?.toDouble(),
      longitude: (jsonSerialization['longitude'] as num?)?.toDouble(),
      platform: jsonSerialization['platform'] as String?,
      plannedArrivalTime: jsonSerialization['plannedArrivalTime'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['plannedArrivalTime'],
            ),
      estimatedArrivalTime: jsonSerialization['estimatedArrivalTime'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['estimatedArrivalTime'],
            ),
      plannedDepartureTime: jsonSerialization['plannedDepartureTime'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['plannedDepartureTime'],
            ),
      estimatedDepartureTime:
          jsonSerialization['estimatedDepartureTime'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['estimatedDepartureTime'],
            ),
      isCancelled: _is.BoolJsonExtension.fromJson(
        jsonSerialization['isCancelled'],
      ),
    );
  }

  /// Stop point the journey calls at.
  String stopPointGid;

  String name;

  /// Where the call is, used to frame the journey on the map and to place the
  /// vehicle when the live feed does not cover it. Null when upstream gives no
  /// geometry.
  double? latitude;

  double? longitude;

  /// Platform the call is made from, the realtime one when upstream reports it.
  /// Null for a stop point without platforms.
  String? platform;

  /// Arrival and departure times at this call. The estimate is null until the
  /// upstream reports one; the "otherwise planned" estimate on the wire is
  /// folded into it.
  DateTime? plannedArrivalTime;

  DateTime? estimatedArrivalTime;

  DateTime? plannedDepartureTime;

  DateTime? estimatedDepartureTime;

  /// A cancelled call stays in the timeline, struck through, so the shape of the
  /// journey is still readable.
  bool isCancelled;

  /// Returns a shallow copy of this [ServiceJourneyCall]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ServiceJourneyCall copyWith({
    String? stopPointGid,
    String? name,
    double? latitude,
    double? longitude,
    String? platform,
    DateTime? plannedArrivalTime,
    DateTime? estimatedArrivalTime,
    DateTime? plannedDepartureTime,
    DateTime? estimatedDepartureTime,
    bool? isCancelled,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ServiceJourneyCall',
      'stopPointGid': stopPointGid,
      'name': name,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (platform != null) 'platform': platform,
      if (plannedArrivalTime != null)
        'plannedArrivalTime': plannedArrivalTime?.toJson(),
      if (estimatedArrivalTime != null)
        'estimatedArrivalTime': estimatedArrivalTime?.toJson(),
      if (plannedDepartureTime != null)
        'plannedDepartureTime': plannedDepartureTime?.toJson(),
      if (estimatedDepartureTime != null)
        'estimatedDepartureTime': estimatedDepartureTime?.toJson(),
      'isCancelled': isCancelled,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ServiceJourneyCall',
      'stopPointGid': stopPointGid,
      'name': name,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (platform != null) 'platform': platform,
      if (plannedArrivalTime != null)
        'plannedArrivalTime': plannedArrivalTime?.toJson(),
      if (estimatedArrivalTime != null)
        'estimatedArrivalTime': estimatedArrivalTime?.toJson(),
      if (plannedDepartureTime != null)
        'plannedDepartureTime': plannedDepartureTime?.toJson(),
      if (estimatedDepartureTime != null)
        'estimatedDepartureTime': estimatedDepartureTime?.toJson(),
      'isCancelled': isCancelled,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ServiceJourneyCallImpl extends ServiceJourneyCall {
  _ServiceJourneyCallImpl({
    required String stopPointGid,
    required String name,
    double? latitude,
    double? longitude,
    String? platform,
    DateTime? plannedArrivalTime,
    DateTime? estimatedArrivalTime,
    DateTime? plannedDepartureTime,
    DateTime? estimatedDepartureTime,
    required bool isCancelled,
  }) : super._(
         stopPointGid: stopPointGid,
         name: name,
         latitude: latitude,
         longitude: longitude,
         platform: platform,
         plannedArrivalTime: plannedArrivalTime,
         estimatedArrivalTime: estimatedArrivalTime,
         plannedDepartureTime: plannedDepartureTime,
         estimatedDepartureTime: estimatedDepartureTime,
         isCancelled: isCancelled,
       );

  /// Returns a shallow copy of this [ServiceJourneyCall]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ServiceJourneyCall copyWith({
    String? stopPointGid,
    String? name,
    Object? latitude = _Undefined,
    Object? longitude = _Undefined,
    Object? platform = _Undefined,
    Object? plannedArrivalTime = _Undefined,
    Object? estimatedArrivalTime = _Undefined,
    Object? plannedDepartureTime = _Undefined,
    Object? estimatedDepartureTime = _Undefined,
    bool? isCancelled,
  }) {
    return ServiceJourneyCall(
      stopPointGid: stopPointGid ?? this.stopPointGid,
      name: name ?? this.name,
      latitude: latitude is double? ? latitude : this.latitude,
      longitude: longitude is double? ? longitude : this.longitude,
      platform: platform is String? ? platform : this.platform,
      plannedArrivalTime: plannedArrivalTime is DateTime?
          ? plannedArrivalTime
          : this.plannedArrivalTime,
      estimatedArrivalTime: estimatedArrivalTime is DateTime?
          ? estimatedArrivalTime
          : this.estimatedArrivalTime,
      plannedDepartureTime: plannedDepartureTime is DateTime?
          ? plannedDepartureTime
          : this.plannedDepartureTime,
      estimatedDepartureTime: estimatedDepartureTime is DateTime?
          ? estimatedDepartureTime
          : this.estimatedDepartureTime,
      isCancelled: isCancelled ?? this.isCancelled,
    );
  }
}
