import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme.dart';
import '../services/haptic_service.dart';

/// Screen presenting the clean GDPR-compliant privacy policy.
class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

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
          tr('privacy'),
          style: GoogleFonts.cormorantGaramond(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          children: [
            _buildSection(
              title: '1. Our Philosophy of Quiet Privacy',
              body:
                  'Rake is built on the philosophy of calm and digital minimalism. We believe a meditation and relaxation app should respect your mental space and personal data. Your sand drawings and gallery patterns remain strictly stored on your own device and are never uploaded to any remote server.',
            ),
            const SizedBox(height: 20),
            _buildSection(
              title: '2. Local Storage & Data Minimization',
              body:
                  'All strokes, preferences (such as sound, haptics, theme, and artist signature), and saved gallery images are preserved solely within your local device storage. If you choose to erase your garden, all associated stroke records are wiped immediately.',
            ),
            const SizedBox(height: 20),
            _buildSection(
              title: '3. Optional Advertisements & GDPR Consent',
              body:
                  'We do not display banner or interstitial ads that disturb your serenity. Optional rewarded ads are only displayed if you explicitly consent and choose to unlock an extra inspiration pattern preview. You can review or revoke your consent at any time in the app settings.',
            ),
            const SizedBox(height: 20),
            _buildSection(
              title: '4. Your Rights under GDPR',
              body:
                  'Under the European General Data Protection Regulation (GDPR), you possess full rights to data portability, restriction, and erasure. Because we do not transmit identifying personal data to external clouds, clearing the app storage or uninstalling the app permanently purges all data.',
            ),
            const SizedBox(height: 20),
            _buildSection(
              title: '5. Contact & Questions',
              body:
                  'For any privacy inquiries or assistance, please reach out to our team at privacy@rake.app.',
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String body}) {
    return Container(
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppColors.borderLight.withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: GoogleFonts.inter(
              fontSize: 14,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

