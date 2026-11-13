import 'dart:ui';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Centralized crash reporting service utilizing Firebase Crashlytics in release builds.
/// Operates silently and gracefully without interrupting the player's calm experience.
class CrashService {
  /// Initializes global exception hooks in release mode.
  static Future<void> init() async {
    if (kReleaseMode) {
      try {
        FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
        PlatformDispatcher.instance.onError = (error, stack) {
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
          return true;
        };
      } catch (e) {
        debugPrint('Crashlytics initialization skipped: $e');
      }
    }
  }

  /// Sets custom diagnostic metadata tags for crash analysis.
  static void setCustomKey(String key, dynamic value) {
    if (kReleaseMode) {
      try {
        FirebaseCrashlytics.instance.setCustomKey(key, value);
      } catch (_) {}
    }
  }

  /// Records non-fatal caught exceptions.
  static void recordNonFatal(dynamic error, StackTrace? stack, {String? reason}) {
    if (kReleaseMode) {
      try {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: false, reason: reason);
      } catch (_) {}
    }
  }
}

