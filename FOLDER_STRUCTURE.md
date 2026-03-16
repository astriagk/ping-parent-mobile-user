# Project Folder Structure Guide

## Overview
The project now has **two separate lib folders** for clean migration:

```
pp-mobile-user/
├── lib/                    ← EXISTING: Legacy code (original, unchanged)
├── lib_new/                ← NEW: Clean architecture (being built)
├── migration/              ← Migration guides & tracking
├── test/                   ← Tests (shared for both)
└── pubspec.yaml            ← Project config
```

---

## NEW Structure (`lib_new/`)

Fresh, clean architecture - being built incrementally.

```
lib_new/
├── main.dart               # Entry point (updated once with ProviderScope)
├── app.dart                # Root widget with go_router
│
├── core/                   # App infrastructure (copy from lib_old)
│   ├── constants/
│   │   ├── api_endpoints.dart
│   │   ├── app_colors.dart
│   │   ├── app_dimensions.dart
│   │   └── enums/
│   │       ├── socket_events.dart
│   │       ├── trip_status.dart
│   │       ├── trip_type.dart
│   │       ├── user_status.dart
│   │       └── vehicle_type.dart
│   ├── errors/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── extensions/
│   │   ├── context_extensions.dart
│   │   ├── string_extensions.dart
│   │   ├── text_extensions.dart
│   │   └── widget_extensions.dart
│   ├── network/
│   │   ├── api_client.dart
│   │   ├── socket_client.dart
│   │   └── interceptors/
│   │       └── auth_interceptor.dart
│   ├── router/
│   │   ├── app_router.dart
│   │   └── route_names.dart
│   ├── services/
│   │   ├── storage_service.dart
│   │   ├── secure_storage_service.dart
│   │   └── locale_service.dart
│   ├── theme/
│   │   ├── app_theme.dart
│   │   ├── app_text_styles.dart
│   │   └── theme_service.dart
│   └── utils/
│       ├── screen_util/
│       ├── date_formatter.dart
│       ├── distance_helper.dart
│       ├── validators.dart
│       └── logger.dart
│
├── features/               # Feature modules (8 features)
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── auth_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── send_otp_response_model.dart
│   │   │   │   └── verify_otp_response_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── user.dart
│   │   │   │   └── otp_data.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── send_otp_usecase.dart
│   │   │       ├── verify_otp_usecase.dart
│   │   │       └── logout_usecase.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── auth_provider.dart
│   │       ├── screens/
│   │       │   ├── sign_in_screen.dart
│   │       │   ├── otp_screen.dart
│   │       │   └── splash_screen.dart
│   │       └── widgets/
│   │
│   ├── profile/           # data/ → domain/ → presentation/
│   ├── students/          # data/ → domain/ → presentation/
│   ├── subscriptions/     # data/ → domain/ → presentation/
│   ├── trips/             # data/ → domain/ → presentation/
│   ├── payments/          # data/ → domain/ → presentation/
│   ├── notifications/     # data/ → domain/ → presentation/
│   └── approvals/         # data/ → domain/ → presentation/ (NEW)
│
├── shared/                # Reusable widgets (Atomic Design)
│   ├── widgets/
│   │   ├── atoms/         # Smallest building blocks
│   │   │   ├── app_button.dart
│   │   │   ├── app_text_field.dart
│   │   │   ├── app_icon.dart
│   │   │   ├── app_avatar.dart
│   │   │   ├── app_badge.dart
│   │   │   ├── app_chip.dart
│   │   │   ├── app_divider.dart
│   │   │   ├── app_loader.dart
│   │   │   ├── app_skeleton.dart
│   │   │   └── skeletons/
│   │   │       ├── skeleton_list_item.dart
│   │   │       └── skeleton_card.dart
│   │   ├── molecules/     # 2-3 atoms combined
│   │   │   ├── labeled_text_field.dart
│   │   │   ├── search_bar.dart
│   │   │   ├── list_tile_item.dart
│   │   │   ├── avatar_with_label.dart
│   │   │   └── confirmation_button_row.dart
│   │   ├── organisms/     # Complex standalone sections
│   │   │   ├── app_header.dart
│   │   │   ├── empty_state.dart
│   │   │   ├── error_state.dart
│   │   │   ├── loading_overlay.dart
│   │   │   ├── confirmation_dialog.dart
│   │   │   └── bottom_nav_bar.dart
│   │   └── templates/     # Full-page layouts (no data)
│   │       ├── scrollable_page.dart
│   │       ├── form_page.dart
│   │       └── tab_page.dart
│   └── providers/
│       ├── theme_provider.dart
│       └── locale_provider.dart
│
└── l10n/                  # Localization
    ├── app_en.arb
    ├── app_ar.arb
    ├── app_es.arb
    ├── app_fr.arb
    └── app_hi.arb
```

