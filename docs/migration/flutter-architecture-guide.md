# Flutter Best-Practice Architecture Guide

**Status:** Reference guide for Ping Parent long-term maintainability
**State Management:** Riverpod (AsyncNotifier / Notifier)
**Real-time:** Socket.IO / WebSocket for live data, API polling for approval updates
**Scope:** Independent mobile app structure; features don't import each other directly

---

## Recommended Folder Structure

```
lib/
├── main.dart                         # Bootstrap: ProviderScope, app config
├── app.dart                          # MaterialApp.router + go_router config
│
├── core/                             # App infrastructure — never feature-specific
│   ├── constants/
│   │   ├── api_endpoints.dart        # All API URL constants
│   │   ├── app_strings.dart
│   │   ├── app_dimensions.dart
│   │   ├── app_colors.dart
│   │   └── enums/                    # Keep from current api/enums/
│   │       ├── socket_events.dart
│   │       ├── trip_status.dart
│   │       └── ...
│   ├── errors/
│   │   ├── exceptions.dart           # ServerException, NetworkException, CacheException
│   │   └── failures.dart             # Sealed class: ServerFailure, NetworkFailure, CacheFailure
│   ├── extensions/                   # Move from common/extension/
│   │   ├── string_extensions.dart
│   │   ├── context_extensions.dart
│   │   ├── datetime_extensions.dart
│   │   └── widget_extensions.dart
│   ├── network/
│   │   ├── api_client.dart           # Dio-based HTTP client (or keep http wrapper)
│   │   ├── interceptors/
│   │   │   ├── auth_interceptor.dart # Auto-inject Bearer, handle 401, refresh token
│   │   │   └── logging_interceptor.dart
│   │   ├── socket_client.dart        # Socket.IO singleton (move from api/services/)
│   │   └── network_info.dart         # connectivity_plus wrapper
│   ├── router/
│   │   ├── app_router.dart           # go_router route definitions + auth guards
│   │   └── route_names.dart          # Route path constants
│   ├── services/
│   │   ├── storage_service.dart      # Keep from api/services/ — already good
│   │   ├── secure_storage_service.dart
│   │   ├── locale_service.dart       # Move from common/languages/
│   │   └── analytics_service.dart    # Firebase + FCM wrapper
│   ├── theme/                        # Move from common/theme/
│   │   ├── app_theme.dart
│   │   ├── app_text_styles.dart
│   │   └── app_colors.dart
│   └── utils/
│       ├── screen_util.dart          # Move from common/screen_util/ (custom responsive sizing)
│       ├── validators.dart
│       ├── date_formatter_helper.dart   # Move from helper/
│       ├── distance_helper.dart
│       └── logger.dart
│
├── features/                         # Vertical slices — one folder per feature
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── auth_remote_datasource.dart   # Calls ApiClient, returns models
│   │   │   ├── models/
│   │   │   │   ├── login_request_model.dart      # toJson() for request body
│   │   │   │   ├── verify_otp_request_model.dart
│   │   │   │   ├── send_otp_response_model.dart  # fromJson() — extends domain entity
│   │   │   │   └── verify_otp_response_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart     # Concrete impl of AuthRepository interface
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── user.dart                     # Pure Dart; no JSON, no Flutter imports
│   │   │   │   ├── auth_token.dart
│   │   │   │   └── otp_data.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart          # abstract interface class
│   │   │   └── usecases/
│   │   │       ├── login_usecase.dart
│   │   │       ├── logout_usecase.dart
│   │   │       ├── send_otp_usecase.dart
│   │   │       └── verify_otp_usecase.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   ├── auth_provider.dart            # AsyncNotifier<User>
│   │       │   ├── otp_provider.dart             # Notifier<OtpState>
│   │       │   └── auth_riverpod.g.dart          # (optional codegen)
│   │       ├── screens/
│   │       │   ├── login_screen.dart
│   │       │   ├── otp_screen.dart
│   │       │   └── splash_screen.dart
│   │       └── widgets/                          # Feature-local only; reusable UI goes to shared/
│   │           └── login_form.dart
│   │
│   ├── students/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── student_remote_datasource.dart  # fetch, add, update, delete
│   │   │   ├── models/
│   │   │   │   ├── add_student_request_model.dart
│   │   │   │   └── student_response_model.dart     # extends domain Student entity
│   │   │   └── repositories/
│   │   │       └── student_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── student.dart
│   │   │   │   ├── school.dart
│   │   │   │   └── driver_assignment.dart
│   │   │   ├── repositories/
│   │   │   │   └── student_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_students_usecase.dart
│   │   │       ├── add_student_usecase.dart
│   │   │       ├── update_student_usecase.dart
│   │   │       └── delete_student_usecase.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   ├── student_list_provider.dart     # FutureProvider<List<Student>>
│   │       │   └── selected_student_provider.dart # Notifier<Student?>
│   │       ├── screens/
│   │       │   ├── student_list_screen.dart
│   │       │   ├── add_student_screen.dart
│   │       │   └── student_detail_screen.dart
│   │       └── widgets/
│   │           ├── student_card.dart
│   │           └── student_form.dart
│   │
│   ├── subscriptions/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── subscription_remote_datasource.dart
│   │   │   │   └── subscription_cache_datasource.dart  # Local Hive/SharedPrefs
│   │   │   ├── models/
│   │   │   │   ├── subscription_plan_model.dart
│   │   │   │   ├── active_subscription_model.dart
│   │   │   │   └── redeem_code_request_model.dart
│   │   │   └── repositories/
│   │   │       └── subscription_repository_impl.dart   # Checks cache first, then API
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── subscription_plan.dart
│   │   │   │   ├── active_subscription.dart
│   │   │   │   └── subscription_feature.dart
│   │   │   ├── repositories/
│   │   │   │   └── subscription_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_plans_usecase.dart
│   │   │       ├── get_active_subscription_usecase.dart
│   │   │       ├── get_recommendations_usecase.dart
│   │   │       ├── create_subscription_usecase.dart
│   │   │       ├── upgrade_subscription_usecase.dart
│   │   │       └── redeem_code_usecase.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   ├── subscription_plans_provider.dart
│   │       │   ├── active_subscription_provider.dart
│   │       │   └── redeem_code_provider.dart        # Called by approval flow
│   │       ├── screens/
│   │       │   ├── subscription_management_screen.dart
│   │       │   ├── plan_selection_screen.dart
│   │       │   └── redeem_code_screen.dart
│   │       └── widgets/
│   │           ├── subscription_card.dart           # Organism
│   │           ├── plan_comparison.dart
│   │           └── redeem_code_form.dart
│   │
│   ├── trips/                        # Real-time feature
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── trip_remote_datasource.dart      # REST: fetch trip details, etc.
│   │   │   │   └── trip_socket_datasource.dart      # Socket.IO: stream live positions
│   │   │   ├── models/
│   │   │   │   ├── trip_response_model.dart
│   │   │   │   ├── position_model.dart
│   │   │   │   └── trip_event_model.dart
│   │   │   └── repositories/
│   │   │       └── trip_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── trip.dart
│   │   │   │   ├── position.dart
│   │   │   │   └── trip_event.dart
│   │   │   ├── repositories/
│   │   │   │   └── trip_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_trip_usecase.dart
│   │   │       ├── watch_trip_position_usecase.dart  # returns Stream<Position>
│   │   │       └── accept_trip_usecase.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   ├── trip_list_provider.dart           # FutureProvider<List<Trip>>
│   │       │   └── trip_position_provider.dart       # StreamProvider<Position>
│   │       ├── screens/
│   │       │   ├── active_trips_screen.dart
│   │       │   └── trip_tracking_screen.dart
│   │       └── widgets/
│   │           ├── trip_card.dart
│   │           ├── live_map_widget.dart
│   │           └── position_update_overlay.dart
│   │
│   └── approvals/                    # Approval/redeem flow (cross-app coordination)
│       ├── data/
│       │   ├── datasources/
│       │   │   └── approval_remote_datasource.dart   # POST /approve, GET /status
│       │   ├── models/
│       │   │   ├── approval_request_model.dart
│       │   │   └── approval_status_model.dart
│       │   └── repositories/
│       │       └── approval_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   ├── approval_request.dart
│       │   │   └── approval_status.dart
│       │   ├── repositories/
│       │   │   └── approval_repository.dart
│       │   └── usecases/
│       │       ├── submit_approval_request_usecase.dart
│       │       └── get_approval_status_usecase.dart
│       └── presentation/
│           ├── providers/
│           │   ├── approval_status_provider.dart     # FutureProvider with manual refresh
│           │   └── approval_form_provider.dart
│           ├── screens/
│           │   └── approval_status_screen.dart
│           └── widgets/
│               └── approval_status_card.dart
│
├── shared/                           # Cross-feature reusable components
│   ├── widgets/
│   │   ├── atoms/                    # Smallest indivisible UI primitives
│   │   │   ├── app_button.dart       # variant: {primary, outline, text, disabled}
│   │   │   ├── app_text_field.dart   # Raw input field with label, hint, error
│   │   │   ├── app_icon.dart         # Wrapper for IconButton / Icon
│   │   │   ├── app_avatar.dart       # Image + circular border
│   │   │   ├── app_badge.dart        # Colored label badge
│   │   │   ├── app_chip.dart         # Chip with optional onDelete
│   │   │   ├── app_divider.dart      # Horizontal divider
│   │   │   ├── app_loader.dart       # CircularProgressIndicator / shimmer
│   │   │   ├── app_skeleton.dart     # Base shimmer box primitive (width/height/radius)
│   │   │   └── status_badge.dart     # Status-colored badge (pending/approved/rejected)
│   │   │
│   │   ├── molecules/                # 2–3 atoms composed together
│   │   │   ├── labeled_text_field.dart       # Label + TextField + error text + helper
│   │   │   ├── search_bar.dart               # TextField atom + search Icon atom
│   │   │   ├── list_tile_item.dart           # Avatar + title/subtitle + trailing widget
│   │   │   ├── avatar_with_label.dart        # Avatar + name + status indicator
│   │   │   ├── confirmation_button_row.dart  # CTA buttons (cancel/confirm)
│   │   │   └── empty_state_view.dart         # Illustration + message + optional CTA
│   │   │
│   │   ├── organisms/                # Complex, standalone UI sections
│   │   │   ├── app_header.dart       # Custom AppBar (avoid duplicate code)
│   │   │   ├── bottom_nav_bar.dart   # BottomNavigationBar wrapper
│   │   │   ├── empty_state.dart      # Full empty view (illustration + message)
│   │   │   ├── error_state.dart      # Error state with retry button
│   │   │   ├── loading_overlay.dart  # Full-screen loading dialog
│   │   │   ├── confirmation_dialog.dart
│   │   │   ├── date_time_picker.dart # Date/time selection UI
│   │   │   └── photo_picker.dart     # Camera/gallery picker sheet
│   │   │
│   │   └── templates/                # Full-page layout scaffolds (no data/logic)
│   │       ├── scrollable_page.dart  # SafeArea + SingleChildScrollView + padding
│   │       ├── form_page.dart        # Header + form body + sticky bottom CTA
│   │       └── tab_page.dart         # TabBar + TabBarView scaffold
│   │
│   ├── providers/
│   │   ├── theme_provider.dart       # Notifier<ThemeMode> — move from common/theme/
│   │   └── locale_provider.dart      # Notifier<Locale> — move from common/languages/
│   │
│   └── utils/
│       ├── debounce_mixin.dart       # Utilities shared across features
│       └── auto_refresh_mixin.dart   # Auto-refresh on screen enter (move from widgets/)
│
└── l10n/                             # Localization ARB files (move from common/languages/)
    ├── app_en.arb
    ├── app_ar.arb
    ├── app_es.arb
    ├── app_fr.arb
    └── app_hi.arb

test/
├── unit/
│   └── features/
│       ├── auth/domain/...
│       ├── students/domain/...
│       └── subscriptions/domain/...
├── widget/
│   └── features/
│       ├── auth/presentation/...
│       └── shared/widgets/...
└── integration/
```

