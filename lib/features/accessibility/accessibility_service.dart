import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import '../../core/feature_flags.dart';
import '../../core/theme.dart';
import '../../data/inspiration_patterns.dart';

/// Comprehensive accessibility service ensuring full VoiceOver, TalkBack, Switch Control,
/// and High Contrast compatibility.
class AccessibilityService {
  /// High Contrast theme for low-vision practitioners (Guarded by FeatureFlags.enableHighContrast).
  static const SandTheme highContrast = SandTheme(
    id: 'high_contrast',
    nameKey: 'theme_high_contrast',
    sandBase: Color(0xFFFFFFFF),
    sandShadow: Color(0xFF000000),
    sandHighlight: Color(0xFFFFFF00),
    background: Color(0xFF000000),
    textPrimary: Color(0xFFFFFF00),
    textSecondary: Color(0xFFFFFFFF),
    cardSurface: Color(0xFF1E1E1E),
    borderLight: Color(0xFFFFFF00),
    isDark: true,
    isPremium: false,
  );

  /// Returns the High Contrast theme if enabled via feature flag.
  static SandTheme? getActiveHighContrastTheme() {
    if (!FeatureFlags.enableHighContrast) return null;
    return highContrast;
  }

  /// Announces spoken descriptions of patterns for visually impaired practitioners.
  static void announcePattern(InspirationPattern pattern) {
    String description;
    switch (pattern.id) {
      case 'concentric':
        description = 'Three centered concentric circular grooves radiating outward on smooth sand.';
        break;
      case 'waves':
        description = 'Five parallel undulating horizontal water ripple grooves.';
        break;
      case 'spiral':
        description = 'A single continuous Archimedean spiral expanding gently from center outward.';
        break;
      case 'zen_wave':
        description = 'Seven classic parallel curved karesansui zen rake grooves.';
        break;
      case 'bamboo':
        description = 'Three vertical segmented bamboo stalks with horizontal node dividers.';
        break;
      case 'leaf':
        description = 'An organic leaf silhouette with curved central spine and ten symmetrical veins.';
        break;
      case 'mountains':
        description = 'Four zigzag mountain peaks with subtle ridge shadow lines.';
        break;
      case 'sunrays':
        description = 'Twelve straight lines radiating outwards like gentle morning sunlight.';
        break;
      case 'lotus':
        description = 'An eight-petal symmetrical lotus blossom centered on the sand.';
        break;
      case 'tree':
        description = 'A minimal zen bonsai tree with strong trunk and four branching leaf clusters.';
        break;
      default:
        description = 'A calm zen pattern etched into sand.';
    }

    SemanticsService.announce(description, TextDirection.ltr);
  }

  /// Checks if reduced motion is requested by the OS.
  static bool get isReducedMotionRequested {
    return WidgetsBinding.instance.platformDispatcher.accessibilityFeatures.reduceMotion;
  }
}
