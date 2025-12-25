import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:utg91/core/domain/models/mascot.dart';
import 'package:utg91/core/domain/services/distance_service.dart';

part 'explore_state.freezed.dart';

/// Production-ready state for Explore feature with real GPS
/// Handles: permissions, location loading, proximity detection, discovery
@freezed
class ExploreState with _$ExploreState {
  /// Initial state before requesting permissions
  const factory ExploreState.initial() = _Initial;

  /// Loading location data (requesting permission or waiting for GPS)
  const factory ExploreState.loadingLocation() = _LoadingLocation;

  /// Location permission denied by user
  const factory ExploreState.permissionDenied({
    required String message,
    required bool isPermanent,
  }) = _PermissionDenied;

  /// Location services disabled on device
  const factory ExploreState.locationServiceDisabled() =
      _LocationServiceDisabled;

  /// User is exploring - shows map, mascots, and proximity status
  const factory ExploreState.exploring({
    required double userLat,
    required double userLng,
    required List<Mascot> allMascots,
    required List<MascotWithDistance> mascotsWithDistance,
    MascotWithDistance? closestMascot,
    MascotWithDistance? mascotInRange,
  }) = _Exploring;

  /// A mascot is in range and can be discovered
  const factory ExploreState.mascotDiscoverable({
    required double userLat,
    required double userLng,
    required List<Mascot> allMascots,
    required List<MascotWithDistance> mascotsWithDistance,
    required MascotWithDistance discoverableMascot,
  }) = _MascotDiscoverable;

  /// Discovering a mascot (unlocking animation in progress)
  const factory ExploreState.discovering({
    required Mascot mascot,
  }) = _Discovering;

  /// Mascot discovered successfully
  const factory ExploreState.discovered({
    required Mascot mascot,
    required double userLat,
    required double userLng,
  }) = _Discovered;

  /// Generic error
  const factory ExploreState.error({
    required String message,
  }) = _Error;
}