---

## Atomic Design Widget Hierarchy

### Atoms (Smallest, always reusable)
- `app_button.dart` — accepts `variant: ButtonVariant.primary | outline | text`
- `app_text_field.dart` — just the input, no label
- `app_loader.dart` — spinner or shimmer primitive
- `app_skeleton.dart` — colored box with border radius (used to build skeletons)
- `status_badge.dart` — small status indicator (pending/approved/rejected/active)

**Ping Parent usage:** `StudentCard` is an **organism**; inside it, atoms for avatar, text, buttons.

### Molecules (2–3 atoms)
- `labeled_text_field.dart` = Label + TextField atom + error text
- `search_bar.dart` = TextField atom + Icon atom
- `list_tile_item.dart` = Avatar atom + Text title/subtitle + trailing widget
- `avatar_with_label.dart` = Avatar atom + name text + optional status atom
- `confirmation_button_row.dart` = Two `app_button` atoms (Cancel / Confirm)
- `empty_state_view.dart` = Image + message + optional CTA button atom

**Ping Parent duplication to eliminate:**
- `StudentWidgets.labeled_text_field` + `ProfileWidgets.labeled_text_field` → move to `molecules/labeled_text_field.dart`

### Organisms (Complex, standalone)
- `app_header.dart` — custom AppBar (replaces current `common_app_bar_layout.dart` + variants)
- `subscription_card.dart` — plan card with feature list + CTA (currently `subscription_card/subscription_card.dart` + 6 parts)
- `ride_card.dart` — ride summary card (currently `ride_card/ride_card.dart` + 4 parts)
- `empty_state.dart` — full empty state view
- `error_state.dart` — full error state with retry
- `confirmation_dialog.dart` — reusable confirm/cancel dialog
- `date_time_picker.dart` — calendar + time picker
- `photo_picker.dart` — camera/gallery picker bottom sheet

