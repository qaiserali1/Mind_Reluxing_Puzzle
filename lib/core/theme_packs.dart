import 'package:flutter/material.dart';
import 'feature_flags.dart';
import 'theme.dart';

/// 10 Additional Premium Collector Sand Themes for Phase 4.
class ThemePacks {
  static const SandTheme wabiSabi = SandTheme(
    id: 'wabi_sabi',
    nameKey: 'theme_wabi_sabi',
    sandBase: Color(0xFFD4B298),
    sandShadow: Color(0xFFB58E72),
    sandHighlight: Color(0xFFE5CCB8),
    background: Color(0xFFF7F2EC),
    textPrimary: Color(0xFF38291F),
    textSecondary: Color(0xFF7A6455),
    cardSurface: Color(0xFFEDE4DC),
    borderLight: Color(0xFFDACCC0),
    isDark: false,
    isPremium: true,
  );

  static const SandTheme nordicWinter = SandTheme(
    id: 'nordic_winter',
    nameKey: 'theme_nordic_winter',
    sandBase: Color(0xFFDCE6EF),
    sandShadow: Color(0xFFBCCDD9),
    sandHighlight: Color(0xFFEFF5FA),
    background: Color(0xFFF6FAFC),
    textPrimary: Color(0xFF223547),
    textSecondary: Color(0xFF6B8399),
    cardSurface: Color(0xFFEAF1F7),
    borderLight: Color(0xFFD3E0EA),
    isDark: false,
    isPremium: true,
  );

  static const SandTheme mediterranean = SandTheme(
    id: 'mediterranean',
    nameKey: 'theme_mediterranean',
    sandBase: Color(0xFFE8B68C),
    sandShadow: Color(0xFFCA9569),
    sandHighlight: Color(0xFFF4CCA8),
    background: Color(0xFFFAF3EC),
    textPrimary: Color(0xFF4A2B14),
    textSecondary: Color(0xFF8A6242),
    cardSurface: Color(0xFFF5E7DB),
    borderLight: Color(0xFFE5D1BE),
    isDark: false,
    isPremium: true,
  );

  static const SandTheme lavenderFields = SandTheme(
    id: 'lavender_fields',
    nameKey: 'theme_lavender',
    sandBase: Color(0xFFE0D7ED),
    sandShadow: Color(0xFFC3B5D6),
    sandHighlight: Color(0xFFEFE9FA),
    background: Color(0xFFFAF8FD),
    textPrimary: Color(0xFF35254A),
    textSecondary: Color(0xFF7A6B8F),
    cardSurface: Color(0xFFF0EBF7),
    borderLight: Color(0xFFDFD5EB),
    isDark: false,
    isPremium: true,
  );

  static const SandTheme goldenHour = SandTheme(
    id: 'golden_hour',
    nameKey: 'theme_golden_hour',
    sandBase: Color(0xFFF0CA84),
    sandShadow: Color(0xFFD4A85B),
    sandHighlight: Color(0xFFFCE1A8),
    background: Color(0xFFFDF7EB),
    textPrimary: Color(0xFF422E0C),
    textSecondary: Color(0xFF8A6D38),
    cardSurface: Color(0xFFF7EDD5),
    borderLight: Color(0xFFEAD8B5),
    isDark: false,
    isPremium: true,
  );

  static const SandTheme monochrome = SandTheme(
    id: 'monochrome',
    nameKey: 'theme_monochrome',
    sandBase: Color(0xFFE6E6E6),
    sandShadow: Color(0xFFC2C2C2),
    sandHighlight: Color(0xFFFFFFFF),
    background: Color(0xFFF7F7F7),
    textPrimary: Color(0xFF141414),
    textSecondary: Color(0xFF6B6B6B),
    cardSurface: Color(0xFFEEEEEE),
    borderLight: Color(0xFFD6D6D6),
    isDark: false,
    isPremium: true,
  );

  static const SandTheme roseGold = SandTheme(
    id: 'rose_gold',
    nameKey: 'theme_rose_gold',
    sandBase: Color(0xFFE8BEB7),
    sandShadow: Color(0xFFCA9D95),
    sandHighlight: Color(0xFFF7D5CF),
    background: Color(0xFFFDF6F5),
    textPrimary: Color(0xFF452420),
    textSecondary: Color(0xFF875E59),
    cardSurface: Color(0xFFF5E4E1),
    borderLight: Color(0xFFE5CAC5),
    isDark: false,
    isPremium: true,
  );

  static const SandTheme deepSea = SandTheme(
    id: 'deep_sea',
    nameKey: 'theme_deep_sea',
    sandBase: Color(0xFF224854),
    sandShadow: Color(0xFF13323B),
    sandHighlight: Color(0xFF386370),
    background: Color(0xFF0C1B20),
    textPrimary: Color(0xFFE4F3F7),
    textSecondary: Color(0xFF86AAB5),
    cardSurface: Color(0xFF152A30),
    borderLight: Color(0xFF27434C),
    isDark: true,
    isPremium: true,
  );

  static const SandTheme paperWhite = SandTheme(
    id: 'paper_white',
    nameKey: 'theme_paper_white',
    sandBase: Color(0xFFFDFBF7),
    sandShadow: Color(0xFFEAE5DB),
    sandHighlight: Color(0xFFFFFFFF),
    background: Color(0xFFFAF7F0),
    textPrimary: Color(0xFF2B2824),
    textSecondary: Color(0xFF756F64),
    cardSurface: Color(0xFFF4EFE5),
    borderLight: Color(0xFFE3DCCE),
    isDark: false,
    isPremium: false,
  );

  static const SandTheme cosmic = SandTheme(
    id: 'cosmic',
    nameKey: 'theme_cosmic',
    sandBase: Color(0xFF241C38),
    sandShadow: Color(0xFF160F26),
    sandHighlight: Color(0xFF3B2E5C),
    background: Color(0xFF0F0A1A),
    textPrimary: Color(0xFFEADBFC),
    textSecondary: Color(0xFF9E8AB5),
    cardSurface: Color(0xFF1A132B),
    borderLight: Color(0xFF2E234A),
    isDark: true,
    isPremium: true,
  );

  /// 6 Core Base Themes available at initial public launch
  static List<SandTheme> get baseThemes => const [
        SandTheme.warm,
        SandTheme.sakura,
        SandTheme.moon,
        SandTheme.snow,
        SandTheme.autumn,
        SandTheme.obsidian,
      ];

  /// 10 Advanced Themes reserved for Phase 4 progressive rollout
  static const List<SandTheme> advancedThemes = [
    wabiSabi,
    nordicWinter,
    mediterranean,
    lavenderFields,
    goldenHour,
    monochrome,
    roseGold,
    deepSea,
    paperWhite,
    cosmic,
  ];

  /// Backward-compatible alias
  static const List<SandTheme> additionalThemes = advancedThemes;

  /// Returns base themes only unless enableAdvancedThemes flag is true
  static List<SandTheme> get availableThemes =>
      FeatureFlags.enableAdvancedThemes
          ? [...baseThemes, ...advancedThemes]
          : baseThemes;
}
