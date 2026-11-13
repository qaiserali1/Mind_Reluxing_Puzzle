import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/constants.dart';
import '../core/theme.dart';
import 'haptic_service.dart';

/// EU-compliant smart in-app review prompt service.
class RateService {
  static final InAppReview _inAppReview = InAppReview.instance;
  static DateTime? sessionStartTime;

  /// Call once when app launches to record session start time and increment open count.
  static Future<void> onAppLaunched() async {
    sessionStartTime = DateTime.now();
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey(AppConstants.keyFirstLaunchDate)) {
      await prefs.setString(AppConstants.keyFirstLaunchDate, DateTime.now().toIso8601String());
    }

    final openCount = (prefs.getInt(AppConstants.keyAppOpenCount) ?? 0) + 1;
    await prefs.setInt(AppConstants.keyAppOpenCount, openCount);
  }

  /// Evaluates whether the peaceful conditions are met to invite user feedback.
  static Future<bool> shouldShowPrompt() async {
    final prefs = await SharedPreferences.getInstance();
    final promptCount = prefs.getInt(AppConstants.keyRatePromptCount) ?? 0;
    if (promptCount >= 2) return false;

    // Check open count (>= 5)
    final openCount = prefs.getInt(AppConstants.keyAppOpenCount) ?? 0;
    if (openCount < 5) return false;

    // Check total strokes (>= 50)
    final totalStrokes = prefs.getInt(AppConstants.keyTotalStrokesCount) ?? 0;
    if (totalStrokes < 50) return false;

    // Check days since first launch (>= 3 days)
    final firstLaunchStr = prefs.getString(AppConstants.keyFirstLaunchDate);
    if (firstLaunchStr != null) {
      final firstLaunch = DateTime.tryParse(firstLaunchStr);
      if (firstLaunch != null && DateTime.now().difference(firstLaunch).inDays < 3) {
        return false;
      }
    }

    // Check session duration (>= 2 minutes of calm interaction)
    if (sessionStartTime != null && DateTime.now().difference(sessionStartTime!).inSeconds < 120) {
      return false;
    }

    return true;
  }

  /// Presents the gentle feedback dialog adhering strictly to European fairness regulations.
  static Future<void> showGentlePrompt(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final promptCount = prefs.getInt(AppConstants.keyRatePromptCount) ?? 0;
    await prefs.setInt(AppConstants.keyRatePromptCount, promptCount + 1);

    if (!context.mounted) return;

    showDialog(
      context: context,
      barrierColor: AppColors.textPrimary.withOpacity(0.35),
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'Are you enjoying Rake?',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Your quiet feedback helps us maintain a tranquil and ad-free experience for everyone.',
          style: GoogleFonts.inter(fontSize: 14, height: 1.4, color: AppColors.textSecondary),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        actions: [
          TextButton(
            onPressed: () async {
              HapticService.lightTap();
              Navigator.pop(ctx);
              final emailLaunchUri = Uri(
                scheme: 'mailto',
                path: AppConstants.feedbackEmail,
                query: 'subject=Rake App Feedback',
              );
              if (await canLaunchUrl(emailLaunchUri)) launchUrl(emailLaunchUri);
            },
            child: Text(
              'Not really',
              style: GoogleFonts.inter(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              HapticService.lightTap();
              Navigator.pop(ctx);
              try {
                if (await _inAppReview.isAvailable()) {
                  await _inAppReview.requestReview();
                }
              } catch (_) {}
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: Text(
              'Yes, loving it',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

