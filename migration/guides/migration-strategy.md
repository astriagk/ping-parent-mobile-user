# Migration Strategy: Feature-by-Feature (Non-Breaking)

**Approach:** Keep all old code. Build new structure alongside. Test incrementally. Delete old code only at the very end.

---

## The Golden Rule

> **Never delete old code during migration.**
>
> Old code and new code coexist. When a feature is done, you only change the router to point to the new screen.
> Delete old code only after everything works and is tested.

---

## Overall Folder Layout (During & After Migration)

### During Migration
```
lib/
├── core/           ← NEW (infrastructure)
├── features/       ← NEW (migrated features)
├── shared/         ← NEW (reusable widgets)
├── api/            ← OLD (untouched)
├── provider/       ← OLD (untouched)
├── screens/        ← OLD (untouched)
├── widgets/        ← OLD (untouched)
└── common/, helper/ ← OLD (untouched)
```

### After Migration Complete
```
lib/
├── core/           ← Moved from old + new
├── features/       ← All features
├── shared/         ← Reusable widgets
└── l10n/           ← Localization
```

Old folders deleted: `api/`, `provider/`, `screens/`, `widgets/`, `common/`, `helper/`, `models/`, `routes/`

---

## Decision Table: What to Copy vs Create

For each file in your old code, here's where it goes and how to handle it:

### Core Infrastructure (Copy Files As-Is)

| Old File | New Location | Action |
|---|---|---|
| `lib/api/api_client.dart` | `lib/core/network/api_client.dart` | Copy — no changes |
| `lib/api/interceptors/auth_interceptor.dart` | `lib/core/network/interceptors/auth_interceptor.dart` | Copy — no changes |
| `lib/api/endpoints.dart` | `lib/core/constants/api_endpoints.dart` | Copy, rename class if needed |
| `lib/api/enums/socket_events.dart` | `lib/core/constants/enums/socket_events.dart` | Copy all enum files |
| `lib/api/services/storage_service.dart` | `lib/core/services/storage_service.dart` | Copy — already well-designed |
| `lib/api/services/trip_websocket_service.dart` | `lib/core/network/socket_client.dart` | Copy, rename class |
| `lib/common/extension/context_extensions.dart` | `lib/core/extensions/context_extensions.dart` | Copy all extension files |
| `lib/common/theme/app_theme.dart` | `lib/core/theme/app_theme.dart` | Copy all theme files |
| `lib/common/theme/app_css.dart` | `lib/core/theme/app_text_styles.dart` | Copy as text styles |
| `lib/common/screen_util/` | `lib/core/utils/screen_util/` | Copy entire folder |
| `lib/helper/date_formatter_helper.dart` | `lib/core/utils/date_formatter.dart` | Copy |
| `lib/helper/distance_helper.dart` | `lib/core/utils/distance_helper.dart` | Copy |

### New Error Handling (Create Fresh)

| File | Location | Purpose |
|---|---|---|
| `exceptions.dart` | `lib/core/errors/` | Define `ServerException`, `NetworkException`, `CacheException` |
| `failures.dart` | `lib/core/errors/` | Define sealed `Failure` class + subclasses |

### Shared Widgets (Extract & Organize)

#### Atoms (copy with simplification)
| Old File | New Location | How to Handle |
|---|---|---|
| `lib/widgets/common_button.dart` | `lib/shared/widgets/atoms/app_button.dart` | Simplify: add `variant: ButtonVariant.primary \| outline \| text` param |
| `lib/widgets/text_form_filed_common.dart` | `lib/shared/widgets/atoms/app_text_field.dart` | Keep raw input only, no label |
| `lib/widgets/common_divider.dart` | `lib/shared/widgets/atoms/app_divider.dart` | Copy as-is |
| `lib/widgets/loading/loading_component.dart` | `lib/shared/widgets/atoms/app_loader.dart` | Rename, simplify to one spinner |
| `lib/widgets/skeletons/*` (4 files) | `lib/shared/widgets/atoms/app_skeleton.dart` | Merge into one base skeleton; specific skeletons go in feature folders |

#### Molecules (combine atoms)
| What | Where | How |
|---|---|---|
| Label + TextField + error | `lib/shared/widgets/molecules/labeled_text_field.dart` | Extract from StudentWidgets + ProfileWidgets (currently duplicated) |
| TextField + search icon | `lib/shared/widgets/molecules/search_bar.dart` | Combine from text field + icon |
| Avatar + name + status | `lib/shared/widgets/molecules/avatar_with_label.dart` | New, combine atoms |
| Icon button + label | `lib/shared/widgets/molecules/labeled_icon_button.dart` | New if used in multiple features |

