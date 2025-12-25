import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:utg91/core/domain/models/mascot.dart';

part 'explore_state.freezed.dart';

/// Immutable state for Explore feature
/// Follows Clean Architecture: UI reacts to state changes only
@freezed
class ExploreState with _$ExploreState {
  const factory ExploreState.initial() = _Initial;

  const factory ExploreState.loading() = _Loading;

  const factory ExploreState.loaded({
    required List<Mascot> nearbyMascots,
    @Default(40.7128) double userLat,
    @Default(-74.0060) double userLng,
  }) = _Loaded;

  const factory ExploreState.error({
    required String message,
  }) = _Error;
}
