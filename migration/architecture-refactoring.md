# Architecture Refactoring Guide

> **Purpose:** Reference document for incremental refactoring of the Ping Parent Flutter app.
> **Approach:** Fix one layer at a time. Each phase is independent and safe to commit separately.

---

## What's Being Fixed

### Problem 1 — Services re-instantiated on every method call
Most providers create a fresh `SubscriptionsService(ApiClient())` inside each method. The app creates **23+ ApiClient instances per user session**. This makes services untestable and wastes resources.

### Problem 2 — UI patterns duplicated across screens
15+ `*_widgets.dart` files contain static helper methods that are copy-pasted between screens instead of using shared `StatelessWidget` classes.

---

## Phase 1 — Fix Service Injection ⚡ (Do This First)

### 1a. Add a shared `ApiClient` instance

**File:** [lib/api/api_client.dart](../lib/api/api_client.dart)

Add one line at the bottom of the file, after the class definition:

```dart
/// Single shared instance for the entire app.
final apiClient = ApiClient();
```

The constructor is unchanged — existing call sites still compile. Migrate them one at a time.

---

### 1b. Wire services as singletons in `main.dart`

**File:** [lib/main.dart](../lib/main.dart)

Before `MultiProvider`, declare all services once:

```dart
void main() {
  final _apiClient = ApiClient();
  final _studentService = StudentService(_apiClient);
  final _subscriptionsService = SubscriptionsService(_apiClient);
  final _driverService = DriverService(_apiClient);
  final _userService = UserService(_apiClient);
  final _notificationService = NotificationService(_apiClient);
  final _uploadService = UploadService(_apiClient); // Phase 1d

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AddStudentProvider(_studentService, _uploadService)),
        ChangeNotifierProvider(create: (_) => DriverProvider(_driverService)),
        ChangeNotifierProvider(create: (_) => SubscriptionsProvider(_subscriptionsService)),
        ChangeNotifierProvider(create: (_) => UserProvider(_userService, _uploadService)),
        ChangeNotifierProvider(create: (_) => NotificationProvider(_notificationService)),
        // ... rest unchanged
      ],
    ),
  );
}
```

---

### 1c. Update providers to accept injected services

**Migration order** (fix worst offenders first):

| Provider | File | Problem |
|---|---|---|
| `SubscriptionsProvider` | [lib/provider/app_pages_providers/subscriptions_provider.dart](../lib/provider/app_pages_providers/subscriptions_provider.dart) | 6 in-method instantiations |
| `AddStudentProvider` | [lib/provider/app_pages_providers/add_student_provider.dart](../lib/provider/app_pages_providers/add_student_provider.dart) | 5 in-method instantiations |
| `DriverProvider` | [lib/provider/app_pages_providers/driver_provider.dart](../lib/provider/app_pages_providers/driver_provider.dart) | 2 in-method instantiations |
| `UserProvider` | [lib/provider/app_pages_providers/user_provider.dart](../lib/provider/app_pages_providers/user_provider.dart) | Field-init, just wire up |

**Pattern to apply to each:**

```dart
// BEFORE ❌
class DriverProvider extends ChangeNotifier {
  Future<void> fetchDrivers() async {
    final driverService = DriverService(ApiClient()); // new instance every call!
    final response = await driverService.getAllDrivers();
  }
}

// AFTER ✅
class DriverProvider extends ChangeNotifier {
  final DriverServiceInterface _service;
  DriverProvider(this._service);

  Future<void> fetchDrivers() async {
    final response = await _service.getAllDrivers();
  }
}
```

Also: **delete `_isInitialized` and `onInit()` from `DriverProvider`** — the screen already calls `refreshData()` via `AutoRefreshMixin`, making `onInit()` unreachable dead code.

---

### 1d. Extract `UploadService`

**New file to create:** [lib/api/services/upload_service.dart](../lib/api/services/upload_service.dart)

The `uploadSharedFile` method is copy-pasted identically in both `UserService` and `StudentService`. Extract it:

```dart
class UploadService {
  final ApiClient _apiClient;
  UploadService(this._apiClient);

  Future<Map<String, dynamic>> uploadSharedFile({
    required File file,
    required String folderPath,
    String? oldFileUrl,
  }) async {
    // move the identical body from UserService here
  }
}
```

Then delete `uploadSharedFile` from:
- [lib/api/services/user_service.dart](../lib/api/services/user_service.dart)
- [lib/api/services/student_service.dart](../lib/api/services/student_service.dart)

---

## Phase 2 — Unify Response Types

**Problem:** Some service methods return typed models, some return `Map<String, dynamic>`, some throw exceptions. Each provider re-implements its own error extraction.

**New file to create:** [lib/api/api_result.dart](../lib/api/api_result.dart)

```dart
class ApiResult<T> {
  final T? data;
  final bool success;
  final String? error;

  const ApiResult._({this.data, required this.success, this.error});

  factory ApiResult.success(T data) => ApiResult._(data: data, success: true);
  factory ApiResult.failure(String error) => ApiResult._(success: false, error: error);

  bool get isSuccess => success && data != null;
}
```

**Only migrate these methods** (currently return raw `Map<String, dynamic>`):
- `SubscriptionsService.createSubscription`
- `SubscriptionsService.upgradeSubscription`
- `StudentService.createStudent`
- `StudentService.updateStudent`

**Do NOT change** existing typed response classes (`SubscriptionRecommendationsResponse`, `DriverListResponse`, etc.) — they already expose `.success`, `.error`, `.data` directly.

---

## Phase 3 — Reduce Provider Boilerplate

Every provider method repeats the same loading/error pattern. Add a private `_run` helper to each provider — **no base class, no mixin**:

