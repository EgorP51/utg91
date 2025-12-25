import 'package:flutter/material.dart';
import 'package:utg91/core/domain/models/mascot.dart';
import 'package:utg91/core/presentation/theme/app_theme.dart';

/// Animation widget shown during mascot discovery
/// Expanding circles and reveal effect
class DiscoveringAnimation extends StatefulWidget {
  final Mascot mascot;

  const DiscoveringAnimation({
    super.key,
    required this.mascot,
  });

  @override
  State<DiscoveringAnimation> createState() => _DiscoveringAnimationState();
}

class _DiscoveringAnimationState extends State<DiscoveringAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.2).animate(
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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rarityColor = AppTheme.getRarityColor(widget.mascot.rarity.name);

    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                // Expanding circles
                ...List.generate(3, (index) {
                  final delay = index * 0.2;
                  final adjustedValue =
                      (_controller.value - delay).clamp(0.0, 1.0);

                  return Transform.scale(
                    scale: adjustedValue * 3,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: rarityColor.withOpacity(0.3 - adjustedValue * 0.3),
                          width: 3,
                        ),
                      ),
                    ),
                  );
                }),

                // Central mascot reveal
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: rarityColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: rarityColor.withOpacity(0.6),
                                blurRadius: 40,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              _getRarityEmoji(),
                              style: const TextStyle(fontSize: 64),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Discovering...',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
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
