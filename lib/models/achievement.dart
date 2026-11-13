/// Category grouping for mindful achievements.
enum AchievementCategory {
  drawing, // strokes, patterns, time
  gallery, // saves, shares
  inspiration, // patterns used
  exploration, // themes tried, settings changed
  loyalty, // streaks, days opened
}

/// Represents an unlocked or progressable achievement.
class Achievement {
  final String id;
  final String titleKey;
  final String descKey;
  final String iconEmoji;
  final AchievementCategory category;
  final int targetCount;
  final bool isHidden;

  const Achievement({
    required this.id,
    required this.titleKey,
    required this.descKey,
    required this.iconEmoji,
    required this.category,
    this.targetCount = 1,
    this.isHidden = false,
  });
}

