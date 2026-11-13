import 'package:flutter/material.dart';

/// Embeddable interactive sand garden canvas for external third-party wellness and meditation apps.
class RakeEmbedCanvas extends StatefulWidget {
  final Color sandColor;
  final Color grooveColor;
  final double strokeWidth;
  final bool readOnly;
  final ValueChanged<int>? onStrokeCountChanged;

  const RakeEmbedCanvas({
    super.key,
    this.sandColor = const Color(0xFFE8DCC8),
    this.grooveColor = const Color(0xFFD4C4A8),
    this.strokeWidth = 16.0,
    this.readOnly = false,
    this.onStrokeCountChanged,
  });

  @override
  State<RakeEmbedCanvas> createState() => _RakeEmbedCanvasState();
}

class _RakeEmbedCanvasState extends State<RakeEmbedCanvas> {
  final List<List<Offset>> _strokes = [];
  List<Offset>? _activeStroke;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.sandColor,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: widget.grooveColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: GestureDetector(
          onPanStart: widget.readOnly
              ? null
              : (details) {
                  setState(() {
                    _activeStroke = [details.localPosition];
                  });
                },
          onPanUpdate: widget.readOnly
              ? null
              : (details) {
                  if (_activeStroke != null) {
                    setState(() {
                      _activeStroke!.add(details.localPosition);
                    });
                  }
                },
          onPanEnd: widget.readOnly
              ? null
              : (_) {
                  if (_activeStroke != null && _activeStroke!.length >= 2) {
                    _strokes.add(List.from(_activeStroke!));
                    widget.onStrokeCountChanged?.call(_strokes.length);
                  }
                  _activeStroke = null;
                  setState(() {});
                },
          child: CustomPaint(
            painter: _EmbedSandPainter(
              strokes: _strokes,
              activeStroke: _activeStroke,
              sandColor: widget.sandColor,
              grooveColor: widget.grooveColor,
              strokeWidth: widget.strokeWidth,
            ),
            size: Size.infinite,
          ),
        ),
      ),
    );
  }
}

class _EmbedSandPainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final List<Offset>? activeStroke;
  final Color sandColor;
  final Color grooveColor;
  final double strokeWidth;

  _EmbedSandPainter({
    required this.strokes,
    this.activeStroke,
    required this.sandColor,
    required this.grooveColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = sandColor;
    canvas.drawRect(Offset.zero & size, bgPaint);

    final linePaint = Paint()
      ..color = grooveColor
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..strokeWidth = strokeWidth * 0.4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (final stroke in strokes) {
      _drawPath(canvas, stroke, linePaint, highlightPaint);
    }

    if (activeStroke != null) {
      _drawPath(canvas, activeStroke!, linePaint, highlightPaint);
    }
  }

  void _drawPath(Canvas canvas, List<Offset> points, Paint shadow, Paint highlight) {
    if (points.length < 2) return;
    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, shadow);

    canvas.save();
    canvas.translate(0, -2);
    canvas.drawPath(path, highlight);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _EmbedSandPainter oldDelegate) => true;
}

