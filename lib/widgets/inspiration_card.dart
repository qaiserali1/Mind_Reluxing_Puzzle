import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../data/inspiration_patterns.dart';
import '../providers/garden_provider.dart';
import '../services/haptic_service.dart';

/// Modal bottom sheet displaying meditation inspiration cards.
class InspirationBottomSheet extends StatelessWidget {
  final VoidCallback onUnlockMoreWithAd;
  final VoidCallback onOpenPremium;

  const InspirationBottomSheet({
    super.key,
    required this.onUnlockMoreWithAd,
    required this.onOpenPremium,
  });

  static void show(
    BuildContext context, {
    required VoidCallback onUnlockMoreWithAd,
    required VoidCallback onOpenPremium,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => InspirationBottomSheet(
        onUnlockMoreWithAd: onUnlockMoreWithAd,
        onOpenPremium: onOpenPremium,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final garden = context.watch<GardenProvider>();
    final isPremium = garden.isPremium;
    final currentTheme = garden.theme;

    return Container(
      height: MediaQuery.of(context).size.height * 0.70,
      decoration: BoxDecoration(
        color: currentTheme.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12.0, bottom: 8.0),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: currentTheme.textSecondary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tr('inspiration'),
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: currentTheme.textPrimary,
                  ),
                ),
                if (!isPremium)
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      onOpenPremium();
                    },
                    icon: const Icon(Icons.star_rounded, size: 16, color: AppColors.premiumGold),
                    label: Text(
                      tr('premium'),
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.premiumGold,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Horizontal scroll of pattern cards
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              scrollDirection: Axis.horizontal,
              itemCount: InspirationPatterns.all.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16.0),
              itemBuilder: (context, index) {
                final pattern = InspirationPatterns.all[index];
                // Free tier gets first 3 patterns; remaining 7 are locked
                final isLocked = !isPremium && index >= 3;
                final isSelected = garden.ghostPattern?.id == pattern.id;

                return _InspirationCardItem(
                  pattern: pattern,
                  isLocked: isLocked,
                  isSelected: isSelected,
                  isPremium: isPremium,
                  theme: currentTheme,
                  onTap: () {
                    HapticService.lightTap();
                    if (isLocked) {
                      onUnlockMoreWithAd();
                    } else {
                      garden.setGhostPattern(pattern);
                      Navigator.pop(context);
                    }
                  },
                  onAutoDraw: isPremium
                      ? () {
                          HapticService.softPulse();
                          garden.autoDrawPattern(pattern);
                          Navigator.pop(context);
                        }
                      : null,
                );
              },
            ),
          ),
          const SizedBox(height: 24.0),
        ],
      ),
    );
  }
}

class _InspirationCardItem extends StatefulWidget {
  final InspirationPattern pattern;
  final bool isLocked;
  final bool isSelected;
  final bool isPremium;
  final SandTheme theme;
  final VoidCallback onTap;
  final VoidCallback? onAutoDraw;

  const _InspirationCardItem({
    required this.pattern,
    required this.isLocked,
    required this.isSelected,
    required this.isPremium,
    required this.theme,
    required this.onTap,
    this.onAutoDraw,
  });

  @override
  State<_InspirationCardItem> createState() => _InspirationCardItemState();
}

class _InspirationCardItemState extends State<_InspirationCardItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: SizedBox(
          width: 160,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Card Preview Box
              Container(
                height: 180,
                width: 160,
                decoration: BoxDecoration(
                  color: widget.theme.sandBase,
                  borderRadius: BorderRadius.circular(18.0),
                  border: Border.all(
                    color: widget.isSelected
                        ? AppColors.accent
                        : widget.theme.borderLight.withOpacity(0.8),
                    width: widget.isSelected ? 2.0 : 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.theme.sandShadow.withOpacity(0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18.0),
                  child: Stack(
                    children: [
                      // Mini Sand Painter
                      CustomPaint(
                        painter: _MiniPatternPainter(
                          pattern: widget.pattern,
                          theme: widget.theme,
                        ),
                        size: Size.infinite,
                      ),

                      // Locked Overlay
                      if (widget.isLocked)
                        Container(
                          color: Colors.black.withOpacity(0.35),
                          child: const Center(
                            child: Icon(
                              Icons.lock_outline_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),

                      // Selected checkmark badge
                      if (widget.isSelected)
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.accent,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),

                      // Auto-draw option for premium users
                      if (widget.isPremium && widget.onAutoDraw != null)
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: widget.onAutoDraw,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.accent.withOpacity(0.85),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 14),
                                    const SizedBox(width: 2),
                                    Text(
                                      tr('auto_draw'),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Pattern Name
              Text(
                tr(widget.pattern.nameKey),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: widget.theme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniPatternPainter extends CustomPainter {
  final InspirationPattern pattern;
  final SandTheme theme;

  _MiniPatternPainter({required this.pattern, required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = theme.sandBase;
    canvas.drawRect(Offset.zero & size, bgPaint);

    final linePaint = Paint()
      ..color = theme.sandShadow.withOpacity(0.9)
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final highlightPaint = Paint()
      ..color = theme.sandHighlight.withOpacity(0.7)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (final stroke in pattern.strokes) {
      if (stroke.length < 2) continue;
      final path = Path();
      path.moveTo(stroke[0].dx * size.width, stroke[0].dy * size.height);
      for (int i = 1; i < stroke.length; i++) {
        path.lineTo(stroke[i].dx * size.width, stroke[i].dy * size.height);
      }
      canvas.drawPath(path, linePaint);

      canvas.save();
      canvas.translate(0, -1);
      canvas.drawPath(path, highlightPaint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _MiniPatternPainter oldDelegate) =>
      oldDelegate.pattern != pattern || oldDelegate.theme != theme;
}

