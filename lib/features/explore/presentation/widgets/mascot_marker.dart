import 'package:flutter/material.dart';
import 'package:utg91/core/domain/models/mascot.dart';
import 'package:utg91/core/presentation/theme/app_theme.dart';

/// Marker widget for displaying mascot on map
/// Positioned based on lat/lng coordinates (simplified for mock map)
class MascotMarker extends StatelessWidget {
  final Mascot mascot;
  final double userLat;
  final double userLng;

  const MascotMarker({
    super.key,
    required this.mascot,
    required this.userLat,
    required this.userLng,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate position on screen (simplified for mock map)
    // In production, real map SDK handles coordinate projection
    final position = _calculatePosition(context);

    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onTap: () => _showMascotDetails(context),
        child: _buildMarker(context),
      ),
    );
  }

  Widget _buildMarker(BuildContext context) {
    final color = AppTheme.getRarityColor(mascot.rarity.name);
    final isUnlocked = mascot.unlockDate != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Marker icon
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.9),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: isUnlocked
                ? Text(
                    _getRarityEmoji(),
                    style: const TextStyle(fontSize: 24),
                  )
                : Icon(
                    Icons.lock,
                    color: Colors.white,
                    size: 24,
                  ),
          ),
        ),

        // Pointer
        CustomPaint(
          size: const Size(12, 8),
          painter: _TrianglePainter(color: color.withOpacity(0.9)),
        ),
      ],
    );
  }

  /// Calculate screen position from coordinates (simplified)
  Offset _calculatePosition(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Simple projection: map lat/lng delta to screen coordinates
    // Real map SDK would handle proper map projection
    final deltaLat = mascot.latitude - userLat;
    final deltaLng = mascot.longitude - userLng;

    // Scale factor (arbitrary for demo)
    const scale = 2000.0;

    final x = (size.width / 2) + (deltaLng * scale);
    final y = (size.height / 2) - (deltaLat * scale);

    return Offset(
      x.clamp(20, size.width - 60),
      y.clamp(60, size.height - 200),
    );
  }

  /// Shows mascot details in bottom sheet
  void _showMascotDetails(BuildContext context) {
    final isUnlocked = mascot.unlockDate != null;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),

            // Mascot icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.getRarityColor(mascot.rarity.name),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isUnlocked
                    ? Text(
                        _getRarityEmoji(),
                        style: const TextStyle(fontSize: 48),
                      )
                    : const Icon(
                        Icons.lock,
                        color: Colors.white,
                        size: 40,
                      ),
              ),
            ),
            const SizedBox(height: 16),

            // Name
            Text(
              isUnlocked ? mascot.name : '???',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),

            // Rarity badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.getRarityColor(mascot.rarity.name),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                mascot.rarity.displayName,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
            const SizedBox(height: 16),

            // Description
            Text(
              isUnlocked ? mascot.description : 'Unlock to reveal this mascot!',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Action button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                child: Text(isUnlocked ? 'View in Collection' : 'Close'),
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

/// Custom painter for marker pointer
class _TrianglePainter extends CustomPainter {
  final Color color;

  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
