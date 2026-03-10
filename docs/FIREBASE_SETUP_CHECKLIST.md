# Firebase Setup Checklist — Android & iOS

## Android Setup

- [x] Create Firebase project at [Firebase Console](https://console.firebase.google.com/)
- [x] Add Android app with package name `com.pixelstrap.skolo`
- [x] Download `google-services.json` and place at `android/app/google-services.json`
- [x] Add `com.google.gms.google-services` plugin to `android/settings.gradle`
- [x] Add `com.google.gms.google-services` plugin to `android/app/build.gradle`
- [x] Add `POST_NOTIFICATIONS` permission to `AndroidManifest.xml`
- [x] Add notification channel meta-data to `AndroidManifest.xml`
- [x] Add `firebase_core`, `firebase_messaging`, `flutter_local_notifications` to `pubspec.yaml`
- [x] Create `lib/firebase_options.dart` with Android config
- [ ] Run `flutter pub get`
- [ ] Run app and verify Firebase initializes (no crash on startup)
- [ ] Login and verify FCM token is registered (check server logs)
- [ ] Trigger a driver action and verify push notification arrives on device

---

## iOS Setup

### 1. Firebase Console

- [ ] Go to Firebase Console > Project Settings > **Add app** > choose **Apple (iOS)**
- [ ] Enter iOS Bundle ID: `com.pixelstrap.skolo` (verify in `ios/Runner.xcodeproj/project.pbxproj`)
- [ ] Register the app
- [ ] Download `GoogleService-Info.plist`
- [ ] Place it at `ios/Runner/GoogleService-Info.plist`
  - **Important**: Add it via Xcode (drag into Runner folder, check "Copy items if needed", target: Runner)

### 2. Xcode Capabilities

Open `ios/Runner.xcworkspace` in Xcode:

- [ ] Select **Runner** target > **Signing & Capabilities**
- [ ] Click **+ Capability** > Add **Push Notifications**
- [ ] Click **+ Capability** > Add **Background Modes**
- [ ] Check **Remote notifications** under Background Modes

### 3. APNs Key (required for FCM on iOS)

- [ ] Go to [Apple Developer](https://developer.apple.com/) > Account > Certificates, Identifiers & Profiles > **Keys**
- [ ] Click **+** to create a new key
- [ ] Enter a name (e.g., "Ping Parent APNs Key")
- [ ] Check **Apple Push Notifications service (APNs)**
- [ ] Click Continue > Register > **Download** the `.p8` file
- [ ] Note down the **Key ID** (shown on the key details page)
- [ ] Note down your **Team ID** (Apple Developer > Membership > Team ID)

### 4. Upload APNs Key to Firebase

- [ ] Go to Firebase Console > Project Settings > **Cloud Messaging** tab
- [ ] Under **Apple app configuration**, click **Upload** next to APNs Authentication Key
- [ ] Upload the `.p8` file
- [ ] Enter the **Key ID** and **Team ID**

### 5. Update firebase_options.dart

- [ ] Add iOS config to `lib/firebase_options.dart` with values from `GoogleService-Info.plist`:
  - `apiKey` → `API_KEY`
  - `appId` → `GOOGLE_APP_ID`
  - `messagingSenderId` → `GCM_SENDER_ID`
  - `projectId` → `PROJECT_ID`
  - `storageBucket` → `STORAGE_BUCKET`
  - `iosBundleId` → `BUNDLE_ID`

### 6. iOS Verification

- [ ] Run `flutter pub get`
- [ ] Run `cd ios && pod install && cd ..`
- [ ] Build and run on iOS device (push notifications do NOT work on simulator)
- [ ] Accept notification permission prompt
- [ ] Login and verify FCM token is registered
- [ ] Trigger a driver action and verify push notification arrives

---

## Common Issues

| Issue | Solution |
|-------|---------|
| `google-services.json` not found | Ensure it's at `android/app/google-services.json` |
| `GoogleService-Info.plist` not found | Add via Xcode, not just file explorer |
| Push not working on iOS simulator | Use a **real device** — simulators don't support push |
| No notification on Android 13+ | `POST_NOTIFICATIONS` permission must be granted at runtime |
| Token registered but no push | Check APNs key is uploaded in Firebase Console (iOS) |
| `MissingPluginException` | Run `flutter clean && flutter pub get` |
| Pod install fails | Run `cd ios && pod repo update && pod install` |
