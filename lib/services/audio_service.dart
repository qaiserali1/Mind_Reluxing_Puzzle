import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import '../core/feature_flags.dart';
import 'storage_service.dart';

/// Zen audio service handling ambient background soundscapes and granular rake audio.
/// Designed for serene non-startling ASMR feedback with graceful missing-file fallback.
class AudioService {
  static final AudioPlayer _ambientPlayer = AudioPlayer();
  static final AudioPlayer _rakePlayer = AudioPlayer();
  static final AudioPlayer _uiPlayer = AudioPlayer();

  static bool _ambientEnabled = false;
  static bool _rakeEnabled = true;
  static double _masterVolume = 1.0;

  static DateTime? _lastRakePlayTime;
  static const int _rakeThrottleMs = 180; // Max ~5 stroke sounds/second

  static bool _isAmbientPlaying = false;

  /// Initializes audio players and default volume configurations.
  static Future<void> init() async {
    _ambientEnabled = StorageService.getAmbientSound();
    _rakeEnabled = StorageService.getRakeSound();

    try {
      await _ambientPlayer.setReleaseMode(ReleaseMode.loop);
      await _ambientPlayer.setVolume(0.0);
      await _rakePlayer.setVolume(0.3 * _masterVolume);
      await _uiPlayer.setVolume(0.35 * _masterVolume);

      if (_ambientEnabled) {
        await startAmbient();
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Audio initialization note: $e');
      }
    }
  }

  /// Sets whether ambient sound loop should run.
  static Future<void> setAmbientEnabled(bool enabled) async {
    _ambientEnabled = enabled;
    if (enabled) {
      await startAmbient();
    } else {
      await stopAmbient();
    }
  }

  /// Sets whether rake drawing sound is enabled.
  static void setRakeEnabled(bool enabled) {
    _rakeEnabled = enabled;
  }

  /// Sets master sound volume (0.0 to 1.0).
  static Future<void> setMasterVolume(double volume) async {
    _masterVolume = volume.clamp(0.0, 1.0);
    try {
      if (_isAmbientPlaying) {
        await _ambientPlayer.setVolume(0.35 * _masterVolume);
      }
      await _rakePlayer.setVolume(0.3 * _masterVolume);
      await _uiPlayer.setVolume(0.35 * _masterVolume);
    } catch (_) {}
  }

  /// Starts smooth loop of ambient wind/nature audio, fading in over 2 seconds.
  static Future<void> startAmbient() async {
    if (!_ambientEnabled) return;
    try {
      _isAmbientPlaying = true;
      await _ambientPlayer.play(AssetSource('audio/ambient_wind.mp3'));
      for (int i = 1; i <= 10; i++) {
        if (!_isAmbientPlaying) break;
        await _ambientPlayer.setVolume((0.35 * _masterVolume) * (i / 10.0));
        await Future.delayed(const Duration(milliseconds: 200));
      }
    } catch (_) {
      _isAmbientPlaying = false;
    }
  }

  /// Fades ambient sound out smoothly over 1.5 seconds.
  static Future<void> stopAmbient() async {
    if (!_isAmbientPlaying) return;
    _isAmbientPlaying = false;
    try {
      for (int i = 9; i >= 0; i--) {
        await _ambientPlayer.setVolume((0.35 * _masterVolume) * (i / 10.0));
        await Future.delayed(const Duration(milliseconds: 150));
      }
      await _ambientPlayer.pause();
    } catch (_) {}
  }

  /// Plays a granular stroke sound, throttled to prevent audio overlap.
  static Future<void> playRakeStroke() async {
    if (!_rakeEnabled) return;
    final now = DateTime.now();
    if (_lastRakePlayTime != null &&
        now.difference(_lastRakePlayTime!).inMilliseconds < _rakeThrottleMs) {
      return;
    }
    _lastRakePlayTime = now;

    try {
      await _rakePlayer.stop();
      await _rakePlayer.play(
        AssetSource('audio/rake_stroke.mp3'),
        volume: 0.28 * _masterVolume,
      );
    } catch (_) {}
  }

  /// Plays a soft UI interaction click.
  static Future<void> playUiTap() async {
    try {
      await _uiPlayer.play(
        AssetSource('audio/ui_tap.mp3'),
        volume: 0.3 * _masterVolume,
      );
    } catch (_) {}
  }

  /// Plays a soothing whoosh when smoothing sand.
  static Future<void> playErase() async {
    try {
      final erasePlayer = AudioPlayer();
      await erasePlayer.play(
        AssetSource('audio/erase_whoosh.mp3'),
        volume: 0.4 * _masterVolume,
      );
    } catch (_) {}
  }

  // ============================================================
  // Phase 4 Sound Enhancements (Guarded by FeatureFlags)
  // ============================================================

  /// Plays an atmospheric sound pack track (Phase 4).
  static Future<void> playSoundPack(String packId) async {
    // Guarded: Disabled for public launch until Phase 4
    if (!FeatureFlags.enableSoundPacks) return;

    try {
      await _ambientPlayer.play(AssetSource('audio/packs/$packId.mp3'));
    } catch (_) {}
  }

  /// Sets up user custom uploaded ambient audio file (Phase 4).
  static Future<void> uploadCustomAudio(String filePath) async {
    // Guarded: Disabled for public launch until Phase 4
    if (!FeatureFlags.enableUploadAudio) return;

    try {
      await _ambientPlayer.play(DeviceFileSource(filePath));
    } catch (_) {}
  }

  /// Plays harmonic pentatonic note mapped from touch coordinates (Phase 4).
  static Future<void> playMusicalNote(double frequency) async {
    // Guarded: Disabled for public launch until Phase 4
    if (!FeatureFlags.enableMusicalRake) return;

    try {
      // Audio synth/chime trigger
    } catch (_) {}
  }

  /// Pauses audio when the app is backgrounded.
  static void onAppPaused() {
    try {
      if (_isAmbientPlaying) {
        _ambientPlayer.pause();
      }
      _rakePlayer.stop();
    } catch (_) {}
  }

  /// Resumes audio when the app returns to the foreground.
  static void onAppResumed() {
    try {
      if (_ambientEnabled && _isAmbientPlaying) {
        _ambientPlayer.resume();
      }
    } catch (_) {}
  }
}
