# Using Both lib/ and lib_new/ Simultaneously in Same App

**Great idea!** You can have BOTH architectures running in the same app and switch between them dynamically.

---

## How It Works

### Current Setup

```
lib/             ← Legacy code (ChangeNotifier providers)
lib_new/         ← New architecture (Riverpod providers)
main.dart        ← Single entry point
```

### Strategy: Feature Flags

When you build a feature in `lib_new/`, you use a **feature flag** to choose which version to use:

```dart
// main.dart
const bool USE_NEW_AUTH = false;      // Toggle this to switch
const bool USE_NEW_STUDENTS = false;
const bool USE_NEW_SUBSCRIPTIONS = false;
// ... etc for each feature

// In routing or widget building:
if (USE_NEW_AUTH) {
  // Use: lib_new/features/auth/presentation/screens/sign_in_screen.dart
} else {
  // Use: lib/screens/auth_screen/sign_in_screen.dart
}
```

---

## Example: How to Add Both Providers

### Step 1: Wrap in Both ProviderScope + MultiProvider

**`lib/main.dart`:**

```dart
void main() async {
  runApp(
    ProviderScope(                    // NEW: Riverpod (for lib_new/ code)
      child: MultiProvider(           // OLD: Provider (for lib/ code)
        providers: [
          // OLD providers from lib/
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => StudentProvider()),
          // ... other old providers
        ],
        child: const MyApp(),
      ),
    ),
  );
}
```

This way:
- **Old code** uses `MultiProvider` (ChangeNotifier)
- **New code** uses `ProviderScope` (Riverpod)
- Both run simultaneously, no conflicts

### Step 2: Create Feature Flag Config

**`lib/core/config/feature_flags.dart`:**

```dart
class FeatureFlags {
  // Auth feature
  static const bool useNewAuth = false;

  // Profile feature
  static const bool useNewProfile = false;

  // Students feature
  static const bool useNewStudents = false;

  // Subscriptions feature
  static const bool useNewSubscriptions = false;

  // Trips feature
  static const bool useNewTrips = false;

  // Payments feature
  static const bool useNewPayments = false;

  // Notifications feature
  static const bool useNewNotifications = false;

  // Approvals feature
  static const bool useNewApprovals = true; // NEW feature only in lib_new/

  // Toggle all at once (for testing)
  static const bool useAllNew = false;
}
```

### Step 3: Conditional Routing

**`lib/routes/route_method.dart`** or **`lib/core/router/app_router.dart`:**

```dart
import 'package:app/core/config/feature_flags.dart';

class AppRoute {
  static Widget getAuthScreen() {
    if (FeatureFlags.useNewAuth || FeatureFlags.useAllNew) {
      // Use new implementation
      return const lib_new.features.auth.presentation.screens.SignInScreen();
    } else {
      // Use old implementation
      return const SignInScreen(); // from lib/screens/auth_screen/
    }
  }

  static Widget getStudentsScreen() {
    if (FeatureFlags.useNewStudents || FeatureFlags.useAllNew) {
      return const lib_new.features.students.presentation.screens.StudentListScreen();
    } else {
      return const StudentListScreen(); // from lib/screens/app_pages/student_screen/
    }
  }

  // ... similar for all other features
}
```

### Step 4: Test Each Feature Individually

**Day 1:**
- Build auth in `lib_new/`
- Set `useNewAuth = false` → app uses old auth ✅
- Set `useNewAuth = true` → app uses new auth ✅
- Compare both in phone
- If new works → keep flag ON
- If issues → keep flag OFF, fix, try again

**Day 2:**
- Build students in `lib_new/`
- Set `useNewStudents = false` → app uses old students
- Set `useNewStudents = true` → app uses new students
- Test and toggle as needed

---

## Full Example: main.dart with Both Architectures

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/feature_flags.dart';
import 'routes/route_method.dart';

// Old providers
import 'provider/auth_providers/auth_provider.dart';
import 'provider/app_pages_providers/user_provider.dart';
import 'provider/app_pages_providers/add_student_provider.dart';
// ... other old providers

