import 'dart:math' as math;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/garden_provider.dart';
import '../services/haptic_service.dart';
import '../services/iap_service.dart';

/// Full-screen upsell screen for the €4.99 one-time Rake Premium unlock.
class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> with SingleTickerProviderStateMixin {
  bool _isProcessing = false;
  bool _showCelebration = false;
  late AnimationController _celebrationController;

  @override
  void initState() {
    super.initState();
    _celebrationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
  }

  @override
  void dispose() {
    _celebrationController.dispose();
    super.dispose();
  }

  Future<void> _handleUnlock() async {
    setState(() => _isProcessing = true);
    HapticService.lightTap();

    final success = await IapService.buyPremium();
    if (!mounted) return;

    setState(() => _isProcessing = false);

    if (success) {
      context.read<GardenProvider>().setPremium(true);
      _triggerCelebration();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not complete purchase. Please try again.'),
          backgroundColor: AppColors.textSecondary,
        ),
      );
    }
  }

  Future<void> _handleRestore() async {
    setState(() => _isProcessing = true);
    HapticService.lightTap();

    final success = await IapService.restorePurchases();
    if (!mounted) return;

    setState(() => _isProcessing = false);

    if (success) {
      context.read<GardenProvider>().setPremium(true);
      _triggerCelebration();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No previous purchases found.'),
          backgroundColor: AppColors.textSecondary,
        ),
      );
    }
  }

  void _triggerCelebration() {
    HapticService.softPulse();
    setState(() => _showCelebration = true);
    _celebrationController.forward().then((_) {
      if (mounted) {
        Future.delayed(const Duration(milliseconds: 600), () {
          if (mounted) Navigator.pop(context);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Top close button
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.close_rounded, size: 26),
                      color: AppColors.textPrimary,
                      onPressed: () {
                        HapticService.lightTap();
                        Navigator.pop(context);
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Hero Zen Sun Illustration
                  SizedBox(
                    width: 140,
                    height: 140,
                    child: CustomPaint(
                      painter: _ZenSunPainter(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Title
                  Text(
                    tr('premium_title'),
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 34,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      letterSpacing: 0.8,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Tagline description
                  Text(
                    tr('premium_desc'),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      height: 1.4,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Feature List Cards
                  _buildFeatureItem(Icons.auto_awesome_rounded, 'All 10 inspiration patterns'),
                  _buildFeatureItem(Icons.palette_outlined, '5 seasonal sand themes'),
                  _buildFeatureItem(Icons.play_circle_outline_rounded, 'Auto-draw relaxation animation'),
                  _buildFeatureItem(Icons.photo_library_outlined, 'Unlimited gallery saves'),
                  _buildFeatureItem(Icons.high_quality_rounded, 'High-resolution exports (4K)'),
                  _buildFeatureItem(Icons.block_rounded, 'No ads, ever'),

                  const SizedBox(height: 28),

                  // Price info card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
                    decoration: BoxDecoration(
                      color: AppColors.cardSurface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Text(
                      '${tr('premium_price')} — One-time purchase',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Unlock Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isProcessing ? null : _handleUnlock,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: _isProcessing
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : Text(
                              tr('buy_premium'),
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Restore Purchase
                  TextButton(
                    onPressed: _isProcessing ? null : _handleRestore,
                    child: Text(
                      tr('restore'),
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),

                  Text(
                    'No subscription. No hidden fees.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textSecondary.withOpacity(0.6),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Particle Celebration Overlay
          if (_showCelebration)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _celebrationController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _CelebrationParticlesPainter(
                      progress: _celebrationController.value,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.accentSoft.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: AppColors.accent),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Zen programmatic illustration of sun over sand waves.
class _ZenSunPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.42);
    final sunPaint = Paint()
      ..color = AppColors.premiumGold.withOpacity(0.85)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 26, sunPaint);

    final wavePaint = Paint()
      ..color = AppColors.sandShadow
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 3; i++) {
      final y = size.height * 0.65 + i * 14.0;
      final path = Path();
      path.moveTo(size.width * 0.15, y);
      path.quadraticBezierTo(size.width * 0.35, y - 8, size.width * 0.5, y);
      path.quadraticBezierTo(size.width * 0.65, y + 8, size.width * 0.85, y);
      canvas.drawPath(path, wavePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Floating sage particles celebrating premium activation.
class _CelebrationParticlesPainter extends CustomPainter {
  final double progress;
  static final List<Offset> _baseOffsets = List.generate(30, (i) {
    final rand = math.Random(i * 17);
    return Offset(rand.nextDouble(), rand.nextDouble());
  });

  _CelebrationParticlesPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < _baseOffsets.length; i++) {
      final base = _baseOffsets[i];
      final currentY = (base.dy - progress * 0.5) % 1.0;
      final x = (base.dx + 0.05 * math.sin(progress * 2 * math.pi + i)) * size.width;
      final y = currentY * size.height;
      final opacity = (1.0 - progress).clamp(0.0, 1.0);

      paint.color = (i % 2 == 0 ? AppColors.accent : AppColors.premiumGold)
          .withOpacity(opacity * 0.7);
      canvas.drawCircle(Offset(x, y), 3.0 + (i % 3), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CelebrationParticlesPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