---

## EXISTING Structure (`lib/`)

**DO NOT MODIFY** — This is the reference implementation.

```
lib/
├── main.dart              # Original entry point
├── config.dart            # Global helpers
├── package_list.dart      # Package exports
├── firebase_options.dart  # Firebase config
├── api/                   # HTTP layer
│   ├── api_client.dart
│   ├── endpoints.dart
│   ├── enums/
│   ├── interceptors/
│   ├── interfaces/
│   ├── models/
│   └── services/
├── common/                # App-wide utilities
│   ├── assets/
│   ├── extension/
│   ├── languages/
│   ├── maps/
│   ├── screen_util/
│   ├── theme/
│   └── index.dart
├── models/                # UI models
├── helper/                # Helper utilities
├── provider/              # State management (ChangeNotifier)
│   ├── auth_providers/
│   ├── app_pages_providers/
│   ├── bottom_provider/
│   ├── common_providers/
│   └── index.dart
├── routes/                # Navigation
│   ├── route_name.dart
│   ├── route_method.dart
│   └── screen_list.dart
├── screens/               # UI screens
│   ├── auth_screen/
│   ├── bottom_screen/
│   ├── app_pages/
│   └── screens_extensions.dart
└── widgets/               # Reusable UI components
    ├── error/
    ├── loading/
    ├── location/
    ├── maps/
    ├── offers_card/
    ├── ride_card/
    ├── skeletons/
    ├── subscription_card/
    └── (30+ common widgets)
```

---

## Migration Workflow

### Phase 0: Setup
1. **Copy infrastructure from `lib/` to `lib_new/core/`**
   - lib/api/ → lib_new/core/network/ + lib_new/core/constants/
   - lib/common/ → lib_new/core/
   - lib/helper/ → lib_new/core/utils/

2. **Create error handling in `lib_new/core/errors/`**
   - exceptions.dart (new)
   - failures.dart (new)

3. **Create router in `lib_new/core/router/`**
   - app_router.dart (empty start)
   - route_names.dart (empty start)

4. **Update `lib_new/main.dart`**
   - Add ProviderScope wrapper
   - Run: `flutter pub add riverpod flutter_riverpod`

### Phases 1-8: Migrate Features
1. Copy service → datasource to `lib_new/features/X/data/datasources/`
2. Copy model → model to `lib_new/features/X/data/models/`
3. Create domain/entities/ (new, pure Dart)
4. Create domain/repositories/ (new, interface)
5. Create domain/usecases/ (new)
6. Create data/repositories/ (new, impl)
7. Create presentation/providers/ (rewrite as Riverpod)
8. Copy screen → screen (update to use new providers)
9. Update router to point to new screen
10. Test feature works
11. Commit

### Final: Switch & Cleanup
1. When all features migrated in `lib_new/`, swap folders:
   - `lib/` (old) → `lib_backup/`
   - `lib_new/` (new) → `lib/`
2. Run `flutter analyze` + `flutter test`
3. Manual QA all features
4. Delete `lib_backup/`

---

## What to Reference

| Question | Look In |
|---|---|
| How do I migrate a feature? | `migration/guides/migration-strategy.md` |
| What's the target structure? | `migration/guides/flutter-architecture-guide.md` |
| What have I completed? | `migration/PROGRESS.md` |
| Where do I copy this from? | `lib/` + `migration/guides/migration-strategy.md` Decision Table |

---

## Key Rules

✅ **`lib/`** — EXISTING code, reference only (don't edit unless fixing bugs)
✅ **`lib_new/`** — NEW code only, being built
✅ **Copy, don't move** — duplicate to new location first
✅ **One feature at a time** — test each before next
✅ **Swap at the end** — when everything works, rename folders

---

## Status

| Folder | Status |
|---|---|
| `lib/` | ✅ All original code intact |
| `lib_new/` | ✅ Fresh empty structure created |
| `migration/guides/` | ✅ Architecture + strategy documented |
| `migration/PROGRESS.md` | ✅ Tracking template ready |