### Templates (Full page)
- `scrollable_page.dart` — `SafeArea` + `SingleChildScrollView` + padding
- `form_page.dart` — header + form body + sticky bottom CTA button
- `tab_page.dart` — `TabBar` + `TabBarView` scaffold

**Usage:** Screens extend templates + add specific content.

---

## Data Flow (Request → Response → Refresh)

### Example: Redeem Approval Code

```
User enters code in SubscriptionRedeemScreen
  └─ provider.redeemCode(code)
       └─ RedeemCodeUseCase.call(code)
            └─ SubscriptionRepository.redeemCode(code)
                 └─ SubscriptionRepositoryImpl
                      └─ SubscriptionRemoteDataSource.redeemCode(code)
                           └─ ApiClient.post('/subscriptions/redeem', body: {'code': code})
                                ← HTTP 200 response: {"success": true, "subscription": {...}}
                           ← RedeemCodeResponseModel.fromJson(response)
                      ← Either.Right(subscription)
            ← Either.Right(subscription)
       ← Update state: isLoading = false, redeemedSubscription = subscription
  ← Provider notifyListeners()
  ← Consumer rebuilds, shows success dialog
```

### Request/Response Layer Pattern

| Layer | File | Purpose | Example |
|---|---|---|---|
| **Presentation** | `redeem_code_screen.dart` | User taps button, calls provider method | `onPressed: () => ref.read(redeemCodeProvider.notifier).redeem(code)` |
| **Provider** | `redeem_code_provider.dart` | Notifier holding form state + loading | `class RedeemCodeNotifier extends Notifier<RedeemCodeState>` |
| **Use Case** | `redeem_code_usecase.dart` | Single action with typed input/output | `Future<Either<Failure, Subscription>> call(String code)` |
| **Repository** | `subscription_repository_impl.dart` | Hides data source (API or cache) | `if (cache.isValid()) return cache; else return apiDataSource.redeem(code)` |
| **Data Source** | `subscription_remote_datasource.dart` | Raw API call | `Future<RedeemCodeResponseModel> redeem(String code)` |
| **Model** | `redeem_code_response_model.dart` | JSON ↔ Dart | `factory RedeemCodeResponseModel.fromJson(Map json)` |
| **Entity** | `subscription.dart` | Pure Dart, no JSON | `class Subscription { final id; final planName; ... }` |

