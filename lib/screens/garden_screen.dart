import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../core/feature_flags.dart';
import '../core/theme.dart';
import '../data/inspiration_patterns.dart';
import '../features/ar/ar_garden_screen.dart';
import '../features/collab/collab_garden_screen.dart';
import '../features/collab/collab_service.dart';
import '../providers/garden_provider.dart';
import '../providers/settings_provider.dart';
import '../services/achievement_service.dart';
import '../services/ad_service.dart';
import '../services/community_service.dart';
import '../services/daily_service.dart';
import '../services/export_service.dart';
import '../services/gallery_service.dart';
import '../services/haptic_service.dart';
import '../services/rate_service.dart';
import '../services/seasonal_service.dart';
import '../services/share_service.dart';
import '../widgets/bottom_toolbar.dart';
import '../widgets/inspiration_card.dart';
import '../widgets/sand_canvas.dart';
import 'gallery_screen.dart';
import 'premium_screen.dart';
import 'settings_screen.dart';

/// The primary garden screen where the user meditatively rakes sand.
/// Configured with clean feature flag gating for the initial public launch.
class GardenScreen extends StatefulWidget {
  const GardenScreen({super.key});

  @override
  State<GardenScreen> createState() => _GardenScreenState();
}

class _GardenScreenState extends State<GardenScreen> {
  final GlobalKey<SandCanvasState> _canvasStateKey = GlobalKey<SandCanvasState>();
  final GlobalKey _canvasKey = GlobalKey();

  InspirationPattern? _dailyPattern;
  SeasonalEvent? _activeSeasonalEvent;

  @override
  void initState() {
    super.initState();
    if (FeatureFlags.enableDailyInspiration || FeatureFlags.enableSeasonalEvents) {
      _loadDailyAndSeasonal();
    }
    if (FeatureFlags.enableAchievements) {
      _checkEarlySunriseAchievement();
    }
  }

  Future<void> _loadDailyAndSeasonal() async {
    InspirationPattern? pattern;
    SeasonalEvent? event;

    if (FeatureFlags.enableDailyInspiration) {
      pattern = await DailyService.getTodayPattern();
    }
    if (FeatureFlags.enableSeasonalEvents) {
      event = SeasonalService.getActiveEvent();
    }

    if (mounted) {
      setState(() {
        _dailyPattern = pattern;
        _activeSeasonalEvent = event;
      });
    }
  }

