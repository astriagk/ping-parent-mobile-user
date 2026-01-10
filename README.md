# taxify_user_ui

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Setup Instructions

### Prerequisites
- Flutter SDK installed ([Install Flutter](https://docs.flutter.dev/get-started/install))
- Android Studio / Xcode (for mobile development)
- VS Code with Flutter extension (recommended)

### Configure Flutter Path

#### Windows
1. Add Flutter to System PATH:
   - Right-click "This PC" → Properties → Advanced system settings
   - Click "Environment Variables"
   - Under "System variables", find "Path" and click Edit
   - Add: `C:\flutter\bin` (or your Flutter installation path)
   - Click OK

2. Verify installation:
   ```bash
   flutter doctor
   ```

#### macOS/Linux
Add to `~/.bashrc`, `~/.zshrc`, or `~/.bash_profile`:
```bash
export PATH="$PATH:/path/to/flutter/bin"
```

Then run:
```bash
source ~/.bashrc  # or ~/.zshrc
flutter doctor
```

#### VS Code Configuration
1. Open VS Code Settings (`Ctrl+,`)
2. Search for "Flutter SDK Path"
3. Set path: `C:\flutter` (Windows) or `/path/to/flutter` (macOS/Linux)

Or add to `.vscode/settings.json`:
```json
{
  "dart.flutterSdkPath": "C:\\flutter"
}
```

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd ping-parent-mobile-user
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Check Flutter setup**
   ```bash
   flutter doctor
   ```

4. **Check available devices**
   ```bash
   flutter devices
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

### Device Management

**Check available devices:**
```bash
flutter devices
```

**List available emulators:**
```bash
flutter emulators
```

**Launch an emulator:**
```bash
flutter emulators --launch <emulator-id>
```

**Run on specific device:**
```bash
flutter run -d <device-id>
```

Examples:
- `flutter run -d chrome` - Run on Chrome browser
- `flutter run -d emulator-5554` - Run on Android emulator
- `flutter run -d windows` - Run on Windows desktop

**In VS Code:**
- Click device selector in bottom-right status bar
- Or Command Palette (`Ctrl+Shift+P`) → "Flutter: Select Device"

### Clean & Reinstall Dependencies

If you encounter dependency issues:

```bash
flutter clean
flutter pub get
```

Or complete clean reinstall:
```bash
flutter clean
rm -rf pubspec.lock     # macOS/Linux
del pubspec.lock        # Windows
flutter pub get
```

### Available Commands

**Dependency Management:**
- `flutter pub get` - Install dependencies
- `flutter pub upgrade` - Upgrade packages
- `flutter clean` - Clean build files
- `flutter pub outdated` - Check for outdated packages

**Device Management:**
- `flutter devices` - List connected devices
- `flutter emulators` - List available emulators
- `flutter emulators --launch <id>` - Launch emulator

**Running:**
- `flutter run` - Run the app
- `flutter run -d chrome` - Run on Chrome
- `flutter run -d <device-id>` - Run on specific device

**Building:**
- `flutter build apk` - Build Android APK
- `flutter build appbundle` - Build Android App Bundle
- `flutter build ios` - Build iOS app
- `flutter build web` - Build web app

**Testing & Quality:**
- `flutter test` - Run tests
- `flutter analyze` - Analyze code
- `flutter format .` - Format code

### Development

**Hot Reload:**
- Press `r` in terminal while running
- Press `R` to hot restart
- Press `q` to quit
- VS Code: Press `F5` to start debugging

**Troubleshooting:**
- Run `flutter doctor -v` for detailed diagnostics
- Run `flutter clean` if build fails
- Check `flutter doctor` for missing dependencies
- Use `flutter devices` to verify device connection