#### Organisms (complex standalone)
| Old | New | How |
|---|---|---|
| `lib/widgets/common_app_bar_layout.dart` + `common_app_bar_layout1.dart` | `lib/shared/widgets/organisms/app_header.dart` | Merge two variants into one with params |
| `lib/widgets/common_empty_state.dart` | `lib/shared/widgets/organisms/empty_state.dart` | Copy, rename |
| `lib/widgets/common_error_state.dart` | `lib/shared/widgets/organisms/error_state.dart` | Copy, rename |
| `lib/widgets/common_confirmation_dialog.dart` | `lib/shared/widgets/organisms/confirmation_dialog.dart` | Copy, rename |
| `lib/widgets/loading/payment_loading_overlay.dart` | `lib/shared/widgets/organisms/loading_overlay.dart` | Generalize payment-specific logic |
| `lib/widgets/redeem_code_dialog.dart` | `lib/features/subscriptions/presentation/widgets/redeem_code_dialog.dart` | Move to subscriptions feature |

#### Feature-Specific Widgets (Stay in Feature Folder)
| Old | New | Decision |
|---|---|---|
| `lib/widgets/subscription_card/` (6 part files) | `lib/features/subscriptions/presentation/widgets/subscription_card.dart` | Move & consolidate 6 files → 1 |
| `lib/widgets/ride_card/` (5 part files) | `lib/features/trips/presentation/widgets/trip_card.dart` | Move & consolidate 5 files → 1 |
| `lib/widgets/offers_card/` | `lib/features/subscriptions/presentation/widgets/offers_card.dart` | Move to subscriptions |
| `lib/widgets/maps/` | `lib/features/trips/presentation/widgets/maps/` | Move entire folder |
| `lib/widgets/country_picker_custom/` | `lib/features/auth/presentation/widgets/country_picker/` | Move to auth |

### Service Interfaces → Repository Interfaces

| Old | New | How |
|---|---|---|
| `lib/api/interfaces/auth_service_interface.dart` | `lib/features/auth/domain/repositories/auth_repository.dart` | Rename, move to domain |
| `lib/api/interfaces/user_service_interface.dart` | `lib/features/profile/domain/repositories/profile_repository.dart` | Move to profile feature |
| Same for all 7 interfaces | Feature domain repos | One repo interface per feature |

### Service Implementations → Datasources + Repositories

| Old | New | How |
|---|---|---|
| `lib/api/services/auth_service.dart` | `lib/features/auth/data/datasources/auth_remote_datasource.dart` | Rename class: AuthService → AuthRemoteDataSource |
| Same for 13 services | Feature datasources | One datasource per service |

Then create:
| New | Where | What |
|---|---|---|
| `auth_repository_impl.dart` | `lib/features/auth/data/repositories/` | Wraps datasource, converts exceptions to failures |
| Same for all | Feature repositories | One per feature |

### Response Models → Feature Models

| Old | New | How |
|---|---|---|
| `lib/api/models/send_otp_response.dart` | `lib/features/auth/data/models/send_otp_response_model.dart` | Copy, class name → `SendOtpResponseModel` |
| `lib/api/models/student_response.dart` | `lib/features/students/data/models/student_response_model.dart` | Copy |
| Same for all 20 models | Feature data/models | One folder per feature |

### Providers → Riverpod Providers (Rewrite)

| Old | New | How |
|---|---|---|
| `lib/provider/auth_providers/sign_in_provider.dart` | `lib/features/auth/presentation/providers/auth_provider.dart` | Rewrite: `ChangeNotifier` → `AsyncNotifier<User>` |
| `lib/provider/app_pages_providers/user_provider.dart` | `lib/features/profile/presentation/providers/profile_provider.dart` | Rewrite |
| All 30 providers | Feature presentation/providers | One notifier per major state |

### Screens → Feature Screens (Copy + Update)

| Old | New | How |
|---|---|---|
| `lib/screens/auth_screen/sign_in_screen.dart` | `lib/features/auth/presentation/screens/sign_in_screen.dart` | Copy, update imports, use `ref.watch()` instead of `Consumer<T>` |
| `lib/screens/app_pages/student_screen/` | `lib/features/students/presentation/screens/` | Copy folder, update imports |
| Same for all screens | Feature presentation/screens | One folder per feature |

### Routes → Core Router (Migrate When Ready)

| Old | New | How |
|---|---|---|
| `lib/routes/route_name.dart` (44 constants) | `lib/core/router/route_names.dart` | Start with empty, migrate routes as features are done |
| `lib/routes/route_method.dart` | `lib/core/router/app_router.dart` | Convert to go_router (optional, can stay manual for now) |

