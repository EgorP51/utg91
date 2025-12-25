import 'package:flutter/material.dart';
import 'package:utg91/core/domain/models/mascot.dart';
import 'package:utg91/core/domain/services/distance_service.dart';
import 'package:utg91/features/explore/presentation/widgets/mascot_marker.dart';
import 'package:utg91/features/explore/presentation/widgets/mock_map_view.dart';

/// Main exploring view - shows map with user position and nearby mascots
class ExploringView extends StatelessWidget {
  final double userLat;
  final double userLng;
  final List<Mascot> allMascots;
  final List<MascotWithDistance> mascotsWithDistance;
  final MascotWithDistance? closestMascot;

  const ExploringView({
    super.key,
    required this.userLat,
    required this.userLng,
    required this.allMascots,
    required this.mascotsWithDistance,
    this.closestMascot,
  });

  @override
  Widget build(BuildContext context) {
    final undiscoveredMascots =
        mascotsWithDistance.where((m) => m.mascot.unlockDate == null).toList();

    return Stack(
      children: [
        // Map view with user position
        MockMapView(
          userLat: userLat,
          userLng: userLng,
        ),

        // Mascot markers (only undiscovered)
        ...undiscoveredMascots.map(
          (mascotWithDistance) => MascotMarker(
            mascot: mascotWithDistance.mascot,
            userLat: userLat,
            userLng: userLng,
          ),
        ),

        // User position marker (blue pulsing dot)
        Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.8, end: 1.0),
            duration: const Duration(seconds: 2),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.5),
                        blurRadius: 12,
                        spreadRadius: 4,
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

        // Bottom info card
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
                    'Exploring',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  if (closestMascot != null) ...[
                    Row(
                      children: [
                        Icon(
                          Icons.near_me,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Closest mascot: ${_formatDistance(closestMascot!.distance)}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                  Row(
                    children: [
                      Icon(
                        Icons.pets,
                        size: 16,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${undiscoveredMascots.length} mascots nearby',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  if (closestMascot != null &&
                      closestMascot!.distance > 100) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Keep moving to discover mascots!',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ],
              ),
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
