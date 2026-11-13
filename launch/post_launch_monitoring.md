# Rake — Post-Launch Monitoring Checklist & Incident Escalation

This document details the operational monitoring cadences, health checklists, and incident response protocols for **Rake** following its commercial store release.

---

## 1. Daily Monitoring Checklist (First 14 Days Post-Launch)

Execute each morning at **09:00 CET**:

- [ ] **Crashlytics & Diagnostics**:
  - Check Crash-Free User Percentage (must be `>= 99.8%`).
  - Inspect any new fatal crash clusters or memory leak traces.
- [ ] **Store Vitals & Performance**:
  - Review Google Play Android Vitals: ANR rate (must be `< 0.05%`), slow render sessions (`< 1.0%`).
  - Review App Store Connect Energy Diagnostics (check background CPU drain and battery impact).
- [ ] **Revenue & Billing Integrity**:
  - Match App Store Connect and Google Play Billing gross sales against Firebase `purchase_completed` counts.
  - Review refund request counts (target: `< 0.5%` of transactions).
  - Verify receipt validation server latency and certificate validity.
- [ ] **Review & Sentiment Triage**:
  - Read 100% of new reviews in all 10 European storefronts.
  - Categorize reviews into: Bug Report, Feature Suggestion, Aesthetic Appreciation, Billing Issue.
  - Respond immediately using localized review response templates (`review_management.md`).
- [ ] **Social Media & Community Radar**:
  - Search TikTok, Instagram, Twitter/X, and Reddit for brand mentions (`"Rake app"`, `"Rake sand garden"`, `"Rake zen"`).
  - Reshare user-generated garden patterns to Instagram Stories with author attribution.

---

## 2. Weekly Monitoring Checklist (Weeks 3–12)

Execute every **Monday at 10:00 CET**:

- [ ] **Retention Cohort Analysis**:
  - Calculate Day-1, Day-7, and Day-30 retention across weekly install cohorts.
  - Compare retention between users who use Daily Inspiration vs. users who draw freehand only.
- [ ] **App Store Optimization (ASO) Review**:
  - Track organic keyword rankings in top 5 markets (Germany, France, UK, Spain, Italy) using AppTweak or Sensor Tower.
  - Compare screenshot conversion rate in Product Page Optimization (PPO) experiments.
- [ ] **Rewarded Ad Health (Non-paying users)**:
  - Verify fill rates for rewarded video previews (target: `>= 90%`).
  - Verify zero accidental clicks or banner ad leakage (strict adherence to zero banner policy).
- [ ] **Support Ticket Resolution**:
  - Audit open inquiries at `support@rake.app`. Ensure average first-response time is `< 12 hours`.
- [ ] **Backlog Prioritization**:
  - Update top 5 user feature requests (e.g., additional rake widths, new river stones, custom wallpaper export).

---

## 3. Monthly Operational Review (Month 2 Onwards)

- [ ] **Financial & Tax Reconciliation**:
  - Reconcile European Digital Services VAT withholdings and Apple/Google developer disbursements.
- [ ] **OS Compatibility & SDK Maintenance**:
  - Check for new iOS/iPadOS beta updates, Android quarterly platform releases, and Flutter SDK patches.
  - Verify privacy manifests and SDK nutrition labels for compliance with updated Apple/Google policies.
- [ ] **Content Cadence**:
  - Prepare the next monthly seasonal theme and limited-time natural soundscape.

---

## 4. Incident Severity Matrix & Response SLAs

| Level | Definition | Example Scenario | Response SLA | Action Plan |
|---|---|---|---|---|
| **P0 (Critical)** | App unplayable for > 5% of users; data loss or billing failure. | Crash on launch on iOS 18; IAP unlocks failing to register; save file corruption. | **< 2 Hours** | Immediate emergency hotfix build submitted via App Store Expedited Review and Google Play Fast-Track. Prepare rollback if needed. |
| **P1 (High)** | Major feature broken for a subset of devices. | Audio crackle on Samsung Galaxy devices; AR mode failing to detect plane; Apple Watch sync failing. | **< 12 Hours** | Issue investigation, reproducible unit test written, target hotfix release within 24 hours. |
| **P2 (Medium)** | Minor visual or localization glitch. | German text clipping in Settings; ghost guide alignment off by 2px in iPad landscape. | **< 48 Hours** | Scheduled into the next planned bi-weekly minor update. |
| **P3 (Low)** | Cosmetic imperfection or small enhancement. | Slight color contrast tweak on Dark Basalt theme icon. | **Next Sprint** | Added to the regular design backlog. |

---

## 5. Emergency Rollback Protocol

If a critical P0 regression occurs in a new release:
1. **Google Play Console**: Use the **Staged Rollout Halt** button immediately to prevent further user downloads, or increase phased rollout target downwards. If 100% rollout was complete, release a version bump hotfix targeting the previous stable commit.
2. **Apple App Store Connect**: Turn off automatic app updates in Phased Release, or submit an expedited fix citing *"Critical crash on launch impacting user base"* (Apple expedited review typically clears within 2–6 hours).
3. **Public Communication**: Post a calm, transparent status notice on `https://rake.app/status` and Reddit/Twitter advising affected users that a hotfix is queued.

