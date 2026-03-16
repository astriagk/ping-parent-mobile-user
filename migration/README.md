# Architecture Migration Guide

## Overview

Ping Parent is being refactored from legacy architecture to clean architecture (domain/data/presentation + Riverpod).

**Approach:** Keep both `lib/` (old) and `lib_new/` (new) running simultaneously using feature flags. Build and test features one-by-one, then switch at the end.

**Status:** Architecture structure created ✅ | Code migration in progress 🔄

---

## Key Documents

| File | Purpose |
|---|---|
| **guides/flutter-architecture-guide.md** | Target structure + design patterns (Atomic Design, data flow, best practices) |
| **guides/migration-strategy.md** | Step-by-step migration with decision tables (what to copy, where to put it, how to modify) |
| **PROGRESS.md** | Track which features are completed |
| **architecture-refactoring.md** | Original tech debt document (Phase 1-4 improvements) |

---

## How It Works

### Parallel Architecture Approach

```
lib/              ← Existing code (ChangeNotifier providers)
lib_new/          ← New code (Riverpod providers)
main.dart         ← Single entry point (both architectures)

Feature Flags:
  useNewAuth = false           (OFF by default)
  useNewStudents = false
  useNewSubscriptions = false
  ... etc
```

**Workflow:**
1. Build feature in `lib_new/` (e.g., auth feature)
2. Set feature flag: `useNewAuth = false` → app uses old code ✅
3. Set feature flag: `useNewAuth = true` → app uses new code → test
4. If new code works → keep flag ON
5. If issues → keep flag OFF, fix, try again
6. Move to next feature
7. When all features done → delete `lib/`, keep `lib_new/` only

**Benefits:**
- ✅ No breaking changes during development
- ✅ Test each feature independently
- ✅ Easy rollback (just toggle boolean)
- ✅ Deploy to phone multiple times with different versions
- ✅ Safe for production app

## Quick Start

### 1. Setup (15 mins)
- Create `lib/core/config/feature_flags.dart` — toggle flags
- Update `lib/main.dart` — add ProviderScope + MultiProvider
- Update routing — conditional screens based on flags

### 2. Build First Feature (2-3 hours)
- Create `lib_new/features/auth/` (data → domain → presentation)
- Wire up routing to use new auth when flag is ON
- Build app, test on phone with old code
- Build app again, test on phone with new code

### 3. Repeat for Other Features (Phases 2-8)
- Same process for profile, students, subscriptions, trips, payments, notifications, approvals

### 4. Final Switch (when done)
- Verify all features work with new code
- Delete `lib/`
- Keep `lib_new/` as the main `lib/`

---

## Key Principles

✅ **Both architectures in same app** — use feature flags to switch
✅ **One feature at a time** — test old vs new before committing
✅ **Copy, don't move** — duplicate code into new structure, keep original
✅ **Feature flags control everything** — toggle boolean, rebuild, test
✅ **Build APK/IPA multiple times** — with different flags to compare behavior
✅ **Zero breaking changes** — app works perfectly the entire time

---

## Documents Overview

| Document | Purpose |
|---|---|
| **guides/flutter-architecture-guide.md** | Complete architecture blueprint (folder structure, patterns, design, data flow) |
| **guides/migration-strategy.md** | Decision tables (what to copy, where it goes, how to name things) |
| **PROGRESS.md** | Checklist to track feature completion |

---

## Current State

✅ **Existing code in `lib/`** — untouched, works perfectly
✅ **New structure in `lib_new/`** — ready to build
✅ **Feature flags** — template provided below
✅ **Main guides** — `flutter-architecture-guide.md` + `migration-strategy.md`

## Next Steps

### 1. Create Feature Flags File
Create `lib/core/config/feature_flags.dart`:
```dart
class FeatureFlags {
  static const bool useNewAuth = false;
  static const bool useNewProfile = false;
  static const bool useNewStudents = false;
  static const bool useNewSubscriptions = false;
  static const bool useNewTrips = false;
  static const bool useNewPayments = false;
  static const bool useNewNotifications = false;
  static const bool useNewApprovals = false;  // True = new only (no old version)

  // Toggle all at once for testing
  static const bool useAllNew = false;
}
```

### 2. Update main.dart
Add both `ProviderScope` (Riverpod) and `MultiProvider` (old):
```dart
void main() async {
  runApp(
    ProviderScope(
      child: MultiProvider(
        providers: [
          // All old providers...
        ],
        child: const MyApp(),
      ),
    ),
  );
}
```

### 3. Update Routing
Conditional screens based on feature flags:
```dart
if (FeatureFlags.useNewAuth) {
  return const lib_new.features.auth.presentation.screens.SignInScreen();
} else {
  return const SignInScreen(); // from lib/screens/auth_screen
}
```

### 4. Start Building Features
- Follow `guides/migration-strategy.md`
- Create features in `lib_new/features/`
- Test with flags ON/OFF
- Move to next feature

## Timeline

| Phase | Time | What |
|---|---|---|
| **Setup** | 1-2 hours | Create feature flags, update main.dart, update routing |
| **Each Feature** | 2-3 hours | Build in lib_new/, test with flag ON/OFF |
| **8 Features** | ~16-24 hours | Auth, profile, students, subscriptions, trips, payments, notifications, approvals |
| **Final** | 1 hour | Delete lib/, verify all works |

**Total:** ~20-30 hours of focused work (spread over weeks)

