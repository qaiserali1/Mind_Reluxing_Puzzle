import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';
import '../models/rake_stroke.dart';

/// Storage service handling local state persistence and debounced stroke serialization.
class StorageService {
  static SharedPreferences? _prefs;
  static Timer? _debounceTimer;

  /// Initializes the underlying SharedPreferences instance.
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // --- Strokes Persistence ---

  /// Loads saved strokes from local storage.
  static List<RakeStroke> loadStrokes() {
    final rawJson = _prefs?.getString(AppConstants.keyStrokesJson);
    if (rawJson == null || rawJson.isEmpty) return [];

    try {
      final List<dynamic> decoded = jsonDecode(rawJson);
      return decoded
          .map((item) => RakeStroke.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Debounces saving of strokes by 1 second to avoid excessive disk writes during drawing.
  static void saveStrokesDebounced(List<RakeStroke> strokes) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(seconds: 1), () {
      saveStrokesImmediately(strokes);
    });
  }

  /// Immediately persists strokes into storage.
  static Future<void> saveStrokesImmediately(List<RakeStroke> strokes) async {
    if (_prefs == null) await init();
    final jsonList = strokes.map((s) => s.toJson()).toList();
    await _prefs?.setString(AppConstants.keyStrokesJson, jsonEncode(jsonList));
  }

  /// Clears persisted strokes.
  static Future<void> clearStrokes() async {
    if (_prefs == null) await init();
    await _prefs?.remove(AppConstants.keyStrokesJson);
  }

  // --- Settings Persistence ---

  static bool getAmbientSound() =>
      _prefs?.getBool(AppConstants.keyAmbientSound) ?? false;
  static Future<void> setAmbientSound(bool value) async =>
      await _prefs?.setBool(AppConstants.keyAmbientSound, value);

  static bool getRakeSound() =>
      _prefs?.getBool(AppConstants.keyRakeSound) ?? true;
  static Future<void> setRakeSound(bool value) async =>
      await _prefs?.setBool(AppConstants.keyRakeSound, value);

  static bool getHapticsEnabled() =>
      _prefs?.getBool(AppConstants.keyHapticsEnabled) ?? true;
  static Future<void> setHapticsEnabled(bool value) async =>
      await _prefs?.setBool(AppConstants.keyHapticsEnabled, value);

  static String getSelectedTheme() =>
      _prefs?.getString(AppConstants.keySelectedTheme) ?? 'warm';
  static Future<void> setSelectedTheme(String theme) async =>
      await _prefs?.setString(AppConstants.keySelectedTheme, theme);

  static String getSignature() =>
      _prefs?.getString(AppConstants.keySignature) ?? '';
  static Future<void> setSignature(String signature) async =>
      await _prefs?.setString(AppConstants.keySignature, signature);

  static bool getPremiumUnlocked() =>
      _prefs?.getBool(AppConstants.keyPremiumUnlocked) ?? false;
  static Future<void> setPremiumUnlocked(bool value) async =>
      await _prefs?.setBool(AppConstants.keyPremiumUnlocked, value);

  static bool getGdprConsent() =>
      _prefs?.getBool(AppConstants.keyGdprConsentV1) ?? false;
  static Future<void> setGdprConsent(bool value) async =>
      await _prefs?.setBool(AppConstants.keyGdprConsentV1, value);
}

