# Rake — Production Build & Deployment Guide

This guide details the prerequisite toolchains, clean build commands, store packaging, and version bumping workflows for deploying **Rake: Zen Sand Garden** to production.

---

## 1. Prerequisites

Ensure your development environment meets the following specifications:
- **Flutter SDK**: Stable channel (`>= 3.22.0`).
- **Dart SDK**: Null-safety enabled (`>= 3.4.0 < 4.0.0`).
- **Xcode**: Version 15.0 or higher with Command Line Tools (macOS required for iOS/watchOS/macOS builds).
- **Android Studio / Android SDK**: Android API level 34 (Android 14) platform and build tools installed.
- **CocoaPods**: Version 1.14.0 or higher (`gem install cocoapods`).

---

## 2. Clean & Dependency Setup

Before generating any release binary, always clean the build caches and fetch fresh dependencies:

```bash
# Clean build artifacts and cached compilation modules
flutter clean

# Retrieve Flutter and Dart dependencies
flutter pub get

# On macOS: Update iOS CocoaPods dependencies
cd ios && pod install --repo-update && cd ..
```

---

## 3. iOS Production Release Build (`.ipa`)

To package the signed archive for submission to App Store Connect:

```bash
# Build production iOS IPA with explicit build number
flutter build ipa --release --build-number=1

# Output Artifact Location:
# build/ios/ipa/Rake.ipa
```

### Uploading to App Store Connect
You can upload the resulting `.ipa` using either:
1. **Apple Transporter App**:
   - Launch Transporter on macOS.
   - Drag and drop `build/ios/ipa/Rake.ipa` into Transporter and click **Deliver**.
2. **Command-Line (xcrun altool)**:
   ```bash
   xcrun altool --upload-app --type ios \
     -f build/ios/ipa/Rake.ipa \
     -u "your-apple-id@email.com" \
     -p "your-app-specific-password"
   ```
3. **Xcode Organizer**:
   - Open `ios/Runner.xcworkspace` in Xcode.
   - Select **Product > Archive**, then click **Distribute App**.

---

## 4. Android Production Release Build (`.aab`)

To generate the Android App Bundle for submission to Google Play Console:

```bash
# Build release Android App Bundle (AAB) with R8 obfuscation
flutter build appbundle --release --build-number=1

# Output Artifact Location:
# build/app/outputs/bundle/release/app-release.aab
```

### Uploading to Google Play Console
1. Navigate to [Google Play Console](https://play.google.com/console).
2. Select **Rake: Zen Sand Garden**.
3. Go to **Release > Production** (or **Testing > Closed testing**).
4. Click **Create new release**, drag and drop `app-release.aab`, add release notes, and submit.

---

## 5. Version Bumping Protocol

Every uploaded binary must have a strictly incrementing build number. Version strings follow the `semantic_version+build_number` format in `pubspec.yaml`:

```yaml
# Initial Public Launch:
version: 1.0.0+1

# First Bugfix Patch:
version: 1.0.1+2

# Subsequent Update:
version: 1.0.2+3

# Minor Feature Release (e.g., Phase 4 Theme Pack):
version: 1.1.0+4
```

### Build Command Parameterization
You can also override version and build numbers directly during CLI build invocations:

```bash
# Override build number dynamically in CI/CD pipelines
flutter build ipa --release --build-name=1.0.0 --build-number=1
flutter build appbundle --release --build-name=1.0.0 --build-number=1
```

---

## 6. Verification Checklist Before Submission

- [ ] `lib/core/feature_flags.dart` has all Phase 4 features set to `false`.
- [ ] No `kDebugMode` banners or test code visible.
- [ ] In-App Purchase ID matches `app.rake.zen.master_gardener`.
- [ ] Build numbers are strictly incremented.

