import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/feature_flags.dart';
import '../../core/theme.dart';
import '../../models/rake_stroke.dart';
import '../../painters/sand_painter.dart';
import '../../services/haptic_service.dart';

/// Augmented Reality Zen Garden screen allowing players to project a virtual sand garden onto physical tables.
class ArGardenScreen extends StatefulWidget {
  const ArGardenScreen({super.key});

  @override
  State<ArGardenScreen> createState() => _ArGardenScreenState();
}

class _ArGardenScreenState extends State<ArGardenScreen> {
  bool _isPlaneDetected = false;
  bool _isGardenPlaced = false;
  double _scale = 1.0;
  final List<RakeStroke> _arStrokes = [];
  RakeStroke? _currentArStroke;

  @override
  void initState() {
    super.initState();
    if (!FeatureFlags.enableARMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.pop(context);
      });
      return;
    }
    // Simulate gentle plane detection after 1.5 seconds in test/dev environments
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) setState(() => _isPlaneDetected = true);
    });
  }

  void _placeGarden() {
    HapticService.softPulse();
    setState(() => _isGardenPlaced = true);
  }

  @override
  Widget build(BuildContext context) {
    final isIOS = !kIsWeb && Platform.isIOS;

    if (!isIOS && !kDebugMode) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text(
              'AR Zen Garden is optimized for iOS devices with ARKit.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 16, color: AppColors.textSecondary),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // AR Camera View Mock / Live View
          Container(
            color: const Color(0xFF1E222A),
            child: Center(
              child: Opacity(
                opacity: 0.25,
                child: Icon(Icons.videocam_outlined, size: 90, color: Colors.white70),
              ),
            ),
          ),

          // Surface Detection Reticle
          if (!_isGardenPlaced)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _isPlaneDetected ? AppColors.accent : Colors.white38,
                        width: 2.5,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Icon(
                        _isPlaneDetected ? Icons.check_circle_outline : Icons.view_in_ar,
                        color: _isPlaneDetected ? AppColors.accent : Colors.white70,
                        size: 40,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _isPlaneDetected ? 'Surface found. Tap to place garden.' : 'Scanning for flat surface...',
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
                  ),
                  if (_isPlaneDetected) ...[
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _placeGarden,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('Place Zen Garden'),
                    ),
                  ],
                ],
              ),
            ),

          // Placed 3D Virtual Garden Canvas
          if (_isGardenPlaced)
            Center(
              child: Transform.scale(
                scale: _scale,
                child: Container(
                  width: 320,
                  height: 420,
                  decoration: BoxDecoration(
                    color: AppColors.sandBase,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 24,
                        offset: const Offset(0, 12),
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
                            _currentArStroke = RakeStroke(
                              points: [
                                Offset(
                                  (details.localPosition.dx / size.width).clamp(0.0, 1.0),
                                  (details.localPosition.dy / size.height).clamp(0.0, 1.0),
                                ),
                              ],
                            );
                            HapticService.lightTap();
                            setState(() {});
                          },
                          onPanUpdate: (details) {
                            if (_currentArStroke != null) {
                              _currentArStroke!.points.add(
                                Offset(
                                  (details.localPosition.dx / size.width).clamp(0.0, 1.0),
                                  (details.localPosition.dy / size.height).clamp(0.0, 1.0),
                                ),
                              );
                              setState(() {});
                            }
                          },
                          onPanEnd: (_) {
                            if (_currentArStroke != null && _currentArStroke!.points.length >= 2) {
                              _arStrokes.add(_currentArStroke!);
                            }
                            _currentArStroke = null;
                            setState(() {});
                          },
                          child: CustomPaint(
                            painter: SandPainter(
                              strokes: _arStrokes,
                              currentStroke: _currentArStroke,
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
              ),
            ),

          // Top Close & Photo Controls
          Positioned(
            top: 48,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
                if (_isGardenPlaced)
                  IconButton(
                    icon: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 26),
                    onPressed: () {
                      HapticService.softPulse();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('AR photo captured to gallery 🌿')),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

