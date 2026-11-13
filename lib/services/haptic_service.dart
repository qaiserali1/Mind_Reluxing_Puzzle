import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

/// Service providing gentle, meditative haptic feedback.
class HapticService {
  static bool enabled = true;

  /// Light tap on starting or completing a stroke.
  static Future<void> lightTap() async {
    if (!enabled) return;
    try {
      final hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        final hasAmplitude = await Vibration.hasAmplitudeControl();
        if (hasAmplitude == true) {
          await Vibration.vibrate(duration: 15, amplitude: 30);
        } else {
          await Vibration.vibrate(duration: 15);
        }
      } else {
        await HapticFeedback.lightImpact();
      }
    } catch (_) {
      try {
        await HapticFeedback.lightImpact();
      } catch (_) {}
    }
  }

  /// Soft pulse for actions like button presses or smooth erasing.
  static Future<void> softPulse() async {
    if (!enabled) return;
    try {
      final hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        final hasAmplitude = await Vibration.hasAmplitudeControl();
        if (hasAmplitude == true) {
          await Vibration.vibrate(duration: 35, amplitude: 50);
        } else {
          await Vibration.vibrate(duration: 35);
        }
      } else {
        await HapticFeedback.mediumImpact();
      }
    } catch (_) {
      try {
        await HapticFeedback.mediumImpact();
      } catch (_) {}
    }
  }
}

