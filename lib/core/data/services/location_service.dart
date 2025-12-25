import 'dart:async';
import 'package:geolocator/geolocator.dart';

/// Production-ready location service
/// Handles GPS permissions, accuracy, and real-time updates
/// Isolated from UI for testability and anti-cheat logic
class LocationService {
  StreamSubscription<Position>? _positionSubscription;

  /// Check if location services are enabled on device
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Check current permission status
  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  /// Request location permission from user
  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  /// Get current position once
  /// Throws if permissions denied or service disabled
  Future<Position> getCurrentPosition() async {
    // Check if location services are enabled
    final serviceEnabled = await isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationServiceDisabledException();
    }

    // Check permissions
    var permission = await checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await requestPermission();
      if (permission == LocationPermission.denied) {
        throw LocationPermissionDeniedException();
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw LocationPermissionPermanentlyDeniedException();
    }

    // Get position with high accuracy
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /// Stream of position updates for real-time tracking
  /// Returns null if permissions are not granted
  Stream<Position>? getPositionStream() {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Update every 10 meters
    );

    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }

  /// Start listening to position updates
  /// Callback is invoked on each position change
  void startLocationUpdates(void Function(Position) onPositionUpdate) {
    _positionSubscription?.cancel();

    _positionSubscription = getPositionStream()?.listen(
      onPositionUpdate,
      onError: (error) {
        // Handle stream errors (permissions revoked, etc.)
        _positionSubscription?.cancel();
      },
    );
  }

  /// Stop listening to position updates
  void stopLocationUpdates() {
    _positionSubscription?.cancel();
    _positionSubscription = null;
  }

  /// Clean up resources
  void dispose() {
    stopLocationUpdates();
  }
}

/// Custom exceptions for location service
class LocationServiceDisabledException implements Exception {
  @override
  String toString() => 'Location services are disabled. Please enable GPS.';
}

class LocationPermissionDeniedException implements Exception {
  @override
  String toString() => 'Location permission denied.';
}

class LocationPermissionPermanentlyDeniedException implements Exception {
  @override
  String toString() =>
      'Location permission permanently denied. Enable in settings.';
}
