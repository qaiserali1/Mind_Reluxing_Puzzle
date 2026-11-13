import 'package:shared_preferences/shared_preferences.dart';
import '../data/inspiration_patterns.dart';

/// Service rotating a daily featured zen pattern and tracking drawing mindfulness streaks.
class DailyService {
  static const String _keyDailyDate = 'last_daily_date';
  static const String _keyDailyIndex = 'daily_index';
  static const String _keyDailyStreak = 'daily_streak';

  /// Obtains the daily highlighted pattern based on local calendar date.
  static Future<InspirationPattern> getTodayPattern() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final lastDate = prefs.getString(_keyDailyDate);

    int index = prefs.getInt(_keyDailyIndex) ?? 0;

    if (lastDate != today) {
      // Rotate to next meditative pattern on calendar day shift
      index = (index + 1) % InspirationPatterns.all.length;
      await prefs.setInt(_keyDailyIndex, index);
      await prefs.setString(_keyDailyDate, today);
    }

    return InspirationPatterns.all[index % InspirationPatterns.all.length];
  }

  /// Increments or updates the player's peaceful daily drawing streak.
  static Future<int> recordDailyDrawing() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final lastDate = prefs.getString('last_draw_date');
    int streak = prefs.getInt(_keyDailyStreak) ?? 0;

    if (lastDate != today) {
      streak += 1;
      await prefs.setInt(_keyDailyStreak, streak);
      await prefs.setString('last_draw_date', today);
    }
    return streak;
  }
}

