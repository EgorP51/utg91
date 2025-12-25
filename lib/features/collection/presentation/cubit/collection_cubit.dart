import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utg91/core/domain/repositories/mascot_repository.dart';
import 'collection_state.dart';

/// Cubit for Mascots Collection feature
/// Handles unlock logic with one-per-day limitation
class CollectionCubit extends Cubit<CollectionState> {
  final MascotRepository _repository;

  CollectionCubit(this._repository) : super(const CollectionState.initial());

  /// Loads all mascots and unlock status
  Future<void> loadCollection() async {
    emit(const CollectionState.loading());

    try {
      final allMascots = await _repository.getAllMascots();
      final unlockedMascots = await _repository.getUnlockedMascots();
      final canUnlock = await _repository.canUnlockToday();
      final nextUnlock = await _repository.getNextUnlockTime();

      emit(CollectionState.loaded(
        allMascots: allMascots,
        unlockedMascots: unlockedMascots,
        canUnlockToday: canUnlock,
        nextUnlockTime: nextUnlock,
      ));
    } catch (e) {
      emit(CollectionState.error(message: e.toString()));
    }
  }

  /// Unlocks a mascot by ID
  /// Only works if user can unlock today (max 1 per day)
  Future<void> unlockMascot(String mascotId) async {
    state.maybeWhen(
      loaded: (allMascots, unlockedMascots, canUnlock, nextUnlock) async {
        if (!canUnlock) {
          emit(CollectionState.error(
            message:
                'You can only unlock one mascot per day. Come back tomorrow!',
          ));
          await Future.delayed(const Duration(seconds: 2));
          await loadCollection();
          return;
        }

        emit(CollectionState.unlocking(mascotId: mascotId));

        try {
          await _repository.unlockMascot(mascotId);

          // Reload collection to get updated data
          final newAllMascots = await _repository.getAllMascots();
          final newUnlockedMascots = await _repository.getUnlockedMascots();
          final unlockedMascot =
              newAllMascots.firstWhere((m) => m.id == mascotId);

          emit(CollectionState.unlocked(
            mascot: unlockedMascot,
            allMascots: newAllMascots,
            unlockedMascots: newUnlockedMascots,
          ));

          // Auto-transition back to loaded state after celebration
          await Future.delayed(const Duration(seconds: 2));
          await loadCollection();
        } catch (e) {
          emit(CollectionState.error(message: e.toString()));
          await Future.delayed(const Duration(seconds: 2));
          await loadCollection();
        }
      },
      orElse: () => null,
    );
  }

  /// Refreshes collection data
  Future<void> refresh() async {
    await loadCollection();
  }
}
