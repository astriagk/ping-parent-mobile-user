# How Migration Works: lib/ vs lib_new/

## The Problem We're Solving

You have a working app in `lib/`. You want to gradually refactor it to clean architecture WITHOUT breaking the app or pausing development.

**Challenge:** How do you switch features from old code to new code during development?

---

## Solution: Parallel Development

### Current Setup

```
lib/              (Legacy code - WORKING)
├── api/
├── provider/     ← State management (ChangeNotifier)
├── screens/      ← UI screens
├── main.dart     ← App entry point

lib_new/          (New architecture - BEING BUILT)
├── core/
├── features/
├── shared/
├── main.dart     ← Will be final entry point
```

---

## How It Works When You Migrate a Feature

### Step-by-Step Example: Migrating Auth Feature

#### Current State (Before Migration)
```
lib/main.dart
  └─ MultiProvider (old code)
       └─ AuthProvider (from lib/provider/auth_providers/)
            └─ AuthService (from lib/api/services/auth_service.dart)
                 └─ Screens: SignInScreen (from lib/screens/auth_screen/)
```

**App works normally** ✅

#### During Migration

1. **You build new auth in `lib_new/`:**
   ```
   lib_new/features/auth/
   ├── data/datasources/auth_remote_datasource.dart
   ├── domain/entities/user.dart
   ├── domain/repositories/auth_repository.dart
   ├── presentation/providers/auth_provider.dart
   └── presentation/screens/sign_in_screen.dart
   ```

2. **App still uses OLD code from `lib/`** ✅
   - Old SignInScreen works
   - Old AuthProvider works
   - No breakage

3. **When new auth is ready:**
   - Copy `lib_new/features/auth/` code
   - The app is NOT using it yet (just building)
   - Test it locally
   - When confident, swap

#### After Feature is Ready (Optional: Use New Code)

You have two choices:

**Option A: Keep Both (Safest)**
- Old code in `lib/` keeps working
- New code ready in `lib_new/`
- No risk, can take time

**Option B: Switch One Feature (More Work)**
- Would require updating imports in the app
- Since we're building in parallel, you DON'T do this until ALL features done

---

## The Real Workflow (Recommended)

### Phase 1-8: Build Everything in lib_new/
- You migrate all 8 features into `lib_new/`
- App keeps using `lib/` the whole time
- **No breaking changes, no interrupted development**
- App continues to work perfectly ✅

### Final: One Big Switch
When everything in `lib_new/` is complete and tested:

```bash
# Step 1: Backup old code
mv lib/ lib_backup/

# Step 2: Activate new code
mv lib_new/ lib/

# Step 3: Verify
flutter run      # Should work identically
flutter test     # All tests pass

# Step 4: Cleanup
rm -rf lib_backup/
```

**One moment of risk**, but ALL features are tested, so it's safe.

---

## Why This Approach is Best

| Approach | Pro | Con |
|---|---|---|
| **Parallel (Current)** | No breaking changes, can develop features independently, low risk | Takes disk space for two copies |
| **Feature-by-feature swap** | Minimal disk space | High risk — have to update routing, imports, etc. for each feature; app could break mid-migration |
| **Rewrite everything at once** | No disk overhead | Very high risk — rewrite 30+ providers, all screens, all services at once |

**We chose Parallel** because it's safest for a production app.

---

## Best Folder Names

Since the workflow is "build everything, then swap", here are good names:

### Option 1: `lib_next` (Recommended)
- ✅ Clear: "next version"
- ✅ Professional: used by many teams (Next.js naming)
- ✅ Obvious: you know which is current, which is next

```
lib/        → Current production code
lib_next/   → Next version (being built)
```

### Option 2: `lib_clean`
- ✅ Describes the architecture
- ⚠️ Less clear which is current

```
lib/        → Old (messy)
lib_clean/  → New (clean)
```

### Option 3: `lib_refactored`
- ✅ Clear action: "this is refactored"
- ⚠️ Long name

```
lib/            → Old
lib_refactored/ → Refactored
```

### Option 4: `lib_v2`
- ✅ Simple version numbering
- ⚠️ Not descriptive

```
lib/     → v1
lib_v2/  → v2
```

---

## My Recommendation: Use `lib_next`

**Why?**
1. **Professional naming** — used by major projects
2. **Clear intent** — you know it's the next version
3. **Obvious workflow** — when ready, "next becomes current"
4. **Disk space OK** — temporary during migration
5. **Easy to remember** — no confusion about which is which

---

## Workflow with lib_next/

### During Development (Months)
```
lib/            ← App runs from here (production)
lib_next/       ← You build new architecture here
│
├── core/       ← Infrastructure (copying from lib/)
├── features/   ← Auth, students, subscriptions, etc.
└── shared/     ← Reusable widgets

## You're working in lib_next/, app uses lib/
## Zero interruption
## Zero breakage
```

### Final Day: Switch
```bash
# Old becomes backup
mv lib/ lib_backup/

# New becomes current
mv lib_next/ lib/

# Verify one more time
flutter run
flutter test

# Clean up
rm -rf lib_backup/
```

---

## FAQ: How Does This Work with pubspec.yaml?

**pubspec.yaml doesn't change** — it only references one `lib/` at a time.

During migration:
- `pubspec.yaml` points to `lib/` ← App uses old code
- You're building in `lib_next/` ← Separate, not used

After migration:
- Swap the folders
- `pubspec.yaml` still points to `lib/` ← Now points to new code
- Done ✅

---

## Summary

| Timeline | lib/ | lib_next/ | App Status |
|---|---|---|---|
| **Today** | Old code 📦 | Fresh structure 📋 | ✅ Working (uses lib/) |
| **Week 1-4** | Old code 📦 | Auth migrated 🏗️ | ✅ Working (uses lib/) |
| **Week 5-8** | Old code 📦 | All features done ✅ | ✅ Working (uses lib/) |
| **Final Day** | Backup 📦 | New code → becomes lib/ ✅ | ✅ Working (now uses lib_next/) |
| **After** | Deleted 🗑️ | N/A ✅ | ✅ Working (clean lib/) |

---

## Recommendation

**Rename `lib_new/` → `lib_next/` now:**

```bash
mv lib_new/ lib_next/
```

Then follow the migration guides using `lib_next/` instead of `lib_new/`.

