import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';
import '../core/theme.dart';
import '../data/inspiration_patterns.dart';
import '../models/rake_stroke.dart';
import '../models/sand_grain.dart';
import '../services/achievement_service.dart';
import '../services/cloud_service.dart';
import '../services/storage_service.dart';

/// State management provider for the Zen Sand Garden incorporating Phase 1, 2, and 3 features.
class GardenProvider extends ChangeNotifier {
  final List<RakeStroke> _strokes = [];
  final List<SandGrain> _grains = SandGrain.generate(count: 1000);

  bool _isErasing = false;
  double _eraseProgress = 0.0; // 0.0 = full visibility, 1.0 = completely erased

  InspirationPattern? _ghostPattern;
  double _ghostOpacity = 0.0;
  Timer? _ghostTimer;

  SandTheme _theme = SandTheme.warm;
  bool _isPremium = false;

  List<RakeStroke> get strokes => List.unmodifiable(_strokes);
  List<SandGrain> get grains => _grains;
  bool get isErasing => _isErasing;
  double get eraseOpacity => (1.0 - _eraseProgress).clamp(0.0, 1.0);
  int get strokeCount => _strokes.length;

  InspirationPattern? get ghostPattern => _ghostPattern;
  double get ghostOpacity => _ghostOpacity;
  SandTheme get theme => _theme;
  bool get isPremium => _isPremium;

  GardenProvider() {
    _loadPersistedData();
  }

  /// Loads previously saved strokes, theme, and premium status.
  void _loadPersistedData() {
    final savedStrokes = StorageService.loadStrokes();
    if (savedStrokes.isNotEmpty) {
      _strokes.addAll(savedStrokes);
    }

    final themeId = StorageService.getSelectedTheme();
    _theme = SandTheme.getById(themeId);

    _isPremium = StorageService.getPremiumUnlocked();
    notifyListeners();
  }

  /// Adds a new completed stroke to the garden, enforcing the 200 stroke ceiling.
  void addStroke(RakeStroke stroke) {
    if (stroke.points.length < 2) return;

    // Drawing automatically dismisses ghost pattern
    if (_ghostPattern != null) {
      clearGhostPattern();
      AchievementService.incrementProgress('ghost_master');
    }

    // Performance safeguard: Enforce max 200 strokes by dropping oldest
    if (_strokes.length >= AppConstants.maxStrokes) {
      _strokes.removeAt(0);
    }

    _strokes.add(stroke);
    notifyListeners();

    // Debounced persist to local storage
    StorageService.saveStrokesDebounced(_strokes);

    // Phase 3 Cloud sync
    CloudService.scheduleCloudPush(_strokes);

    // Phase 3 Achievements & Stats
    _trackStrokeAchievements(stroke);
  }

  Future<void> _trackStrokeAchievements(RakeStroke stroke) async {
    final prefs = await SharedPreferences.getInstance();
    final total = (prefs.getInt(AppConstants.keyTotalStrokesCount) ?? 0) + 1;
    await prefs.setInt(AppConstants.keyTotalStrokesCount, total);

    AchievementService.incrementProgress('first_stroke');
    AchievementService.incrementProgress('hundred_strokes');
    AchievementService.incrementProgress('thousand_strokes');
    AchievementService.incrementProgress('ten_thousand');
    AchievementService.incrementProgress('all_shapes');

    // Long stroke achievement (> 0.4 normalized total length)
    double length = 0;
    for (int i = 1; i < stroke.points.length; i++) {
      length += (stroke.points[i] - stroke.points[i - 1]).distance;
    }
    if (length > 0.45) {
      AchievementService.unlock('long_stroke');
    }
  }

  /// Sets the ghost guide pattern for user to trace.
  void setGhostPattern(InspirationPattern? pattern) {
    _ghostTimer?.cancel();
    if (_ghostPattern?.id == pattern?.id) {
      clearGhostPattern();
      return;
    }

    _ghostPattern = pattern;
    _ghostOpacity = 1.0;
    notifyListeners();

    if (pattern != null) {
      _ghostTimer = Timer(const Duration(seconds: 45), () {
        clearGhostPattern();
      });
    }
  }

  /// Clears active ghost pattern.
  void clearGhostPattern() {
    _ghostTimer?.cancel();
    _ghostPattern = null;
    _ghostOpacity = 0.0;
    notifyListeners();
  }

  /// Auto-draws an inspiration pattern stroke by stroke (premium feature).
  Future<void> autoDrawPattern(InspirationPattern pattern) async {
    clearGhostPattern();
    for (final strokePoints in pattern.strokes) {
      if (strokePoints.length < 2) continue;
      final stroke = RakeStroke(
        points: List<Offset>.from(strokePoints),
        width: AppConstants.defaultStrokeWidth,
      );
      addStroke(stroke);
      await Future.delayed(const Duration(milliseconds: 140));
    }
  }

  /// Applies a new sand theme.
  void setTheme(SandTheme newTheme) {
    _theme = newTheme;
    StorageService.setSelectedTheme(newTheme.id);
    notifyListeners();
  }

  /// Updates premium unlock state.
  void setPremium(bool unlocked) {
    _isPremium = unlocked;
    StorageService.setPremiumUnlocked(unlocked);
    notifyListeners();
  }

  /// Sets erase animation progress during smooth transition.
  void updateEraseProgress(double progress) {
    _isErasing = progress < 1.0;
    _eraseProgress = progress;
    notifyListeners();
  }

  /// Completely removes all strokes and clears storage.
  void finishErase() {
    _strokes.clear();
    _isErasing = false;
    _eraseProgress = 0.0;
    clearGhostPattern();
    notifyListeners();
    StorageService.clearStrokes();
  }
}
