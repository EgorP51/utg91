import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:utg91/core/presentation/widgets/app_shell.dart';
import 'package:utg91/features/collection/presentation/pages/collection_page.dart';
import 'package:utg91/features/explore/presentation/pages/explore_page.dart';
import 'package:utg91/features/profile/presentation/pages/profile_page.dart';
import 'package:utg91/features/social/presentation/pages/social_page.dart';

/// Centralized routing configuration using go_router
/// Supports deep linking, nested navigation, and URL parameters
class AppRouter {
  AppRouter._();

  /// Route paths as constants for type safety
  static const String explore = '/explore';
  static const String collection = '/collection';
  static const String social = '/social';
  static const String profile = '/profile';

  /// Main router configuration
  /// Uses StatefulShellRoute for persistent bottom navigation
  static final GoRouter router = GoRouter(
    initialLocation: explore,
    debugLogDiagnostics: true,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          // AppShell wraps all routes with bottom navigation
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          // Tab 1: Map Explore
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: explore,
                name: 'explore',
                pageBuilder: (context, state) => _buildPageTransition(
                  context: context,
                  state: state,
                  child: const ExplorePage(),
                ),
                // Future nested routes for explore feature
                // routes: [
                //   GoRoute(
                //     path: 'mascot/:id',
                //     name: 'mascot-detail',
                //     builder: (context, state) => MascotDetailPage(
                //       mascotId: state.pathParameters['id']!,
                //     ),
                //   ),
                // ],
              ),
            ],
          ),

          // Tab 2: Mascots Collection
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: collection,
                name: 'collection',
                pageBuilder: (context, state) => _buildPageTransition(
                  context: context,
                  state: state,
                  child: const CollectionPage(),
                ),
              ),
            ],
          ),

          // Tab 3: Social (placeholder)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: social,
                name: 'social',
                pageBuilder: (context, state) => _buildPageTransition(
                  context: context,
                  state: state,
                  child: const SocialPage(),
                ),
              ),
            ],
          ),

          // Tab 4: Profile (placeholder)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: profile,
                name: 'profile',
                pageBuilder: (context, state) => _buildPageTransition(
                  context: context,
                  state: state,
                  child: const ProfilePage(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Route not found: ${state.uri}'),
      ),
    ),
  );

  /// Custom page transition for iOS-style navigation
  static Page<dynamic> _buildPageTransition({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Fade transition for tab switches
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}
