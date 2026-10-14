import 'package:flutter/material.dart';

import 'client.dart';
import 'screens/vehicle_map_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeClient();
  runApp(const MyApp());
}

/// Builds a theme for the given [brightness].
ThemeData _buildTheme(Brightness brightness) {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: brightness,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Open Transport Map',
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // The map fills the screen; there is no app bar, so the map overlays handle
    // their own safe area.
    //
    // To test authentication in this example app, replace the body with
    // `SignInScreen(child: VehicleMapScreen())`. This wraps the map screen with
    // a SignInScreen, which automatically shows a sign-in UI when the user is
    // not authenticated.
    return const Scaffold(body: VehicleMapScreen());
  }
}
