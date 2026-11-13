# Rake — Pre-Launch Verification Checklist

This comprehensive verification checklist must be completely executed and signed off prior to submitting the public release build (v1.0.0+1) to the Apple App Store and Google Play Store.

---

## 1. Feature Flag Status (Zero Phase 4 Exposure)

- [ ] `enableCoreDrawing` = `true`
- [ ] `enableLocalization` = `true`
- [ ] `enableInspirationPatterns` = `true`
- [ ] `enableGallery` = `true`
- [ ] `enableShare` = `true`
- [ ] `enableSettings` = `true`
- [ ] `enablePremium` = `true`
- [ ] `enableGDPR` = `true`
- [ ] `enableAds` = `true`
- [ ] `enableThemes` = `true`
- [ ] `enableDailyInspiration` = `true`
- [ ] `enableOnboarding` = `true`
- [ ] `enableAchievements` = `true`
- [ ] `enableCloudSync` = `true`
- [ ] `enableCommunity` = `true`
- [ ] `enableWidgets` = `true`
- [ ] `enableSeasonalEvents` = `true`
- [ ] `enableRatePrompt` = `true`
- [ ] `enableReferral` = `true`
- [ ] `enableAnalytics` = `true`
- [ ] **All Phase 4 Flags strictly `false`**:
  - `enableAppleWatch` = `false`
  - `enableARMode` = `false`
  - `enableCollaboration` = `false`
  - `enableMacOS` = `false`
  - `enableIPadOptimized` = `false`
  - `enableAndroidTabletOptimized` = `false`
  - `enableLiveActivities` = `false`
  - `enablePublicSDK` = `false`
  - `enableSoundPacks` = `false`
  - `enableUploadAudio` = `false`
  - `enableMusicalRake` = `false`
  - `enableAdvancedExport` = `false`
  - `enableAdvancedThemes` = `false`
  - `enableHighContrast` = `false`
- [ ] Verify no Phase 4 buttons, menus, or dialogs appear in the UI.

---

## 2. Functional Testing

- [ ] **Fresh Install Flow**: App launches into onboarding; GDPR dialog opens cleanly; preferences saved; garden canvas renders smoothly without lag.
- [ ] **Drawing Interaction**: Multi-touch drawing produces smooth curved rake strokes with realistic depth and particle highlights.
- [ ] **Inspiration Tracing**: 10 patterns load properly; ghost overlay opacity is calm; completion calculation works accurately.
- [ ] **Smooth Erase**: Smooth dialog opens; confirmation triggers graceful particle fade and rake lines clear cleanly.
- [ ] **Save & Gallery**: Pattern saves to local storage; thumbnail generated; gallery displays saved items; free tier 5-save limit enforced.
- [ ] **Share Flow**: Canvas captures cleanly; native OS share sheet appears; signature watermark added if configured.
- [ ] **Settings Screen**: All sound toggles, theme pickers, language options, legal items, and about dialogs work properly.
- [ ] **Language Selection**: Switching between 10 languages updates strings instantly without restarts.
- [ ] **Theme Switching**: 6 launch themes switch smoothly; premium themes prompt for unlock when locked.
- [ ] **In-App Purchase**: "Master Gardener" (€4.99) purchase completes in Sandbox; restores successfully via Restore Purchases button.
- [ ] **Rewarded Ads**: Previewing locked patterns triggers rewarded ad properly; max 2/day frequency cap strictly respected; no banner ads shown.
- [ ] **Achievements**: Unlocking events trigger Game Center / Play Games popups; progress counter increments accurately.
- [ ] **Cloud Sync**: Anonymous Firebase auth works; pattern sync restores saved gardens on secondary device.
- [ ] **Community Gallery**: Public patterns load; uploading garden publishes to Firestore with moderation status.
- [ ] **Seasonal Events**: Active seasonal badge displays correctly on daily inspiration card.
- [ ] **Rate Prompt**: Rate dialog appears only after user completes 5 patterns or opens app across 3 consecutive days.
- [ ] **Referral Link**: Generating referral link opens native share sheet with valid HTTPS deep link (`https://rake.app`).

---

## 3. Edge Cases & Resilience

- [ ] **Airplane Mode (Offline)**: App runs 100% offline without crashing; local drawing, gallery saves, and themes function seamlessly.
- [ ] **App Killed Mid-Draw**: Terminating app while drawing retains previously committed strokes upon relaunch.
- [ ] **Low Storage State**: App gracefully catches storage write exceptions without crashing.
- [ ] **Rapid Multi-Touch Stress Test**: 10 simultaneous fingers moving erratically across the canvas causes zero dropped frames or crashes.
- [ ] **Background / Foreground Cycles**: Backgrounding the app mutes ambient sound; foregrounding restores audio smoothly.
- [ ] **Screen Rotation**: Phone remains locked in portrait; tablets handle orientation change without losing active strokes.