**Key:** Entity extends all the way back to the UI. Model extends Entity. Repository hands Entity to provider.

---

## Cross-App Approval Refresh Strategy

**Scenario:** User A requests approval (e.g., subscribe to a plan in one app) → User B (in **different** app) approves → User A's app auto-updates.

### Approach: Three layers

#### 1. Pull-to-Refresh (User-triggered)
```dart
// approval_status_screen.dart
RefreshIndicator(
  onRefresh: () => ref.refresh(approvalStatusProvider(requestId).future),
  child: Consumer(
    builder: (_, ref, __) {
      final status = ref.watch(approvalStatusProvider(requestId));
      return status.when(
        loading: () => ApprovalSkeleton(),
        error: (e, _) => ErrorState(error: e.toString()),
        data: (approval) => ApprovalStatusCard(approval: approval),
      );
    },
  ),
);
```

#### 2. Auto-Refresh on Screen Enter
```dart
// approval_status_provider.dart
final approvalStatusProvider = FutureProvider.family<Approval, String>((ref, id) {
  return ref.watch(approvalRepositoryProvider).getStatus(id);
});

// In screen's initState or didChangeDependencies
@override
void didChangeDependencies() {
  super.didChangeDependencies();
  ref.invalidate(approvalStatusProvider(id)); // Re-fetch every time screen is entered
}
```

