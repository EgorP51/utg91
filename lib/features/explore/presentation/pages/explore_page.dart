import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utg91/core/di/injection_container.dart';
import 'package:utg91/features/explore/presentation/cubit/explore_cubit.dart';
import 'package:utg91/features/explore/presentation/cubit/explore_state.dart';
import 'package:utg91/features/explore/presentation/widgets/mascot_marker.dart';
import 'package:utg91/features/explore/presentation/widgets/mock_map_view.dart';

/// Map Explore page - Tab 1
/// Displays nearby mascots on a map view
/// Architecture allows future GPS integration and real map SDKs
class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ExploreCubit>()..loadNearbyMascots(),
      child: const _ExploreView(),
    );
  }
}

class _ExploreView extends StatelessWidget {
  const _ExploreView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<ExploreCubit>().refresh(),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: BlocBuilder<ExploreCubit, ExploreState>(
        builder: (context, state) {
          return state.when(
            initial: () => const Center(
              child: Text('Initializing map...'),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            loaded: (mascots, userLat, userLng) => Stack(
              children: [
                // Mock map view (replace with real map SDK in production)
                MockMapView(
                  userLat: userLat,
                  userLng: userLng,
                ),

                // Mascot markers overlay
                ...mascots.map(
                  (mascot) => MascotMarker(
                    mascot: mascot,
                    userLat: userLat,
                    userLng: userLng,
                  ),
                ),

                // Info card at bottom
                Positioned(
                  bottom: 24,
                  left: 16,
                  right: 16,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nearby Mascots',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${mascots.length} mascots in your area',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Move around to discover more!',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            error: (message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading mascots',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.read<ExploreCubit>().refresh(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
