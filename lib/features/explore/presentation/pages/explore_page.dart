import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utg91/core/di/injection_container.dart';
import 'package:utg91/features/explore/presentation/cubit/explore_cubit.dart';
import 'package:utg91/features/explore/presentation/cubit/explore_state.dart';
import 'package:utg91/features/explore/presentation/widgets/discovered_modal.dart';
import 'package:utg91/features/explore/presentation/widgets/discoverable_view.dart';
import 'package:utg91/features/explore/presentation/widgets/discovering_animation.dart';
import 'package:utg91/features/explore/presentation/widgets/explore_error_widget.dart';
import 'package:utg91/features/explore/presentation/widgets/exploring_view.dart';
import 'package:utg91/features/explore/presentation/widgets/location_disabled_widget.dart';
import 'package:utg91/features/explore/presentation/widgets/permission_denied_widget.dart';

/// Map Explore page - Tab 1
/// Real GPS-based exploration with distance-based discovery
class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ExploreCubit>()..initialize(),
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
      body: BlocConsumer<ExploreCubit, ExploreState>(
        listener: (context, state) {
          // Show modal on successful discovery
          state.maybeWhen(
            discovered: (mascot, lat, lng) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => DiscoveredModal(
                  mascot: mascot,
                  onClose: () => Navigator.pop(context),
                ),
              );
            },
            orElse: () {},
          );
        },
        builder: (context, state) {
          return state.when(
            initial: () => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.explore,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Ready to Explore',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => context.read<ExploreCubit>().initialize(),
                    icon: const Icon(Icons.my_location),
                    label: const Text('Start Exploring'),
                  ),
                ],
              ),
            ),
            loadingLocation: () => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 24),
                  Text(
                    'Getting your location...',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            permissionDenied: (message, isPermanent) => PermissionDeniedWidget(
              message: message,
              isPermanent: isPermanent,
            ),
            locationServiceDisabled: () => const LocationDisabledWidget(),
            exploring: (lat, lng, mascots, distances, closest, inRange) =>
                ExploringView(
              userLat: lat,
              userLng: lng,
              allMascots: mascots,
              mascotsWithDistance: distances,
              closestMascot: closest,
            ),
            mascotDiscoverable: (lat, lng, mascots, distances, discoverable) =>
                DiscoverableView(
              userLat: lat,
              userLng: lng,
              allMascots: mascots,
              mascotsWithDistance: distances,
              discoverableMascot: discoverable,
              onDiscover: () => context
                  .read<ExploreCubit>()
                  .discoverMascot(discoverable.mascot.id),
            ),
            discovering: (mascot) => DiscoveringAnimation(mascot: mascot),
            discovered: (mascot, lat, lng) => ExploringView(
              userLat: lat,
              userLng: lng,
              allMascots: const [],
              mascotsWithDistance: const [],
              closestMascot: null,
            ),
            error: (message) => ExploreErrorWidget(
              message: message,
              onRetry: () => context.read<ExploreCubit>().refresh(),
            ),
          );
        },
      ),
    );
  }
}
