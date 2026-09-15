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

abstract class VehiclePosition
    implements _is.SerializableModel, _is.ProtocolSerialization {
  VehiclePosition._({
    required this.vehicleId,
    required this.timestamp,
    this.serviceJourneyGid,
    this.status,
    this.atStop,
    this.lastStopPointGid,
    required this.latitude,
    required this.longitude,
    this.speedKmh,
    this.course,
    this.destination,
    this.via,
    this.lineShortName,
    this.lineTransportMode,
    this.lineBackgroundColor,
    this.lineForegroundColor,
  });

  factory VehiclePosition({
    required String vehicleId,
    required DateTime timestamp,
    String? serviceJourneyGid,
    String? status,
    bool? atStop,
    String? lastStopPointGid,
    required double latitude,
    required double longitude,
    double? speedKmh,
    double? course,
    String? destination,
    String? via,
    String? lineShortName,
    String? lineTransportMode,
    String? lineBackgroundColor,
    String? lineForegroundColor,
  }) = _VehiclePositionImpl;

  factory VehiclePosition.fromJson(Map<String, dynamic> jsonSerialization) {
    return VehiclePosition(
      vehicleId: jsonSerialization['vehicleId'] as String,
      timestamp: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
      serviceJourneyGid: jsonSerialization['serviceJourneyGid'] as String?,
      status: jsonSerialization['status'] as String?,
      atStop: jsonSerialization['atStop'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['atStop']),
      lastStopPointGid: jsonSerialization['lastStopPointGid'] as String?,
      latitude: (jsonSerialization['latitude'] as num).toDouble(),
      longitude: (jsonSerialization['longitude'] as num).toDouble(),
      speedKmh: (jsonSerialization['speedKmh'] as num?)?.toDouble(),
      course: (jsonSerialization['course'] as num?)?.toDouble(),
      destination: jsonSerialization['destination'] as String?,
      via: jsonSerialization['via'] as String?,
      lineShortName: jsonSerialization['lineShortName'] as String?,
      lineTransportMode: jsonSerialization['lineTransportMode'] as String?,
      lineBackgroundColor: jsonSerialization['lineBackgroundColor'] as String?,
      lineForegroundColor: jsonSerialization['lineForegroundColor'] as String?,
    );
  }

  String vehicleId;

  DateTime timestamp;

  String? serviceJourneyGid;

  String? status;

  bool? atStop;

  String? lastStopPointGid;

  double latitude;

  double longitude;

  double? speedKmh;

  double? course;

  String? destination;

  String? via;

  String? lineShortName;

  String? lineTransportMode;

  String? lineBackgroundColor;

  String? lineForegroundColor;

  /// Returns a shallow copy of this [VehiclePosition]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  VehiclePosition copyWith({
    String? vehicleId,
    DateTime? timestamp,
    String? serviceJourneyGid,
    String? status,
    bool? atStop,
    String? lastStopPointGid,
    double? latitude,
    double? longitude,
    double? speedKmh,
    double? course,
    String? destination,
    String? via,
    String? lineShortName,
    String? lineTransportMode,
    String? lineBackgroundColor,
    String? lineForegroundColor,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VehiclePosition',
      'vehicleId': vehicleId,
      'timestamp': timestamp.toJson(),
      if (serviceJourneyGid != null) 'serviceJourneyGid': serviceJourneyGid,
      if (status != null) 'status': status,
      if (atStop != null) 'atStop': atStop,
      if (lastStopPointGid != null) 'lastStopPointGid': lastStopPointGid,
      'latitude': latitude,
      'longitude': longitude,
      if (speedKmh != null) 'speedKmh': speedKmh,
      if (course != null) 'course': course,
      if (destination != null) 'destination': destination,
      if (via != null) 'via': via,
      if (lineShortName != null) 'lineShortName': lineShortName,
      if (lineTransportMode != null) 'lineTransportMode': lineTransportMode,
      if (lineBackgroundColor != null)
        'lineBackgroundColor': lineBackgroundColor,
      if (lineForegroundColor != null)
        'lineForegroundColor': lineForegroundColor,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'VehiclePosition',
      'vehicleId': vehicleId,
      'timestamp': timestamp.toJson(),
      if (serviceJourneyGid != null) 'serviceJourneyGid': serviceJourneyGid,
      if (status != null) 'status': status,
      if (atStop != null) 'atStop': atStop,
      if (lastStopPointGid != null) 'lastStopPointGid': lastStopPointGid,
      'latitude': latitude,
      'longitude': longitude,
      if (speedKmh != null) 'speedKmh': speedKmh,
      if (course != null) 'course': course,
      if (destination != null) 'destination': destination,
      if (via != null) 'via': via,
      if (lineShortName != null) 'lineShortName': lineShortName,
      if (lineTransportMode != null) 'lineTransportMode': lineTransportMode,
      if (lineBackgroundColor != null)
        'lineBackgroundColor': lineBackgroundColor,
      if (lineForegroundColor != null)
        'lineForegroundColor': lineForegroundColor,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _VehiclePositionImpl extends VehiclePosition {
  _VehiclePositionImpl({
    required String vehicleId,
    required DateTime timestamp,
    String? serviceJourneyGid,
    String? status,
    bool? atStop,
    String? lastStopPointGid,
    required double latitude,
    required double longitude,
    double? speedKmh,
    double? course,
    String? destination,
    String? via,
    String? lineShortName,
    String? lineTransportMode,
    String? lineBackgroundColor,
    String? lineForegroundColor,
  }) : super._(
         vehicleId: vehicleId,
         timestamp: timestamp,
         serviceJourneyGid: serviceJourneyGid,
         status: status,
         atStop: atStop,
         lastStopPointGid: lastStopPointGid,
         latitude: latitude,
         longitude: longitude,
         speedKmh: speedKmh,
         course: course,
         destination: destination,
         via: via,
         lineShortName: lineShortName,
         lineTransportMode: lineTransportMode,
         lineBackgroundColor: lineBackgroundColor,
         lineForegroundColor: lineForegroundColor,
       );

  /// Returns a shallow copy of this [VehiclePosition]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  VehiclePosition copyWith({
    String? vehicleId,
    DateTime? timestamp,
    Object? serviceJourneyGid = _Undefined,
    Object? status = _Undefined,
    Object? atStop = _Undefined,
    Object? lastStopPointGid = _Undefined,
    double? latitude,
    double? longitude,
    Object? speedKmh = _Undefined,
    Object? course = _Undefined,
    Object? destination = _Undefined,
    Object? via = _Undefined,
    Object? lineShortName = _Undefined,
    Object? lineTransportMode = _Undefined,
    Object? lineBackgroundColor = _Undefined,
    Object? lineForegroundColor = _Undefined,
  }) {
    return VehiclePosition(
      vehicleId: vehicleId ?? this.vehicleId,
      timestamp: timestamp ?? this.timestamp,
      serviceJourneyGid: serviceJourneyGid is String?
          ? serviceJourneyGid
          : this.serviceJourneyGid,
      status: status is String? ? status : this.status,
      atStop: atStop is bool? ? atStop : this.atStop,
      lastStopPointGid: lastStopPointGid is String?
          ? lastStopPointGid
          : this.lastStopPointGid,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      speedKmh: speedKmh is double? ? speedKmh : this.speedKmh,
      course: course is double? ? course : this.course,
      destination: destination is String? ? destination : this.destination,
      via: via is String? ? via : this.via,
      lineShortName: lineShortName is String?
          ? lineShortName
          : this.lineShortName,
      lineTransportMode: lineTransportMode is String?
          ? lineTransportMode
          : this.lineTransportMode,
      lineBackgroundColor: lineBackgroundColor is String?
          ? lineBackgroundColor
          : this.lineBackgroundColor,
      lineForegroundColor: lineForegroundColor is String?
          ? lineForegroundColor
          : this.lineForegroundColor,
    );
  }
}
