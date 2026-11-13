import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../data/inspiration_patterns.dart';
import '../models/rake_stroke.dart';
import '../models/sand_grain.dart';

/// CustomPainter rendering the textured sand surface, 3D rake grooves, and optional ghost pattern overlay.
class SandPainter extends CustomPainter {
  final List<RakeStroke> strokes;
  final RakeStroke? currentStroke;
  final List<SandGrain> grains;
  final double strokeOpacity;
  final InspirationPattern? ghostPattern;
  final double ghostOpacity;
  final SandTheme theme;

  const SandPainter({
    required this.strokes,
    required this.grains,
    this.currentStroke,
    this.strokeOpacity = 1.0,
    this.ghostPattern,
    this.ghostOpacity = 0.0,
    this.theme = SandTheme.warm,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    // 1. Base sand color with subtle vertical gradient (lighter at top, darker at bottom)
    final baseRect = Offset.zero & size;
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          theme.sandHighlight.withOpacity(theme.isDark ? 0.4 : 0.85),
          theme.sandBase,
          theme.sandShadow.withOpacity(theme.isDark ? 0.7 : 0.4),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(baseRect);
    canvas.drawRect(baseRect, gradientPaint);

    // 2. Sand grains (random dots for organic tactile texture)
    final grainPaint = Paint()..style = PaintingStyle.fill;
    for (final grain in grains) {
      grainPaint.color = theme.sandShadow.withOpacity(
        (grain.opacity * (theme.isDark ? 0.3 : 0.6)).clamp(0.05, 1.0),
      );
      final center = Offset(
        grain.position.dx * size.width,
        grain.position.dy * size.height,
      );
      canvas.drawCircle(center, grain.size, grainPaint);
    }

    // 3. Optional Ghost Overlay Pattern for tracing
    if (ghostPattern != null && ghostOpacity > 0.0) {
      _drawGhostPattern(canvas, ghostPattern!, size, ghostOpacity);
    }

    // 4. Render completed rake strokes
    if (strokeOpacity > 0.0) {
      for (final stroke in strokes) {
        _drawRakeStroke(canvas, stroke, size, strokeOpacity);
      }

      // Render the active in-progress stroke if present
      if (currentStroke != null) {
        _drawRakeStroke(canvas, currentStroke!, size, 1.0);
      }
    }
  }

  /// Draws the semi-transparent guide pattern for mindfulness tracing.
  void _drawGhostPattern(
    Canvas canvas,
    InspirationPattern pattern,
    Size size,
    double opacity,
  ) {
    final ghostPaint = Paint()
      ..color = theme.textPrimary.withOpacity((opacity * 0.28).clamp(0.0, 1.0))
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    for (final strokePoints in pattern.strokes) {
      if (strokePoints.length < 2) continue;
      final path = Path();
      path.moveTo(
        strokePoints[0].dx * size.width,
        strokePoints[0].dy * size.height,
      );
      for (int i = 1; i < strokePoints.length; i++) {
        path.lineTo(
          strokePoints[i].dx * size.width,
          strokePoints[i].dy * size.height,
        );
      }
      canvas.drawPath(path, ghostPaint);
    }
  }

  /// Draws a single rake stroke with dual shadow & highlight passes
  /// to create a satisfying, tactile 3D groove in the sand.
  void _drawRakeStroke(
    Canvas canvas,
    RakeStroke stroke,
    Size size,
    double opacity,
  ) {
    if (stroke.points.length < 2) return;

    // Create smooth path from points using quadratic Bezier curves
    final path = Path();
    path.moveTo(
      stroke.points[0].dx * size.width,
      stroke.points[0].dy * size.height,
    );

    for (int i = 1; i < stroke.points.length; i++) {
      final p1 = Offset(
        stroke.points[i - 1].dx * size.width,
        stroke.points[i - 1].dy * size.height,
      );
      final p2 = Offset(
        stroke.points[i].dx * size.width,
        stroke.points[i].dy * size.height,
      );
      final mid = Offset((p1.dx + p2.dx) / 2, (p1.dy + p2.dy) / 2);
      path.quadraticBezierTo(p1.dx, p1.dy, mid.dx, mid.dy);
    }

    // Draw shadow groove (darker sand)
    final shadowPaint = Paint()
      ..color = theme.sandShadow.withOpacity(0.7 * opacity)
      ..strokeWidth = stroke.width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, shadowPaint);

    // Draw highlight edge (lighter sand, offset by 2px)
    final highlightPaint = Paint()
      ..color = theme.sandHighlight.withOpacity(0.6 * opacity)
      ..strokeWidth = stroke.width * 0.4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.save();
    canvas.translate(0, -2);
    canvas.drawPath(path, highlightPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant SandPainter oldDelegate) {
    return oldDelegate.strokes != strokes ||
        oldDelegate.currentStroke != currentStroke ||
        oldDelegate.strokeOpacity != strokeOpacity ||
        oldDelegate.ghostPattern != ghostPattern ||
        oldDelegate.ghostOpacity != ghostOpacity ||
        oldDelegate.theme != theme ||
        oldDelegate.grains != grains;
  }
}
