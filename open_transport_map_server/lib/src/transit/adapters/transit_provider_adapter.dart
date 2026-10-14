import 'dart:async';

import '../../generated/protocol.dart';

class AgencyDto {
  final String externalId;
  final String name;
  final String timezone;
  final String countryCode;
  final String city;

  const AgencyDto({
    required this.externalId,
    required this.name,
    this.timezone = 'Europe/Stockholm',
    this.countryCode = 'SE',
    required this.city,
  });
}

class ZoneDto {
  final String externalId;
  final String name;
  final String? color;
  final String? geometryGeoJson;

  const ZoneDto({
    required this.externalId,
    required this.name,
    this.color,
    this.geometryGeoJson,
  });
}

class StopAreaDto {
  final String externalId;
  final String name;
  final double latitude;
  final double longitude;
  final String? municipality;
  final String? tariffZoneExternalId;

  const StopAreaDto({
    required this.externalId,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.municipality,
    this.tariffZoneExternalId,
  });
}

class StopPointDto {
  final String externalId;
  final String stopAreaExternalId;
  final String name;
  final String? platform;
  final double latitude;
  final double longitude;
  final String? designation;

  const StopPointDto({
    required this.externalId,
    required this.stopAreaExternalId,
    required this.name,
    this.platform,
    required this.latitude,
    required this.longitude,
    this.designation,
  });
}

class RouteDto {
  final String externalId;
  final String shortName;
  final String? longName;
  final String transportMode;
  final String? backgroundColor;
  final String? foregroundColor;
  final String? borderColor;

  const RouteDto({
    required this.externalId,
    required this.shortName,
    this.longName,
    required this.transportMode,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
  });
}

class RouteShapeDto {
  final String routeExternalId;
  final int? directionId;
  final String? headsign;
  final String geometryGeoJson;
  final List<String> orderedStopPointExternalIds;

  const RouteShapeDto({
    required this.routeExternalId,
    this.directionId,
    this.headsign,
    required this.geometryGeoJson,
    this.orderedStopPointExternalIds = const [],
  });
}

abstract class TransitProviderAdapter {
  String get agencyExternalId;

  Future<AgencyDto> fetchAgency();
  Future<List<ZoneDto>> fetchZones();
  Future<List<StopAreaDto>> fetchStopAreas();
  Future<List<StopPointDto>> fetchStopPoints();
  Future<List<RouteDto>> fetchRoutes();
  Future<List<RouteShapeDto>> fetchRouteShapes(String routeExternalId);

  /// The provider's whole-service-area vehicle feed. Callers share one of
  /// these through `VehicleFeedHub` and scope it per client viewport there.
  Stream<VehicleDelta> watchVehicles();
}
