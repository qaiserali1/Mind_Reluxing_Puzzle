# Rake Firebase Setup Instructions

Rake optionally utilizes Firebase for cross-device sync, anonymous auth, community pattern sharing, and GDPR-compliant telemetry. If Firebase is not configured, the app gracefully falls back to local storage and offline mode.

## 1. Firebase Project Setup
1. Create a project at [https://console.firebase.google.com](https://console.firebase.google.com) named `rake-zen-garden`.
2. Enable **Authentication**:
   - Enable **Anonymous** sign-in provider.
   - Enable **Email/Password** sign-in provider.
3. Enable **Cloud Firestore**:
   - Choose production mode and select an EU data region (e.g. `europe-west1` or `europe-west3`) for GDPR compliance.
   - Deploy `firestore.rules` provided in this repository.

## 2. FlutterFire CLI Integration
Run the following in the project root:
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```
This generates `lib/firebase_options.dart` which registers your iOS, Android, and Web clients.

## 3. GDPR Compliance Guarantee
- Analytics is strictly **opt-in** and default disabled.
- Anonymous accounts hold no personally identifiable information (PII).
- Users can permanently delete their cloud data from **Settings > Account > Delete Account**.

