import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';

/// Service managing GDPR compliance and user consent state.
class GdprService {
  /// Checks whether user has already responded to GDPR consent prompt.
  static Future<bool> hasUserResponded() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(AppConstants.keyGdprConsentV1);
  }

  /// Retrieves current consent status (defaults to false for privacy by default).
  static Future<bool> hasConsent() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConstants.keyGdprConsentV1) ?? false;
  }

  /// Persists user's GDPR choice.
  static Future<void> setConsent(bool consentGiven) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyGdprConsentV1, consentGiven);
    if (consentGiven) {
      // Initialize Mobile Ads SDK safely if consented
      try {
        await MobileAds.instance.initialize();
      } catch (_) {}
    }
  }

  /// Request Google UMP (User Messaging Platform) consent info update.
  static Future<void> requestUmpUpdate() async {
    try {
      final params = ConsentRequestParameters();
      ConsentInformation.instance.requestConsentInfoUpdate(
        params,
        () async {
          ConsentForm.loadAndShowConsentFormIfRequired((formError) {});
        },
        (formError) {},
      );
    } catch (_) {}
  }
}

