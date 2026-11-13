import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'app.dart';
import 'core/feature_flags.dart';
import 'core/localization.dart';
import 'core/theme.dart';
import 'services/achievement_service.dart';
import 'services/analytics_service.dart';
import 'services/audio_service.dart';
import 'services/cloud_service.dart';
import 'services/crash_service.dart';
import 'services/gdpr_service.dart';
import 'services/haptic_service.dart';
import 'services/iap_service.dart';
import 'services/live_activity_service.dart';
import 'services/rate_service.dart';
import 'services/referral_service.dart';
import 'services/storage_service.dart';
import 'services/watch_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. StorageService (unconditional foundation)
  await StorageService.init();

  // 2. AudioService (unconditional base)
  await AudioService.init();

  // 3. HapticService (unconditional base)
  HapticService.enabled = StorageService.getHaptic();

  // 4. LocalizationService (unconditional)
  await EasyLocalization.ensureInitialized();

  // 5. CrashService (unconditional release logging)
  await CrashService.init();

  // 6. GDPR Consent Check & UMP
  if (FeatureFlags.enableGDPR) {
    await GdprService.requestUmpUpdate();
  }

  // 7. Firebase Initialization (Guarded for Cloud, Analytics, or Community)
  if (FeatureFlags.enableCloudSync || FeatureFlags.enableAnalytics || FeatureFlags.enableCommunity) {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      debugPrint('Firebase initialization skipped or offline: $e');
    }
  }

  // 8. Phase 2-3 Flag-Guarded Services
  if (FeatureFlags.enableCloudSync) {
    await CloudService.initialize();
  }

  if (FeatureFlags.enableAnalytics) {
    await AnalyticsService.initialize();
  }

  if (FeatureFlags.enableRatePrompt) {
    await RateService.onAppLaunched();
  }

  if (FeatureFlags.enablePremium) {
    await IapService.initialize();
  }

  if (FeatureFlags.enableAchievements) {
    AchievementService.initPlatformGames();
  }

  if (FeatureFlags.enableReferral) {
    ReferralService.initDeepLinks();
  }

  if (FeatureFlags.enableAds && await GdprService.hasConsent()) {
    try {
      await MobileAds.instance.initialize();
    } catch (_) {}
  }

  // 9. Phase 4 Flag-Guarded Services (Disabled for Launch)
  if (FeatureFlags.enableAppleWatch) {
    // Watch connectivity bridge active only when flag is true
  }

  if (FeatureFlags.enableLiveActivities) {
    // Live Activities active only when flag is true
  }

  // Orientation settings
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    if (FeatureFlags.enableIPadOptimized || FeatureFlags.enableAndroidTabletOptimized) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
  }

  // Serene system UI overlay
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.background,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // App lifecycle listener to pause audio cleanly
  WidgetsBinding.instance.addObserver(_AppLifecycleListener());

  runApp(
    EasyLocalization(
      supportedLocales: AppLocalization.supportedLocales,
      path: AppLocalization.path,
      fallbackLocale: AppLocalization.fallbackLocale,
      child: const RakeApp(),
    ),
  );
}

class _AppLifecycleListener extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      AudioService.onAppPaused();
    } else if (state == AppLifecycleState.resumed) {
      AudioService.onAppResumed();
    }
  }
}
