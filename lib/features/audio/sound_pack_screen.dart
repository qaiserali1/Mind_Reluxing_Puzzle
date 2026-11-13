import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/feature_flags.dart';
import '../../core/theme.dart';
import '../../services/haptic_service.dart';
import 'upload_audio_dialog.dart';

/// Sound pack model for ambient atmospheres.
class AmbientSoundPack {
  final String id;
  final String title;
  final String description;
  final String iconEmoji;
  final bool isPremium;

  const AmbientSoundPack({
    required this.id,
    required this.title,
    required this.description,
    required this.iconEmoji,
    this.isPremium = true,
  });
}

/// Screen presenting expanded atmospheric soundscapes and binaural mindfulness frequencies.
class SoundPackScreen extends StatefulWidget {
  const SoundPackScreen({super.key});

  @override
  State<SoundPackScreen> createState() => _SoundPackScreenState();
}

class _SoundPackScreenState extends State<SoundPackScreen> {
  String _selectedPackId = 'wind';
  bool _binauralEnabled = false;

  static const List<AmbientSoundPack> soundPacks = [
    AmbientSoundPack(
      id: 'wind',
      title: 'Gentle Breeze',
      description: 'Soft mountain wind whispering through pine branches.',
      iconEmoji: '🍃',
      isPremium: false,
    ),
    AmbientSoundPack(
      id: 'forest',
      title: 'Bamboo Forest',
      description: 'Distant songbirds and rustling bamboo stalks in Kyoto.',
      iconEmoji: '🎋',
    ),
    AmbientSoundPack(
      id: 'ocean',
      title: 'Tidal Waves',
      description: 'Rhythmic, gentle waves ebbing on pebble shorelines.',
      iconEmoji: '🌊',
    ),
    AmbientSoundPack(
      id: 'rain',
      title: 'Temple Rain',
      description: 'Steady, calming raindrops falling onto wooden temple eaves.',
      iconEmoji: '🌧️',
    ),
    AmbientSoundPack(
      id: 'cafe',
      title: 'Quiet Tearoom',
      description: 'Soft clinking of porcelain and distant calming murmur.',
      iconEmoji: '🍵',
    ),
    AmbientSoundPack(
      id: 'night',
      title: 'Night Garden',
      description: 'Peaceful cicadas and evening breeze beneath starlight.',
      iconEmoji: '🌌',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (!FeatureFlags.enableSoundPacks) {
      return const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: AppColors.textPrimary,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Soundscapes',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            // Custom Audio Import Button
            OutlinedButton.icon(
              onPressed: () {
                UploadAudioDialog.show(context);
              },
              icon: const Icon(Icons.library_music_outlined, size: 20),
              label: const Text('Use Custom Ambient Track'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: AppColors.borderLight),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),

            const SizedBox(height: 24),

            // Binaural Beats Switch
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.cardSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '528Hz Zen Frequency',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Subtle harmonic frequency promoting serenity.',
                        style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  Switch(
                    value: _binauralEnabled,
                    activeColor: AppColors.accent,
                    onChanged: (val) {
                      HapticService.lightTap();
                      setState(() => _binauralEnabled = val);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'ATMOSPHERES',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),

            ...soundPacks.map((pack) {
              final isSelected = _selectedPackId == pack.id;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? AppColors.accent : AppColors.borderLight,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: ListTile(
                  leading: Text(pack.iconEmoji, style: const TextStyle(fontSize: 26)),
                  title: Text(
                    pack.title,
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    pack.description,
                    style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle_rounded, color: AppColors.accent)
                      : pack.isPremium
                          ? const Icon(Icons.lock_outline_rounded, size: 20, color: Colors.black38)
                          : null,
                  onTap: () {
                    HapticService.lightTap();
                    setState(() => _selectedPackId = pack.id);
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

