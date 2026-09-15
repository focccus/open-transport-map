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
      home: const MyHomePage(title: 'Vehicle positions'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      // To test authentication in this example app, uncomment the block below
      // and remove the line above. This wraps the VehicleMapScreen with a
      // SignInScreen, which automatically shows a sign-in UI when the user is
      // not authenticated.
      //
      // body: SignInScreen(
      //   child: const VehicleMapScreen(),
      // ),
      body: const VehicleMapScreen(),
    );
  }
}
