import 'package:flutter/services.dart';
import '../core/feature_flags.dart';

/// Flutter MethodChannel bridge for iOS 16+ Live Activities and Dynamic Island.
/// Guarded by FeatureFlags.enableLiveActivities.
class LiveActivityService {
  static const MethodChannel _channel = MethodChannel('app.rake.game/live_activity');

  /// Starts or updates a Live Activity on the lock screen during a peaceful meditation session.
  static Future<void> startSessionActivity({required String patternName}) async {
    // Guarded: Disabled for initial launch
    if (!FeatureFlags.enableLiveActivities) return;

    try {
      await _channel.invokeMethod('startActivity', {'patternName': patternName});
    } catch (_) {}
  }

  /// Concludes the active lock screen activity.
  static Future<void> stopSessionActivity() async {
    // Guarded: Disabled for initial launch
    if (!FeatureFlags.enableLiveActivities) return;

    try {
      await _channel.invokeMethod('stopActivity');
    } catch (_) {}
  }
}
