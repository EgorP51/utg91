import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:utg91/core/di/injection_container.dart';
import 'package:utg91/core/presentation/theme/app_theme.dart';
import 'package:utg91/core/router/app_router.dart';

/// Application entry point
/// Initializes dependencies and launches the app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await initializeDependencies();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const UTG91App());
}

/// Root application widget
/// Provides routing, theming, and global configuration
class UTG91App extends StatelessWidget {
  const UTG91App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'UTG91',
      debugShowCheckedModeBanner: false,

      // Theme configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      // Routing configuration
      routerConfig: AppRouter.router,
    );
  }
}
