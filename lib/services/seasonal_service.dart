import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../data/inspiration_patterns.dart';

/// Represents a time-limited seasonal mindfulness event with dedicated themes & patterns.
class SeasonalEvent {
  final String id;
  final String name;
  final String badgeEmoji;
  final int startMonth;
  final int startDay;
  final int endMonth;
  final int endDay;
  final SandTheme specialTheme;
  final List<InspirationPattern> specialPatterns;

  const SeasonalEvent({
    required this.id,
    required this.name,
    required this.badgeEmoji,
    required this.startMonth,
    required this.startDay,
    required this.endMonth,
    required this.endDay,
    required this.specialTheme,
    required this.specialPatterns,
  });

  bool isActiveOn(DateTime date) {
    final month = date.month;
    final day = date.day;

    // Standard single-year range (e.g. March to May)
    if (startMonth <= endMonth) {
      if (month < startMonth || month > endMonth) return false;
      if (month == startMonth && day < startDay) return false;
      if (month == endMonth && day > endDay) return false;
      return true;
    } else {
      // Cross-year range (e.g. Dec 1 to March 19)
      if (month > startMonth || (month == startMonth && day >= startDay)) return true;
      if (month < endMonth || (month == endMonth && day <= endDay)) return true;
      return false;
    }
  }
}

/// Service detecting active events and granting seasonal themes.
class SeasonalService {
  static final SeasonalEvent spring = SeasonalEvent(
    id: 'spring_blossom',
    name: 'Spring Blossom',
    badgeEmoji: '🌸',
    startMonth: 3,
    startDay: 20,
    endMonth: 5,
    endDay: 31,
    specialTheme: SandTheme.sakura,
    specialPatterns: [InspirationPatterns.lotus, InspirationPatterns.tree],
  );

  static final SeasonalEvent summer = SeasonalEvent(
    id: 'summer_solstice',
    name: 'Summer Solstice',
    badgeEmoji: '☀️',
    startMonth: 6,
    startDay: 20,
    endMonth: 8,
    endDay: 31,
    specialTheme: SandTheme.warm,
    specialPatterns: [InspirationPatterns.sunRays, InspirationPatterns.waterRipples],
  );

  static final SeasonalEvent autumn = SeasonalEvent(
    id: 'autumn_leaves',
    name: 'Autumn Leaves',
    badgeEmoji: '🍂',
    startMonth: 9,
    startDay: 20,
    endMonth: 11,
    endDay: 30,
    specialTheme: SandTheme.autumn,
    specialPatterns: [InspirationPatterns.leaf, InspirationPatterns.tree],
  );

  static final SeasonalEvent winter = SeasonalEvent(
    id: 'winter_snow',
    name: 'Winter Snow',
    badgeEmoji: '❄️',
    startMonth: 12,
    startDay: 1,
    endMonth: 3,
    endDay: 19,
    specialTheme: SandTheme.snow,
    specialPatterns: [InspirationPatterns.mountains, InspirationPatterns.concentric],
  );

  static final List<SeasonalEvent> allEvents = [spring, summer, autumn, winter];

  /// Returns currently active seasonal event according to local device date.
  static SeasonalEvent? getActiveEvent([DateTime? date]) {
    final now = date ?? DateTime.now();
    for (final event in allEvents) {
      if (event.isActiveOn(now)) return event;
    }
    return null;
  }
}

