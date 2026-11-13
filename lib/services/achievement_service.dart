import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:games_services/games_services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/theme.dart';
import '../data/achievements.dart';
import '../models/achievement.dart';
import 'audio_service.dart';
import 'haptic_service.dart';

/// Service managing achievement progress, unlocking, and Game Center / Google Play Games synchronization.
class AchievementService {
  static GlobalKey<NavigatorState>? navigatorKey;
  static bool _gamesServicesSignedIn = false;

  /// Attempts silent authentication with Apple Game Center / Google Play Games.
  static Future<void> initPlatformGames() async {
    try {
      await GameAuth.signIn();
      _gamesServicesSignedIn = await GameAuth.isSignedIn;
    } catch (_) {
      _gamesServicesSignedIn = false;
    }
  }

  /// Increments progress towards an achievement and unlocks it when target count is reached.
  static Future<void> incrementProgress(String id, [int amount = 1]) async {
    final prefs = await SharedPreferences.getInstance();
    final unlockKey = 'achievement_$id';
    if (prefs.getBool(unlockKey) ?? false) return;

    final progressKey = 'progress_$id';
    final current = (prefs.getInt(progressKey) ?? 0) + amount;
    await prefs.setInt(progressKey, current);

    final achievement = AchievementsData.getById(id);
    if (current >= achievement.targetCount) {
      await unlock(id);
    }
  }

  /// Explicitly unlocks an achievement.
  static Future<void> unlock(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'achievement_$id';
    if (prefs.getBool(key) ?? false) return; // Already unlocked

    await prefs.setBool(key, true);
    await prefs.setString('${key}_date', DateTime.now().toIso8601String());

    final achievement = AchievementsData.getById(id);

    // Audio & Haptic feedback
    HapticService.lightTap();
    AudioService.playUiTap();

    // Show peaceful in-app toast
    _showUnlockToast(achievement);

    // Sync to Apple Game Center / Google Play Games silently
    _syncToPlatform(id);
  }

  /// Synchronizes unlock state to platform game services.
  static Future<void> _syncToPlatform(String id) async {
    if (!_gamesServicesSignedIn) return;
    try {
      await Achievements.unlock(achievement: Achievement(androidID: id, iOSID: id));
    } catch (_) {}
  }

  /// Displays a subtle, serene unlock banner sliding down from the top.
  static void _showUnlockToast(Achievement achievement) {
    final context = navigatorKey?.currentContext;
    if (context == null) return;

    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (ctx) => _AchievementToastWidget(
        achievement: achievement,
        onDismissed: () => entry.remove(),
      ),
    );

    overlay.insert(entry);
  }

  /// Checks if an achievement is unlocked.
  static Future<bool> isUnlocked(String id) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('achievement_$id') ?? false;
  }

  /// Returns total number of unlocked achievements.
  static Future<int> getUnlockedCount() async {
    final prefs = await SharedPreferences.getInstance();
    int count = 0;
    for (final a in AchievementsData.all) {
      if (prefs.getBool('achievement_${a.id}') ?? false) {
        count++;
      }
    }
    return count;
  }

  /// Returns progress value for a given achievement.
  static Future<int> getProgress(String id) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('progress_$id') ?? 0;
  }
}

class _AchievementToastWidget extends StatefulWidget {
  final Achievement achievement;
  final VoidCallback onDismissed;

  const _AchievementToastWidget({
    required this.achievement,
    required this.onDismissed,
  });

  @override
  State<_AchievementToastWidget> createState() => _AchievementToastWidgetState();
}

class _AchievementToastWidgetState extends State<_AchievementToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));

    _animController.forward();

    // Auto dismiss after 3 seconds
    Timer(const Duration(milliseconds: 3200), () {
      if (mounted) {
        _animController.reverse().then((_) {
          widget.onDismissed();
        });
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 12,
      left: 20,
      right: 20,
      child: SlideTransition(
        position: _offsetAnimation,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Text(widget.achievement.iconEmoji, style: const TextStyle(fontSize: 26)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Achievement Unlocked',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        tr(widget.achievement.titleKey),
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

