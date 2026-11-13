import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/constants.dart';
import '../core/feature_flags.dart';
import '../core/localization.dart';
import '../core/theme.dart';
import '../providers/garden_provider.dart';
import '../providers/settings_provider.dart';
import '../services/achievement_service.dart';
import '../services/analytics_service.dart';
import '../services/cloud_service.dart';
import '../services/haptic_service.dart';
import '../services/referral_service.dart';
import '../services/seasonal_service.dart';
import '../widgets/signature_dialog.dart';
import 'account_screen.dart';
import 'achievements_screen.dart';
import 'community_screen.dart';
import 'gdpr_screen.dart';
import 'premium_screen.dart';
import 'privacy_screen.dart';

/// Zen Settings Screen incorporating feature-flag gated controls.
/// Only Phase 1-3 approved elements are exposed for the European public launch.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _appVersion = '1.0.0';
  int _unlockedAchievementsCount = 0;
  bool _analyticsEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadAsyncData();
  }

  Future<void> _loadAsyncData() async {
    try {
      final info = await PackageInfo.fromPlatform();
      int count = 0;
      if (FeatureFlags.enableAchievements) {
        count = await AchievementService.getUnlockedCount();
      }
      setState(() {
        _appVersion = '${info.version} (${info.buildNumber})';
        _unlockedAchievementsCount = count;
        _analyticsEnabled = FeatureFlags.enableAnalytics && AnalyticsService.isEnabled;
      });
    } catch (_) {}
  }

  void _openThemePicker(BuildContext context) {
    final garden = context.read<GardenProvider>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: garden.theme.background,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tr('theme'),
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: garden.theme.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 120,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: SandTheme.all.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, index) {
                    final themeItem = SandTheme.all[index];
                    final isLocked = themeItem.isPremium && !garden.isPremium;
                    final isSelected = garden.theme.id == themeItem.id;

                    return GestureDetector(
                      onTap: () {
                        HapticService.lightTap();
                        if (isLocked) {
                          if (FeatureFlags.enablePremium) {
                            Navigator.pop(ctx);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const PremiumScreen()),
                            );
                          }
                        } else {
                          garden.setTheme(themeItem);
                          Navigator.pop(ctx);
                        }
                      },
                      child: Container(
                        width: 90,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: themeItem.sandBase,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.accent
                                : themeItem.sandShadow.withOpacity(0.5),
                            width: isSelected ? 2.5 : 1.0,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (isLocked)
                              const Icon(Icons.lock_outline_rounded,
                                  size: 22, color: AppColors.textSecondary)
                            else if (isSelected)
                              const Icon(Icons.check_circle_rounded,
                                  size: 22, color: AppColors.accent)
                            else
                              const SizedBox(height: 22),
                            const SizedBox(height: 8),
                            Text(
                              tr(themeItem.nameKey),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                color: themeItem.textPrimary,
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
      },
    );
  }

  void _openLanguagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final currentCode = context.locale.languageCode;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          decoration: BoxDecoration(
            color: context.read<GardenProvider>().theme.background,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tr('language'),
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: context.read<GardenProvider>().theme.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: AppLocalization.supportedLocales.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, index) {
                    final locale = AppLocalization.supportedLocales[index];
                    final code = locale.languageCode;
                    final isSelected = code == currentCode;

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        AppLocalization.languageNames[code] ?? code,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_rounded, color: AppColors.accent)
                          : null,
                      onTap: () async {
                        HapticService.lightTap();
                        await context.setLocale(locale);
                        if (mounted) Navigator.pop(ctx);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final garden = context.watch<GardenProvider>();
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      backgroundColor: garden.theme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: garden.theme.textPrimary,
          onPressed: () {
            HapticService.lightTap();
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          tr('settings'),
          style: GoogleFonts.cormorantGaramond(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: garden.theme.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          children: [
            // ============================================================
            // 1. PREMIUM UNLOCK CARD (Conditional on enablePremium)
            // ============================================================
            if (FeatureFlags.enablePremium && !garden.isPremium) ...[
              GestureDetector(
                onTap: () {
                  HapticService.lightTap();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PremiumScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(18.0),
                  decoration: BoxDecoration(
                    color: AppColors.premiumGold.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.premiumGold.withOpacity(0.6)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star_rounded, color: AppColors.premiumGold, size: 28),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Unlock Rake Premium — ${tr('premium_price')}',
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: garden.theme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              tr('premium_desc'),
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: garden.theme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: AppColors.premiumGold),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
            ],

            // ============================================================
            // 2. MINDFUL PROGRESSION (Conditional on Achievements / Community)
            // ============================================================
            if (FeatureFlags.enableAchievements || FeatureFlags.enableCommunity) ...[
              _buildSectionHeader('Mindful Progression', garden.theme),
              const SizedBox(height: 8),
              _buildCard(
                theme: garden.theme,
                children: [
                  if (FeatureFlags.enableAchievements)
                    _buildActionRow(
                      title: 'Achievements',
                      subtitle: '$_unlockedAchievementsCount / 25 Unlocked',
                      theme: garden.theme,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AchievementsScreen()),
                        );
                      },
                    ),
                  if (FeatureFlags.enableAchievements && FeatureFlags.enableCommunity)
                    const Divider(height: 1, color: AppColors.borderLight),
                  if (FeatureFlags.enableCommunity)
                    _buildActionRow(
                      title: 'Community Gallery',
                      subtitle: 'Explore creations from zen artists',
                      theme: garden.theme,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CommunityScreen()),
                        );
                      },
                    ),
                ],
              ),
              const SizedBox(height: 20),
            ],

            // ============================================================
            // 3. SOUND SECTION (ALWAYS SHOW BASE SOUND TOGGLES)
            // ============================================================
            _buildSectionHeader(tr('sound'), garden.theme),
            const SizedBox(height: 8),
            _buildCard(
              theme: garden.theme,
              children: [
                _buildSwitchRow(
                  title: tr('rake_sound'),
                  value: settings.rakeSound,
                  theme: garden.theme,
                  onChanged: (val) => settings.setRakeSound(val),
                ),
                const Divider(height: 1, color: AppColors.borderLight),
                _buildSwitchRow(
                  title: tr('ambient_sound'),
                  value: settings.ambientSound,
                  theme: garden.theme,
                  onChanged: (val) => settings.setAmbientSound(val),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ============================================================
            // 4. APPEARANCE (ALWAYS SHOW THEME PICKER & SIGNATURE)
            // ============================================================
            _buildSectionHeader('Appearance', garden.theme),
            const SizedBox(height: 8),
            _buildCard(
              theme: garden.theme,
              children: [
                _buildActionRow(
                  title: '${tr('theme')} (${FeatureFlags.availableThemeCount} Themes)',
                  subtitle: tr(garden.theme.nameKey),
                  theme: garden.theme,
                  onTap: () => _openThemePicker(context),
                ),
                const Divider(height: 1, color: AppColors.borderLight),
                _buildActionRow(
                  title: tr('signature'),
                  subtitle: settings.signature.isEmpty ? 'Tap to configure' : settings.signature,
                  theme: garden.theme,
                  onTap: () {
                    SignatureDialog.show(
                      context,
                      initialSignature: settings.signature,
                      onSaved: (name) {
                        settings.setSignature(name);
                        if (FeatureFlags.enableAchievements) {
                          AchievementService.incrementProgress('signature_set');
                        }
                      },
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ============================================================
            // 5. CLOUD SYNC & REFERRAL (Conditional)
            // ============================================================
            if (FeatureFlags.enableCloudSync || FeatureFlags.enableReferral) ...[
              _buildSectionHeader('Cloud & Devices', garden.theme),
              const SizedBox(height: 8),
              _buildCard(
                theme: garden.theme,
                children: [
                  if (FeatureFlags.enableCloudSync)
                    _buildActionRow(
                      title: 'Account & Cross-Device Sync',
                      subtitle: CloudService.userEmail ?? 'Guest (Tap to link account)',
                      theme: garden.theme,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AccountScreen()),
                        );
                      },
                    ),
                  if (FeatureFlags.enableCloudSync && FeatureFlags.enableReferral)
                    const Divider(height: 1, color: AppColors.borderLight),
                  if (FeatureFlags.enableReferral)
                    _buildActionRow(
                      title: 'Invite Friends & Earn Themes',
                      subtitle: 'Share your personal referral link',
                      theme: garden.theme,
                      onTap: () => ReferralService.shareReferralInvite(),
                    ),
                ],
              ),
              const SizedBox(height: 20),
            ],

            // ============================================================
            // 6. SEASONAL EVENTS (Conditional on enableSeasonalEvents)
            // ============================================================
            if (FeatureFlags.enableSeasonalEvents && SeasonalService.getActiveEvent() != null) ...[
              _buildSectionHeader('Seasonal Moment', garden.theme),
              const SizedBox(height: 8),
              _buildCard(
                theme: garden.theme,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Text(
                          SeasonalService.getActiveEvent()!.badgeEmoji,
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                SeasonalService.getActiveEvent()!.title,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: garden.theme.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                SeasonalService.getActiveEvent()!.description,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: garden.theme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],

            // ============================================================
            // 7. LANGUAGE (ALWAYS SHOW)
            // ============================================================
            _buildSectionHeader(tr('language'), garden.theme),
            const SizedBox(height: 8),
            _buildCard(
              theme: garden.theme,
              children: [
                _buildActionRow(
                  title: tr('language'),
                  subtitle: AppLocalization.languageNames[context.locale.languageCode] ?? 'English',
                  theme: garden.theme,
                  onTap: () => _openLanguagePicker(context),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ============================================================
            // 8. LEGAL & PRIVACY (ALWAYS SHOW)
            // ============================================================
            _buildSectionHeader('Legal & Privacy', garden.theme),
            const SizedBox(height: 8),
            _buildCard(
              theme: garden.theme,
              children: [
                _buildActionRow(
                  title: tr('privacy'),
                  theme: garden.theme,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PrivacyScreen()),
                    );
                  },
                ),
                if (FeatureFlags.enableGDPR) ...[
                  const Divider(height: 1, color: AppColors.borderLight),
                  _buildActionRow(
                    title: tr('privacy_settings'),
                    theme: garden.theme,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const GdprScreen()),
                      );
                    },
                  ),
                ],
                if (FeatureFlags.enableAnalytics) ...[
                  const Divider(height: 1, color: AppColors.borderLight),
                  _buildSwitchRow(
                    title: 'Optional Anonymous Analytics',
                    value: _analyticsEnabled,
                    theme: garden.theme,
                    onChanged: (val) async {
                      await AnalyticsService.setEnabled(val);
                      setState(() => _analyticsEnabled = val);
                    },
                  ),
                ],
              ],
            ),

            const SizedBox(height: 20),

            // ============================================================
            // 9. ABOUT & COMMUNITY (ALWAYS SHOW BASE ABOUT)
            // ============================================================
            _buildSectionHeader('About', garden.theme),
            const SizedBox(height: 8),
            _buildCard(
              theme: garden.theme,
              children: [
                if (FeatureFlags.enableRatePrompt) ...[
                  _buildActionRow(
                    title: tr('rate'),
                    theme: garden.theme,
                    onTap: () async {
                      final uri = Uri.parse(AppConstants.appUrl);
                      if (await canLaunchUrl(uri)) launchUrl(uri);
                    },
                  ),
                  const Divider(height: 1, color: AppColors.borderLight),
                ],
                _buildActionRow(
                  title: tr('share_app'),
                  theme: garden.theme,
                  onTap: () {
                    Share.share(
                      'Experience quiet meditation with Rake: ${AppConstants.appUrl}',
                    );
                  },
                ),
                const Divider(height: 1, color: AppColors.borderLight),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tr('made_with_calm'),
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: garden.theme.textSecondary,
                        ),
                      ),
                      Text(
                        'v$_appVersion',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: garden.theme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, SandTheme theme) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
          color: theme.textSecondary,
        ),
      ),
    );
  }

  Widget _buildCard({required SandTheme theme, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.borderLight, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildActionRow({
    required String title,
    String? subtitle,
    required SandTheme theme,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        HapticService.lightTap();
        onTap();
      },
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: theme.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: theme.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, size: 20, color: theme.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchRow({
    required String title,
    required bool value,
    required SandTheme theme,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: theme.textPrimary,
            ),
          ),
          Switch.adaptive(
            value: value,
            activeColor: AppColors.accent,
            onChanged: (val) {
              HapticService.lightTap();
              onChanged(val);
            },
          ),
        ],
      ),
    );
  }
}
