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

abstract class DepartureItem
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DepartureItem._({
    required this.serviceJourneyGid,
    required this.lineDesignation,
    required this.lineShortName,
    this.lineName,
    required this.destination,
    this.via,
    this.platform,
    required this.plannedTime,
    this.estimatedTime,
    required this.isCancelled,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.transportMode,
    this.occupancyLevel,
    this.nextStop,
    this.detailsReference,
    this.stopPointGid,
  });

  factory DepartureItem({
    required String serviceJourneyGid,
    required String lineDesignation,
    required String lineShortName,
    String? lineName,
    required String destination,
    String? via,
    String? platform,
    required DateTime plannedTime,
    DateTime? estimatedTime,
    required bool isCancelled,
    String? backgroundColor,
    String? foregroundColor,
    String? borderColor,
    String? transportMode,
    String? occupancyLevel,
    String? nextStop,
    String? detailsReference,
    String? stopPointGid,
  }) = _DepartureItemImpl;

  factory DepartureItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return DepartureItem(
      serviceJourneyGid: jsonSerialization['serviceJourneyGid'] as String,
      lineDesignation: jsonSerialization['lineDesignation'] as String,
      lineShortName: jsonSerialization['lineShortName'] as String,
      lineName: jsonSerialization['lineName'] as String?,
      destination: jsonSerialization['destination'] as String,
      via: jsonSerialization['via'] as String?,
      platform: jsonSerialization['platform'] as String?,
      plannedTime: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['plannedTime'],
      ),
      estimatedTime: jsonSerialization['estimatedTime'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['estimatedTime'],
            ),
      isCancelled: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['isCancelled'],
      ),
      backgroundColor: jsonSerialization['backgroundColor'] as String?,
      foregroundColor: jsonSerialization['foregroundColor'] as String?,
      borderColor: jsonSerialization['borderColor'] as String?,
      transportMode: jsonSerialization['transportMode'] as String?,
      occupancyLevel: jsonSerialization['occupancyLevel'] as String?,
      nextStop: jsonSerialization['nextStop'] as String?,
      detailsReference: jsonSerialization['detailsReference'] as String?,
      stopPointGid: jsonSerialization['stopPointGid'] as String?,
    );
  }

  String serviceJourneyGid;

  String lineDesignation;

  String lineShortName;

  String? lineName;

  String destination;

  String? via;

  String? platform;

  DateTime plannedTime;

  DateTime? estimatedTime;

  bool isCancelled;

  String? backgroundColor;

  String? foregroundColor;

  String? borderColor;

  String? transportMode;

  String? occupancyLevel;

  /// Name of the call after this one on the journey, known only once the
  /// journey details have been fetched. Null while that is pending, and for a
  /// journey that terminates at this stop.
  String? nextStop;

  /// Handle for the departure details endpoint, and the stop point the
  /// departure is observed at. Both come from the upstream departures entry and
  /// are what the timeline view passes back to fetch the journey's calls. Null
  /// when the upstream entry omitted them, in which case the row has no
  /// timeline to open.
  String? detailsReference;

  String? stopPointGid;

  /// Returns a shallow copy of this [DepartureItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DepartureItem copyWith({
    String? serviceJourneyGid,
    String? lineDesignation,
    String? lineShortName,
    String? lineName,
    String? destination,
    String? via,
    String? platform,
    DateTime? plannedTime,
    DateTime? estimatedTime,
    bool? isCancelled,
    String? backgroundColor,
    String? foregroundColor,
    String? borderColor,
    String? transportMode,
    String? occupancyLevel,
    String? nextStop,
    String? detailsReference,
    String? stopPointGid,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DepartureItem',
      'serviceJourneyGid': serviceJourneyGid,
      'lineDesignation': lineDesignation,
      'lineShortName': lineShortName,
      if (lineName != null) 'lineName': lineName,
      'destination': destination,
      if (via != null) 'via': via,
      if (platform != null) 'platform': platform,
      'plannedTime': plannedTime.toJson(),
      if (estimatedTime != null) 'estimatedTime': estimatedTime?.toJson(),
      'isCancelled': isCancelled,
      if (backgroundColor != null) 'backgroundColor': backgroundColor,
      if (foregroundColor != null) 'foregroundColor': foregroundColor,
      if (borderColor != null) 'borderColor': borderColor,
      if (transportMode != null) 'transportMode': transportMode,
      if (occupancyLevel != null) 'occupancyLevel': occupancyLevel,
      if (nextStop != null) 'nextStop': nextStop,
      if (detailsReference != null) 'detailsReference': detailsReference,
      if (stopPointGid != null) 'stopPointGid': stopPointGid,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DepartureItem',
      'serviceJourneyGid': serviceJourneyGid,
      'lineDesignation': lineDesignation,
      'lineShortName': lineShortName,
      if (lineName != null) 'lineName': lineName,
      'destination': destination,
      if (via != null) 'via': via,
      if (platform != null) 'platform': platform,
      'plannedTime': plannedTime.toJson(),
      if (estimatedTime != null) 'estimatedTime': estimatedTime?.toJson(),
      'isCancelled': isCancelled,
      if (backgroundColor != null) 'backgroundColor': backgroundColor,
      if (foregroundColor != null) 'foregroundColor': foregroundColor,
      if (borderColor != null) 'borderColor': borderColor,
      if (transportMode != null) 'transportMode': transportMode,
      if (occupancyLevel != null) 'occupancyLevel': occupancyLevel,
      if (nextStop != null) 'nextStop': nextStop,
      if (detailsReference != null) 'detailsReference': detailsReference,
      if (stopPointGid != null) 'stopPointGid': stopPointGid,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DepartureItemImpl extends DepartureItem {
  _DepartureItemImpl({
    required String serviceJourneyGid,
    required String lineDesignation,
    required String lineShortName,
    String? lineName,
    required String destination,
    String? via,
    String? platform,
    required DateTime plannedTime,
    DateTime? estimatedTime,
    required bool isCancelled,
    String? backgroundColor,
    String? foregroundColor,
    String? borderColor,
    String? transportMode,
    String? occupancyLevel,
    String? nextStop,
    String? detailsReference,
    String? stopPointGid,
  }) : super._(
         serviceJourneyGid: serviceJourneyGid,
         lineDesignation: lineDesignation,
         lineShortName: lineShortName,
         lineName: lineName,
         destination: destination,
         via: via,
         platform: platform,
         plannedTime: plannedTime,
         estimatedTime: estimatedTime,
         isCancelled: isCancelled,
         backgroundColor: backgroundColor,
         foregroundColor: foregroundColor,
         borderColor: borderColor,
         transportMode: transportMode,
         occupancyLevel: occupancyLevel,
         nextStop: nextStop,
         detailsReference: detailsReference,
         stopPointGid: stopPointGid,
       );

  /// Returns a shallow copy of this [DepartureItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DepartureItem copyWith({
    String? serviceJourneyGid,
    String? lineDesignation,
    String? lineShortName,
    Object? lineName = _Undefined,
    String? destination,
    Object? via = _Undefined,
    Object? platform = _Undefined,
    DateTime? plannedTime,
    Object? estimatedTime = _Undefined,
    bool? isCancelled,
    Object? backgroundColor = _Undefined,
    Object? foregroundColor = _Undefined,
    Object? borderColor = _Undefined,
    Object? transportMode = _Undefined,
    Object? occupancyLevel = _Undefined,
    Object? nextStop = _Undefined,
    Object? detailsReference = _Undefined,
    Object? stopPointGid = _Undefined,
  }) {
    return DepartureItem(
      serviceJourneyGid: serviceJourneyGid ?? this.serviceJourneyGid,
      lineDesignation: lineDesignation ?? this.lineDesignation,
      lineShortName: lineShortName ?? this.lineShortName,
      lineName: lineName is String? ? lineName : this.lineName,
      destination: destination ?? this.destination,
      via: via is String? ? via : this.via,
      platform: platform is String? ? platform : this.platform,
      plannedTime: plannedTime ?? this.plannedTime,
      estimatedTime: estimatedTime is DateTime?
          ? estimatedTime
          : this.estimatedTime,
      isCancelled: isCancelled ?? this.isCancelled,
      backgroundColor: backgroundColor is String?
          ? backgroundColor
          : this.backgroundColor,
      foregroundColor: foregroundColor is String?
          ? foregroundColor
          : this.foregroundColor,
      borderColor: borderColor is String? ? borderColor : this.borderColor,
      transportMode: transportMode is String?
          ? transportMode
          : this.transportMode,
      occupancyLevel: occupancyLevel is String?
          ? occupancyLevel
          : this.occupancyLevel,
      nextStop: nextStop is String? ? nextStop : this.nextStop,
      detailsReference: detailsReference is String?
          ? detailsReference
          : this.detailsReference,
      stopPointGid: stopPointGid is String? ? stopPointGid : this.stopPointGid,
    );
  }
}