---

## 4. Hardware & Device Matrix

- [ ] **iPhone 16 / 15 Pro Max**: Dynamic Island and Safe Area margins respected; 120Hz ProMotion silky smooth.
- [ ] **iPhone SE (3rd Gen / Compact)**: UI fits cleanly on 4.7" display without text truncation or button overlap.
- [ ] **iPad Air / Pro (11" & 12.9")**: Clean centered canvas with elegant margins in mobile fallback mode.
- [ ] **Google Pixel 8 / 9 Pro**: Android 14/15 predictive back gestures handled smoothly; gesture pill safe area respected.
- [ ] **Mid-Range / Budget Device (Redmi / Samsung Galaxy A series)**: Constant 60 FPS maintained during continuous drawing.

---

## 5. Localization & Typography Verification

- [ ] **German (de)**: Long compound words ("Achtsamkeitsmuster", "Datenschutzeinstellungen") do not clip or wrap awkwardly.
- [ ] **French (fr)**: Formal "vous" phrasing verified; accents and ligatures render properly.
- [ ] **Spanish (es)** & **Italian (it)**: Friendly informal phrasing verified.
- [ ] **Dutch (nl)** & **Polish (pl)**: String lengths checked against button boundaries.
- [ ] **Swedish (sv)**: Special characters (`å`, `ä`, `ö`) render cleanly in Cormorant Garamond and Inter fonts.
- [ ] **Turkish (tr)**: Dotted and dotless `i` / `I` (`İ`, `ı`, `ğ`, `ş`) render without glyph corruption.

---

## 6. Store Submission Assets & Compliance

- [ ] **App Store Screenshots**: Localized sets uploaded for 6.7", 6.5", and 12.9" display sizes.
- [ ] **Google Play Feature Graphic**: 1024x500 PNG (24-bit, no alpha) uploaded.
- [ ] **Store Metadata**: Title, Subtitle, Keywords, Short Description, and Long Description populated in all 10 languages.
- [ ] **Privacy Policy Live**: Accessible at `https://rake.app/privacy`.
- [ ] **Support URL Live**: Accessible at `https://rake.app/support`.
- [ ] **Age Rating**: Rated 4+ on Apple App Store; PEGI 3 / USK 0 / Everyone on Google Play.
- [ ] **Data Safety & App Privacy**: Declarations match exact data collection (Crashlytics, anonymous telemetry with consent).
- [ ] **In-App Purchase**: Non-consumable product `app.rake.zen.master_gardener` submitted with screenshot and review notes.

---

## 7. Security & European Privacy (GDPR)

- [ ] **Consent Gating**: Zero analytics, crash identifiers, or ad requests fire before consent is explicitly provided.
- [ ] **No Personal Identifiable Information (PII)**: No user names, email addresses, phone numbers, or GPS data collected.
- [ ] **Account Deletion**: "Delete My Data" button functional in Account screen, deleting Firestore records and local cache.
- [ ] **Firestore Security Rules**: Strict rules deployed preventing unauthenticated writes or data tampering.

---

## 8. Performance & Benchmarks

- [ ] **Frame Rate**: Steady 60 FPS (or 120 FPS on ProMotion) with `< 1%` frame drops.
- [ ] **Cold Startup Time**: Time to first interactive canvas `< 2.0 seconds` on modern hardware.
- [ ] **Memory Footprint**: Active drawing session consumes `< 120 MB` RAM.
- [ ] **Battery Efficiency**: 15 minutes of continuous drawing causes `< 3%` battery drain.

---

## 9. Accessibility Compliance

- [ ] **Screen Readers**: Full VoiceOver and TalkBack announcements verified for all interactive buttons.
- [ ] **Touch Targets**: All interactive elements have touch boundaries `>= 48 x 48 dp` (recommended `>= 56 dp`).
- [ ] **Dynamic Type**: Text scales up to `1.5x` without breaking critical layout containers.
- [ ] **Contrast Ratios**: All UI text meets minimum WCAG AA standard (`4.5:1`).

---

## 10. Final Release Build Sign-Off

- [ ] Version code set to `1.0.0+1`.
- [ ] Obfuscation and code shrinking (R8/ProGuard) enabled and verified.
- [ ] Debug banners and test logging completely stripped.
- [ ] Production signing keys applied to release `.ipa` and `.aab`.

