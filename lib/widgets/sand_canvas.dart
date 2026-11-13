import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../models/rake_stroke.dart';
import '../painters/sand_painter.dart';
import '../providers/garden_provider.dart';
import '../services/audio_service.dart';
import '../services/haptic_service.dart';

/// The interactive sand garden canvas where the player meditatively draws rake patterns.
class SandCanvas extends StatefulWidget {
  final GlobalKey canvasKey;

  const SandCanvas({
    super.key,
    required this.canvasKey,
  });

  @override
  State<SandCanvas> createState() => SandCanvasState();
}

class SandCanvasState extends State<SandCanvas> with SingleTickerProviderStateMixin {
  RakeStroke? _currentStroke;
  late AnimationController _eraseController;
  late Animation<double> _eraseAnimation;

  // Single pointer enforcement
  int? _activePointerId;

  // First-launch coach mark
  bool _showCoachMark = true;
  Timer? _coachMarkTimer;

  // Staggered erase animation
  int _lastStrokePlayMs = 0;

  @override
  void initState() {
    super.initState();
    _eraseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: AppConstants.eraseDurationMs),
    );

    _eraseAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _eraseController,
        curve: Curves.easeInOut,
      ),
    );

    _eraseController.addListener(() {
      setState(() {});
    });

    _eraseController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        final provider = context.read<GardenProvider>();
        provider.finishErase();
        _eraseController.reset();
      }
    });

    // Auto-dismiss coach mark after 3.5 seconds
    _coachMarkTimer = Timer(const Duration(milliseconds: 3500), () {
      if (mounted) setState(() => _showCoachMark = false);
    });
  }

  @override
  void dispose() {
    _coachMarkTimer?.cancel();
    _eraseController.dispose();
    super.dispose();
  }

  /// Triggers smooth fade out of all strokes over 800ms with soothing whoosh sound.
  void animateSmoothErase() {
    AudioService.playErase();
    _eraseController.forward(from: 0.0);
  }

  void _dismissCoachMark() {
    if (_showCoachMark) {
      _coachMarkTimer?.cancel();
      setState(() => _showCoachMark = false);
    }
  }

  /// Normalizes screen coordinates to the 0.0 - 1.0 unit box.
  Offset _normalize(Offset localPosition, Size size) {
    if (size.width == 0 || size.height == 0) return Offset.zero;
    final dx = (localPosition.dx / size.width).clamp(0.0, 1.0);
    final dy = (localPosition.dy / size.height).clamp(0.0, 1.0);
    return Offset(dx, dy);
  }

  @override
  Widget build(BuildContext context) {
    final gardenProvider = context.watch<GardenProvider>();
    final currentTheme = gardenProvider.theme;

    return RepaintBoundary(
      key: widget.canvasKey,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
          boxShadow: [
            BoxShadow(
              color: currentTheme.sandShadow.withOpacity(0.35),
              blurRadius: 18.0,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final size = Size(constraints.maxWidth, constraints.maxHeight);

              return Listener(
                onPointerDown: (event) {
                  if (_activePointerId == null && !_eraseController.isAnimating) {
                    _activePointerId = event.pointer;
                    _dismissCoachMark();

                    final normalized = _normalize(event.localPosition, size);
                    _currentStroke = RakeStroke(
                      points: [normalized],
                      width: AppConstants.defaultStrokeWidth,
                    );
                    HapticService.lightTap();
                    AudioService.playRakeStroke();
                    setState(() {});
                  }
                },
                onPointerMove: (event) {
                  if (event.pointer == _activePointerId && _currentStroke != null) {
                    final normalized = _normalize(event.localPosition, size);
                    final last = _currentStroke!.points.last;
                    final distance = Offset(
                      (normalized.dx - last.dx) * size.width,
                      (normalized.dy - last.dy) * size.height,
                    ).distance;

                    if (distance > AppConstants.minPointDistance) {
                      _currentStroke!.points.add(normalized);
                      final nowMs = DateTime.now().millisecondsSinceEpoch;
                      if (nowMs - _lastStrokePlayMs > 200) {
                        _lastStrokePlayMs = nowMs;
                        AudioService.playRakeStroke();
                      }
                      setState(() {});
                    }
                  }
                },
                onPointerUp: (event) {
                  if (event.pointer == _activePointerId) {
                    _activePointerId = null;
                    if (_currentStroke != null) {
                      // Support gentle tap for a single spot dot
                      if (_currentStroke!.points.length == 1) {
                        final p = _currentStroke!.points.first;
                        _currentStroke!.points.add(Offset(p.dx + 0.001, p.dy + 0.001));
                      }
                      if (_currentStroke!.points.length >= 2) {
                        gardenProvider.addStroke(_currentStroke!);
                        HapticService.lightTap();
                      }
                      _currentStroke = null;
                      setState(() {});
                    }
                  }
                },
                onPointerCancel: (event) {
                  if (event.pointer == _activePointerId) {
                    _activePointerId = null;
                    _currentStroke = null;
                    setState(() {});
                  }
                },
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CustomPaint(
                      painter: SandPainter(
                        strokes: gardenProvider.strokes,
                        currentStroke: _currentStroke,
                        grains: gardenProvider.grains,
                        ghostPattern: gardenProvider.ghostPattern,
                        ghostOpacity: gardenProvider.ghostOpacity,
                        theme: currentTheme,
                        strokeOpacity: _eraseController.isAnimating
                            ? _eraseAnimation.value
                            : 1.0,
                      ),
                      size: Size.infinite,
                    ),

                    // First-Launch Coach Mark
                    if (_showCoachMark && gardenProvider.strokeCount == 0)
                      IgnorePointer(
                        child: AnimatedOpacity(
                          opacity: _showCoachMark ? 0.75 : 0.0,
                          duration: const Duration(milliseconds: 600),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.touch_app_outlined,
                                  size: 40,
                                  color: currentTheme.textSecondary,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  tr('draw_anywhere'),
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.5,
                                    color: currentTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
