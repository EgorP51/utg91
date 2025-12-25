import 'package:flutter/material.dart';
import 'package:utg91/core/domain/models/mascot.dart';
import 'package:utg91/core/domain/services/distance_service.dart';
import 'package:utg91/core/presentation/theme/app_theme.dart';
import 'package:utg91/features/explore/presentation/widgets/mascot_marker.dart';
import 'package:utg91/features/explore/presentation/widgets/mock_map_view.dart';

/// View shown when a mascot is in range and can be discovered
/// Adds pulsing "Discover!" button and visual effects
class DiscoverableView extends StatelessWidget {
  final double userLat;
  final double userLng;
  final List<Mascot> allMascots;
  final List<MascotWithDistance> mascotsWithDistance;
  final MascotWithDistance discoverableMascot;
  final VoidCallback onDiscover;

  const DiscoverableView({
    super.key,
    required this.userLat,
    required this.userLng,
    required this.allMascots,
    required this.mascotsWithDistance,
    required this.discoverableMascot,
    required this.onDiscover,
  });

  @override
  Widget build(BuildContext context) {
    final rarityColor =
        AppTheme.getRarityColor(discoverableMascot.mascot.rarity.name);

    return Stack(
      children: [
        // Map view
        MockMapView(
          userLat: userLat,
          userLng: userLng,
        ),

        // Mascot markers
        ...mascotsWithDistance
            .where((m) => m.mascot.unlockDate == null)
            .map(
              (mascotWithDistance) => MascotMarker(
                mascot: mascotWithDistance.mascot,
                userLat: userLat,
                userLng: userLng,
              ),
            ),

        // User position marker with glow
        Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.9, end: 1.1),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: rarityColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: rarityColor.withOpacity(0.6),
                        blurRadius: 20,
                        spreadRadius: 6,
                      ),
                    ],
                  ),
                ),
              );
            },
            onEnd: () {
              // Loop animation
            },
          ),
        ),

        // Top banner - Mascot in range!
        Positioned(
          top: 24,
          left: 16,
          right: 16,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 500),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Card(
                  color: rarityColor.withOpacity(0.95),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Mascot in Range!',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Bottom card with mascot info
        Positioned(
          bottom: 100,
          left: 16,
          right: 16,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: rarityColor.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.pets,
                          color: rarityColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '??? Mascot',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_formatDistance(discoverableMascot.distance)} away',
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
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: rarityColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          discoverableMascot.mascot.rarity.displayName,
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // Pulsing Discover button
        Positioned(
          bottom: 24,
          left: 0,
          right: 0,
          child: Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 1.0, end: 1.1),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: FloatingActionButton.extended(
                    onPressed: onDiscover,
                    backgroundColor: rarityColor,
                    icon: const Icon(Icons.touch_app, color: Colors.white),
                    label: Text(
                      'Discover!',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                );
              },
              onEnd: () {
                // Loop animation
              },
            ),
          ),
        ),
      ],
    );
  }

  String _formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.round()} m';
    } else {
      return '${(meters / 1000).toStringAsFixed(1)} km';
    }
  }
}
