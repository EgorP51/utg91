import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:utg91/core/data/services/location_service.dart';
import 'package:utg91/core/domain/repositories/mascot_repository.dart';
import 'package:utg91/core/domain/services/distance_service.dart';
import 'explore_state.dart';

/// Production Cubit for real-world GPS exploration
/// Handles: permissions, location updates, proximity detection, discovery
class ExploreCubit extends Cubit<ExploreState> {
  final MascotRepository _repository;
  final LocationService _locationService;
  final DistanceService _distanceService;

  StreamSubscription<Position>? _locationSubscription;

  ExploreCubit(
      this._repository,
      this._locationService,
      this._distanceService,
      ) : super(const ExploreState.initial());

  /// Initialize: request permissions and start tracking
  Future<void> initialize() async {
    emit(const ExploreState.loadingLocation());

    try {
      // Check if location service is enabled
      final serviceEnabled = await _locationService.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(const ExploreState.locationServiceDisabled());
        return;
      }

      // Request permission
      final permission = await _locationService.requestPermission();
      if (permission == LocationPermission.denied) {
        emit(const ExploreState.permissionDenied(
          message: 'Location permission denied',
          isPermanent: false,
        ));
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        emit(const ExploreState.permissionDenied(
          message: 'Location permission permanently denied',
          isPermanent: true,
        ));
        return;
      }

      // Get initial position
      final position = await _locationService.getCurrentPosition();
      await _updateLocationAndCheckProximity(position);

      // Start listening to location updates
      _startLocationTracking();
    } catch (e) {
      emit(ExploreState.error(message: e.toString()));
    }
  }

  /// Start real-time location tracking
  void _startLocationTracking() {
    _locationService.startLocationUpdates((position) {
      _updateLocationAndCheckProximity(position);
    });
  }

  /// Update user location and check for nearby mascots
  Future<void> _updateLocationAndCheckProximity(Position position) async {
    try {
      // Get all mascots
      final allMascots = await _repository.getAllMascots();

      // Filter out already discovered mascots
      final undiscoveredMascots =
      allMascots.where((m) => m.unlockDate == null).toList();

      // Calculate distances
      final mascotsWithDistance = _distanceService.getMascotsInRange(
        userLat: position.latitude,
        userLng: position.longitude,
        mascots: undiscoveredMascots,
      );

      // Find closest mascot
      final closestMascot = mascotsWithDistance.isNotEmpty
          ? mascotsWithDistance.first
          : null;

      // Find mascots in range (undiscovered only)
      final mascotsInRange =
      mascotsWithDistance.where((m) => m.inRange).toList();

      if (mascotsInRange.isNotEmpty) {
        // Mascot is discoverable!
        final discoverableMascot = mascotsInRange.first;

        emit(ExploreState.mascotDiscoverable(
          userLat: position.latitude,
          userLng: position.longitude,
          allMascots: allMascots,
          mascotsWithDistance: mascotsWithDistance,
          discoverableMascot: discoverableMascot,
        ));
      } else {
        // Just exploring
        emit(ExploreState.exploring(
          userLat: position.latitude,
          userLng: position.longitude,
          allMascots: allMascots,
          mascotsWithDistance: mascotsWithDistance,
          closestMascot: closestMascot,
          mascotInRange: null,
        ));
      }
    } catch (e) {
      emit(ExploreState.error(message: e.toString()));
    }
  }

  /// Discover a mascot (unlock it)
  Future<void> discoverMascot(String mascotId) async {
    // Use pattern matching instead of type check
    state.maybeWhen(
      mascotDiscoverable: (lat, lng, mascots, distances, discoverable) async {
        final mascot = discoverable.mascot;

        emit(ExploreState.discovering(mascot: mascot));

        try {
          // Unlock the mascot in repository
          await _repository.unlockMascot(mascotId);

          // Show discovery success
          emit(ExploreState.discovered(
            mascot: mascot,
            userLat: lat,
            userLng: lng,
          ));

          // After celebration, return to exploring
          await Future.delayed(const Duration(seconds: 3));

          // Refresh location to update state
          final position = await _locationService.getCurrentPosition();
          await _updateLocationAndCheckProximity(position);
        } catch (e) {
          emit(ExploreState.error(message: e.toString()));
        }
      },
      orElse: () => null,
    );
  }

  /// Manual refresh
  Future<void> refresh() async {
    try {
      final position = await _locationService.getCurrentPosition();
      await _updateLocationAndCheckProximity(position);
    } catch (e) {
      emit(ExploreState.error(message: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _locationService.stopLocationUpdates();
    return super.close();
  }
}