# UTG91 - Mascot Collection App

A production-ready Flutter app with Feature-First architecture, built for scalability and long-term growth.

## Architecture

### Clean Architecture + Feature-First
```
lib/
├── core/                           # Shared across all features
│   ├── data/                       # Data layer
│   │   ├── repositories/           # Repository implementations
│   │   └── sources/                # Data sources (local, remote)
│   ├── domain/                     # Business logic
│   │   ├── models/                 # Domain entities (freezed)
│   │   └── repositories/           # Repository interfaces
│   ├── presentation/               # Shared UI
│   │   ├── theme/                  # Theme configuration
│   │   └── widgets/                # Reusable widgets
│   ├── di/                         # Dependency injection
│   └── router/                     # Navigation
│
└── features/                       # Feature modules
    ├── explore/                    # Tab 1: Map Explore
    │   └── presentation/
    │       ├── cubit/              # State management
    │       ├── pages/              # Screens
    │       └── widgets/            # Feature-specific widgets
    │
    ├── collection/                 # Tab 2: Mascots Collection
    ├── social/                     # Tab 3: Placeholder
    └── profile/                    # Tab 4: Placeholder
```

### Tech Stack
- **State Management**: `flutter_bloc` (Cubit pattern)
- **Navigation**: `go_router` with StatefulShellRoute
- **Dependency Injection**: `get_it`
- **Code Generation**: `freezed` + `json_serializable`
- **UI**: Material 3 with Apple-style minimalism

## Features

### ✅ Tab 1: Map Explore
- Mock map view (ready for real map SDK integration)
- Displays nearby mascots with custom markers
- Rarity-based visual styling
- Tap markers to view details
- Architecture supports future GPS and real-time updates

### ✅ Tab 2: Mascots Collection
- Grid view of all mascots (locked/unlocked)
- **Unlock limit**: 1 mascot per day
- Unlock countdown timer
- Animated unlock celebration
- Rarity system: Common, Rare, Epic, Legendary
- Blurred preview for locked mascots

### 🔲 Tab 3: Social (Placeholder)
- Ready for: Friends, Leaderboards, Trading

### 🔲 Tab 4: Profile (Placeholder)
- Ready for: Settings, Stats, Achievements

## Getting Started

### Prerequisites
- Flutter SDK 3.0.0 or higher
- Dart SDK 3.0.0 or higher

### Installation

1. **Install dependencies**
```bash
flutter pub get
```

2. **Generate code** (freezed + json_serializable)
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

3. **Run the app**
```bash
flutter run
```

### Development Commands

```bash
# Generate code (watch mode)
flutter pub run build_runner watch --delete-conflicting-outputs

# Clean build files
flutter clean && flutter pub get

# Run tests
flutter test

# Build for production
flutter build apk --release        # Android
flutter build ios --release        # iOS
```

## Code Generation

This project uses `freezed` and `json_serializable` for:
- Immutable data classes
- JSON serialization
- Union types for states
- copyWith, equality, toString

**IMPORTANT**: After pulling changes or modifying models, always run:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Project Structure Decisions

### Why Feature-First?
- **Scalability**: Each feature is self-contained
- **Team collaboration**: Multiple devs can work on different features
- **Lazy loading**: Features can be loaded on demand
- **Testing**: Easier to test features in isolation

### Why Cubit over Bloc?
- **Simplicity**: Cubit uses methods instead of events
- **Less boilerplate**: No need to define event classes
- **Sufficient for most cases**: Events are overkill for simple state changes
- **Easy to upgrade**: Can switch to Bloc if events are needed

### Why get_it?
- **Zero magic**: Explicit dependency registration
- **Type-safe**: Compile-time checks
- **Fast**: No code generation overhead
- **Flexible**: Supports singletons, factories, lazy loading

### Why go_router?
- **Declarative**: Routes defined in one place
- **Type-safe**: Path parameters validated at compile time
- **Deep linking**: Built-in support for URLs
- **StatefulShellRoute**: Maintains tab state automatically

## Data Flow

```
UI → Cubit → Repository → DataSource
 ↑      ↓
 └─ State
```

1. **UI** calls Cubit method
2. **Cubit** calls Repository
3. **Repository** fetches from DataSource
4. **Cubit** emits new State
5. **UI** rebuilds with new State

## Theme System

All colors defined in `AppTheme`:
- Light theme
- Dark theme
- Rarity colors
- No inline colors allowed

Switch theme: Settings → System (auto), Light, or Dark

## Mascot System

### Rarity Levels
- **Common**: Gray, basic mascots
- **Rare**: Blue, uncommon finds
- **Epic**: Purple, special mascots
- **Legendary**: Orange, ultra-rare

### Unlock Rules
- Max 1 mascot per day
- Countdown timer shows next unlock
- Locked mascots are blurred
- Unlock animation celebrates new mascots

## Future Enhancements

### Short-term
- [ ] Real GPS integration
- [ ] Map SDK (Google Maps / Mapbox)
- [ ] Persistent storage (Hive / Drift)
- [ ] Push notifications
- [ ] User authentication

### Long-term
- [ ] Backend API integration
- [ ] Real-time mascot spawning
- [ ] Friend system
- [ ] Trading system
- [ ] Leaderboards
- [ ] Achievements
- [ ] AR mode

## Testing Strategy

```
lib/
└── features/
    └── explore/
        ├── presentation/
        │   └── cubit/
        │       └── explore_cubit.dart
        └── test/
            ├── unit/
            │   └── explore_cubit_test.dart
            ├── widget/
            │   └── explore_page_test.dart
            └── integration/
                └── explore_flow_test.dart
```

## Contributing

When adding new features:
1. Create feature folder under `lib/features/`
2. Follow existing structure: `presentation/cubit/`, `pages/`, `widgets/`
3. Register dependencies in `injection_container.dart`
4. Add routes in `app_router.dart`
5. Run code generation if using freezed
6. Update this README

## Architecture Principles

1. **Separation of Concerns**: UI, Business Logic, Data are separate
2. **Dependency Inversion**: Depend on abstractions, not implementations
3. **Single Responsibility**: Each class has one reason to change
4. **Open/Closed**: Open for extension, closed for modification
5. **DRY**: Don't repeat yourself - extract common logic

## License

This project is private and not for public distribution.
