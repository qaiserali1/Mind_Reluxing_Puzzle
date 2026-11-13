# Rake — First 30 Days Launch Contingency Plans

This document defines response playbooks for unexpected operational, market, or technical scenarios during the critical first 30 days of release.

---

## Scenario A: Viral Surge (> 10,000 Installs / Day)

*Trigger: A TikTok video goes viral, or Apple features Rake as "App of the Day" across European storefronts.*

### Risks
- Firebase Cloud Firestore / Storage bandwidth quotas exceeded.
- Server-side receipt validation latency spikes.
- Influx of customer support inquiries overflowing the inbox.
- Community Discord flooded with spam or troll accounts.

### Contingency Action Plan
1. **Infrastructure Scaling**:
   - Upgrade Firebase project immediately from Spark (Free) to **Blaze (Pay-as-you-go)**.
   - Adjust Firestore read/write security rules to cache global community patterns via Firebase CDN.
   - Scale Cloud Functions concurrency limit to `500 instances` to handle sudden spikes in receipt validation.
2. **Customer Support Buffer**:
   - Activate automated Zendesk / HelpScout auto-reply with FAQs covering common questions (how to restore purchases, how to change themes, offline mode).
   - Set up an automated macro triage workflow for email classification.
3. **Community Shielding**:
   - Turn on Discord Verification Level: **Highest** (verified phone number required).
   - Enable AutoMod to block invite links, repetitive emojis, and vulgarity.
   - Appoint 3 trusted community moderators from early beta testers.

---

## Scenario B: Expected Growth (1,000 – 10,000 Installs in First Month)

*Trigger: Steady, predictable adoption driven by Reddit posts, ASO keywords, and micro-influencers.*

### Focus Areas
1. **Paywall Optimization**:
   - If conversion to Master Gardener is `< 3.5%`, trigger introductory discount experiment (€3.99 for first 7 days).
   - Add a subtle preview carousel on the Master Gardener unlock sheet showing 4K export side-by-side with standard PNG.
2. **ASO Consolidation**:
   - Identify top 3 converting search terms in Germany and France; update Subtitles in next minor update to target these exact keyword combinations.
3. **Creator Wave 2**:
   - Re-invest initial €1,000 revenue into 5 paid micro-sponsorships with cozy German and French lifestyle creators.

---

## Scenario C: Underperformance (< 1,000 Total Installs in Week 1)

*Trigger: Organic discovery fails to ignite, App Store algorithm ranks app below position #50 for primary keywords.*

### Diagnostic Root Cause Checklist
- [ ] **Keyword Indexing Check**: Are keywords actually indexed in App Store Connect? (Search exact bundle identifier and primary keywords).
- [ ] **Conversion Rate (CVR) Audit**: Is the Product Page View → Install rate `< 15%`? If so, screenshots or app icon are not appealing.
- [ ] **Price Barrier**: Did the paid up-front price or paywall communicate value poorly?

### Corrective Action Playbook
1. **Creative Overhaul**:
   - Replace Screenshot 1 with a high-contrast, tactile ASMR close-up ("Crisp Sand Drawing").
   - Test a new app icon featuring a single moss stone in soft natural sunlight.
2. **Community & Grassroots Repositioning**:
   - Share the authentic "Why I built an anti-game" founder story on `r/IndieGaming`, Hacker News (Show HN), and LinkedIn.
   - Offer 50 free unlock codes directly to cozy gaming subreddits and Discord servers.
3. **Editorial Nomination Outreach**:
   - Re-submit the official Apple App Store Nomination Form highlighting unique iPad and Apple Watch cross-platform support.

---

## Scenario D: Critical Technical Incident / Crash Loop

*Trigger: A new iOS or Android platform update causes instant crashes on launch for a specific manufacturer (e.g., Samsung OneUI or iOS 18.1).*

### Incident Protocol
1. **Immediate Assessment (< 30 minutes)**:
   - Identify affected OS versions and hardware models in Firebase Crashlytics.
   - Reproduce locally on matching simulator or physical test device.
2. **Mitigation (< 2 hours)**:
   - If Android: Halt phased rollout in Google Play Console immediately.
   - If iOS: Submit expedited review request to Apple App Store Review team, explaining:
     > *"Emergency bug fix for crash on launch impacting users on iOS version X. We request expedited review to restore service to our users."*
3. **Transparent Communication**:
   - Post an honest, calm advisory banner on `https://rake.app` and pinned post on Discord acknowledging the issue and providing an estimated resolution ETA.

---

## Scenario E: Store Policy Dispute or IAP Issue

*Trigger: Apple or Google flags an update citing guideline 3.1.1 (In-App Purchase), GDPR compliance, or intellectual property questions.*

### Resolution Pathways
1. **Guideline 3.1.1 (IAP / Business Model)**:
   - Ensure the "Restore Purchases" button is conspicuously visible on both the Paywall screen and Settings screen.
   - Ensure Terms of Service (`https://rake.app/terms`) and Privacy Policy (`https://rake.app/privacy`) links are functional inside the app without requiring login.
2. **GDPR / Privacy Scrutiny**:
   - Reference `gdpr_service.dart` implementation proving that Google UMP consent SDK is initialized prior to any ad or analytics network call.
   - Provide the Data Safety / Privacy Nutrition label mapping documentation showing zero tracking without consent.