---

## Phase 0: One-Time Setup (30-60 mins)

Do this once. It doesn't break anything.

### 0.1 Create core/ directory structure
```bash
mkdir -p lib/core/{constants/enums,errors,extensions,network/interceptors,router,services,theme,utils/screen_util}
```

### 0.2 Copy infrastructure files from old code

Use the table above. Copy:
- `api/` → `core/network/` + `core/constants/`
- `common/` → `core/`
- `helper/` → `core/utils/`

### 0.3 Create error classes (NEW files)

**`lib/core/errors/exceptions.dart`:**
```dart
class ServerException implements Exception {
  final String message;
  final int? statusCode;
  ServerException({required this.message, this.statusCode});
}

class NetworkException implements Exception {
  final String message;
  NetworkException({required this.message});
}

class CacheException implements Exception {
  final String message;
  CacheException({required this.message});
}
```

**`lib/core/errors/failures.dart`:**
```dart
sealed class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure(super.message);
}

class NetworkFailure extends Failure {
  NetworkFailure(super.message);
}

class CacheFailure extends Failure {
  CacheFailure(super.message);
}
```

### 0.4 Create router files (empty for now)

**`lib/core/router/route_names.dart`:**
```dart
class RouteNames {
  // Routes will be added here as features migrate
}
```

**`lib/core/router/app_router.dart`:**
```dart
// Empty for now, or start with manual routes if you prefer
// Will migrate to go_router later if desired
```

### 0.5 Update `main.dart` to add ProviderScope

```dart
void main() async {
  runApp(
    ProviderScope(        // ADD THIS
      child: MultiProvider( // Keep existing
        providers: [...],
        child: const MyApp(),
      ),
    ),
  );
}
```

Then run `flutter pub add riverpod flutter_riverpod`.

### 0.6 Create shared/widgets directory structure
```bash
mkdir -p lib/shared/widgets/{atoms,molecules,organisms,templates}
```

---

## Phase 1: Migrate First Feature (Auth)

### 1.1 Create Feature Folder Structure
```bash
mkdir -p lib/features/auth/{data/datasources,data/models,data/repositories,domain/entities,domain/repositories,domain/usecases,presentation/providers,presentation/screens,presentation/widgets}
```

### 1.2 Copy Data Files

**Copy `lib/api/services/auth_service.dart` → `lib/features/auth/data/datasources/auth_remote_datasource.dart`**
- Change class name: `AuthService` → `AuthRemoteDataSource`
- Constructor still takes `ApiClient` (import from `core/network/api_client.dart`)
- Update method names if needed (optional)

**Copy `lib/api/models/send_otp_response.dart` → `lib/features/auth/data/models/send_otp_response_model.dart`**
- Change class name: `SendOtpResponse` → `SendOtpResponseModel`
- Update imports

### 1.3 Create Domain Layer (NEW)

**`lib/features/auth/domain/entities/user.dart`:**
```dart
class User {
  final String id;
  final String name;
  final String? phoneNumber;
  final String? userType;

  User({
    required this.id,
    required this.name,
    this.phoneNumber,
    this.userType,
  });
}
```

**`lib/features/auth/domain/repositories/auth_repository.dart`:**
```dart
abstract interface class AuthRepository {
  Future<(User, String token)> sendOtp(String phone);
  Future<(User, String token)> verifyOtp(String phone, String otp);
  Future<void> logout();
}
```

**`lib/features/auth/domain/usecases/send_otp_usecase.dart`:**
```dart
class SendOtpUseCase {
  final AuthRepository _repository;
  SendOtpUseCase(this._repository);

  Future<(User, String)> call(String phone) => _repository.sendOtp(phone);
}
```

(Same for `verify_otp_usecase.dart`, `logout_usecase.dart`)

### 1.4 Create Data Repository Implementation

**`lib/features/auth/data/repositories/auth_repository_impl.dart`:**
```dart
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _datasource;
  final StorageService _storage;

  AuthRepositoryImpl(this._datasource, this._storage);

  @override
  Future<(User, String)> sendOtp(String phone) async {
    try {
      final model = await _datasource.sendOtp(phone);
      // Return User entity + token
      return (User(...), model.token);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }
}
```

### 1.5 Create Riverpod Providers

