import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';
import '../core/theme.dart';
import '../models/sand_grain.dart';
import '../services/gdpr_service.dart';
import 'garden_screen.dart';
import 'gdpr_screen.dart';
import 'onboarding_screen.dart';

/// Zen splash screen with calming staggered fade animations, GDPR and Onboarding routing.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sandFadeAnimation;
  late Animation<double> _logoFadeAnimation;
  final List<SandGrain> _grains = SandGrain.generate(count: 600, seed: 108);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    // Sand texture fades in (0 to 1200ms -> 0.0 to 0.5)
    _sandFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );

    // Logo & tagline fade in with 600ms delay (600 to 1800ms -> 0.25 to 0.75)
    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.25, 0.75, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();

    // After animation and hold, route: GDPR -> Onboarding -> Garden
    Timer(const Duration(milliseconds: 3000), () async {
      if (!mounted) return;
      final hasGdprResponded = await GdprService.hasUserResponded();
      final prefs = await SharedPreferences.getInstance();
      final onboardingComplete = prefs.getBool(AppConstants.keyOnboardingComplete) ?? false;

      Widget targetScreen;
      if (!hasGdprResponded) {
        targetScreen = const GdprScreen();
      } else if (!onboardingComplete) {
        targetScreen = const OnboardingScreen();
      } else {
        targetScreen = const GardenScreen();
      }

      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => targetScreen,
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                ),
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: [
              // 1. Subtle sand texture
              Opacity(
                opacity: _sandFadeAnimation.value,
                child: CustomPaint(
                  painter: _SplashSandPainter(grains: _grains),
                  size: Size.infinite,
                ),
              ),

              // 2. Centered Logo and tagline
              Center(
                child: Opacity(
                  opacity: _logoFadeAnimation.value,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        tr('app_name'),
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 48,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2.0,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        tr('tagline'),
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.8,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SplashSandPainter extends CustomPainter {
  final List<SandGrain> grains;

  _SplashSandPainter({required this.grains});

  @override
  void paint(Canvas canvas, Size size) {
    final baseRect = Offset.zero & size;
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.sandHighlight.withOpacity(0.5),
          AppColors.sandBase.withOpacity(0.6),
          AppColors.sandShadow.withOpacity(0.3),
        ],
      ).createShader(baseRect);
    canvas.drawRect(baseRect, gradientPaint);

    final grainPaint = Paint()..style = PaintingStyle.fill;
    for (final grain in grains) {
      grainPaint.color = AppColors.sandShadow.withOpacity(grain.opacity * 0.4);
      final center = Offset(
        grain.position.dx * size.width,
        grain.position.dy * size.height,
      );
      canvas.drawCircle(center, grain.size, grainPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
