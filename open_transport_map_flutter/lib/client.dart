import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:open_transport_map_client/open_transport_map_client.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

import 'stop_search_store.dart';

// When you are running the app on a physical device, you need to set the
// server URL to the IP address of your computer. You can find the IP
// address by running `ipconfig` on Windows or `ifconfig` on Mac/Linux.
//
// You can set the variable when running or building your app like this:
// E.g. `flutter run --dart-define=SERVER_URL=https://api.example.com/`.
//
// Otherwise, the server URL is fetched from the assets/config.json file or
// defaults to http://$localhost:8080/ if not found.
final serverUrl = getServerUrl();

/// Sets up a global client object that can be used to talk to the server from
/// anywhere in our app. The client is generated from your server code
/// and is set up to connect to a Serverpod running on a local server on
/// the default port. You will need to modify this to connect to staging or
/// production servers.
/// In a larger app, you may want to use the dependency injection of your choice
/// instead of using a global client object. This is just a simple example.
late final Client client;

/// Local SQLite session holding the stop cache and the recent searches. The
/// cache mirrors the server; the recent searches never leave the device. Null
/// when the local database cannot be opened (e.g. on the web build), in which
/// case search runs against the server and recent searches are not kept.
ClientDatabaseSession? dbSession;

/// Local stop search, backed by [dbSession].
late final StopSearchStore stopSearchStore;

Future<void> initializeClient() async {
  client = Client(await serverUrl)
    ..connectivityMonitor = FlutterConnectivityMonitor()
    ..authSessionManager = FlutterAuthSessionManager();
  unawaited(client.auth.initialize());
  dbSession = await _openDatabase();
  stopSearchStore = StopSearchStore(client: client, session: dbSession);
  // Kick off the stop cache refresh in the background; search falls back to the
  // server until it finishes.
  unawaited(_syncStopCache());
}

/// Opens the local database, or returns null when it is unavailable so the app
/// still runs against the server.
Future<ClientDatabaseSession?> _openDatabase() async {
  try {
    return await client.createSession(
      await _databaseFilePath(),
      isDebugMode: kDebugMode,
    );
  } catch (e) {
    debugPrint('Local stop database unavailable, using the server: $e');
    return null;
  }
}

Future<void> _syncStopCache() async {
  try {
    await stopSearchStore.sync();
  } catch (e) {
    // Offline, or the server is unreachable: the cache keeps what it has.
    debugPrint('Stop cache sync failed: $e');
  }
}

Future<String> _databaseFilePath() async {
  const fileName = 'open_transport_map.db';
  // The web build keeps the database in the browser's own storage.
  if (kIsWeb) return fileName;
  final dir = await getApplicationSupportDirectory();
  return p.join(dir.path, fileName);
}
