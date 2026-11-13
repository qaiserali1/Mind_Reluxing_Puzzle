# Rake — Analytics Taxonomy & Dashboard Architecture

This document specifies the privacy-first, GDPR-compliant event tracking schema, dashboard KPIs, and retention funnels for **Rake**.

---

## 1. Privacy Principles & European Compliance (GDPR)

1. **Zero Personal Identifiable Information (PII)**: No IP addresses, device names, emails, advertising IDs (IDFA/GAID) are collected or associated with event logs unless explicit opt-in consent is obtained.
2. **Explicit Consent Gating**: No analytics initialize until the user accepts standard consent via the UMP / GDPR dialog (`gdpr_service.dart`).
3. **Data Minimization**: Only aggregate engagement and reliability events are tracked.
4. **Anonymized Sessions**: Session IDs are ephemeral and reset every 24 hours.

---

## 2. Event Taxonomy (Firebase Analytics & Telemetry)

All parameters use snake_case and strict typing:

| Event Name | Trigger Condition | Parameters | Purpose |
|---|---|---|---|
| `app_session_started` | App comes to foreground | `is_first_launch` (bool)<br>`locale` (string, e.g. "de_DE")<br>`platform` (string, "ios" / "android") | Active user counts (DAU/MAU) |
| `onboarding_completed` | User completes 3rd slide & tutorial | `time_spent_seconds` (int)<br>`skipped` (bool) | Onboarding drop-off analysis |
| `garden_drawn` | User lifts finger after stroke session | `stroke_count` (int)<br>`duration_seconds` (int)<br>`rake_tool` (string: "single", "triple", "wide") | Core engagement depth |
| `garden_smoothed` | User taps "Smooth" button | `total_strokes_cleared` (int)<br>`time_since_creation` (int) | Rake clearing frequency |
| `pattern_guided_selected`| User picks inspiration pattern | `pattern_id` (string: "waves", "spiral", "lotus")<br>`is_daily` (bool) | Content preference |
| `pattern_completed` | Guide pattern traced to >=85% | `pattern_id` (string)<br>`duration_seconds` (int) | Completion success rate |
| `theme_switched` | User switches sand color | `theme_id` (string: "classic", "kyoto_moss")<br>`is_premium` (bool) | Aesthetic customization usage |
| `soundscape_toggled` | User changes ambient sound | `sound_id` (string: "wind", "water", "bell")<br>`volume_level` (float: 0.0–1.0) | Audio engagement |
| `garden_exported` | User saves PNG or SVG | `export_format` (string: "png", "svg", "pdf")<br>`destination` (string: "camera_roll", "share_sheet")| Virality & utility |
| `paywall_viewed` | Premium unlock dialog shown | `trigger_source` (string: "theme_lock", "gallery_limit", "settings", "banner") | In-app purchase interest |
| `purchase_completed` | IAP transaction verified | `product_id` (string: "rake_master_gardener")<br>`price_eur` (float: 4.99)<br>`currency` (string: "EUR") | Revenue tracking & LTV |
| `purchase_restored` | User restores past purchases | `success` (bool) | Customer satisfaction tracking |
| `rate_prompt_displayed`| In-app rating dialog triggered | `trigger_milestone` (string: "5th_pattern", "3rd_day") | Store rating funnel |

---

## 3. Core Funnels & Conversion Tracking

### Funnel 1: Onboarding to Core Habit
```
[ App Launch ]
     ↓ 98%
[ Onboarding Slide 3 ]
     ↓ 94%
[ First Rake Stroke Drawn ]  <-- Core Activation Metric
     ↓ 62%
[ Pattern Traced OR 50+ Strokes ]
     ↓ 42%
[ D1 Re-engagement ]
```

### Funnel 2: Free User to Master Gardener Unlock
```
[ Active User (D3+) ]
     ↓ 28%
[ Paywall View (Attempt to pick premium theme or export 4K) ]
     ↓ 35%
[ Tap Purchase (€4.99) ]
     ↓ 82%
[ Store Transaction Success ]
```
*Target Overall Free-to-Paid Conversion*: `5.0%` of D7 retained users.

---

## 4. Stability & Quality Benchmarks (Crashlytics & Play Vitals)

| Metric | Target SLA | Warning Threshold | Critical Alert (Rollback Trigger) |
|---|---|---|---|
| **Crash-Free User Rate** | `>= 99.8%` | `< 99.5%` | `< 99.0%` |
| **Crash-Free Session Rate**| `>= 99.9%` | `< 99.7%` | `< 99.2%` |
| **Android ANR Rate** | `< 0.05%` | `>= 0.10%` | `>= 0.25%` |
| **Frame Drops (< 60 FPS)** | `< 1.0%` | `>= 3.0%` | `>= 8.0%` |
| **Cold Startup Time (P90)** | `< 1.5s` | `>= 2.2s` | `>= 3.5s` |
| **Memory Consumption** | `< 120 MB` | `>= 180 MB` | `>= 250 MB` |

---

## 5. Automated Alert Rules (Slack / Email Integration)

- **Alert 1 (Revenue Spike or Drop)**: Triggers if daily IAP revenue deviates by `> 40%` week-over-week.
- **Alert 2 (Fatal Crash Velocity)**: Triggers if any single crash signature impacts `> 10 users` in a 1-hour window.
- **Alert 3 (Negative Store Review)**: Triggers an immediate Slack notification for any 1-star or 2-star review submitted on the App Store or Google Play Store.

