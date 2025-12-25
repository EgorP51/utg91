import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utg91/core/domain/repositories/mascot_repository.dart';
import 'explore_state.dart';

/// Cubit for Map Explore feature
/// Responsibilities: load nearby mascots, handle map interactions
/// Business logic is delegated to repository/use cases
class ExploreCubit extends Cubit<ExploreState> {
  final MascotRepository _repository;

  ExploreCubit(this._repository) : super(const ExploreState.initial());

  /// Loads mascots near user's current location
  /// In production, would use real GPS coordinates
  Future<void> loadNearbyMascots({
    double? userLat,
    double? userLng,
  }) async {
    emit(const ExploreState.loading());

    try {
      // Mock user location (would come from GPS in production)
      final lat = userLat ?? 40.7128;
      final lng = userLng ?? -74.0060;

      // Define bounding box around user (approx 5km radius in degrees)
      const delta = 0.05; // ~5km at this latitude

      final mascots = await _repository.getMascotsInBounds(
        minLat: lat - delta,
        maxLat: lat + delta,
        minLng: lng - delta,
        maxLng: lng + delta,
      );

      emit(ExploreState.loaded(
        nearbyMascots: mascots,
        userLat: lat,
        userLng: lng,
      ));
    } catch (e) {
      emit(ExploreState.error(message: e.toString()));
    }
  }

  /// Refreshes map data
  Future<void> refresh() async {
    state.maybeWhen(
      loaded: (mascots, lat, lng) async {
        await loadNearbyMascots(userLat: lat, userLng: lng);
      },
      orElse: () async {
        await loadNearbyMascots();
      },
    );
  }

  /// Updates visible map region
  /// Would be called when user pans/zooms the map
  Future<void> updateMapBounds({
    required double minLat,
    required double maxLat,
    required double minLng,
    required double maxLng,
  }) async {
    try {
      final mascots = await _repository.getMascotsInBounds(
        minLat: minLat,
        maxLat: maxLat,
        minLng: minLng,
        maxLng: maxLng,
      );

      emit(ExploreState.loaded(
        nearbyMascots: mascots,
        userLat: (minLat + maxLat) / 2,
        userLng: (minLng + maxLng) / 2,
      ));
    } catch (e) {
      emit(ExploreState.error(message: e.toString()));
    }
  }
}