#### 3. Polling (Background, optional)
```dart
// approval_status_provider.dart
final approvalStatusProvider = FutureProvider.family<Approval, String>((ref, id) {
  // Start timer when provider is first watched
  ref.onDispose(() {
    timer?.cancel();
  });

  timer = Timer.periodic(Duration(seconds: 15), (_) {
    ref.invalidateSelf(); // Re-run the provider
  });

  return ref.watch(approvalRepositoryProvider).getStatus(id);
});
```

**Best practice:** Combine #1 (user-triggered) + #2 (auto on screen enter). Only add #3 if you need true real-time without user action.

---

## Real-time Data (WebSocket / Socket.IO)

### Example: Live Trip Position Tracking

#### Data Source (Socket layer)
```dart
// trip_socket_datasource.dart
class TripSocketDataSource {
  final SocketClient socketClient;

  Stream<Position> watchPosition(String tripId) {
    return socketClient
        .on('trip:$tripId:position')
        .map((data) => PositionModel.fromJson(data));
  }
}
```

#### Provider (Riverpod)
```dart
// trip_position_provider.dart
final tripPositionProvider = StreamProvider.family<Position, String>((ref, tripId) {
  final socketDataSource = ref.watch(tripSocketDataSourceProvider);
  return socketDataSource.watchPosition(tripId);
});
```

#### Screen (Consumer)
```dart
// trip_tracking_screen.dart
Consumer(
  builder: (_, ref, __) {
    final position = ref.watch(tripPositionProvider(tripId));

    return position.when(
      loading: () => LiveMapSkeleton(),
      error: (e, _) => ErrorState(error: e.toString()),
      data: (pos) => LiveMapWidget(
        latitude: pos.latitude,
        longitude: pos.longitude,
        heading: pos.heading,
      ),
    );
  },
)
```

**Key:** No manual refresh needed. Every socket event automatically triggers a rebuild via Riverpod's reactivity.

---

## Gap Analysis: Current → Recommended

