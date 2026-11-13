import 'dart:math' as math;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme.dart';
import '../services/gdpr_service.dart';
import '../services/haptic_service.dart';
import 'garden_screen.dart';
import 'privacy_screen.dart';

/// Full-screen GDPR consent screen matching the serene aesthetic.
class GdprScreen extends StatelessWidget {
  const GdprScreen({super.key});

  void _onChoice(BuildContext context, bool accepted) async {
    HapticService.lightTap();
    await GdprService.setConsent(accepted);
    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const GardenScreen(),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),

              // Meditative sand circle illustration with rake lines
              SizedBox(
                width: 140,
                height: 140,
                child: CustomPaint(painter: _GdprSandIllustrationPainter()),
              ),

              const SizedBox(height: 36),

              // Title
              Text(
                tr('welcome_title'),
                textAlign: TextAlign.center,
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 18),

              // Body text
              Text(
                tr('gdpr_body'),
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  height: 1.5,
                  color: AppColors.textSecondary,
                ),
              ),

              const Spacer(),

              // Primary "Accept" button (Sage Green)
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => _onChoice(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    tr('accept'),
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Secondary "Necessary Only" button
              TextButton(
                onPressed: () => _onChoice(context, false),
                child: Text(
                  tr('necessary_only'),
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Privacy Policy link
              TextButton(
                onPressed: () {
                  HapticService.lightTap();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PrivacyScreen()),
                  );
                },
                child: Text(
                  tr('privacy'),
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.accent,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _GdprSandIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.42;

    // Sand base disk
    final sandPaint = Paint()
      ..color = AppColors.sandBase
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, sandPaint);

    final borderPaint = Paint()
      ..color = AppColors.sandShadow.withOpacity(0.5)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, borderPaint);

    // Rake concentric circles
    final rakePaint = Paint()
      ..color = AppColors.sandShadow
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (int i = 1; i <= 3; i++) {
      canvas.drawCircle(center, radius * (i / 4.0), rakePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