**`lib/features/auth/presentation/providers/auth_provider.dart`:**
```dart
final authRemoteDataSourceProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRemoteDataSource(apiClient);
});

final authRepositoryProvider = Provider((ref) {
  final datasource = ref.watch(authRemoteDataSourceProvider);
  final storage = ref.watch(storageServiceProvider);
  return AuthRepositoryImpl(datasource, storage);
});

final sendOtpUseCaseProvider = Provider((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return SendOtpUseCase(repo);
});

class AuthNotifier extends AsyncNotifier<User?> {
  @override
  Future<User?> build() async {
    // Load current user from storage
    return null;
  }

  Future<void> sendOtp(String phone) async {
    state = const AsyncLoading();
    final useCase = ref.watch(sendOtpUseCaseProvider);
    state = await AsyncValue.guard(() async {
      final (user, token) = await useCase.call(phone);
      // Save token to storage
      return user;
    });
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, User?>(AuthNotifier.new);
```

### 1.6 Copy & Update Screens

**Copy `lib/screens/auth_screen/sign_in_screen.dart` → `lib/features/auth/presentation/screens/sign_in_screen.dart`**

**Update the screen to use Riverpod:**
```dart
// OLD:
Consumer<AuthProvider>(
  builder: (_, provider, __) => ElevatedButton(
    onPressed: () => provider.login(...),
  ),
)

// NEW:
ConsumerWidget build(context, ref) {
  return ElevatedButton(
    onPressed: () => ref.read(authProvider.notifier).sendOtp(...),
  );
}
```

### 1.7 Wire Router (Keep It Working)

**In `lib/routes/route_method.dart`:**
```dart
// Find the auth route
// OLD: case '/auth': return const SignInScreen(); // from lib/screens/auth_screen
// NEW: case '/auth': return const SignInScreen(); // from lib/features/auth/presentation/screens

// Just update the import:
import 'package:app/features/auth/presentation/screens/sign_in_screen.dart';
// instead of:
// import 'package:app/screens/auth_screen/sign_in_screen.dart';
```

### 1.8 Test
```bash
flutter run
# Navigate to auth → test login/logout
# Navigate to other features → should still work (using old code)
```

### 1.9 Commit
```bash
git add -A
git commit -m "feat(auth): migrate to clean architecture with Riverpod"
```

---

## Phase 2–8: Migrate Remaining Features

Repeat Phase 1 for each feature in this order:

| # | Feature | Notes |
|---|---|---|
| 2 | **profile** | Read-only, good for practice |
| 3 | **students** | CRUD operations |
| 4 | **subscriptions** | Complex, add caching here |
| 5 | **trips** | Add StreamProvider for WebSocket |
| 6 | **payments** | Razorpay integration |
| 7 | **notifications** | Simple read-only |
| 8 | **approvals** | NEW feature, build from scratch |

---

## Cleanup Phase (After All Features Done)

### Check Everything Works
```bash
flutter analyze     # 0 issues
flutter test        # all tests pass
flutter run         # manual QA
```

### Delete Old Code
```bash
rm -rf lib/api/
rm -rf lib/provider/
rm -rf lib/screens/
rm -rf lib/widgets/
rm -rf lib/common/
rm -rf lib/helper/
rm -rf lib/models/
rm -rf lib/routes/
```

### Update `main.dart`
```dart
// Remove MultiProvider, keep only ProviderScope
void main() async {
  runApp(
    ProviderScope(
      child: MaterialApp.router(
        routerConfig: ref.watch(appRouterProvider),
        // ...
      ),
    ),
  );
}
```

---

## Quick Reference: What Gets Copied vs Created

| Category | Action | Examples |
|---|---|---|
| **Core Infrastructure** | Copy as-is | api_client.dart, endpoints.dart, enums/, extensions/, theme/ |
| **Error Handling** | Create fresh | exceptions.dart, failures.dart |
| **Shared Widgets** | Extract & simplify | app_button.dart, app_text_field.dart, app_header.dart |
| **Feature Data** | Copy & rename | SendOtpResponseModel, AuthRemoteDataSource |
| **Domain Layer** | Create fresh | User entity, AuthRepository interface, SendOtpUseCase |
| **Repository Impls** | Create fresh | AuthRepositoryImpl wraps datasource |
| **Providers** | Rewrite | AsyncNotifier instead of ChangeNotifier |
| **Screens** | Copy & update | Change Consumer<T> to ref.watch() |
| **Routes** | Update imports | Point old route names to new screens |

---

## Testing Strategy During Migration

### Per Feature
- [ ] Unit test domain/entities, domain/usecases
- [ ] Widget test presentation/screens with mocked provider
- [ ] Manual: test happy path, error cases, edge cases

### After Each Feature
- [ ] Run full app
- [ ] Navigate to migrated feature → works?
- [ ] Navigate to non-migrated features → still work?
- [ ] No console errors or warnings?

### Full App After All Features
- [ ] `flutter analyze` → 0 errors
- [ ] `flutter test` → all tests pass
- [ ] Manual QA: all features, all flows

