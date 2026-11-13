import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';
import 'gdpr_service.dart';

/// Service managing optional, quiet rewarded ads for extra inspiration previews.
/// Banner and interstitial ads are strictly prohibited to protect the meditative experience.
class AdService {
  static const String rewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917'; // Google Test ID
  static const int maxRewardedAdsPerDay = 2;

  static const String _keyDailyAdCount = 'daily_ad_count';
  static const String _keyDailyAdDate = 'daily_ad_date';

  /// Checks if user has given GDPR consent.
  static Future<bool> _hasConsent() async {
    return await GdprService.hasConsent();
  }

  /// Checks if daily rewarded ad cap (2 per day) has been reached.
  static Future<bool> isDailyLimitReached() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final lastDate = prefs.getString(_keyDailyAdDate);

    if (lastDate != today) {
      await prefs.setString(_keyDailyAdDate, today);
      await prefs.setInt(_keyDailyAdCount, 0);
      return false;
    }

    final count = prefs.getInt(_keyDailyAdCount) ?? 0;
    return count >= maxRewardedAdsPerDay;
  }

  /// Increments daily rewarded ad count.
  static Future<void> _incrementAdCount() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final current = prefs.getInt(_keyDailyAdCount) ?? 0;
    await prefs.setString(_keyDailyAdDate, today);
    await prefs.setInt(_keyDailyAdCount, current + 1);
  }

  /// Loads and presents a rewarded ad if consented and daily quota is available.
  static Future<bool> showRewardedAd({
    required VoidCallback onReward,
    required VoidCallback onLimitReached,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final isPremium = prefs.getBool(AppConstants.keyPremiumUnlocked) ?? false;
    if (isPremium) {
      // Premium users never see ads; grant reward directly
      onReward();
      return true;
    }

    if (!await _hasConsent()) {
      return false;
    }

    if (await isDailyLimitReached()) {
      onLimitReached();
      return false;
    }

    try {
      RewardedAd? loadedAd;
      await RewardedAd.load(
        adUnitId: rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            loadedAd = ad;
          },
          onAdFailedToLoad: (error) {
            loadedAd = null;
          },
        ),
      );

      if (loadedAd != null) {
        bool rewarded = false;
        loadedAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            ad.dispose();
            if (rewarded) {
              _incrementAdCount();
              onReward();
            }
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            ad.dispose();
          },
        );

        await loadedAd!.show(onUserEarnedReward: (ad, reward) {
          rewarded = true;
        });
        return true;
      } else {
        // Fallback for offline / test environments
        if (kDebugMode) {
          await _incrementAdCount();
          onReward();
          return true;
        }
        return false;
      }
    } catch (_) {
      return false;
    }
  }
}

