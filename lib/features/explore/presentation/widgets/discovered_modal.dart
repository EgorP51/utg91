import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:utg91/core/domain/models/mascot.dart';
import 'package:utg91/core/presentation/theme/app_theme.dart';

/// Modal shown after successful mascot discovery
class DiscoveredModal extends StatelessWidget {
  final Mascot mascot;
  final VoidCallback onClose;

  const DiscoveredModal({
    super.key,
    required this.mascot,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final rarityColor = AppTheme.getRarityColor(mascot.rarity.name);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              rarityColor.withOpacity(0.1),
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: rarityColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: rarityColor.withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 48,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              'Discovered!',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: rarityColor,
                  ),
            ),
            const SizedBox(height: 16),

            // Mascot icon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: rarityColor.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: rarityColor,
                  width: 3,
                ),
              ),
              child: Center(
                child: Text(
                  _getRarityEmoji(),
                  style: const TextStyle(fontSize: 56),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Mascot name
            Text(
              mascot.name,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),

            // Rarity badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: rarityColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                mascot.rarity.displayName,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 16),

            // Description
            Text(
              mascot.description,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 24),

            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onClose,
                    child: const Text('Continue Exploring'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.go('/collection');
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: rarityColor,
                    ),
                    child: const Text('View Collection'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getRarityEmoji() {
    switch (mascot.rarity) {
      case MascotRarity.common:
        return '⭐';
      case MascotRarity.rare:
        return '💎';
      case MascotRarity.epic:
        return '👑';
      case MascotRarity.legendary:
        return '🔥';
    }
  }
}
