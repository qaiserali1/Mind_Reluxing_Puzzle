import 'package:flutter/services.dart';
import '../core/feature_flags.dart';

/// Flutter-side bridge for Apple Watch WatchConnectivity framework.
/// Guarded by FeatureFlags.enableAppleWatch.
class WatchService {
  static const MethodChannel _channel = MethodChannel('app.rake.game/watch');

  /// Sends latest daily pattern and mindfulness stats to the paired Apple Watch.
  static Future<void> syncWatchContext({
    required String dailyPattern,
    required int totalStrokes,
    required int dayStreak,
    required int unlockedAchievements,
  }) async {
    // Guarded: Disabled for initial launch
    if (!FeatureFlags.enableAppleWatch) return;

    try {
      await _channel.invokeMethod('updateContext', {
        'dailyPattern': dailyPattern,
        'totalStrokes': totalStrokes,
        'dayStreak': dayStreak,
        'achievements': unlockedAchievements,
      });
    } catch (_) {}
  }

  /// Sends a trigger to initiate watch mindfulness breathing session.
  static Future<void> startWatchBreathing() async {
    // Guarded: Disabled for initial launch
    if (!FeatureFlags.enableAppleWatch) return;

    try {
      await _channel.invokeMethod('startBreathing');
    } catch (_) {}
  }
}
