# Ayana Movies — README

## Overview

Ayana Movies is a Flutter application that showcases movie and TV content with a clean, modern interface. The UI is inspired by the “Movie Streaming App UI Kit” and adapted to fit the app’s architecture and data model.

- **Flutter Version:** 3.32.6
- **Dart SDK:** 3.8.1
- **UI Reference:** https://www.behance.net/gallery/198896501/Movie-Streaming-App-UI-Kit
- **State Management:** BLoC (via `flutter_bloc` + `equatable`)

## Requirements

- Flutter **3.32.6** (recommended to use FVM for version pinning)
- Dart **3.8.1**
- (Optional) Android Studio / Xcode for platform builds

## Quick Start

```bash
# If you use FVM
fvm use 3.32.6
fvm flutter --version

# Install dependencies
fvm flutter pub get

# Run on a device/emulator
fvm flutter run
```

If you are not using FVM, replace `fvm flutter` with `flutter`.

## Project Highlights

- **Architecture:** Presentation (BLoC) + Domain (Use Cases, Entities) + Data (Repositories, Data Sources)
- **State Management:** `flutter_bloc` for reactive UI states; `equatable` for value equality
- **Local Storage:** Hive (via simple `Prefs`) for language and onboarding flags
- **DI:** `get_it` for lightweight dependency injection

## Running Unit Tests

The project includes unit and BLoC tests for core flows (Movies, TV, Explore, Search, Detail, Onboarding).

```bash
# With FVM
fvm flutter test -r expanded

# Without FVM
flutter test -r expanded
```

> Tip: If you see the default `widget_test.dart` (Flutter template counter test) causing failures and you don’t use it, you can remove or skip that file.

### Typical Test Targets

- `MovieListBloc`: success & error states for popular movies
- `TvBloc`: success & error states for popular TV shows
- `ExploreBloc`: trending, search success/error
- `SearchBloc`: idle, loading, loaded, error
- `DetailBloc`: load detail (movie/TV) and toggle favorite
- `OnboardingBloc`: language choice and save flow

## Conventions

- **Foldering:** `presentation/bloc`, `domain/entities|usecases|repositories`, `data/models|repositories|datasources`
- **Equatable:** All states/events/entities implement `props` for predictable comparisons
- **Result Monad:** Simple `Ok`/`Err` wrapper to avoid exceptions in flows

## Notes

- The UI visuals are adapted from the Behance reference; actual components, spacing, and interactions may differ to match app architecture and platform constraints.
- Ensure emulator/runtime has network access if you connect to real APIs; otherwise use mocks for tests.

---
