import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// Widget shown when location permission is denied
/// Provides guidance and button to open settings
class PermissionDeniedWidget extends StatelessWidget {
  final String message;
  final bool isPermanent;

  const PermissionDeniedWidget({
    super.key,
    required this.message,
    required this.isPermanent,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              size: 80,
              color: Theme.of(context).colorScheme.error.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'Location Permission Required',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              isPermanent
                  ? 'Location permission is permanently denied. Please enable it in Settings to discover mascots.'
                  : 'We need your location to help you discover mascots nearby.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            if (isPermanent)
              FilledButton.icon(
                onPressed: () => openAppSettings(),
                icon: const Icon(Icons.settings),
                label: const Text('Open Settings'),
              )
            else
              FilledButton.icon(
                onPressed: () {
                  // User can retry by refreshing
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
          ],
        ),
      ),
    );
  }
}
