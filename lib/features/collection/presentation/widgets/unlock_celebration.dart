import 'package:flutter/material.dart';
import 'package:utg91/core/domain/models/mascot.dart';
import 'package:utg91/core/presentation/theme/app_theme.dart';

/// Celebration animation when mascot is unlocked
/// Shows reveal animation with confetti-like effect
class UnlockCelebration extends StatefulWidget {
  final Mascot mascot;

  const UnlockCelebration({
    super.key,
    required this.mascot,
  });

  @override
  State<UnlockCelebration> createState() => _UnlockCelebrationState();
}

class _UnlockCelebrationState extends State<UnlockCelebration>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _controller.forward();

    // Auto-close after animation
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rarityColor = AppTheme.getRarityColor(widget.mascot.rarity.name);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: rarityColor.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Celebration icon
                    Text(
                      '🎉',
                      style: TextStyle(
                        fontSize: 80,
                        shadows: [
                          Shadow(
                            color: rarityColor.withOpacity(0.5),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // "Unlocked!" text
                    Text(
                      'Unlocked!',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: rarityColor,
                          ),
                    ),
                    const SizedBox(height: 24),

                    // Mascot icon
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: rarityColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: rarityColor,
                          width: 4,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _getRarityEmoji(),
                          style: const TextStyle(fontSize: 64),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Mascot name
                    Text(
                      widget.mascot.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),

                    // Rarity badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: rarityColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        widget.mascot.rarity.displayName,
                        style:
                            Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Description
                    Text(
                      widget.mascot.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getRarityEmoji() {
    switch (widget.mascot.rarity) {
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
