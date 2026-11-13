import 'dart:math';
import 'package:app_links/app_links.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';
import 'cloud_service.dart';
import 'storage_service.dart';

/// Service managing referral invitation links, deep link resolution, and rewards.
class ReferralService {
  static final AppLinks _appLinks = AppLinks();

  /// Obtains or generates a clean 6-character referral code.
  static Future<String> getReferralCode() async {
    final prefs = await SharedPreferences.getInstance();
    String? code = prefs.getString(AppConstants.keyReferralCode);
    if (code == null) {
      final uid = CloudService.currentUid;
      if (uid != null && uid.length >= 6) {
        code = uid.substring(0, 6).toUpperCase();
      } else {
        const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
        final rand = Random();
        code = List.generate(6, (_) => chars[rand.nextInt(chars.length)]).join();
      }
      await prefs.setString(AppConstants.keyReferralCode, code);
    }
    return code;
  }

  /// Shares personalized invitation link via system share sheet.
  static Future<void> shareReferralInvite() async {
    final code = await getReferralCode();
    final link = 'https://rake.app/ref/$code';
    await Share.share(
      'Take a mindful breath with me on Rake: $link 🌿 Use code $code to unlock the Cherry Blossom sand theme.',
    );
  }

  /// Initializes deep link listener to detect incoming referral invitations.
  static void initDeepLinks({Function(String code)? onReferralReceived}) {
    _appLinks.uriLinkStream.listen((uri) async {
      final pathSegments = uri.pathSegments;
      if (pathSegments.contains('ref') && pathSegments.length > 1) {
        final code = pathSegments[pathSegments.indexOf('ref') + 1];
        await _applyReferralCode(code);
        onReferralReceived?.call(code);
      }
    }, onError: (_) {});
  }

  /// Applies referral bonus (e.g., grants free Sakura / Cherry Blossom sand theme).
  static Future<bool> _applyReferralCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(AppConstants.keyReferredBy)) return false; // Already used
    await prefs.setString(AppConstants.keyReferredBy, code);

    // Reward: Unlock Cherry Blossom theme for referred player
    final unlocked = prefs.getStringList(AppConstants.keyUnlockedThemes) ?? [];
    if (!unlocked.contains('sakura')) {
      unlocked.add('sakura');
      await prefs.setStringList(AppConstants.keyUnlockedThemes, unlocked);
    }
    return true;
  }
}

