import '../../domain/models/mascot.dart';
import '../../domain/repositories/mascot_repository.dart';
import '../sources/local/mascot_local_datasource.dart';

/// Production implementation of MascotRepository
/// Delegates to local datasource (can be extended with remote in future)
class MascotRepositoryImpl implements MascotRepository {
  final MascotLocalDatasource _localDatasource;

  MascotRepositoryImpl(this._localDatasource);

  @override
  Future<List<Mascot>> getAllMascots() async {
    return _localDatasource.getAllMascots();
  }

  @override
  Future<List<Mascot>> getUnlockedMascots() async {
    final all = await _localDatasource.getAllMascots();
    return all.where((m) => m.unlockDate != null).toList();
  }

  @override
  Future<List<Mascot>> getMascotsInBounds({
    required double minLat,
    required double maxLat,
    required double minLng,
    required double maxLng,
  }) async {
    final all = await _localDatasource.getAllMascots();
    return all.where((m) {
      return m.latitude >= minLat &&
          m.latitude <= maxLat &&
          m.longitude >= minLng &&
          m.longitude <= maxLng;
    }).toList();
  }

  @override
  Future<void> unlockMascot(String mascotId) async {
    return _localDatasource.unlockMascot(mascotId);
  }

  @override
  Future<bool> canUnlockToday() async {
    return _localDatasource.canUnlockToday();
  }

  @override
  Future<DateTime?> getNextUnlockTime() async {
    return _localDatasource.getNextUnlockTime();
  }
}