  void _checkEarlySunriseAchievement() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 7) {
      AchievementService.unlock('hidden_sunrise');
    }
  }

  void _onSmoothPressed() {
    final gardenProvider = context.read<GardenProvider>();
    if (gardenProvider.strokeCount == 0) return;

    HapticService.softPulse();

    showDialog<bool>(
      context: context,
      barrierColor: gardenProvider.theme.textPrimary.withOpacity(0.3),
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: gardenProvider.theme.cardSurface,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
            side: BorderSide(color: gardenProvider.theme.borderLight, width: 1.0),
          ),
          title: Text(
            tr('erase_title'),
            style: GoogleFonts.cormorantGaramond(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: gardenProvider.theme.textPrimary,
            ),
          ),
          content: Text(
            tr('erase_desc'),
            style: GoogleFonts.inter(
              fontSize: 14,
              color: gardenProvider.theme.textSecondary,
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(
                tr('cancel'),
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: gardenProvider.theme.textSecondary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: gardenProvider.theme.sandShadow,
                foregroundColor: gardenProvider.theme.textPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: Text(
                tr('erase_confirm'),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    ).then((confirmed) {
      if (confirmed == true) {
        HapticService.softPulse();
        _canvasStateKey.currentState?.animateSmoothErase();
        if (FeatureFlags.enableAchievements) {
          AchievementService.incrementProgress('smooth_canvas');
        }
      }
    });
  }

  void _onSavePressed() async {
    final garden = context.read<GardenProvider>();
    final settings = context.read<SettingsProvider>();

    if (garden.strokeCount == 0) return;
    HapticService.lightTap();

    if (await GalleryService.isFreeLimitReached()) {
      if (mounted && FeatureFlags.enablePremium) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PremiumScreen()),
        );
      }
      return;
    }

    final item = await GalleryService.saveCanvasPattern(
      canvasKey: _canvasKey,
      theme: garden.theme.id,
      signature: settings.signature,
    );

    if (item != null && mounted) {
      HapticService.softPulse();
      if (FeatureFlags.enableAchievements) {
        AchievementService.incrementProgress('first_save');
        AchievementService.incrementProgress('five_saves');
        AchievementService.incrementProgress('twenty_five');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(tr('save_success')),
          backgroundColor: AppColors.accent,
          duration: const Duration(seconds: 2),
        ),
      );

      if (FeatureFlags.enableCommunity) {
        _offerCommunityShare();
      }

      if (FeatureFlags.enableRatePrompt && await RateService.shouldShowPrompt() && mounted) {
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) RateService.showGentlePrompt(context);
        });
      }
    }
  }

  void _offerCommunityShare() {
    final garden = context.read<GardenProvider>();
    final settings = context.read<SettingsProvider>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: garden.theme.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Share with the World?',
              style: GoogleFonts.cormorantGaramond(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: garden.theme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You can peacefully publish this pattern to the Community Gallery for others to enjoy.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 13, color: garden.theme.textSecondary),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(tr('cancel'), style: const TextStyle(color: AppColors.textSecondary)),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(ctx);
                      final success = await CommunityService.uploadPattern(
                        strokes: garden.strokes,
                        theme: garden.theme.id,
                        authorName: settings.signature,
                        canvasKey: _canvasKey,
                      );
                      if (success && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Shared to Community Gallery! 🌿')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Share Publicly'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onSharePressed() async {
    final garden = context.read<GardenProvider>();
    final settings = context.read<SettingsProvider>();

    HapticService.lightTap();
    final shared = await ShareService.shareCanvas(
      canvasKey: _canvasKey,
      signature: settings.signature,
      isPremium: garden.isPremium,
    );

    if (shared && FeatureFlags.enableAchievements) {
      AchievementService.incrementProgress('first_share');
      AchievementService.incrementProgress('ten_shares');
    }
  }

  void _onInspirationPressed() {
    HapticService.lightTap();
    InspirationBottomSheet.show(
      context,
      onOpenPremium: () {
        if (FeatureFlags.enablePremium) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PremiumScreen()),
          );
        }
      },
      onUnlockMoreWithAd: () {
        if (FeatureFlags.enableAds) {
          AdService.showRewardedAd(
            onReward: () {
              if (_dailyPattern != null && mounted) {
                context.read<GardenProvider>().setGhostPattern(_dailyPattern);
                if (FeatureFlags.enableAchievements) {
                  AchievementService.incrementProgress('first_pattern');
                }
              }
            },
            onLimitReached: () {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(tr('limit_reached')),
                    backgroundColor: AppColors.textSecondary,
                  ),
                );
              }
            },
          );
        }
      },
    );
  }

  void _onGalleryPressed() {
    HapticService.lightTap();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const GalleryScreen()),
    );
  }

  void _onSettingsPressed() {
    HapticService.lightTap();
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const SettingsScreen(),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final garden = context.watch<GardenProvider>();
    final theme = garden.theme;

    return Scaffold(
      backgroundColor: theme.background,
      body: SafeArea(
        child: Column(
          children: [
            // ============================================================
            // TOP BAR: Logo + (if enableDailyInspiration) Daily Card + Menu + Settings
            // ============================================================
            Container(
              height: 64.0,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo
                  Text(
                    tr('app_name'),
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                      color: theme.textPrimary,
                    ),
                  ),

                  // Center: Daily Inspiration Card (when enabled)
                  if (FeatureFlags.enableDailyInspiration && _dailyPattern != null)
                    GestureDetector(
                      onTap: () {
                        HapticService.lightTap();
                        garden.setGhostPattern(_dailyPattern);
                        if (FeatureFlags.enableAchievements) {
                          AchievementService.incrementProgress('first_pattern');
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: theme.cardSurface.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: theme.borderLight.withOpacity(0.7)),
                          boxShadow: [
                            BoxShadow(
                              color: theme.sandShadow.withOpacity(0.15),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _activeSeasonalEvent?.badgeEmoji ?? '☀️',
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              tr('daily_inspiration'),
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: theme.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    const SizedBox.shrink(),

                  // Actions: Gallery, Overflow Menu, Settings
                  Row(
                    children: [
                      if (FeatureFlags.enableGallery) ...[
                        IconButton(
                          icon: const Icon(Icons.photo_library_outlined, size: 22),
                          color: theme.textPrimary,
                          tooltip: tr('gallery'),
                          onPressed: _onGalleryPressed,
                        ),
                      ],
                      // Zen Overflow Menu
                      PopupMenuButton<String>(
                        icon: Icon(Icons.more_horiz_rounded, color: theme.textPrimary),
                        color: theme.cardSurface,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        onSelected: (value) async {
                          HapticService.lightTap();
                          switch (value) {
                            case 'save':
                              _onSavePressed();
                              break;
                            case 'export_svg':
                              if (FeatureFlags.enableAdvancedExport) {
                                final file = await ExportService.exportAsSvg(
                                  strokes: garden.strokes,
                                  theme: theme,
                                  size: const Size(1080, 1920),
                                );
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Exported SVG: ${file.path}')),
                                  );
                                }
                              }
                              break;
                            case 'community':
                              if (FeatureFlags.enableCommunity) {
                                _offerCommunityShare();
                              }
                              break;
                            case 'erase_all':
                              _onSmoothPressed();
                              break;
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem(
                            value: 'save',
                            child: Row(
                              children: [
                                const Icon(Icons.bookmark_border_rounded, size: 18),
                                const SizedBox(width: 10),
                                Text(tr('save')),
                              ],
                            ),
                          ),
                          if (FeatureFlags.enableAdvancedExport) ...[
                            const PopupMenuItem(
                              value: 'export_svg',
                              child: Row(
                                children: [
                                  Icon(Icons.draw_outlined, size: 18),
                                  SizedBox(width: 10),
                                  Text('Export SVG'),
                                ],
                              ),
                            ),
                          ],
                          if (FeatureFlags.enableCommunity) ...[
                            const PopupMenuItem(
                              value: 'community',
                              child: Row(
                                children: [
                                  Icon(Icons.public_rounded, size: 18),
                                  SizedBox(width: 10),
                                  Text('Share to Community'),
                                ],
                              ),
                            ),
                          ],
                          PopupMenuItem(
                            value: 'erase_all',
                            child: Row(
                              children: [
                                const Icon(Icons.waves_rounded, size: 18),
                                const SizedBox(width: 10),
                                Text(tr('smooth')),
                              ],
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.tune_rounded, size: 22),
                        color: theme.textPrimary,
                        tooltip: tr('settings'),
                        onPressed: _onSettingsPressed,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Expanded Sand Canvas Area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: SandCanvas(
                  key: _canvasStateKey,
                  canvasKey: _canvasKey,
                ),
              ),
            ),

            // ============================================================
            // BOTTOM TOOLBAR: Inspiration, Smooth, Share (always) + Collab, AR (guarded)
            // ============================================================
            BottomToolbar(
              theme: theme,
              onInspirationPressed: _onInspirationPressed,
              onSmoothPressed: _onSmoothPressed,
              onSharePressed: _onSharePressed,
              onCollabPressed: FeatureFlags.enableCollaboration
                  ? () async {
                      final settings = context.read<SettingsProvider>();
                      final id = await CollabService.createSession(
                        authorName: settings.signature.isEmpty ? 'Zen Artist' : settings.signature,
                      );
                      if (mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => CollabGardenScreen(sessionId: id)),
                        );
                      }
                    }
                  : null,
              onArPressed: FeatureFlags.enableARMode
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ArGardenScreen()),
                      );
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
