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
import 'package:open_transport_map_server/src/generated/future_calls.dart'
    as _ibcnyg44;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import '../auth/email_idp_endpoint.dart' as _iuc1hd5t;
import '../auth/jwt_refresh_endpoint.dart' as _inwq3ztq;
import '../transit/transit_endpoint.dart' as _i86mganb;
import '../vehicles/vehicle_positions_endpoint.dart' as _irb6r25j;
export 'future_calls.dart' show ServerpodFutureCallsGetter;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'emailIdp': _iuc1hd5t.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'jwtRefresh': _inwq3ztq.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'transit': _i86mganb.TransitEndpoint()
        ..initialize(
          server,
          'transit',
          null,
        ),
      'vehiclePositions': _irb6r25j.VehiclePositionsEndpoint()
        ..initialize(
          server,
          'vehiclePositions',
          null,
        ),
    };
    connectors['emailIdp'] = _is.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'login': _is.MethodConnector(
          name: 'login',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint).login(
                    session,
                    email: params['email'],
                    password: params['password'],
                  ),
        ),
        'startRegistration': _is.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyRegistrationCode': _is.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _is.ParameterDescription(
              name: 'accountRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _is.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _is.ParameterDescription(
              name: 'registrationToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _is.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _is.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _is.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _is.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _is.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'newPassword': _is.ParameterDescription(
              name: 'newPassword',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
        'hasAccount': _is.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['jwtRefresh'] = _is.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _is.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _is.ParameterDescription(
              name: 'refreshToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['jwtRefresh'] as _inwq3ztq.JwtRefreshEndpoint)
                      .refreshAccessToken(
                        session,
                        refreshToken: params['refreshToken'],
                      ),
        ),
      },
    );
    connectors['transit'] = _is.EndpointConnector(
      name: 'transit',
      endpoint: endpoints['transit']!,
      methodConnectors: {
        'getStopAreasInBounds': _is.MethodConnector(
          name: 'getStopAreasInBounds',
          params: {
            'north': _is.ParameterDescription(
              name: 'north',
              type: _is.getType<double>(),
              nullable: false,
            ),
            'south': _is.ParameterDescription(
              name: 'south',
              type: _is.getType<double>(),
              nullable: false,
            ),
            'east': _is.ParameterDescription(
              name: 'east',
              type: _is.getType<double>(),
              nullable: false,
            ),
            'west': _is.ParameterDescription(
              name: 'west',
              type: _is.getType<double>(),
              nullable: false,
            ),
            'agencyExternalId': _is.ParameterDescription(
              name: 'agencyExternalId',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['transit'] as _i86mganb.TransitEndpoint)
                  .getStopAreasInBounds(
                    session,
                    north: params['north'],
                    south: params['south'],
                    east: params['east'],
                    west: params['west'],
                    agencyExternalId: params['agencyExternalId'],
                  ),
        ),
        'searchStopAreas': _is.MethodConnector(
          name: 'searchStopAreas',
          params: {
            'query': _is.ParameterDescription(
              name: 'query',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'agencyExternalId': _is.ParameterDescription(
              name: 'agencyExternalId',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['transit'] as _i86mganb.TransitEndpoint)
                  .searchStopAreas(
                    session,
                    query: params['query'],
                    limit: params['limit'],
                    agencyExternalId: params['agencyExternalId'],
                  ),
        ),
        'listStopAreas': _is.MethodConnector(
          name: 'listStopAreas',
          params: {
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'offset': _is.ParameterDescription(
              name: 'offset',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'agencyExternalId': _is.ParameterDescription(
              name: 'agencyExternalId',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['transit'] as _i86mganb.TransitEndpoint)
                  .listStopAreas(
                    session,
                    limit: params['limit'],
                    offset: params['offset'],
                    agencyExternalId: params['agencyExternalId'],
                  ),
        ),
        'getStopPointsInBounds': _is.MethodConnector(
          name: 'getStopPointsInBounds',
          params: {
            'north': _is.ParameterDescription(
              name: 'north',
              type: _is.getType<double>(),
              nullable: false,
            ),
            'south': _is.ParameterDescription(
              name: 'south',
              type: _is.getType<double>(),
              nullable: false,
            ),
            'east': _is.ParameterDescription(
              name: 'east',
              type: _is.getType<double>(),
              nullable: false,
            ),
            'west': _is.ParameterDescription(
              name: 'west',
              type: _is.getType<double>(),
              nullable: false,
            ),
            'agencyExternalId': _is.ParameterDescription(
              name: 'agencyExternalId',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['transit'] as _i86mganb.TransitEndpoint)
                  .getStopPointsInBounds(
                    session,
                    north: params['north'],
                    south: params['south'],
                    east: params['east'],
                    west: params['west'],
                    agencyExternalId: params['agencyExternalId'],
                  ),
        ),
        'getRouteShapesInBounds': _is.MethodConnector(
          name: 'getRouteShapesInBounds',
          params: {
            'north': _is.ParameterDescription(
              name: 'north',
              type: _is.getType<double>(),
              nullable: false,
            ),
            'south': _is.ParameterDescription(
              name: 'south',
              type: _is.getType<double>(),
              nullable: false,
            ),
            'east': _is.ParameterDescription(
              name: 'east',
              type: _is.getType<double>(),
              nullable: false,
            ),
            'west': _is.ParameterDescription(
              name: 'west',
              type: _is.getType<double>(),
              nullable: false,
            ),
            'agencyExternalId': _is.ParameterDescription(
              name: 'agencyExternalId',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['transit'] as _i86mganb.TransitEndpoint)
                  .getRouteShapesInBounds(
                    session,
                    north: params['north'],
                    south: params['south'],
                    east: params['east'],
                    west: params['west'],
                    agencyExternalId: params['agencyExternalId'],
                  ),
        ),
        'getServiceJourneyCalls': _is.MethodConnector(
          name: 'getServiceJourneyCalls',
          params: {
            'stopPointGid': _is.ParameterDescription(
              name: 'stopPointGid',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'detailsReference': _is.ParameterDescription(
              name: 'detailsReference',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'agencyExternalId': _is.ParameterDescription(
              name: 'agencyExternalId',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['transit'] as _i86mganb.TransitEndpoint)
                  .getServiceJourneyCalls(
                    session,
                    stopPointGid: params['stopPointGid'],
                    detailsReference: params['detailsReference'],
                    agencyExternalId: params['agencyExternalId'],
                  ),
        ),
        'getZones': _is.MethodConnector(
          name: 'getZones',
          params: {
            'agencyExternalId': _is.ParameterDescription(
              name: 'agencyExternalId',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['transit'] as _i86mganb.TransitEndpoint).getZones(
                    session,
                    agencyExternalId: params['agencyExternalId'],
                  ),
        ),
        'triggerSync': _is.MethodConnector(
          name: 'triggerSync',
          params: {
            'agencyExternalId': _is.ParameterDescription(
              name: 'agencyExternalId',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['transit'] as _i86mganb.TransitEndpoint)
                  .triggerSync(
                    session,
                    agencyExternalId: params['agencyExternalId'],
                  ),
        ),
        'watchStopDepartures': _is.MethodStreamConnector(
          name: 'watchStopDepartures',
          params: {
            'gid': _is.ParameterDescription(
              name: 'gid',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'isStopArea': _is.ParameterDescription(
              name: 'isStopArea',
              type: _is.getType<bool>(),
              nullable: false,
            ),
            'agencyExternalId': _is.ParameterDescription(
              name: 'agencyExternalId',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['transit'] as _i86mganb.TransitEndpoint)
                  .watchStopDepartures(
                    session,
                    gid: params['gid'],
                    isStopArea: params['isStopArea'],
                    agencyExternalId: params['agencyExternalId'],
                  ),
        ),
      },
    );
    connectors['vehiclePositions'] = _is.EndpointConnector(
      name: 'vehiclePositions',
      endpoint: endpoints['vehiclePositions']!,
      methodConnectors: {
        'watchVehicles': _is.MethodStreamConnector(
          name: 'watchVehicles',
          params: {
            'north': _is.ParameterDescription(
              name: 'north',
              type: _is.getType<double>(),
              nullable: false,
            ),
            'south': _is.ParameterDescription(
              name: 'south',
              type: _is.getType<double>(),
              nullable: false,
            ),
            'east': _is.ParameterDescription(
              name: 'east',
              type: _is.getType<double>(),
              nullable: false,
            ),
            'west': _is.ParameterDescription(
              name: 'west',
              type: _is.getType<double>(),
              nullable: false,
            ),
            'agencyExternalId': _is.ParameterDescription(
              name: 'agencyExternalId',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['vehiclePositions']
                          as _irb6r25j.VehiclePositionsEndpoint)
                      .watchVehicles(
                        session,
                        north: params['north'],
                        south: params['south'],
                        east: params['east'],
                        west: params['west'],
                        agencyExternalId: params['agencyExternalId'],
                      ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _iais.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _iacs.Endpoints()
      ..initializeEndpoints(server);
  }

  @override
  _is.FutureCallDispatch? get futureCalls {
    return _ibcnyg44.FutureCalls();
  }
}
