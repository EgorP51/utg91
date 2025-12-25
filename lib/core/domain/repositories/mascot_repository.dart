import '../models/mascot.dart';

/// Abstract repository interface for mascot data operations
/// Allows swapping data sources (local, remote, mock) without changing business logic
abstract class MascotRepository {
  /// Fetches all mascots (locked and unlocked)
  Future<List<Mascot>> getAllMascots();

  /// Fetches only unlocked mascots
  Future<List<Mascot>> getUnlockedMascots();

  /// Fetches mascots within map bounds (for map view)
  Future<List<Mascot>> getMascotsInBounds({
    required double minLat,
    required double maxLat,
    required double minLng,
    required double maxLng,
  });

  /// Unlocks a mascot by ID
  Future<void> unlockMascot(String mascotId);

  /// Checks if user can unlock today (max 1 per day)
  Future<bool> canUnlockToday();

  /// Gets the next available unlock time
  Future<DateTime?> getNextUnlockTime();
}
