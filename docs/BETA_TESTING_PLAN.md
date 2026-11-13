# Rake — Beta Testing Plan & QA Playbook

This document defines the 4-phase beta testing strategy, recruitment channels, feedback collection mechanisms, daily monitoring cadences, and launch readiness criteria for **Rake**.

---

## 1. Beta Testing Phases & Timeline

```
[ Phase 1: Internal QA ] -> [ Phase 2: Closed Beta ] -> [ Phase 3: External Community Beta ] -> [ Phase 4: Open Stress Test ]
      Week 1 (5–10)               Week 2 (50)                  Weeks 3–4 (200–500)                 Weeks 5–6 (1,000+)
```

### Phase 1: Internal Alpha & Sanity (Week 1)
- **Cohort Size**: 5–10 core team members and close advisors.
- **Distribution**: Apple TestFlight Internal Track & Google Play Internal App Sharing.
- **Objective**: Core sanity check. Verify sand drawing physics, stroke persistence, haptic responsiveness, and ensure zero launch crashes on standard devices.

### Phase 2: Closed Friends & Family Beta (Week 2)
- **Cohort Size**: 50 invited testers across various European countries.
- **Distribution**: TestFlight External Group (invitation link) & Google Play Closed Testing Track.
- **Objective**: Test all Phase 1–3 capabilities: localization across 10 languages, inspiration overlays, theme switching, IAP sandbox purchases, and GDPR consent dialogs.

### Phase 3: Targeted Community Beta (Weeks 3–4)
- **Cohort Size**: 200–500 active cozy gamers and mindfulness practitioners.
- **Distribution**: Public TestFlight link and Google Play Closed Track (fulfilling the 20-tester / 14-day Google Play requirement).
- **Objective**: Real-world usage testing. Measure D1 and D7 retention, gather qualitative impressions on relaxation value, and identify hardware-specific edge cases.

### Phase 4: Scale & Stress Testing (Weeks 5–6)
- **Cohort Size**: 1,000+ public participants.
- **Distribution**: Open beta track in Google Play and TestFlight capacity expansion.
- **Objective**: Concurrency stress testing for Firebase Cloud Sync, Community Gallery uploads, receipt validation, and offline recovery.

---

## 2. Tester Recruitment Channels

1. **Reddit**:
   - `r/CozyGamers`: Authentic developer post offering early TestFlight access to a tranquil, ad-free sand garden.
   - `r/iosgaming` & `r/AndroidGaming`: Focus on the ethical monetization and technical fluidity.
2. **Discord**:
   - Partnered cozy gaming servers (Cozy Games Guild, Indie Game Devs).
   - "The Garden" official Rake Discord server (`#beta-announcements`).
3. **Twitter / X & Threads**:
   - Short 10-second video clip showing rake grooves dividing sand with crisp audio and the TestFlight signup link.
4. **European Mindfulness & Student Communities**:
   - University student unions and remote work Slack groups seeking calm study break tools.

---

## 3. Feedback Collection Framework

Feedback is gathered via TestFlight in-app screenshots, Google Play feedback forms, and an anonymous Google Form / Tally survey.

### Core Survey Questionnaire
1. **Overall Experience**: On a scale of 1 to 5, how calming was your time with Rake?
2. **Favorite Aspect**: What felt most satisfying? (Sand physics, sounds, haptics, daily inspiration, themes).
3. **Friction Points**: Was there anything confusing, abrupt, or frustrating?
4. **Technical Issues**: Did you encounter any stuttering, battery drain, or crashes? (If so, what phone model?).
5. **Willingness to Pay**: Would you consider unlocking the lifetime Master Gardener pack for a one-time purchase of €4.99?
6. **Feature Desires**: What is one thing you would love to see added in future updates?
7. **Language Quality**: Did the translations in your language feel natural and warm?

---

## 4. Daily Monitoring & Weekly Operating Rhythm

### Daily Tasks (09:00 CET)
- **Crashlytics Inspection**: Review new issues; verify crash-free user rate remains `>= 99.5%`.
- **TestFlight / Google Play Feedback Review**: Log reported bugs and device configurations into the issue tracker.
- **Engagement Check**: Track daily active sessions per tester (target: 2–3 short sessions/day).

### Weekly Triage & Release Cadence
- **Monday**: Review all survey responses; extract the top 3 critical bugs and top 2 UX friction points.
- **Wednesday**: Deploy iterative beta patch (e.g., v1.0.0-b2, v1.0.0-b3) with targeted fixes.
- **Friday**: Post update summary to testers in Discord `#beta-announcements` thanking them and highlighting resolved items.

---

## 5. Commercial Launch Readiness Gate

The application will only be submitted for public store release once all of the following criteria are met:

| Quality Metric | Launch Requirement | Status |
|---|---|---|
| **Crash-Free User Rate** | `>= 99.5%` across all active beta builds | Required |
| **Crash-Free Session Rate**| `>= 99.8%` | Required |
| **Day-1 Retention** | `>= 35%` among external testers | Required |
| **Average Beta Rating** | `>= 4.2 / 5.0` stars | Required |
| **Core Feature Completeness**| 100% of Phase 1–3 features functional | Required |
| **Google Play Testing** | 20+ testers continuously opted-in for 14 days | Required |
| **Zero Critical P0/P1 Bugs**| No unaddressed data loss, freeze, or billing errors | Required |

