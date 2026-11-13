import 'package:flutter/widgets.dart';

/// Centralized feature flags controlling the progressive rollout of Rake capabilities.
/// Phase 1-3 are enabled for the initial public European release.
/// Phase 4 advanced multiplatform/experimental features remain disabled until post-launch updates.
class FeatureFlags {
  // ============================================================
  // Phase 1-3 Core & Polish Capabilities (ENABLED FOR V1.0.0 LAUNCH)
  // ============================================================
  static const bool enableCoreDrawing = true;
  static const bool enableLocalization = true;
  static const bool enableInspirationPatterns = true;
  static const bool enableGallery = true;
  static const bool enableShare = true;
  static const bool enableSettings = true;
  static const bool enablePremium = true;
  static const bool enableGDPR = true;
  static const bool enableAds = true;
  static const bool enableThemes = true;
  static const bool enableDailyInspiration = true;
  static const bool enableOnboarding = true;
  static const bool enableAchievements = true;
  static const bool enableCloudSync = true;
  static const bool enableCommunity = true;
  static const bool enableWidgets = true;
  static const bool enableSeasonalEvents = true;
  static const bool enableRatePrompt = true;
  static const bool enableReferral = true;
  static const bool enableAnalytics = true;

  // ============================================================
  // Phase 4 Post-Launch Capabilities (DISABLED FOR INITIAL LAUNCH)
  // ============================================================
  static const bool enableAppleWatch = false;
  static const bool enableARMode = false;
  static const bool enableCollaboration = false;
  static const bool enableMacOS = false;
  static const bool enableIPadOptimized = false;
  static const bool enableAndroidTabletOptimized = false;
  static const bool enableLiveActivities = false;
  static const bool enablePublicSDK = false;
  static const bool enableSoundPacks = false;
  static const bool enableUploadAudio = false;
  static const bool enableMusicalRake = false;
  static const bool enableAdvancedExport = false;
  static const bool enableAdvancedThemes = false;
  static const bool enableHighContrast = false;

  /// Returns true if any Phase 4 advanced module is active.
  static bool get isPhase4Active =>
      enableAppleWatch ||
      enableARMode ||
      enableCollaboration ||
      enableMacOS ||
      enableLiveActivities ||
      enablePublicSDK;

  /// Determines whether the responsive layout should expand into multi-column tablet mode.
  static bool shouldUseTabletLayout(BuildContext context) {
    if (!enableIPadOptimized && !enableAndroidTabletOptimized) return false;
    return MediaQuery.of(context).size.width >= 600;
  }

  /// Controls the visibility of SVG, 300 DPI PDF, and animated exports.
  static bool shouldShowAdvancedExport() => enableAdvancedExport;

  /// Returns the count of sand themes currently accessible to users.
  static int get availableThemeCount => enableAdvancedThemes ? 16 : 6;
}