| Area | Current | Recommended | Migration Priority |
|---|---|---|---|
| **State Mgmt** | Provider + ChangeNotifier (30 providers) | Riverpod (AsyncNotifier / Notifier) | HIGH — enables rest of refactor |
| **Architecture** | No domain layer | `domain/entities/`, `domain/usecases/`, `domain/repositories/` | HIGH — foundational |
| **Folder Org** | Type-based: `screens/`, `provider/`, `api/` | Feature-based: `features/auth/`, `features/subscriptions/` | MEDIUM — long-term, phased |
| **Widgets** | Flat `lib/widgets/` with `common_` prefix | Atomic: `atoms/`, `molecules/`, `organisms/`, `templates/` | LOW — cosmetic, but do first |
| **Routing** | Manual named routes (44 constants) | `go_router` with guards | MEDIUM — incremental adoption |
| **HTTP Client** | `http` wrapper (`ApiClient`) | `Dio` with interceptor chain | LOW — low ROI, current works |
| **Services** | Mixed injection patterns | Riverpod providers (one instance per scope) | MEDIUM — with state mgmt switch |
| **Skeletons** | 4 skeleton widgets in `widgets/skeletons/` | Atoms + feature-specific organisms | LOW — already good structure |
| **Real-time** | `TripTrackingProvider` + `trip_websocket_service.dart` | `StreamProvider` + `trip_socket_datasource.dart` | MEDIUM — move to feature folder |
| **Approvals** | Not yet formalized | Submission + polling in `features/approvals/` | HIGH — new feature |

---

## What's Already GOOD (Keep & Reuse ✓)

| Component | Location | Action |
|---|---|---|
| **Response Models** | `lib/api/models/` (20 models) | Keep as-is, move to feature `data/models/` folders during refactor |
| **Service Interfaces** | `lib/api/interfaces/` (7 interfaces) | Convert to Repository interfaces in `domain/repositories/` |
| **Service Impls** | `lib/api/services/` (13 services) | Convert to Datasource impls in `data/datasources/` |
| **Enums** | `lib/api/enums/` | Move to `core/constants/enums/` |
| **Extensions** | `lib/common/extension/` | Move to `core/extensions/` |
| **Theme System** | `lib/common/theme/` | Move to `core/theme/` |
| **Responsive Util** | `lib/common/screen_util/` | Move to `core/utils/screen_util/` |
| **Localization** | `lib/common/languages/` | Move to `l10n/` + `core/services/locale_service.dart` |
| **Storage Singleton** | `lib/api/services/storage_service.dart` | Already good, keep unchanged |
| **Socket.IO** | `lib/api/services/trip_websocket_service.dart` | Rename to `core/network/socket_client.dart` |
| **Firebase + FCM** | Already integrated | Keep, wrap in `core/services/analytics_service.dart` |
| **Razorpay** | `lib/api/services/razorpay_service.dart` | Move to `features/payments/data/datasources/razorpay_datasource.dart` |

---

## Migration Roadmap (Recommended Phases)

### Phase 1: Foundation (Weeks 1–2)
**Goal:** Set up folder structure + domain layer for ONE feature.

1. Create `core/` directory with:
   - `constants/` (copy from `common/` + `api/`)
   - `errors/` (new Exceptions + Failures)
   - `extensions/` (copy from `common/extension/`)
   - `theme/` (copy from `common/theme/`)
   - `utils/` (copy from `common/screen_util/` + `helper/`)
   - `network/` (wrap existing `ApiClient`, add socket client)
   - `router/` (refactor manual named routes)
   - `services/` (copy storage + secure storage + locale)

2. Refactor ONE feature fully (e.g., `features/auth/`):
   - Create `data/datasources/`, `data/models/`, `data/repositories/`
   - Create `domain/entities/`, `domain/repositories/`, `domain/usecases/`
   - Move `auth_screen/` → `features/auth/presentation/screens/`
   - Move `auth_providers/` → `features/auth/presentation/providers/` (still ChangeNotifier for now)

3. Create `shared/widgets/` with atoms (no molecules yet).

**Deliverable:** `features/auth/` fully restructured + `core/` in place.

### Phase 2: State Management (Weeks 3–4)
**Goal:** Switch to Riverpod for the refactored feature.

1. Install `flutter_riverpod`, `riverpod_annotation` (optional codegen).
2. Convert `features/auth/presentation/providers/` from ChangeNotifier → `AsyncNotifier<AuthState>`.
3. Update `main.dart`: `MultiProvider` → `ProviderScope`.
4. Update `features/auth/presentation/screens/` to use `Consumer` instead of `Consumer<T>`.

