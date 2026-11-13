import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';

/// Privacy-first, GDPR opt-in analytics service. Disabled by default.
class AnalyticsService {
  static FirebaseAnalytics? _analytics;
  static bool _isEnabled = false;

  static bool get isEnabled => _isEnabled;

  /// Initializes analytics only if user explicitly consented via opt-in setting.
  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _isEnabled = prefs.getBool(AppConstants.keyAnalyticsOptIn) ?? false;

    if (_isEnabled && Firebase.apps.isNotEmpty) {
      try {
        _analytics = FirebaseAnalytics.instance;
        await _analytics?.setAnalyticsCollectionEnabled(true);
        if (!kIsWeb) {
          FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
        }
      } catch (_) {}
    } else {
      _analytics = null;
    }
  }

  /// Sets user opt-in status.
  static Future<void> setEnabled(bool enabled) async {
    _isEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyAnalyticsOptIn, enabled);

    if (enabled) {
      await initialize();
    } else {
      try {
        await _analytics?.setAnalyticsCollectionEnabled(false);
      } catch (_) {}
      _analytics = null;
    }
  }

  /// Logs a feature interaction (e.g. pattern drawn, theme switched).
  static Future<void> logEvent(String name, [Map<String, Object>? params]) async {
    if (!_isEnabled || _analytics == null) return;
    try {
      await _analytics?.logEvent(name: name, parameters: params);
    } catch (_) {}
  }

  /// Tracks drawing session statistics.
  static Future<void> logStrokeCount(int strokeCount) async {
    await logEvent('drawing_session_ended', {'strokes_drawn': strokeCount});
  }

  /// Tracks theme usage without personal identifying attributes.
  static Future<void> logThemeChanged(String themeId) async {
    await logEvent('theme_selected', {'theme_id': themeId});
  }

  /// Tracks pattern tracing.
  static Future<void> logPatternTraced(String patternId) async {
    await logEvent('pattern_traced', {'pattern_id': patternId});
  }
}

