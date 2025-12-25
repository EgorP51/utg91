import 'package:utg91/core/domain/models/mascot.dart';

/// Local datasource for mascot data
/// Currently uses in-memory storage with mock data
/// Can be extended to use shared_preferences, hive, or sqflite
class MascotLocalDatasource {
  // In-memory storage (replace with persistent storage in production)
  final List<Mascot> _mascots = _generateMockMascots();
  DateTime? _lastUnlockDate;

  Future<List<Mascot>> getAllMascots() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_mascots);
  }

  Future<void> unlockMascot(String mascotId) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final index = _mascots.indexWhere((m) => m.id == mascotId);
    if (index == -1) return;

    _mascots[index] = _mascots[index].copyWith(
      unlockDate: DateTime.now(),
    );
    _lastUnlockDate = DateTime.now();
  }

  Future<bool> canUnlockToday() async {
    if (_lastUnlockDate == null) return true;

    final now = DateTime.now();
    final lastUnlock = _lastUnlockDate!;

    // Check if last unlock was on a different day
    return now.year != lastUnlock.year ||
        now.month != lastUnlock.month ||
        now.day != lastUnlock.day;
  }

  Future<DateTime?> getNextUnlockTime() async {
    if (_lastUnlockDate == null) return null;

    // Next unlock is at midnight of the next day
    final lastUnlock = _lastUnlockDate!;
    final nextUnlock = DateTime(
      lastUnlock.year,
      lastUnlock.month,
      lastUnlock.day + 1,
    );

    return nextUnlock;
  }

  /// Generates mock mascots for demonstration
  /// In production, this would come from API or local database
  static List<Mascot> _generateMockMascots() {
    return [
      // Common mascots (40.7128° N, 74.0060° W - New York area mock coords)
      const Mascot(
        id: '1',
        name: 'Sparky',
        description: 'A cheerful lightning mascot that loves thunderstorms',
        rarity: MascotRarity.common,
        latitude: 40.7128,
        longitude: -74.0060,
      ),
      const Mascot(
        id: '2',
        name: 'Bubbles',
        description: 'A playful water mascot found near rivers',
        rarity: MascotRarity.common,
        latitude: 40.7580,
        longitude: -73.9855,
      ),
      const Mascot(
        id: '3',
        name: 'Leafy',
        description: 'A nature-loving mascot hiding in parks',
        rarity: MascotRarity.common,
        latitude: 40.7829,
        longitude: -73.9654,
      ),
      const Mascot(
        id: '4',
        name: 'Rocky',
        description: 'A sturdy stone mascot found in mountains',
        rarity: MascotRarity.common,
        latitude: 40.7489,
        longitude: -73.9680,
      ),

      // Rare mascots
      const Mascot(
        id: '5',
        name: 'Frostbite',
        description: 'A cool ice mascot that appears in winter',
        rarity: MascotRarity.rare,
        latitude: 40.7614,
        longitude: -73.9776,
      ),
      const Mascot(
        id: '6',
        name: 'Ember',
        description: 'A fierce fire mascot with a warm heart',
        rarity: MascotRarity.rare,
        latitude: 40.7484,
        longitude: -73.9857,
      ),
      const Mascot(
        id: '7',
        name: 'Zephyr',
        description: 'A swift wind mascot that rides the breeze',
        rarity: MascotRarity.rare,
        latitude: 40.7589,
        longitude: -73.9851,
      ),

      // Epic mascots
      const Mascot(
        id: '8',
        name: 'Lumina',
        description: 'A radiant light mascot that illuminates the darkness',
        rarity: MascotRarity.epic,
        latitude: 40.7558,
        longitude: -73.9865,
      ),
      const Mascot(
        id: '9',
        name: 'Shadow',
        description: 'A mysterious dark mascot lurking in the shadows',
        rarity: MascotRarity.epic,
        latitude: 40.7614,
        longitude: -73.9776,
      ),

      // Legendary mascots
      const Mascot(
        id: '10',
        name: 'Aurora',
        description: 'A legendary celestial mascot born from the northern lights',
        rarity: MascotRarity.legendary,
        latitude: 40.7580,
        longitude: -73.9855,
      ),
      const Mascot(
        id: '11',
        name: 'Phoenix',
        description: 'The legendary bird that rises from ashes',
        rarity: MascotRarity.legendary,
        latitude: 40.7128,
        longitude: -74.0060,
      ),
      const Mascot(
        id: '12',
        name: 'Nexus',
        description: 'A cosmic mascot that connects all dimensions',
        rarity: MascotRarity.legendary,
        latitude: 40.7489,
        longitude: -73.9680,
      ),
    ];
  }
}
