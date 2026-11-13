import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/feature_flags.dart';
import '../../core/theme.dart';
import '../../services/haptic_service.dart';

/// Modal dialog and widget allowing users to pick a local audio file for background playback.
/// Guarded by FeatureFlags.enableUploadAudio.
class UploadAudioDialog extends StatelessWidget {
  const UploadAudioDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // Guarded: Disabled for initial launch
    if (!FeatureFlags.enableUploadAudio) {
      return const SizedBox.shrink();
    }

    return AlertDialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        'Personal Soundscape',
        style: GoogleFonts.cormorantGaramond(fontSize: 22, fontWeight: FontWeight.w600),
      ),
      content: Text(
        'Choose an audio file from your device (e.g. ambient music, rain, or white noise). For privacy, your audio is stored locally and never leaves your device.',
        style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
        ),
        ElevatedButton(
          onPressed: () => _pickFile(context),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
          child: const Text('Select Audio File'),
        ),
      ],
    );
  }

  static Future<void> _pickFile(BuildContext context) async {
    HapticService.lightTap();
    Navigator.pop(context);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'wav', 'm4a', 'aac'],
      );
      if (result != null && result.files.single.path != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Loaded "${result.files.single.name}" 🌿'),
            backgroundColor: AppColors.accent,
          ),
        );
      }
    } catch (_) {}
  }

  static Future<void> show(BuildContext context) async {
    if (!FeatureFlags.enableUploadAudio) return;
    showDialog(
      context: context,
      builder: (ctx) => const UploadAudioDialog(),
    );
  }
}
