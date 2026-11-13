import '../models/achievement.dart';

/// Complete catalog of 25 meditative achievements.
class AchievementsData {
  static const List<Achievement> all = [
    // DRAWING (7)
    Achievement(
      id: 'first_stroke',
      titleKey: 'ach_first_stroke_title',
      descKey: 'ach_first_stroke_desc',
      iconEmoji: '🎯',
      category: AchievementCategory.drawing,
      targetCount: 1,
    ),
    Achievement(
      id: 'hundred_strokes',
      titleKey: 'ach_hundred_strokes_title',
      descKey: 'ach_hundred_strokes_desc',
      iconEmoji: '🎋',
      category: AchievementCategory.drawing,
      targetCount: 100,
    ),
    Achievement(
      id: 'thousand_strokes',
      titleKey: 'ach_thousand_strokes_title',
      descKey: 'ach_thousand_strokes_desc',
      iconEmoji: '🌊',
      category: AchievementCategory.drawing,
      targetCount: 1000,
    ),
    Achievement(
      id: 'ten_thousand',
      titleKey: 'ach_ten_thousand_title',
      descKey: 'ach_ten_thousand_desc',
      iconEmoji: '⛩️',
      category: AchievementCategory.drawing,
      targetCount: 10000,
    ),
    Achievement(
      id: 'long_stroke',
      titleKey: 'ach_long_stroke_title',
      descKey: 'ach_long_stroke_desc',
      iconEmoji: '〰️',
      category: AchievementCategory.drawing,
      targetCount: 1,
    ),
    Achievement(
      id: 'smooth_canvas',
      titleKey: 'ach_smooth_canvas_title',
      descKey: 'ach_smooth_canvas_desc',
      iconEmoji: '💨',
      category: AchievementCategory.drawing,
      targetCount: 10,
    ),
    Achievement(
      id: 'all_shapes',
      titleKey: 'ach_all_shapes_title',
      descKey: 'ach_all_shapes_desc',
      iconEmoji: '🧭',
      category: AchievementCategory.drawing,
      targetCount: 500,
    ),

    // GALLERY (5)
    Achievement(
      id: 'first_save',
      titleKey: 'ach_first_save_title',
      descKey: 'ach_first_save_desc',
      iconEmoji: '🌸',
      category: AchievementCategory.gallery,
      targetCount: 1,
    ),
    Achievement(
      id: 'five_saves',
      titleKey: 'ach_five_saves_title',
      descKey: 'ach_five_saves_desc',
      iconEmoji: '🖼️',
      category: AchievementCategory.gallery,
      targetCount: 5,
    ),
    Achievement(
      id: 'twenty_five',
      titleKey: 'ach_twenty_five_title',
      descKey: 'ach_twenty_five_desc',
      iconEmoji: '🏛️',
      category: AchievementCategory.gallery,
      targetCount: 25,
    ),
    Achievement(
      id: 'first_share',
      titleKey: 'ach_first_share_title',
      descKey: 'ach_first_share_desc',
      iconEmoji: '🌿',
      category: AchievementCategory.gallery,
      targetCount: 1,
    ),
    Achievement(
      id: 'ten_shares',
      titleKey: 'ach_ten_shares_title',
      descKey: 'ach_ten_shares_desc',
      iconEmoji: '💌',
      category: AchievementCategory.gallery,
      targetCount: 10,
    ),

    // INSPIRATION (4)
    Achievement(
      id: 'first_pattern',
      titleKey: 'ach_first_pattern_title',
      descKey: 'ach_first_pattern_desc',
      iconEmoji: '✨',
      category: AchievementCategory.inspiration,
      targetCount: 1,
    ),
    Achievement(
      id: 'all_patterns',
      titleKey: 'ach_all_patterns_title',
      descKey: 'ach_all_patterns_desc',
      iconEmoji: '🧘',
      category: AchievementCategory.inspiration,
      targetCount: 10,
    ),
    Achievement(
      id: 'ghost_master',
      titleKey: 'ach_ghost_master_title',
      descKey: 'ach_ghost_master_desc',
      iconEmoji: '✍️',
      category: AchievementCategory.inspiration,
      targetCount: 5,
    ),
    Achievement(
      id: 'daily_week',
      titleKey: 'ach_daily_week_title',
      descKey: 'ach_daily_week_desc',
      iconEmoji: '☀️',
      category: AchievementCategory.inspiration,
      targetCount: 7,
    ),

    // EXPLORATION (4)
    Achievement(
      id: 'theme_switch',
      titleKey: 'ach_theme_switch_title',
      descKey: 'ach_theme_switch_desc',
      iconEmoji: '🎨',
      category: AchievementCategory.exploration,
      targetCount: 3,
    ),
    Achievement(
      id: 'all_themes',
      titleKey: 'ach_all_themes_title',
      descKey: 'ach_all_themes_desc',
      iconEmoji: '🌈',
      category: AchievementCategory.exploration,
      targetCount: 6,
    ),
    Achievement(
      id: 'signature_set',
      titleKey: 'ach_signature_set_title',
      descKey: 'ach_signature_set_desc',
      iconEmoji: '✒️',
      category: AchievementCategory.exploration,
      targetCount: 1,
    ),
    Achievement(
      id: 'language_switch',
      titleKey: 'ach_language_switch_title',
      descKey: 'ach_language_switch_desc',
      iconEmoji: '🌐',
      category: AchievementCategory.exploration,
      targetCount: 2,
    ),

    // LOYALTY (5)
    Achievement(
      id: 'day_2',
      titleKey: 'ach_day_2_title',
      descKey: 'ach_day_2_desc',
      iconEmoji: '🌱',
      category: AchievementCategory.loyalty,
      targetCount: 2,
    ),
    Achievement(
      id: 'week_streak',
      titleKey: 'ach_week_streak_title',
      descKey: 'ach_week_streak_desc',
      iconEmoji: '🍃',
      category: AchievementCategory.loyalty,
      targetCount: 7,
    ),
    Achievement(
      id: 'month_streak',
      titleKey: 'ach_month_streak_title',
      descKey: 'ach_month_streak_desc',
      iconEmoji: '🌙',
      category: AchievementCategory.loyalty,
      targetCount: 30,
    ),
    Achievement(
      id: 'hundred_days',
      titleKey: 'ach_hundred_days_title',
      descKey: 'ach_hundred_days_desc',
      iconEmoji: '🎍',
      category: AchievementCategory.loyalty,
      targetCount: 100,
    ),
    Achievement(
      id: 'hidden_sunrise',
      titleKey: 'ach_hidden_sunrise_title',
      descKey: 'ach_hidden_sunrise_desc',
      iconEmoji: '🌅',
      category: AchievementCategory.loyalty,
      targetCount: 1,
      isHidden: true,
    ),
  ];

  static Achievement getById(String id) {
    return all.firstWhere((a) => a.id == id, orElse: () => all.first);
  }
}

