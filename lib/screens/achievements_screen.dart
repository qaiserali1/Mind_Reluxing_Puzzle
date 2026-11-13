import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/theme.dart';
import '../data/achievements.dart';
import '../models/achievement.dart';
import '../services/haptic_service.dart';

/// Screen exhibiting all 25 mindful achievements with category filters and progress tracking.
class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  AchievementCategory? _selectedCategory;
  final Map<String, bool> _unlockedMap = {};
  final Map<String, int> _progressMap = {};
  final Map<String, String> _dateMap = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    for (final a in AchievementsData.all) {
      final isUnlocked = prefs.getBool('achievement_${a.id}') ?? false;
      _unlockedMap[a.id] = isUnlocked;
      _progressMap[a.id] = prefs.getInt('progress_${a.id}') ?? 0;
      if (isUnlocked) {
        _dateMap[a.id] = prefs.getString('achievement_${a.id}_date') ?? '';
      }
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  int get _unlockedCount => _unlockedMap.values.where((v) => v).length;

  List<Achievement> get _filteredAchievements {
    if (_selectedCategory == null) return AchievementsData.all;
    return AchievementsData.all.where((a) => a.category == _selectedCategory).toList();
  }

  void _showDetailDialog(Achievement achievement) {
    HapticService.lightTap();
    final isUnlocked = _unlockedMap[achievement.id] ?? false;
    final unlockDate = _dateMap[achievement.id];

    showDialog(
      context: context,
      barrierColor: AppColors.textPrimary.withOpacity(0.35),
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: isUnlocked ? AppColors.accentSoft.withOpacity(0.4) : AppColors.cardSurface,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                isUnlocked || !achievement.isHidden ? achievement.iconEmoji : '❓',
                style: const TextStyle(fontSize: 34),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isUnlocked || !achievement.isHidden ? tr(achievement.titleKey) : 'Secret Achievement',
              textAlign: TextAlign.center,
              style: GoogleFonts.cormorantGaramond(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isUnlocked || !achievement.isHidden
                  ? tr(achievement.descKey)
                  : 'Continue raking sand peacefully to uncover this secret.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary),
            ),
            if (isUnlocked && unlockDate != null && unlockDate.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Unlocked: ${unlockDate.substring(0, 10)}',
                style: GoogleFonts.inter(fontSize: 12, color: AppColors.accent),
              ),
            ],
          ],
        ),
        actions: [
          if (isUnlocked)
            TextButton.icon(
              onPressed: () {
                Share.share(
                  'I unlocked the "${tr(achievement.titleKey)}" achievement in Rake! 🌿 https://rake.app',
                );
              },
              icon: const Icon(Icons.share_rounded, size: 16, color: AppColors.accent),
              label: Text(
                'Share',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppColors.accent),
              ),
            ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(tr('cancel'), style: const TextStyle(color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: AppColors.textPrimary,
          onPressed: () {
            HapticService.lightTap();
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Achievements',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Stats Banner
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$_unlockedCount / ${AchievementsData.all.length} Unlocked',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.accent,
                        ),
                      ),
                      Text(
                        '${((_unlockedCount / AchievementsData.all.length) * 100).toInt()}% Complete',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Category Chips Filter
                SizedBox(
                  height: 48,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      _buildFilterChip('All', null),
                      _buildFilterChip('Drawing', AchievementCategory.drawing),
                      _buildFilterChip('Gallery', AchievementCategory.gallery),
                      _buildFilterChip('Inspiration', AchievementCategory.inspiration),
                      _buildFilterChip('Exploration', AchievementCategory.exploration),
                      _buildFilterChip('Loyalty', AchievementCategory.loyalty),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Achievements List
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                    itemCount: _filteredAchievements.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12.0),
                    itemBuilder: (context, index) {
                      final a = _filteredAchievements[index];
                      final isUnlocked = _unlockedMap[a.id] ?? false;
                      final progress = _progressMap[a.id] ?? 0;

                      return GestureDetector(
                        onTap: () => _showDetailDialog(a),
                        child: Container(
                          padding: const EdgeInsets.all(14.0),
                          decoration: BoxDecoration(
                            color: isUnlocked ? AppColors.cardSurface : AppColors.cardSurface.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isUnlocked
                                  ? AppColors.borderLight
                                  : AppColors.borderLight.withOpacity(0.4),
                            ),
                          ),
                          child: Row(
                            children: [
                              // Icon Box
                              Container(
                                width: 54,
                                height: 54,
                                decoration: BoxDecoration(
                                  color: isUnlocked
                                      ? AppColors.sandBase.withOpacity(0.7)
                                      : Colors.black.withOpacity(0.04),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  isUnlocked || !a.isHidden ? a.iconEmoji : '🔒',
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: isUnlocked ? null : Colors.black38,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),

                              // Text & Progress
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          isUnlocked || !a.isHidden
                                              ? tr(a.titleKey)
                                              : 'Secret Achievement',
                                          style: GoogleFonts.cormorantGaramond(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: isUnlocked
                                                ? AppColors.textPrimary
                                                : AppColors.textSecondary,
                                          ),
                                        ),
                                        if (isUnlocked)
                                          const Icon(Icons.check_circle_rounded,
                                              size: 16, color: AppColors.accent),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      isUnlocked || !a.isHidden
                                          ? tr(a.descKey)
                                          : 'Discover by exploring the garden',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    if (!isUnlocked && a.targetCount > 1 && !a.isHidden) ...[
                                      const SizedBox(height: 6),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: LinearProgressIndicator(
                                          value: (progress / a.targetCount).clamp(0.0, 1.0),
                                          backgroundColor: AppColors.borderLight,
                                          valueColor:
                                              const AlwaysStoppedAnimation(AppColors.accent),
                                          minHeight: 4,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildFilterChip(String label, AchievementCategory? category) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: AppColors.accent,
        backgroundColor: AppColors.cardSurface,
        labelStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          color: isSelected ? Colors.white : AppColors.textPrimary,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        side: BorderSide(
          color: isSelected ? AppColors.accent : AppColors.borderLight,
        ),
        onSelected: (_) {
          HapticService.lightTap();
          setState(() => _selectedCategory = category);
        },
      ),
    );
  }
}

