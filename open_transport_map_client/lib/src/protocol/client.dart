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
import 'dart:async' as _ida;
import 'package:http/http.dart' as _i85jenna;
import 'package:open_transport_map_client/src/protocol/transit/service_journey_call.dart'
    as _ilj1lx3c;
import 'package:open_transport_map_client/src/protocol/transit/stop_departures_response.dart'
    as _itokrwqi;
import 'package:open_transport_map_client/src/protocol/transit/transit_route_shape.dart'
    as _i6gu4vwk;
import 'package:open_transport_map_client/src/protocol/transit/transit_stop_area.dart'
    as _isa4rit7;
import 'package:open_transport_map_client/src/protocol/transit/transit_stop_point.dart'
    as _iemyo4bi;
import 'package:open_transport_map_client/src/protocol/transit/transit_zone.dart'
    as _i453y01z;
import 'package:open_transport_map_client/src/protocol/vehicles/vehicle_delta.dart'
    as _i1xa9spw;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_database/serverpod_database.dart' as _isd;
import 'protocol.dart' as _il2as5qe;
import 'package:open_transport_map_client/migrations/migration_registry.dart';

/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
/// {@category Endpoint}
class EndpointEmailIdp extends _iaic.EndpointEmailIdpBase {
  EndpointEmailIdp(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<_iacc.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _ida.Future<_isc.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _ida.Future<String> verifyRegistrationCode({
    required _isc.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _ida.Future<_iacc.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _ida.Future<_isc.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _ida.Future<String> verifyPasswordResetCode({
    required _isc.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );

  @override
  _ida.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'emailIdp',
    'hasAccount',
    {},
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _iacc.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// If [refreshToken] is omitted, cookie-mode web clients fall back to the
  /// configured HttpOnly refresh cookie. When neither source is present this
  /// throws [RefreshTokenNotFoundException], the same public "no usable refresh
  /// credential" exception used for unknown refresh tokens.
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _ida.Future<_iacc.AuthSuccess> refreshAccessToken({String? refreshToken}) =>
      caller.callServerEndpoint<_iacc.AuthSuccess>(
        'jwtRefresh',
        'refreshAccessToken',
        {'refreshToken': refreshToken},
        authenticated: false,
      );
}

/// {@category Endpoint}
class EndpointTransit extends _isc.EndpointRef {
  EndpointTransit(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'transit';

  /// Fetches station hubs / interchange complexes within the bounding box.
  /// Intended for low and medium map zoom levels (< 13.5).
  _ida.Future<List<_isa4rit7.TransitStopArea>> getStopAreasInBounds({
    required double north,
    required double south,
    required double east,
    required double west,
    String? agencyExternalId,
  }) => caller.callServerEndpoint<List<_isa4rit7.TransitStopArea>>(
    'transit',
    'getStopAreasInBounds',
    {
      'north': north,
      'south': south,
      'east': east,
      'west': west,
      'agencyExternalId': agencyExternalId,
    },
  );

  /// Searches stop areas by name in the local database.
  ///
  /// Matches case-insensitively, prioritizing prefix matches over substring matches.
  _ida.Future<List<_isa4rit7.TransitStopArea>> searchStopAreas({
    required String query,
    int? limit,
    String? agencyExternalId,
  }) => caller.callServerEndpoint<List<_isa4rit7.TransitStopArea>>(
    'transit',
    'searchStopAreas',
    {
      'query': query,
      'limit': limit,
      'agencyExternalId': agencyExternalId,
    },
  );

  /// Every stop area, ordered by id, for the client's local stop cache. Paged
  /// so the client pulls the list in batches instead of one large response.
  ///
  /// Stops change rarely, so the client re-syncs on this rather than on every
  /// search.
  _ida.Future<List<_isa4rit7.TransitStopArea>> listStopAreas({
    required int limit,
    required int offset,
    String? agencyExternalId,
  }) => caller.callServerEndpoint<List<_isa4rit7.TransitStopArea>>(
    'transit',
    'listStopAreas',
    {
      'limit': limit,
      'offset': offset,
      'agencyExternalId': agencyExternalId,
    },
  );

  /// Fetches physical boarding platforms / quays within the bounding box.
  /// Intended for street-level map zoom levels (>= 13.5).
  _ida.Future<List<_iemyo4bi.TransitStopPoint>> getStopPointsInBounds({
    required double north,
    required double south,
    required double east,
    required double west,
    String? agencyExternalId,
  }) => caller.callServerEndpoint<List<_iemyo4bi.TransitStopPoint>>(
    'transit',
    'getStopPointsInBounds',
    {
      'north': north,
      'south': south,
      'east': east,
      'west': west,
      'agencyExternalId': agencyExternalId,
    },
  );

  /// Fetches route alignment shapes (GeoJSON LineStrings).
  _ida.Future<List<_i6gu4vwk.TransitRouteShape>> getRouteShapesInBounds({
    required double north,
    required double south,
    required double east,
    required double west,
    String? agencyExternalId,
  }) => caller.callServerEndpoint<List<_i6gu4vwk.TransitRouteShape>>(
    'transit',
    'getRouteShapesInBounds',
    {
      'north': north,
      'south': south,
      'east': east,
      'west': west,
      'agencyExternalId': agencyExternalId,
    },
  );

  /// Departures at a stop area or stop point, fetched on demand, together with
  /// the GeoJSON of the routes serving it. Routes are cached in the database
  /// the first time they are seen and reused until they expire.
  ///
  /// Pass [isStopArea] true to query `/stop-areas/{gid}/departures`, false to
  /// query `/stop-points/{gid}/departures`.
  ///
  /// Two states are streamed: the departures (with any already-cached route
  /// shapes) first, then the full route GeoJSON once the remaining detail
  /// calls finish. The client renders the list without waiting for routes.
  ///
  /// Streaming also lets the server run the detail calls concurrently instead
  /// of blocking a single response on all of them.
  _ida.Stream<_itokrwqi.StopDeparturesResponse> watchStopDepartures({
    required String gid,
    required bool isStopArea,
    String? agencyExternalId,
  }) =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<_itokrwqi.StopDeparturesResponse>,
        _itokrwqi.StopDeparturesResponse
      >(
        'transit',
        'watchStopDepartures',
        {
          'gid': gid,
          'isStopArea': isStopArea,
          'agencyExternalId': agencyExternalId,
        },
        {},
      );

  /// Ordered calls of the journey behind one departure, for the timeline view.
  ///
  /// [stopPointGid] and [detailsReference] are the handles carried by the
  /// `DepartureItem` the user tapped. Returns an empty list when the journey
  /// cannot be read.
  _ida.Future<List<_ilj1lx3c.ServiceJourneyCall>> getServiceJourneyCalls({
    required String stopPointGid,
    required String detailsReference,
    String? agencyExternalId,
  }) => caller.callServerEndpoint<List<_ilj1lx3c.ServiceJourneyCall>>(
    'transit',
    'getServiceJourneyCalls',
    {
      'stopPointGid': stopPointGid,
      'detailsReference': detailsReference,
      'agencyExternalId': agencyExternalId,
    },
  );

  /// Fetches tariff / fare boundary zones with polygon boundaries.
  _ida.Future<List<_i453y01z.TransitZone>> getZones({
    String? agencyExternalId,
  }) => caller.callServerEndpoint<List<_i453y01z.TransitZone>>(
    'transit',
    'getZones',
    {'agencyExternalId': agencyExternalId},
  );

  /// Manually triggers transit infrastructure synchronization.
  _ida.Future<bool> triggerSync({String? agencyExternalId}) =>
      caller.callServerEndpoint<bool>(
        'transit',
        'triggerSync',
        {'agencyExternalId': agencyExternalId},
      );
}

/// Streams vehicle positions to clients as a [Stream] of [VehicleDelta].
///
/// The stream is viewport-scoped: the client passes its bounds, and
/// [VehicleFeedHub] forwards only the vehicles inside them, from one upstream
/// feed shared with every other client.
/// {@category Endpoint}
class EndpointVehiclePositions extends _isc.EndpointRef {
  EndpointVehiclePositions(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'vehiclePositions';

  _ida.Stream<_i1xa9spw.VehicleDelta> watchVehicles({
    required double north,
    required double south,
    required double east,
    required double west,
    String? agencyExternalId,
  }) =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<_i1xa9spw.VehicleDelta>,
        _i1xa9spw.VehicleDelta
      >(
        'vehiclePositions',
        'watchVehicles',
        {
          'north': north,
          'south': south,
          'east': east,
          'west': west,
          'agencyExternalId': agencyExternalId,
        },
        {},
      );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _iaic.Caller(client);
    serverpod_auth_core = _iacc.Caller(client);
  }

  late final _iaic.Caller serverpod_auth_idp;

  late final _iacc.Caller serverpod_auth_core;
}

class Client extends _isc.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _isc.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_isc.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i85jenna.Client? httpClientOverride,
  }) : super(
         host,
         _il2as5qe.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
         httpClientOverride: httpClientOverride,
       ) {
    emailIdp = EndpointEmailIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    transit = EndpointTransit(this);
    vehiclePositions = EndpointVehiclePositions(this);
    modules = Modules(this);
  }

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointTransit transit;

  late final EndpointVehiclePositions vehiclePositions;

  late final Modules modules;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'transit': transit,
    'vehiclePositions': vehiclePositions,
  };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };

  /// Creates a new client-side database session for the given path.
  ///
  /// The [path] is the file path to the SQLite database file. Since SQLite uses
  /// WAL mode, note that `[path]-shm` and `[path]-wal` files might also exist
  /// transiently for the database while the session is open.
  ///
  /// If [runMigrations] is true, pending migrations will be applied when
  /// opening the database. Be careful when setting this to false, as it might
  /// lead to inconsistencies between the models and the database.
  ///
  /// If [isDebugMode] is true, the database integrity will be verified after
  /// the migrations are applied to provide feedback of possible issues. On a
  /// Flutter application, this should be set to [kDebugMode].
  _ida.Future<_isd.ClientDatabaseSession> createSession(
    String path, {
    bool runMigrations = true,
    bool isDebugMode = false,
  }) async {
    return await _isd.ClientDatabaseSession.open(
      path,
      _il2as5qe.Protocol(),
      clientMigrations: MigrationRegistry.migrations,
      runMigrations: runMigrations,
      isDebugMode: isDebugMode,
    );
  }
}
