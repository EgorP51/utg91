import 'package:geolocator/geolocator.dart';
import 'package:utg91/core/domain/models/mascot.dart';

/// Domain service for distance calculations
/// Isolated from UI for anti-cheat and business logic clarity
/// Uses Haversine formula via Geolocator for accurate geodesic distance
class DistanceService {
  /// Calculate distance between two coordinates in meters
  /// Uses Haversine formula for accurate geodesic distance
  double calculateDistance({
    required double lat1,
    required double lon1,
    required double lat2,
    required double lon2,
  }) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }

  /// Check if user is within interaction radius of a mascot
  /// Returns true if distance is less than or equal to radius
  bool isWithinRadius({
    required double userLat,
    required double userLng,
    required Mascot mascot,
  }) {
    final distance = calculateDistance(
      lat1: userLat,
      lon1: userLng,
      lat2: mascot.latitude,
      lon2: mascot.longitude,
    );

    return distance <= mascot.interactionRadius;
  }

  /// Get distance to mascot in meters
  double getDistanceToMascot({
    required double userLat,
    required double userLng,
    required Mascot mascot,
  }) {
    return calculateDistance(
      lat1: userLat,
      lon1: userLng,
      lat2: mascot.latitude,
      lon2: mascot.longitude,
    );
  }

  /// Get all mascots within interaction radius
  /// Sorted by distance (closest first)
  List<MascotWithDistance> getMascotsInRange({
    required double userLat,
    required double userLng,
    required List<Mascot> mascots,
  }) {
    final mascotsWithDistance = mascots.map((mascot) {
      final distance = getDistanceToMascot(
        userLat: userLat,
        userLng: userLng,
        mascot: mascot,
      );

      final inRange = distance <= mascot.interactionRadius;

      return MascotWithDistance(
        mascot: mascot,
        distance: distance,
        inRange: inRange,
      );
    }).toList();

    // Sort by distance (closest first)
    mascotsWithDistance.sort((a, b) => a.distance.compareTo(b.distance));

    return mascotsWithDistance;
  }

  /// Find closest mascot to user
  MascotWithDistance? getClosestMascot({
    required double userLat,
    required double userLng,
    required List<Mascot> mascots,
  }) {
    if (mascots.isEmpty) return null;

    final mascotsWithDistance = getMascotsInRange(
      userLat: userLat,
      userLng: userLng,
      mascots: mascots,
    );

    return mascotsWithDistance.first;
  }

  /// Format distance for UI display
  /// Returns "X m" for distances < 1000m, "X.X km" for longer distances
  String formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.round()} m';
    } else {
      return '${(meters / 1000).toStringAsFixed(1)} km';
    }
  }
}

/// Value object combining mascot with calculated distance
class MascotWithDistance {
  final Mascot mascot;
  final double distance; // in meters
  final bool inRange;

  MascotWithDistance({
    required this.mascot,
    required this.distance,
    required this.inRange,
  });
}