void main() async {
  runApp(
    ProviderScope(  // NEW: For lib_new/ features (Riverpod)
      child: MultiProvider(  // OLD: For lib/ features (ChangeNotifier)
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => StudentProvider()),
          ChangeNotifierProvider(create: (_) => SubscriptionsProvider()),
          ChangeNotifierProvider(create: (_) => TripTrackingProvider()),
          ChangeNotifierProvider(create: (_) => NotificationProvider()),
          // ... all other old providers
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreen(),
      routes: {
        '/auth': (context) => AppRoute.getAuthScreen(),
        '/students': (context) => AppRoute.getStudentsScreen(),
        '/profile': (context) => AppRoute.getProfileScreen(),
        '/subscriptions': (context) => AppRoute.getSubscriptionsScreen(),
        '/trips': (context) => AppRoute.getTripsScreen(),
        '/payments': (context) => AppRoute.getPaymentsScreen(),
        '/notifications': (context) => AppRoute.getNotificationsScreen(),
        '/approvals': (context) => AppRoute.getApprovalsScreen(),
      },
    );
  }
}
```

---

## Workflow with Feature Flags

### Timeline

```
Day 1:
  lib/             ✅ Working (old auth, old students, etc.)
  lib_new/         🏗️ Building (new auth ready)
  Feature Flags:   useNewAuth = false
  Phone:           Uses old auth ✅

Day 2:
  Feature Flags:   useNewAuth = true
  Phone:           Uses new auth → test it ✅ or ❌

If ✅ (new auth works):
  Keep: useNewAuth = true
  Move to next feature

If ❌ (new auth broken):
  Keep: useNewAuth = false
  Fix new auth code in lib_new/
  Try again later

Day 3:
  lib_new/         🏗️ Building (new students ready)
  Feature Flags:   useNewStudents = false (initially)
  Phone:           Uses old students ✅

Then toggle:
  Feature Flags:   useNewStudents = true
  Phone:           Uses new students → test it
```

---

## Benefits of This Approach

✅ **Test in real device** — build APK/IPA with feature flags on/off
✅ **Easy rollback** — just toggle boolean, rebuild
✅ **Compare side-by-side** — test old vs new without code changes
✅ **No breaking changes** — keep old code safe in `lib/`
✅ **Zero app downtime** — never pause development
✅ **Flexible timeline** — work on features at your own pace
✅ **Easy debugging** — toggle to see which version has the issue

---

## Implementation Checklist

### Phase 0: Setup
- [ ] Create `lib/core/config/feature_flags.dart`
- [ ] Update `lib/main.dart` with both `ProviderScope` + `MultiProvider`
- [ ] Update routing to use feature flags conditionally
- [ ] Run app: verify both old code works

### Phase 1: Migrate Auth
- [ ] Build auth in `lib_new/features/auth/`
- [ ] Create conditional logic in `AppRoute.getAuthScreen()`
- [ ] Build app with `useNewAuth = false` → test old auth ✅
- [ ] Build app with `useNewAuth = true` → test new auth ✅
- [ ] If new works, keep flag ON
- [ ] If issues, keep flag OFF, fix, try again

### Phase 2-8: Repeat for Each Feature
- Same pattern for profile, students, subscriptions, trips, payments, notifications

### Final: Switch All at Once
When all features are tested and working:
```dart
// In feature_flags.dart, set all to true:
static const bool useNewAuth = true;
static const bool useNewProfile = true;
static const bool useNewStudents = true;
// ... etc
```

Then:
```bash
# When confident everything works:
# Delete lib/ and rename lib_new/ to lib/
mv lib/ lib_backup/
mv lib_new/ lib/
```

---

## Advanced: Build Variants

If you want to be even more sophisticated, you can use **build variants**:

```bash
# Build with old architecture
flutter run --dart-define=USE_NEW_FEATURES=false

# Build with new architecture
flutter run --dart-define=USE_NEW_FEATURES=true
```

Then in code:
```dart
const bool useNewFeatures = String.fromEnvironment('USE_NEW_FEATURES', defaultValue: 'false') == 'true';
```

This way you can **distribute two different APKs** to testers:
- One using all old code
- One using all new code

---

## TL;DR

**Yes, you can use both simultaneously:**

1. Keep both `lib/` and `lib_new/` in the project
2. Wrap app in both `ProviderScope` (Riverpod) + `MultiProvider` (old Provider)
3. Use feature flags to toggle which version to use
4. Test each migrated feature before moving to next
5. Build APK/IPA multiple times with different flag values
6. When everything works, delete old code and keep new code

**This is the safest approach** for a production app.

