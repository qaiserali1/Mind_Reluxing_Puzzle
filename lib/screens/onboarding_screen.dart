import 'dart:math' as math;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';
import '../core/theme.dart';
import '../models/rake_stroke.dart';
import '../painters/sand_painter.dart';
import '../services/haptic_service.dart';
import 'garden_screen.dart';

/// Serene 3-slide introductory onboarding experience with interactive sand playground.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Slide 1 Rake Stroke Animation
  late AnimationController _strokeAnimController;

  // Slide 2 Interactive Sand Playground
  final List<RakeStroke> _demoStrokes = [];
  RakeStroke? _currentDemoStroke;

  @override
  void initState() {
    super.initState();
    _strokeAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
  }

  @override
  void dispose() {
    _strokeAnimController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    HapticService.lightTap();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyOnboardingComplete, true);

    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const GardenScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
  }

  void _nextPage() {
    HapticService.lightTap();
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Skip link
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_currentPage < 2)
                    TextButton(
                      onPressed: _completeOnboarding,
                      child: Text(
                        'Skip',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    )
                  else
                    const SizedBox(height: 48),
                ],
              ),
            ),

            // 3-Slide PageView
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) => setState(() => _currentPage = page),
                children: [
                  _buildSlide1(),
                  _buildSlide2(),
                  _buildSlide3(),
                ],
              ),
            ),

            // Bottom Navigation & Indicator Dots
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 12, 28, 24),
              child: Column(
                children: [
                  // Page Indicator Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (i) {
                      final isActive = i == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 20 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.accent : AppColors.borderLight,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),

                  // Full-width Primary Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        _currentPage == 2 ? 'Begin' : 'Continue',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // SLIDE 1 — Welcome
  Widget _buildSlide1() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: AppColors.sandBase,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.borderLight, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.sandShadow.withOpacity(0.3),
                  blurRadius: 16,
                ),
              ],
            ),
            child: AnimatedBuilder(
              animation: _strokeAnimController,
              builder: (context, _) {
                return CustomPaint(
                  painter: _AnimatedStrokePainter(progress: _strokeAnimController.value),
                );
              },
            ),
          ),
          const SizedBox(height: 40),
          Text(
            tr('welcome_title'),
            textAlign: TextAlign.center,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 34,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'A quiet place for your mind.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: AppColors.textSecondary,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  // SLIDE 2 — The Mechanic (Interactive sandbox)
  Widget _buildSlide2() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Drag to draw.',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Watch the sand transform under your touch.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          // Interactive mini canvas
          Container(
            height: 240,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.sandBase,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.borderLight),
              boxShadow: [
                BoxShadow(
                  color: AppColors.sandShadow.withOpacity(0.3),
                  blurRadius: 12,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final size = Size(constraints.maxWidth, constraints.maxHeight);
                  return GestureDetector(
                    onPanStart: (details) {
                      _currentDemoStroke = RakeStroke(
                        points: [Offset(details.localPosition.dx / size.width, details.localPosition.dy / size.height)],
                      );
                      HapticService.lightTap();
                      setState(() {});
                    },
                    onPanUpdate: (details) {
                      if (_currentDemoStroke != null) {
                        _currentDemoStroke!.points.add(
                          Offset(details.localPosition.dx / size.width, details.localPosition.dy / size.height),
                        );
                        setState(() {});
                      }
                    },
                    onPanEnd: (_) {
                      if (_currentDemoStroke != null && _currentDemoStroke!.points.length >= 2) {
                        _demoStrokes.add(_currentDemoStroke!);
                      }
                      _currentDemoStroke = null;
                      setState(() {});
                    },
                    child: CustomPaint(
                      painter: SandPainter(
                        strokes: _demoStrokes,
                        currentStroke: _currentDemoStroke,
                        grains: const [],
                        theme: SandTheme.warm,
                      ),
                      size: Size.infinite,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // SLIDE 3 — Inspiration & Philosophy
  Widget _buildSlide3() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildMiniFeatureIcon(Icons.waves_rounded),
              const SizedBox(width: 16),
              _buildMiniFeatureIcon(Icons.spa_outlined),
              const SizedBox(width: 16),
              _buildMiniFeatureIcon(Icons.all_inclusive_rounded),
            ],
          ),
          const SizedBox(height: 36),
          Text(
            'Find inspiration. Or create your own.',
            textAlign: TextAlign.center,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'No timers. No scores. Just you and the sand.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 15,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniFeatureIcon(IconData icon) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Icon(icon, color: AppColors.accent, size: 28),
    );
  }
}

class _AnimatedStrokePainter extends CustomPainter {
  final double progress;

  _AnimatedStrokePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final wavePaint = Paint()
      ..color = AppColors.sandShadow
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    final count = (progress * 50).toInt();
    for (int i = 0; i <= count; i++) {
      final t = i / 50.0;
      final x = size.width * (0.2 + 0.6 * t);
      final y = size.height * (0.5 + 0.18 * math.sin(t * 2 * math.pi));
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, wavePaint);
  }

  @override
  bool shouldRepaint(covariant _AnimatedStrokePainter oldDelegate) =>
      oldDelegate.progress != progress;
}

