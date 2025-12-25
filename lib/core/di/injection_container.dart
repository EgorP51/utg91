import 'package:get_it/get_it.dart';
import 'package:utg91/core/data/repositories/mascot_repository_impl.dart';
import 'package:utg91/core/data/sources/local/mascot_local_datasource.dart';
import 'package:utg91/core/domain/repositories/mascot_repository.dart';
import 'package:utg91/features/collection/presentation/cubit/collection_cubit.dart';
import 'package:utg91/features/explore/presentation/cubit/explore_cubit.dart';

import '../data/services/location_service.dart';
import '../domain/services/distance_service.dart';

/// Global service locator for dependency injection
/// Follows single responsibility: register dependencies once, retrieve anywhere
final sl = GetIt.instance;

/// Initialize all dependencies
/// Call this once at app startup before runApp
Future<void> initializeDependencies() async {
  sl.registerLazySingleton<LocationService>(() => LocationService());
  sl.registerLazySingleton<DistanceService>(() => DistanceService());
  // ==================== DATA SOURCES ====================
  // Singleton: single instance shared across app
  sl.registerLazySingleton<MascotLocalDatasource>(
    () => MascotLocalDatasource(),
  );

  // ==================== REPOSITORIES ====================
  // Singleton: stateless data layer, safe to share
  sl.registerLazySingleton<MascotRepository>(
    () => MascotRepositoryImpl(sl()),
  );

  // ==================== CUBITS ====================
  // Factory: new instance per feature to avoid state conflicts
  // Each screen gets its own Cubit instance via BlocProvider
  sl.registerFactory(
    () => ExploreCubit(sl(), sl(), sl()),
  );

  sl.registerFactory(
    () => CollectionCubit(sl()),
  );
}

/// Extension for cleaner syntax when retrieving dependencies
/// Usage: final repo = di&lt;MascotRepository&gt;();
extension GetItExtension on GetIt {
  T di<T extends Object>() => get<T>();
}