**Deliverable:** `features/auth/` fully functional on Riverpod.

### Phase 3: Remaining Features (Weeks 5+)
**Goal:** Refactor remaining features one by one.

Recommended order:
1. `features/students/` (no real-time, no payment)
2. `features/subscriptions/` (adds cache + approval flow)
3. `features/trips/` (adds WebSocket + real-time)
4. `features/approvals/` (NEW feature for cross-app sync)

Repeat the Phase 1 + Phase 2 pattern for each.

### Phase 4: Atomic Design Widgets (Ongoing)
**Goal:** Consolidate `lib/widgets/` → `shared/widgets/` with hierarchy.

1. Extract atoms from existing common widgets.
2. Combine atoms into molecules (eliminate duplication like StudentWidgets vs ProfileWidgets).
3. Move feature-specific widgets to feature folders.
4. Consolidate multiple AppBar variants → `shared/widgets/organisms/app_header.dart`.

### Phase 5: Optional Improvements
- Migrate to `go_router` from manual named routes.
- Replace `http` package with `Dio` for centralized interceptors.
- Add `dartz` + `Either<L, R>` for explicit error propagation.
- Add `hive` for local caching (SubscriptionsRepository already shows caching pattern).

---

## File Structure Checklist

After full migration, these files should exist:

```
✓ lib/core/constants/api_endpoints.dart
✓ lib/core/constants/app_strings.dart
✓ lib/core/constants/enums/socket_events.dart
✓ lib/core/errors/exceptions.dart
✓ lib/core/errors/failures.dart
✓ lib/core/extensions/string_extensions.dart
✓ lib/core/network/api_client.dart
✓ lib/core/network/socket_client.dart
✓ lib/core/router/app_router.dart
✓ lib/core/services/storage_service.dart
✓ lib/core/theme/app_theme.dart
✓ lib/features/auth/data/datasources/auth_remote_datasource.dart
✓ lib/features/auth/data/models/send_otp_response_model.dart
✓ lib/features/auth/data/repositories/auth_repository_impl.dart
✓ lib/features/auth/domain/entities/user.dart
✓ lib/features/auth/domain/repositories/auth_repository.dart
✓ lib/features/auth/domain/usecases/login_usecase.dart
✓ lib/features/auth/presentation/providers/auth_provider.dart
✓ lib/features/auth/presentation/screens/login_screen.dart
✓ lib/features/students/... (same structure)
✓ lib/features/subscriptions/... (same structure)
✓ lib/features/trips/... (same structure)
✓ lib/features/approvals/... (same structure)
✓ lib/shared/widgets/atoms/app_button.dart
✓ lib/shared/widgets/molecules/labeled_text_field.dart
✓ lib/shared/widgets/organisms/app_header.dart
✓ lib/shared/widgets/templates/scrollable_page.dart
✓ lib/l10n/app_en.arb
```

---

## Key Principles

1. **Vertical slices:** Features are self-contained. Only exception: `core/` for infrastructure, `shared/` for reusable UI.
2. **Domain is pure:** No JSON, no Flutter imports. Domain entities are the single source of truth.
3. **No circular dependencies:** Features don't import each other. Communication via shared domain entities or events.
4. **Consistent request/response:** Every API call has a Request Model (`toJson()`) + Response Model (`fromJson()`).
5. **Refresh is explicit:** Don't auto-refresh unless it's a WebSocket. Use pull-to-refresh or invalidate providers on navigation.
6. **Atomic design:** Atoms are always reusable. Molecules are useful. Organisms are complex but non-reusable. Templates are scaffolds.

---

## Related Documents

- **`migration/architecture-refactoring.md`** — Phase 1–4 technical fixes (service injection, upload duplication, response types, loading boilerplate). This guide complements it.
- **Riverpod Docs:** https://riverpod.dev/
- **Clean Architecture:** https://www.freecodecamp.org/news/a-quick-guide-to-clean-architecture/

