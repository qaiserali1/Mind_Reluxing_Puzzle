# Rake — Store Submission & Publishing Playbook

This step-by-step operational guide details the end-to-end publishing process for releasing **Rake** on the Apple App Store and Google Play Store.

---

## Part 1: Apple App Store Submission Guide

### 1. Prerequisites
- Active Apple Developer Program enrollment ($99/year).
- Mac workstation with Xcode 15+ and command-line developer tools.
- Production signing certificates (Apple Distribution) and App Store Provisioning Profile.

### 2. App Store Connect Setup
1. **Identifier**:
   - In Developer Portal, register explicit App ID: `app.rake.zen`.
   - Enable In-App Purchase and Push Notifications capabilities.
2. **New App Creation**:
   - Primary Language: English (U.S.) or English (UK).
   - App Name: `Rake: Zen Sand Garden`.
   - Bundle ID: `app.rake.zen`.
   - SKU: `RAKE001`.
   - User Access: Full Access.
3. **Categorization & Age Rating**:
   - Primary Category: `Lifestyle`.
   - Secondary Category: `Entertainment` or `Games (Puzzle / Trivia)`.
   - Age Rating: Complete questionnaire to achieve `4+` (no violence, gambling, or adult content).

### 3. Store Listing & Assets
- **Pricing**: Free with In-App Purchase.
- **In-App Purchase Product**:
  - Type: Non-Consumable.
  - Reference Name: `Master Gardener`.
  - Product ID: `app.rake.zen.master_gardener`.
  - Tier: Tier 5 (€4.99).
  - Review Screenshot & Notes explaining unlock of all themes and soundscapes.
- **Screenshots**: Upload required sizes:
  - 6.7" iPhone Display (1290 x 2796 px)
  - 6.5" iPhone Display (1242 x 2688 px)
  - 12.9" iPad Pro Display (2048 x 2732 px)
- **App Preview Video**: 30-second video trailer (M4V/MP4, H.264, 30fps).
- **Metadata**: Populate Title, Subtitle, Promotional Text, Description, and Keywords across all 10 languages from `launch/app_store_metadata.md`.
- **URLs**:
  - Privacy Policy URL: `https://rake.app/privacy`
  - Support URL: `https://rake.app/support`
  - Marketing URL: `https://rake.app`

### 4. App Privacy Nutrition Labels
- **Data Used to Track You**: None.
- **Data Linked to You**: None.
- **Data Not Linked to You**:
  - Diagnostics: Crash Data (Firebase Crashlytics).
  - Usage Data: Product Interaction (Anonymous Analytics, opt-in only).

### 5. Build Upload & Submission
```bash
# Clean and compile release archive
flutter clean
flutter pub get
flutter build ipa --release --build-number=1

# Upload via Apple Transporter or Xcode Organizer
xcrun altool --upload-app --type ios -f build/ios/ipa/Rake.ipa -u "apple_id" -p "app_specific_password"
```
- Select uploaded build in App Store Connect.
- Provide demo reviewer account credentials (not required since app operates without mandatory account).
- Click **Submit for Review** (Standard review window: 24–48 hours).

### 6. Common Apple Rejections & Preventions
- **Guideline 2.1 (Performance / Crashes)**: Verify IPv6 network compatibility and clean launch.
- **Guideline 3.1.1 (Business / IAP)**: Ensure the "Restore Purchases" button is plainly accessible.
- **Guideline 5.1.1 (Data Privacy)**: Ensure `NSUserTrackingUsageDescription` and `NSCameraUsageDescription` explain exactly why permissions are requested.

---

## Part 2: Google Play Store Submission Guide

### 1. Prerequisites
- Google Play Console developer account ($25 one-time registration).
- Java Keystore (`upload-keystore.jks`) for Play App Signing.

### 2. Play Console Setup
1. **Create App**:
   - App Name: `Rake: Zen Sand Garden`.
   - Default Language: English (United States) - `en-US`.
   - App or Game: `App`.
   - Free or Paid: `Free`.
2. **Store Listing Details**:
   - Short Description (80 chars): `Draw. Breathe. Relax. Meditative zen sand garden in your pocket.`
   - Full Description (4000 chars): Populated from `launch/google_play_metadata.md`.
   - App Icon: `512 x 512 px` (32-bit PNG, max 1024 KB).
   - Feature Graphic: `1024 x 500 px` (24-bit PNG, no alpha).
   - Phone Screenshots: 8 screens (`1080 x 1920 px`).
   - 7-inch & 10-inch Tablet Screenshots.

### 3. Store Presence Policy Questionnaires
- **App Access**: All functionality is available without special access restrictions.
- **Ads**: Declare "Yes, my app contains ads" (rewarded ads only, no banners).
- **Target Audience & Content**: Target age `18 and over` (or `13+`).
- **Content Rating**: Complete IARC questionnaire to secure PEGI 3 / USK 0 / Everyone.
- **Data Safety Form**:
  - Declare anonymous crash logs (Firebase Crashlytics).
  - Declare ephemeral diagnostics.
  - State all data is encrypted in transit via HTTPS and can be requested for deletion.

### 4. In-App Products Setup
- In Play Console under **Monetize > Products > In-app products**:
  - Product ID: `app.rake.zen.master_gardener`.
  - Name: `Master Gardener Unlock`.
  - Price: `€4.99` (Play Console automatically adjusts for European VAT).
  - Status: Active.

### 5. Release Track Progression
```bash
# Generate Android App Bundle with ProGuard code shrinking
flutter clean
flutter pub get
flutter build appbundle --release --build-number=1
# Output: build/app/outputs/bundle/release/app-release.aab
```
1. **Internal Testing**: Verify installation and licensing test purchase on device.
2. **Closed Testing**: Fulfill Google Play policy (maintain 20 testers for 14 continuous days).
3. **Production Track**: Submit bundle for official review (standard review window: 2–7 business days).

### 6. Common Google Play Rejections & Preventions
- **Data Safety Discrepancy**: Ensure all declared third-party SDKs match actual code dependencies.
- **Target SDK**: Ensure `targetSdkVersion` is set to 34 (Android 14) or higher.
- **Broken In-App Billing**: Test with Google Play License Testing accounts prior to review.

---

## Part 3: Post-Submission Operations

1. **Email Monitoring**: Keep notification alerts active for developer email account (`support@rake.app`).
2. **Rejection Response Protocol**:
   - If an objection arises, reply politely within 24 hours via the Resolution Center with documentation or targeted clarification.
   - For technical rejections, resolve the issue immediately, bump the build number (e.g., `1.0.0+2`), and resubmit.
3. **Phased Release Strategy**:
   - Use Apple Phased Release (Day 1: 1%, Day 2: 2%, Day 3: 5%, Day 4: 10%, Day 5: 20%, Day 6: 50%, Day 7: 100%) to safely monitor crash rates.
   - Use Google Play Staged Rollout starting at 10%.

