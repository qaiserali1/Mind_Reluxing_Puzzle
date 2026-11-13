import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme_packs.dart';

/// Sand theme definition for seasonal and meditative variations.
class SandTheme {
  final String id;
  final String nameKey;
  final Color sandBase;
  final Color sandShadow;
  final Color sandHighlight;
  final Color background;
  final Color textPrimary;
  final Color textSecondary;
  final Color cardSurface;
  final Color borderLight;
  final bool isDark;
  final bool isPremium;

  const SandTheme({
    required this.id,
    required this.nameKey,
    required this.sandBase,
    required this.sandShadow,
    required this.sandHighlight,
    required this.background,
    required this.textPrimary,
    required this.textSecondary,
    required this.cardSurface,
    required this.borderLight,
    this.isDark = false,
    this.isPremium = false,
  });

  static const SandTheme warm = SandTheme(
    id: 'warm',
    nameKey: 'theme_warm',
    sandBase: Color(0xFFE8DCC8),
    sandShadow: Color(0xFFD4C4A8),
    sandHighlight: Color(0xFFF2E8D5),
    background: Color(0xFFFAF6EF),
    textPrimary: Color(0xFF3D3529),
    textSecondary: Color(0xFF8B7D6B),
    cardSurface: Color(0xFFF4ECE1),
    borderLight: Color(0xFFE2D6C3),
    isDark: false,
    isPremium: false,
  );

  static const SandTheme sakura = SandTheme(
    id: 'sakura',
    nameKey: 'theme_sakura',
    sandBase: Color(0xFFF5DEE5),
    sandShadow: Color(0xFFE8C5CE),
    sandHighlight: Color(0xFFFBEFF3),
    background: Color(0xFFFDF9FA),
    textPrimary: Color(0xFF4A343A),
    textSecondary: Color(0xFF91737B),
    cardSurface: Color(0xFFF9EEF1),
    borderLight: Color(0xFFECD5DB),
    isDark: false,
    isPremium: true,
  );

  static const SandTheme moon = SandTheme(
    id: 'moon',
    nameKey: 'theme_moon',
    sandBase: Color(0xFF3D4A5C),
    sandShadow: Color(0xFF2E3846),
    sandHighlight: Color(0xFF52617A),
    background: Color(0xFF1A1F2E),
    textPrimary: Color(0xFFF0F0F0),
    textSecondary: Color(0xFFB0B0B0),
    cardSurface: Color(0xFF242C3E),
    borderLight: Color(0xFF333E54),
    isDark: true,
    isPremium: true,
  );

  static const SandTheme snow = SandTheme(
    id: 'snow',
    nameKey: 'theme_snow',
    sandBase: Color(0xFFF0F2F5),
    sandShadow: Color(0xFFDCE0E8),
    sandHighlight: Color(0xFFFFFFFF),
    background: Color(0xFFFAFBFD),
    textPrimary: Color(0xFF2D333D),
    textSecondary: Color(0xFF7A8394),
    cardSurface: Color(0xFFEFF2F7),
    borderLight: Color(0xFFDFE4ED),
    isDark: false,
    isPremium: true,
  );

  static const SandTheme autumn = SandTheme(
    id: 'autumn',
    nameKey: 'theme_autumn',
    sandBase: Color(0xFFD4A574),
    sandShadow: Color(0xFFB8895C),
    sandHighlight: Color(0xFFE8C09A),
    background: Color(0xFFF5EDE0),
    textPrimary: Color(0xFF3D2A18),
    textSecondary: Color(0xFF8C6E4F),
    cardSurface: Color(0xFFEFE4D2),
    borderLight: Color(0xFFDFCBB1),
    isDark: false,
    isPremium: true,
  );

  static const SandTheme obsidian = SandTheme(
    id: 'obsidian',
    nameKey: 'theme_obsidian',
    sandBase: Color(0xFF2A2A2A),
    sandShadow: Color(0xFF1A1A1A),
    sandHighlight: Color(0xFF3D3D3D),
    background: Color(0xFF0F0F0F),
    textPrimary: Color(0xFFF0F0F0),
    textSecondary: Color(0xFFB0B0B0),
    cardSurface: Color(0xFF1E1E1E),
    borderLight: Color(0xFF2D2D2D),
    isDark: true,
    isPremium: true,
  );

  static List<SandTheme> get all => ThemePacks.availableThemes;

  static SandTheme getById(String id) {
    return all.firstWhere((t) => t.id == id, orElse: () => warm);
  }
}

/// App color palette strictly adhering to the specification.
class AppColors {
  // Sand Garden Colors
  static const Color sandBase = Color(0xFFE8DCC8);
  static const Color sandShadow = Color(0xFFD4C4A8);
  static const Color sandHighlight = Color(0xFFF2E8D5);

  // Surface & Text
  static const Color background = Color(0xFFFAF6EF);
  static const Color textPrimary = Color(0xFF3D3529);
  static const Color textSecondary = Color(0xFF8B7D6B);

  // Accents
  static const Color accent = Color(0xFF7FA88E); // Sage green
  static const Color accentSoft = Color(0xFFB8C9B5);
  static const Color premiumGold = Color(0xFFC9A961);

  // Card & Element background
  static const Color cardSurface = Color(0xFFF4ECE1);
  static const Color borderLight = Color(0xFFE2D6C3);
}

/// App theme configuration with elegant serif headers and clean sans-serif body.
class AppTheme {
  static ThemeData getThemeFor(SandTheme sandTheme) {
    final textTheme = TextTheme(
      displayLarge: GoogleFonts.cormorantGaramond(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: sandTheme.textPrimary,
        letterSpacing: 0.5,
      ),
      displayMedium: GoogleFonts.cormorantGaramond(
        fontSize: 30,
        fontWeight: FontWeight.w600,
        color: sandTheme.textPrimary,
        letterSpacing: 0.5,
      ),
      displaySmall: GoogleFonts.cormorantGaramond(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: sandTheme.textPrimary,
      ),
      headlineMedium: GoogleFonts.cormorantGaramond(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: sandTheme.textPrimary,
      ),
      titleLarge: GoogleFonts.cormorantGaramond(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: sandTheme.textPrimary,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: sandTheme.textPrimary,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: sandTheme.textPrimary,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: sandTheme.textSecondary,
        height: 1.4,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: sandTheme.textPrimary,
        letterSpacing: 0.2,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: sandTheme.isDark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: sandTheme.background,
      colorScheme: ColorScheme(
        brightness: sandTheme.isDark ? Brightness.dark : Brightness.light,
        primary: AppColors.accent,
        secondary: AppColors.accentSoft,
        surface: sandTheme.background,
        error: Colors.redAccent,
        onPrimary: Colors.white,
        onSecondary: sandTheme.textPrimary,
        onSurface: sandTheme.textPrimary,
        onError: Colors.white,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: sandTheme.textPrimary),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: sandTheme.cardSurface,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.accent,
        contentTextStyle: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static ThemeData get lightTheme => getThemeFor(SandTheme.warm);
}
