import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme.dart';
import '../services/haptic_service.dart';

/// Top bar with logo, Save action, Gallery access, and Settings.
class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final SandTheme theme;
  final VoidCallback onSavePressed;
  final VoidCallback onGalleryPressed;
  final VoidCallback onSettingsPressed;

  const TopBar({
    super.key,
    required this.theme,
    required this.onSavePressed,
    required this.onGalleryPressed,
    required this.onSettingsPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Logo in serif
          Text(
            tr('app_name'),
            style: GoogleFonts.cormorantGaramond(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              color: theme.textPrimary,
            ),
          ),

          // Action Buttons
          Row(
            children: [
              _IconButton(
                icon: Icons.bookmark_border_rounded,
                semanticLabel: tr('save'),
                theme: theme,
                onTap: onSavePressed,
              ),
              const SizedBox(width: 8.0),
              _IconButton(
                icon: Icons.photo_library_outlined,
                semanticLabel: tr('gallery'),
                theme: theme,
                onTap: onGalleryPressed,
              ),
              const SizedBox(width: 8.0),
              _IconButton(
                icon: Icons.tune_rounded,
                semanticLabel: tr('settings'),
                theme: theme,
                onTap: onSettingsPressed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final String semanticLabel;
  final SandTheme theme;
  final VoidCallback onTap;

  const _IconButton({
    required this.icon,
    required this.semanticLabel,
    required this.theme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticService.lightTap();
            onTap();
          },
          borderRadius: BorderRadius.circular(16.0),
          child: Container(
            constraints: const BoxConstraints(minWidth: 56.0, minHeight: 56.0),
            alignment: Alignment.center,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: theme.cardSurface.withOpacity(0.7),
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.borderLight.withOpacity(0.6),
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                color: theme.textPrimary,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
