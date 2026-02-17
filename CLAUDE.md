# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Ping Parent — a Flutter mobile app for parents in a ride-sharing/school-transport system. Parents manage students, track trips in real-time, handle subscriptions, and make payments via Razorpay.

## Common Commands

```bash
flutter pub get              # Install dependencies
flutter run                  # Run on default device
flutter run -d <device-id>   # Run on specific device
flutter analyze              # Lint (uses flutter_lints)
flutter test                 # Run tests
flutter build apk            # Build Android APK
flutter build appbundle      # Build Android App Bundle
flutter clean && rm pubspec.lock && flutter pub get  # Full clean rebuild
```

## Architecture

**State Management:** Provider + ChangeNotifier (MVVM-like). ~30 providers registered in `MultiProvider` in `main.dart`.

**Layer Structure:**
- `lib/api/` — HTTP client (`ApiClient` wrapping `http` package), endpoint constants, service interfaces, service implementations, response models. Manual JSON serialization (`fromJson` constructors) — no code generation.
- `lib/provider/` — ChangeNotifier providers organized by feature (`auth_providers/`, `app_pages_providers/`, `bottom_provider/`, `common_providers/`).
- `lib/screens/` — UI screens split into `auth_screen/`, `bottom_screen/` (tab pages), and `app_pages/` (feature screens). Each screen is typically a StatefulWidget using `Consumer<T>` for state.
- `lib/widgets/` — Reusable UI components.
- `lib/routes/` — Named route navigation. `route_name.dart` defines constants, `route_method.dart` maps routes to widgets, `screen_list.dart` exports screens.
- `lib/common/` — Theme system (`AppTheme` with light/dark), localization (`LanguageProvider` with RTL support), responsive utilities (`ScreenUtil`), session management, extensions.
- `lib/config.dart` — Global helper functions (see below).

**API Layer:** Services implement interfaces (e.g., `UserServiceInterface` → `UserService`). `ApiClient` auto-injects Bearer token from session. Base URL configured in `lib/api/endpoints.dart`.

**Real-time:** Socket.IO (`socket_io_client`) for trip tracking and position updates.

**Payments:** Razorpay Flutter SDK integration.

## Key Global Helpers (`config.dart`)

```dart
appColor(context)            // Access ThemeService
language(context, text)      // Translate text via localization
currency(context)            // Access CurrencyProvider
showLoading(context)         // Show loading dialog
hideLoading(context)         // Hide loading dialog
isNetworkConnection()        // Check internet connectivity
```

## Conventions

- Dart SDK constraint: `>=3.3.4 <4.0.0`
- No code generation — all models are hand-written with `fromJson()`/`toJson()`
- Navigation uses named routes: `route.pushNamed(context, routeName.screenName)`
- Responsive sizing via `ScreenUtil` and `Sizes` constants
- Session data in `SharedPreferences`; credentials in `FlutterSecureStorage`
- Orientation locked to portrait
