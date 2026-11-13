import 'package:flutter/material.dart';
import '../services/audio_service.dart';
import '../services/haptic_service.dart';
import '../services/storage_service.dart';

/// State management provider for user settings and sensory preferences.
class SettingsProvider extends ChangeNotifier {
  bool _ambientSound = false;
  bool _rakeSound = true;
  double _volume = 1.0;
  bool _hapticsEnabled = true;
  String _selectedTheme = 'warm';
  String _signature = '';

  bool get ambientSound => _ambientSound;
  bool get rakeSound => _rakeSound;
  double get volume => _volume;
  bool get hapticsEnabled => _hapticsEnabled;
  String get selectedTheme => _selectedTheme;
  String get signature => _signature;

  SettingsProvider() {
    _loadSettings();
  }

  void _loadSettings() {
    _ambientSound = StorageService.getAmbientSound();
    _rakeSound = StorageService.getRakeSound();
    _hapticsEnabled = StorageService.getHapticsEnabled();
    _selectedTheme = StorageService.getSelectedTheme();
    _signature = StorageService.getSignature();
    HapticService.enabled = _hapticsEnabled;
    AudioService.setAmbientEnabled(_ambientSound);
    AudioService.setRakeEnabled(_rakeSound);
    notifyListeners();
  }

  Future<void> setAmbientSound(bool value) async {
    _ambientSound = value;
    await StorageService.setAmbientSound(value);
    await AudioService.setAmbientEnabled(value);
    notifyListeners();
  }

  Future<void> setRakeSound(bool value) async {
    _rakeSound = value;
    await StorageService.setRakeSound(value);
    AudioService.setRakeEnabled(value);
    notifyListeners();
  }

  Future<void> setVolume(double volume) async {
    _volume = volume;
    await AudioService.setMasterVolume(volume);
    notifyListeners();
  }

  Future<void> setHapticsEnabled(bool value) async {
    _hapticsEnabled = value;
    HapticService.enabled = value;
    await StorageService.setHapticsEnabled(value);
    notifyListeners();
  }

  Future<void> setSelectedTheme(String theme) async {
    _selectedTheme = theme;
    await StorageService.setSelectedTheme(theme);
    notifyListeners();
  }

  Future<void> setSignature(String signature) async {
    _signature = signature;
    await StorageService.setSignature(signature);
    notifyListeners();
  }
}
