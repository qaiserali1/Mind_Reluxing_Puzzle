/// Application-wide constants.
class AppConstants {
  static const String appName = 'Rake';
  static const String appUrl = 'https://rake.app';
  static const String privacyPolicyUrl = 'https://rake.app/privacy';
  static const String termsUrl = 'https://rake.app/terms';
  static const String feedbackEmail = 'feedback@rake.app';
  static const String shareDefaultText = 'My zen garden 🌿 Made with Rake';

  // Sand Drawing Limits & Dimensions
  static const int maxStrokes = 200;
  static const double defaultStrokeWidth = 18.0;
  static const double minPointDistance = 3.0;

  // Animation Durations
  static const int eraseDurationMs = 800;
  static const int splashFadeMs = 1200;
  static const int splashDelayMs = 600;
  static const int splashHoldMs = 800;

  // Storage Keys - Phase 1 & 2
  static const String keyStrokesJson = 'strokes_json';
  static const String keySavedPatterns = 'saved_patterns';
  static const String keySelectedTheme = 'selected_theme';
  static const String keyUnlockedThemes = 'unlocked_themes';
  static const String keyPremiumUnlocked = 'premium_unlocked';
  static const String keyGdprConsentV1 = 'gdpr_consent_v1';
  static const String keyAmbientSound = 'ambient_sound';
  static const String keyRakeSound = 'rake_sound';
  static const String keyHapticsEnabled = 'haptics_enabled';
  static const String keyLanguageCode = 'language_code';
  static const String keySignature = 'signature';
  static const String keyLastInspirationDate = 'last_inspiration_date';

  // Storage Keys - Phase 3
  static const String keyOnboardingComplete = 'onboarding_complete';
  static const String keyTutorialDrawn = 'tutorial_drawn';
  static const String keyRatePromptShown = 'rate_prompt_shown';
  static const String keyRatePromptCount = 'rate_prompt_count';
  static const String keyAppOpenCount = 'app_open_count';
  static const String keyTotalStrokesCount = 'total_strokes_count';
  static const String keyFirstLaunchDate = 'first_launch_date';
  static const String keyAnalyticsOptIn = 'analytics_opt_in';
  static const String keyReferralCode = 'referral_code';
  static const String keyReferredBy = 'referred_by';
  static const String keyCloudSyncEnabled = 'cloud_sync_enabled';
}
