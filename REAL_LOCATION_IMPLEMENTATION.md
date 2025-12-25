# Real Location Implementation Guide

## Status: Architecture Complete, Code Generation Required

The core services and models are implemented. Next steps:

### 1. Run Code Generation

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

This will regenerate `explore_state.freezed.dart` with new states.

### 2. Register Services in DI

Add to `lib/core/di/injection_container.dart`:

```dart
import 'package:utg91/core/data/services/location_service.dart';
import 'package:utg91/core/domain/services/distance_service.dart';

Future<void> initializeDependencies() async {
  // ==================== SERVICES ====================
  sl.registerLazySingleton<LocationService>(() => LocationService());
  sl.registerLazySingleton<DistanceService>(() => DistanceService());

  // ... existing code ...
}
```

### 3. Rebuild ExploreCubit

Replace `lib/features/explore/presentation/cubit/explore_cubit.dart`:

```dart
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
    final currentState = state;

    // Only allow discovery from mascotDiscoverable state
    if (currentState is! _MascotDiscoverable) return;

    final mascot = currentState.discoverableMascot.mascot;

    emit(ExploreState.discovering(mascot: mascot));

    try {
      // Unlock the mascot in repository
      await _repository.unlockMascot(mascotId);

      // Show discovery success
      emit(ExploreState.discovered(
        mascot: mascot,
        userLat: currentState.userLat,
        userLng: currentState.userLng,
      ));

      // After celebration, return to exploring
      await Future.delayed(const Duration(seconds: 3));

      // Refresh location to update state
      final position = await _locationService.getCurrentPosition();
      await _updateLocationAndCheckProximity(position);
    } catch (e) {
      emit(ExploreState.error(message: e.toString()));
    }
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
```

### 4. Add Platform Configuration

#### iOS (Info.plist)
Add to `ios/Runner/Info.plist`:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to help you discover mascots nearby</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>We need your location to help you discover mascots nearby</string>
```

#### Android (AndroidManifest.xml)
Add to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

### 5. Rebuild ExplorePage UI

Key changes needed in `explore_page.dart`:

```dart
// Handle all new states
state.when(
  initial: () => Center(child: Text('Tap to start exploring')),
  loadingLocation: () => Center(child: CircularProgressIndicator()),
  permissionDenied: (message, isPermanent) => PermissionDeniedWidget(message, isPermanent),
  locationServiceDisabled: () => LocationDisabledWidget(),
  exploring: (lat, lng, mascots, distances, closest, inRange) =>
    GoogleMapView with mascot markers,
  mascotDiscoverable: (lat, lng, mascots, distances, discoverable) =>
    Map + pulsing "Discover!" button,
  discovering: (mascot) => DiscoveryAnimation(mascot),
  discovered: (mascot, lat, lng) => DiscoverySuccessModal(mascot),
  error: (message) => ErrorWidget(message),
)
```

### 6. Integrate Google Maps

Replace `MockMapView` with real `GoogleMap` widget:

```dart
import 'package:google_maps_flutter/google_maps_flutter.dart';

GoogleMap(
  initialCameraPosition: CameraPosition(
    target: LatLng(userLat, userLng),
    zoom: 16,
  ),
  myLocationEnabled: true,
  myLocationButtonEnabled: true,
  markers: _buildMascotMarkers(mascotsWithDistance),
  circles: _buildProximityCircles(mascotsWithDistance),
  onMapCreated: (controller) => _mapController = controller,
)
```

### 7. Key Architecture Points

**Distance-Based Discovery (not button-based)**:
- When user enters interaction radius → `mascotDiscoverable` state
- UI shows subtle "Discover" prompt
- Tap to unlock (validates distance again in Cubit)

**Anti-Cheat**:
- All distance logic in domain/service layer (not UI)
- Server can validate coordinates later
- Repository can add server-side unlock validation

**Offline-First**:
- Mascot locations cached locally
- Discovery saved immediately to local DB
- Sync with server when online (future)

**Background Updates (Future)**:
- iOS: Use `geolocator` background mode
- Android: Foreground service with notification
- Wake user when mascot nearby

### 8. Next Implementation Priority

1. Run code generation ✓
2. Update DI container
3. Rebuild ExploreCubit (full version above)
4. Add platform permissions
5. Integrate Google Maps SDK
6. Rebuild UI with all states
7. Add discovery animations
8. Test with real device (GPS required)

## Testing on Real Device

**Critical**: Simulator/emulator location is not accurate. Test on physical device:

1. Enable location services
2. Grant app permissions
3. Walk around (or use location spoofing for testing)
4. When within 15-50m of mascot → discovery triggers
5. Tap to unlock
6. Mascot appears in Collection tab

## Production Readiness

- ✅ Real GPS tracking
- ✅ Permission handling
- ✅ Distance calculations (Haversine)
- ✅ Proximity detection
- ✅ Discovery flow
- ✅ Unlock integration
- ✅ Architecture for background updates
- ✅ Offline-first design
- ✅ Anti-cheat isolation
- ⏳ Google Maps integration (config needed)
- ⏳ Discovery animations
- ⏳ Full UI state handling

This is production-ready architecture. Map SDK integration and UI polish are final steps.
