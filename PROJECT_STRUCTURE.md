# Project Structure

## Complete File Tree

```
utg91/
├── lib/
│   ├── main.dart                          # App entry point
│   │
│   ├── core/                              # Shared across all features
│   │   ├── data/
│   │   │   ├── repositories/
│   │   │   │   └── mascot_repository_impl.dart
│   │   │   └── sources/
│   │   │       └── local/
│   │   │           └── mascot_local_datasource.dart
│   │   ├── domain/
│   │   │   ├── models/
│   │   │   │   ├── mascot.dart            # Domain model with freezed
│   │   │   │   ├── mascot.freezed.dart    # Generated
│   │   │   │   └── mascot.g.dart          # Generated
│   │   │   └── repositories/
│   │   │       └── mascot_repository.dart
│   │   ├── presentation/
│   │   │   ├── theme/
│   │   │   │   └── app_theme.dart         # Light/Dark themes
│   │   │   └── widgets/
│   │   │       └── app_shell.dart         # Bottom nav container
│   │   ├── di/
│   │   │   └── injection_container.dart   # get_it setup
│   │   └── router/
│   │       └── app_router.dart            # go_router config
│   │
│   └── features/                          # Feature modules
│       ├── explore/                       # Tab 1: Map Explore
│       │   └── presentation/
│       │       ├── cubit/
│       │       │   ├── explore_cubit.dart
│       │       │   ├── explore_state.dart
│       │       │   └── explore_state.freezed.dart # Generated
│       │       ├── pages/
│       │       │   └── explore_page.dart
│       │       └── widgets/
│       │           ├── mascot_marker.dart
│       │           └── mock_map_view.dart
│       │
│       ├── collection/                    # Tab 2: Mascots Collection
│       │   └── presentation/
│       │       ├── cubit/
│       │       │   ├── collection_cubit.dart
│       │       │   ├── collection_state.dart
│       │       │   └── collection_state.freezed.dart # Generated
│       │       ├── pages/
│       │       │   └── collection_page.dart
│       │       └── widgets/
│       │           ├── mascot_card.dart
│       │           └── unlock_celebration.dart
│       │
│       ├── social/                        # Tab 3: Placeholder
│       │   └── presentation/
│       │       └── pages/
│       │           └── social_page.dart
│       │
│       └── profile/                       # Tab 4: Placeholder
│           └── presentation/
│               └── pages/
│                   └── profile_page.dart
│
├── test/
│   └── widget_test.dart                   # Placeholder test
│
├── pubspec.yaml                           # Dependencies
├── build.yaml                             # Code generation config
└── README.md                              # Documentation
```

## Key Architecture Patterns

### 1. Feature-First Structure
Each feature is self-contained with its own:
- Presentation layer (Cubit, Pages, Widgets)
- Future: Domain layer (Use Cases)
- Future: Data layer (if feature-specific data needed)

### 2. Clean Architecture Layers

```
┌─────────────────────────────────────────┐
│          PRESENTATION LAYER             │
│  (UI, Cubits, States, Pages, Widgets)  │
└─────────────────┬───────────────────────┘
                  │ depends on
┌─────────────────▼───────────────────────┐
│           DOMAIN LAYER                  │
│   (Models, Repository Interfaces,       │
│    Use Cases - future)                  │
└─────────────────┬───────────────────────┘
                  │ depends on
┌─────────────────▼───────────────────────┐
│            DATA LAYER                   │
│  (Repository Implementations,           │
│   Data Sources)                         │
└─────────────────────────────────────────┘
```

### 3. Data Flow

```
User Interaction
      ↓
  UI Widget
      ↓
  Cubit Method
      ↓
Repository Interface
      ↓
Repository Implementation
      ↓
   Data Source
      ↓
  New State Emitted
      ↓
   UI Rebuilds
```

### 4. Dependency Injection

```dart
// Registration (injection_container.dart)
sl.registerLazySingleton<DataSource>(() => DataSourceImpl());
sl.registerLazySingleton<Repository>(() => RepositoryImpl(sl()));
sl.registerFactory(() => FeatureCubit(sl()));

// Usage (in BlocProvider)
BlocProvider(create: (_) => sl<FeatureCubit>())
```

### 5. State Management with Freezed

```dart
// Define states
@freezed
class FeatureState with _$FeatureState {
  const factory FeatureState.initial() = _Initial;
  const factory FeatureState.loading() = _Loading;
  const factory FeatureState.loaded({required Data data}) = _Loaded;
  const factory FeatureState.error({required String message}) = _Error;
}

// Use in Cubit
emit(FeatureState.loading());
emit(FeatureState.loaded(data: result));

// Use in UI
state.when(
  initial: () => InitialWidget(),
  loading: () => LoadingWidget(),
  loaded: (data) => LoadedWidget(data),
  error: (message) => ErrorWidget(message),
)
```

## File Naming Conventions

- **Dart files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables/Functions**: `camelCase`
- **Constants**: `camelCase` or `SCREAMING_SNAKE_CASE` for compile-time constants

## Import Ordering

```dart
// 1. Dart SDK
import 'dart:async';

// 2. Flutter SDK
import 'package:flutter/material.dart';

// 3. External packages
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// 4. Internal imports (relative)
import 'package:utg91/core/...';
import 'package:utg91/features/...';
```

## Code Generation

### Files that need generation:
- `*.dart` with `@freezed` annotation → `*.freezed.dart`
- `*.dart` with `@JsonSerializable` → `*.g.dart`

### Commands:
```bash
# One-time generation
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (auto-regenerates on changes)
flutter pub run build_runner watch --delete-conflicting-outputs
```

## Testing Structure (Future)

```
test/
├── unit/
│   ├── cubits/
│   └── repositories/
├── widget/
│   └── features/
└── integration/
    └── flows/
```

## Adding a New Feature

1. Create feature folder: `lib/features/my_feature/`
2. Add presentation layer:
   ```
   my_feature/
   └── presentation/
       ├── cubit/
       │   ├── my_feature_cubit.dart
       │   └── my_feature_state.dart
       ├── pages/
       │   └── my_feature_page.dart
       └── widgets/
           └── (feature widgets)
   ```
3. Register Cubit in `injection_container.dart`
4. Add route in `app_router.dart`
5. Add to bottom nav if needed in `app_shell.dart`
6. Run code generation if using freezed
7. Update README.md

## Current Features Status

✅ **Explore** (Tab 1)
- Mock map view
- Mascot markers
- Rarity-based styling
- Ready for real map SDK

✅ **Collection** (Tab 2)
- Mascot grid
- Lock/unlock system
- 1-per-day limit
- Unlock animations

🔲 **Social** (Tab 3)
- Placeholder UI
- Architecture ready

🔲 **Profile** (Tab 4)
- Placeholder UI
- Architecture ready
