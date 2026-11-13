# Rake — 12-Week Master Launch Timeline

This timeline outlines the week-by-week roadmap leading up to and through the European commercial launch of **Rake**.

---

## High-Level Phase Overview

```
[ W1 - W2 ] Preparation, Localization Freeze & Deep QA
[ W3 - W4 ] Apple & Google Store Submissions, TestFlight & Closed Beta
[   W5    ] Soft Launch (Netherlands, Poland, Portugal)
[   W6    ] Soft Launch Analysis, Fixes & Paywall Tuning
[ W7 - W8 ] Tier 1 Pan-European Grand Launch (DE, FR, UK, ES, IT, SE)
[ W9 - W10] Organic Influencer Push, Press Coverage & ASO Momentum
[ W11-W12 ] First Seasonal Live Event & Sustainable Growth
```

---

## Detailed Week-by-Week Roadmap

### Weeks 1–2: Preparation, Localization Freeze & QA

#### Week 1: Build Polish & Localization Lock
- [ ] Freeze all 10 language translation files in `assets/l10n/` (`en`, `de`, `fr`, `es`, `it`, `pt`, `nl`, `pl`, `sv`, `tr`).
- [ ] Run automated end-to-end device testing across all screen aspect ratios (iPhone SE 4.7", iPhone 15 Pro 6.1", iPhone 16 Pro Max 6.9", iPad Pro 12.9", Galaxy S24, Pixel 8).
- [ ] Verify haptic feedback latency on both Taptic Engine (iOS) and Android Vibrator API.
- [ ] Validate audio ducking and loop seam smoothness in ambient soundscapes.
- [ ] Execute GDPR & UMP compliance verification with EU IP address test (IAB TCF v2.2 consent string validation).

#### Week 2: Build Hardening & Asset Production
- [ ] Finalize master 1024x1024 app icon, Android adaptive icons, and Play Store 1024x500 feature graphic.
- [ ] Generate all 8 screenshots with localized overlays for all 10 languages using `launch/screenshot_overlays.json`.
- [ ] Build release `.ipa` (iOS) and `.aab` (Android App Bundle) with code shrinking, R8 obfuscation, and stripped debug symbols.
- [ ] Ensure In-App Purchase products (`rake_premium_unlock`, `rake_autumn_theme`, etc.) are configured in App Store Connect and Google Play Billing Console.

---

### Weeks 3–4: Store Submissions & Beta Testing

#### Week 3: Store Listing Setup & Closed Beta
- [ ] Upload screenshots, metadata, privacy URLs, and localized text into App Store Connect and Google Play Console.
- [ ] Configure TestFlight External Beta (invite 200 European cozy gaming and mindfulness community members).
- [ ] Launch Google Play Closed Testing track (20 testers for 14 continuous days to meet Google Play requirements).
- [ ] Verify receipt validation and restore purchases button in TestFlight sandbox environment.

#### Week 4: App Store Review & Press Embargo
- [ ] Submit iOS build for official App Store Review (Target turnaround: 24–48 hours).
- [ ] Submit Android build for production track approval.
- [ ] Prepare press kit on `https://rake.app/press` (screenshots, trailer, factsheet, high-res logos).
- [ ] Send embargoed pitch emails to tier-1 European tech and gaming journalists (embargo lifting on Week 7 Launch Day).

---

### Week 5: Soft Launch (Netherlands, Poland, Portugal)

- [ ] Release production build exclusively in NL, PL, and PT.
- [ ] Monitor real-time crash rate via Firebase Crashlytics (Target: `< 0.1%` crash-free users `>= 99.9%`).
- [ ] Check IAP purchase completion funnel and receipt validation logs.
- [ ] Monitor battery consumption and frame rate performance during 15-minute continuous drawing sessions.
- [ ] Collect initial feedback on UI clarity and rake line smoothness.

---

### Week 6: Soft Launch Analysis & Final Refinements

- [ ] Analyze Day-1 and Day-3 retention metrics from soft launch cohorts.
- [ ] Tune rewarded ad frequency caps if needed (strictly keep <= 2 per day).
- [ ] Deploy hotfix build v1.0.1 addressing any edge cases found in soft launch.
- [ ] Request featuring consideration via Apple Store Editorial App Nomination Form (`appstore.com/promotions`) 3 weeks before wide launch.

---

### Weeks 7–8: Tier 1 Pan-European Grand Launch

#### Week 7: Grand Launch Day (Tuesday 10:00 AM CET)
- [ ] Flip release switch to Worldwide (focus: Germany, France, United Kingdom, Spain, Italy, Sweden).
- [ ] Publish official press release across European PR distribution wires.
- [ ] Lift embargo on tech journalists and lifestyle bloggers.
- [ ] Release launch trailer on YouTube, TikTok, and Instagram Reels.
- [ ] Post organic developer stories on `r/CozyGamers`, `r/iosgaming`, `r/AndroidGaming`.

#### Week 8: Initial Traction & Community Nurturing
- [ ] Monitor App Store and Play Store review queues; reply to 100% of reviews within 24 hours in local languages.
- [ ] Track keyword ranking trajectory across top 10 European App Stores for "zen garden", "mindfulness", "drawing game", "relaxing puzzle".
- [ ] Deploy first TikTok/Reels organic creator wave (micro-influencers posting calming rake drawing videos with lo-fi sound).

---

### Weeks 9–10: ASO Momentum & Influencer Wave

- [ ] Review Product Page Optimization (PPO) results: compare Icon Variant A (sand swirl) vs. Variant B (stone ripple).
- [ ] Run second creator wave targeting European study, ASMR, and stress-relief accounts.
- [ ] Pitch Apple App Store editors for "App of the Day" and "New Apps We Love" placements in European storefronts.
- [ ] Analyze user-submitted gardens in Community Gallery; highlight the top 5 weekly community masterpieces.

---

### Weeks 11–12: First Seasonal Live Event & Sustainable Scale

- [ ] Launch first seasonal in-game event: "Autumn Foliage & Kyoto Ginkgo Leaves" (exclusive seasonal theme & leaf scatter effect).
- [ ] Release update v1.1.0 with top user-requested minor features (e.g., additional rake widths or stone styles).
- [ ] Review lifetime financial performance against 12-week forecasts.
- [ ] Transition from launch sprints to sustainable weekly marketing cadence (3 reels/week, monthly community contest).

