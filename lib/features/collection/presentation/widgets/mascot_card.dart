import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:utg91/core/domain/models/mascot.dart';
import 'package:utg91/core/presentation/theme/app_theme.dart';

/// Card widget for displaying mascot in collection grid
/// Shows locked/unlocked state with visual indicators
class MascotCard extends StatelessWidget {
  final Mascot mascot;
  final bool isUnlocked;
  final bool canUnlock;
  final VoidCallback? onTap;

  const MascotCard({
    super.key,
    required this.mascot,
    required this.isUnlocked,
    this.canUnlock = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final rarityColor = AppTheme.getRarityColor(mascot.rarity.name);

    return GestureDetector(
      onTap: canUnlock ? onTap : null,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUnlocked
                ? rarityColor.withOpacity(0.5)
                : Theme.of(context).colorScheme.outline.withOpacity(0.2),
            width: 2,
          ),
          boxShadow: isUnlocked
              ? [
                  BoxShadow(
                    color: rarityColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            // Content
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Mascot icon/image
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: rarityColor.withOpacity(isUnlocked ? 0.2 : 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: isUnlocked
                        ? Text(
                            _getRarityEmoji(),
                            style: const TextStyle(fontSize: 48),
                          )
                        : Icon(
                            Icons.lock,
                            size: 40,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant
                                .withOpacity(0.5),
                          ),
                  ),
                ),
                const SizedBox(height: 12),

                // Name
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    isUnlocked ? mascot.name : '???',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 4),

                // Rarity badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: rarityColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    mascot.rarity.displayName,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),

            // Blur overlay for locked mascots
            if (!isUnlocked)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(
                    color: Colors.black.withOpacity(0.1),
                  ),
                ),
              ),

            // Unlock indicator
            if (canUnlock && !isUnlocked)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_open,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),

            // Unlocked indicator
            if (isUnlocked)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: rarityColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
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