```dart
Future<void> _run(Future<void> Function() action, {bool isRefresh = false}) async {
  if (isRefresh) {
    isRefreshing = true;
  } else {
    isLoading = true;
  }
  errorMessage = null;
  notifyListeners();
  try {
    await action();
  } catch (e) {
    errorMessage = 'An error occurred. Please try again.';
  } finally {
    isLoading = false;
    isRefreshing = false;
    notifyListeners();
  }
}
```

**Usage:**
```dart
// Before ❌
Future<void> fetchDrivers() async {
  isLoading = true;
  errorMessage = null;
  notifyListeners();
  try {
    final response = await _service.getAllDrivers();
    // ...
  } catch (e) {
    errorMessage = 'An error occurred.';
  }
  isLoading = false;
  notifyListeners();
}

// After ✅
Future<void> fetchDrivers() async {
  await _run(() async {
    final response = await _service.getAllDrivers();
    // ...
  });
}
```

---

## Phase 4 — Widget Consolidation

### New widgets to create

#### 4a. `LabeledTextField`
**New file:** [lib/widgets/labeled_text_field.dart](../lib/widgets/labeled_text_field.dart)

Replaces: `StudentWidgets.commonTextField()` and `ProfileWidgets.commonTextField()`

```dart
class LabeledTextField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool readOnly;
  final FocusNode? focusNode;
  final int maxLines;
  final void Function(String)? onChanged;

  const LabeledTextField({
    super.key,
    this.label,
    this.hintText,
    this.controller,
    this.keyboardType,
    this.readOnly = false,
    this.focusNode,
    this.maxLines = 1,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) Text(label!, style: AppCss.urbanistMedium14),
        if (label != null) const SizedBox(height: 6),
        TextFieldCommon(
          hintText: hintText,
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          focusNode: focusNode,
          maxLines: maxLines,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
```

---

#### 4b. `AvatarImage`
**New file:** [lib/widgets/avatar_image.dart](../lib/widgets/avatar_image.dart)

Replaces: The `ClipOval` + file/url/asset fallback stack in `StudentWidgets` and `ProfileWidgets`.

```dart
class AvatarImage extends StatelessWidget {
  final String? photoUrl;      // network image
  final File? selectedFile;    // local file (takes priority over url)
  final double size;
  final String fallbackAsset;  // path to local asset image

  const AvatarImage({
    super.key,
    this.photoUrl,
    this.selectedFile,
    this.size = 79,
    required this.fallbackAsset,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: selectedFile != null
            ? Image.file(selectedFile!, fit: BoxFit.cover)
            : photoUrl != null && photoUrl!.isNotEmpty
                ? Image.network(photoUrl!, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Image.asset(fallbackAsset, fit: BoxFit.cover))
                : Image.asset(fallbackAsset, fit: BoxFit.cover),
      ),
    );
  }
}
```

---

#### 4c. `showPhotoPicker`
**New file:** [lib/widgets/photo_picker_dialog.dart](../lib/widgets/photo_picker_dialog.dart)

Replaces: The inline dialog in `ProfileWidgets.profileImageLayout` and `StudentWidgets.showPhotoSelectionDialog`.

```dart
void showPhotoPicker(
  BuildContext context, {
  required Future<void> Function() onGalleryTap,
  required Future<void> Function() onCameraTap,
}) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(language(context, 'select_photo')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: Text(language(context, 'gallery')),
            onTap: () { Navigator.pop(context); onGalleryTap(); },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: Text(language(context, 'camera')),
            onTap: () { Navigator.pop(context); onCameraTap(); },
          ),
        ],
      ),
    ),
  );
}
```

---

### Migration approach

1. Create the new widget
2. Replace one screen's call site at a time
3. Keep `*_widgets.dart` helper files until **all** their callers are migrated
4. Delete the helper file once it has no more callers

**Do NOT convert all 15 `*_widgets.dart` files.** Only target cross-screen duplication. Screen-specific helpers (e.g. `SelectRiderWidgets`, `NotificationWidgets`) can stay as static method classes.

---

## Execution Order & Risk

| Phase | Files Changed | Risk | Can parallelize? |
|---|---|---|---|
| **1a** — shared ApiClient | `api_client.dart` | Very low | — |
| **1b** — main.dart wiring | `main.dart` | Low | After 1a |
| **1c** — provider constructors | 4 provider files | Low | After 1b, one per commit |
| **1d** — UploadService | new file + 2 services | Low | After 1c |
| **3** — loading helper | 3-4 provider files | Low | After 1c |
| **2** — ApiResult | new file + 4 methods | Medium | After 1c |
| **4a-c** — new widgets | 3 new widget files | Low | Fully independent |
| **4d** — delete old helpers | 2-3 widget helper files | Low | After screens migrated |

---

## Verification Checklist

### After Phase 1
- [ ] Run app: login → navigate all screens → data loads normally
- [ ] Search codebase: `ApiClient()` should only appear in `main.dart`, nowhere else
- [ ] Verify `DriverProvider` no longer has `onInit()` method

### After Phase 2
- [ ] Create a subscription — verify success and error cases show correct messages
- [ ] Create/update a student — verify validation errors surface correctly

### After Phase 3
- [ ] All provider fetch methods use `_run()` — verify loading spinners still appear and disappear correctly
- [ ] Simulate a network error — verify "An error occurred" message shows

### After Phase 4
- [ ] Add student flow — form fields look identical, photo picker works
- [ ] Profile screen — image upload, photo picker, form fields all work
- [ ] Old `StudentWidgets` and `ProfileWidgets` files deleted
