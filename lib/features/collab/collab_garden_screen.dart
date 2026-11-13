import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants.dart';
import '../../core/feature_flags.dart';
import '../../core/theme.dart';
import '../../models/rake_stroke.dart';
import '../../painters/sand_painter.dart';
import '../../services/haptic_service.dart';
import 'collab_service.dart';

/// Screen hosting a shared co-drawing zen session between two connected users.
class CollabGardenScreen extends StatefulWidget {
  final String sessionId;
  final bool isHost;

  const CollabGardenScreen({
    super.key,
    required this.sessionId,
    this.isHost = true,
  });

  @override
  State<CollabGardenScreen> createState() => _CollabGardenScreenState();
}

class _CollabGardenScreenState extends State<CollabGardenScreen> {
  final List<RakeStroke> _strokes = [];
  RakeStroke? _currentStroke;
  StreamSubscription<List<RakeStroke>>? _strokeSubscription;

  @override
  void initState() {
    super.initState();
    if (!FeatureFlags.enableCollaboration) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.pop(context);
      });
      return;
    }
    _strokeSubscription = CollabService.subscribeStrokes(widget.sessionId).listen((remoteStrokes) {
      if (mounted) {
        setState(() {
          _strokes.clear();
          _strokes.addAll(remoteStrokes);
        });
      }
    });
  }

  @override
  void dispose() {
    _strokeSubscription?.cancel();
    super.dispose();
  }

  void _shareInviteLink() {
    HapticService.lightTap();
    Share.share(
      'Join my peaceful sand garden session on Rake: https://rake.app/collab/${widget.sessionId}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, size: 24),
          color: AppColors.textPrimary,
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(
              'Co-Drawing Room',
              style: GoogleFonts.cormorantGaramond(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'Room #${widget.sessionId}',
              style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_outlined, color: AppColors.accent),
            tooltip: 'Invite Friend',
            onPressed: _shareInviteLink,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.sandBase,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.sandShadow.withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final size = Size(constraints.maxWidth, constraints.maxHeight);

                  return GestureDetector(
                    onPanStart: (details) {
                      _currentStroke = RakeStroke(
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
                      if (_currentStroke != null) {
                        _currentStroke!.points.add(
                          Offset(
                            (details.localPosition.dx / size.width).clamp(0.0, 1.0),
                            (details.localPosition.dy / size.height).clamp(0.0, 1.0),
                          ),
                        );
                        setState(() {});
                      }
                    },
                    onPanEnd: (_) {
                      if (_currentStroke != null && _currentStroke!.points.length >= 2) {
                        _strokes.add(_currentStroke!);
                        CollabService.publishStroke(widget.sessionId, _currentStroke!);
                      }
                      _currentStroke = null;
                      setState(() {});
                    },
                    child: CustomPaint(
                      painter: SandPainter(
                        strokes: _strokes,
                        currentStroke: _currentStroke,
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
    );
  }
}

