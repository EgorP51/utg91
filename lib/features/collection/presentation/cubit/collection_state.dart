import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:utg91/core/domain/models/mascot.dart';

part 'collection_state.freezed.dart';

/// State for Collection feature
/// Handles unlock logic with one-per-day limitation
@freezed
class CollectionState with _$CollectionState {
  const factory CollectionState.initial() = _Initial;

  const factory CollectionState.loading() = _Loading;

  const factory CollectionState.loaded({
    required List<Mascot> allMascots,
    required List<Mascot> unlockedMascots,
    required bool canUnlockToday,
    DateTime? nextUnlockTime,
  }) = _Loaded;

  const factory CollectionState.unlocking({
    required String mascotId,
  }) = _Unlocking;

  const factory CollectionState.unlocked({
    required Mascot mascot,
    required List<Mascot> allMascots,
    required List<Mascot> unlockedMascots,
  }) = _Unlocked;

  const factory CollectionState.error({
    required String message,
  }) = _Error;
}
