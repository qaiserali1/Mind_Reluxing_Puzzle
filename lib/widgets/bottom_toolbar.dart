import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../core/feature_flags.dart';
import '../core/theme.dart';
import 'soft_button.dart';

/// Bottom toolbar providing primary zen actions: Inspiration, Smooth, and Share,
/// with guarded Phase 4 actions (Collaborate, AR) when enabled.
class BottomToolbar extends StatelessWidget {
  final SandTheme theme;
  final VoidCallback onInspirationPressed;
  final VoidCallback onSmoothPressed;
  final VoidCallback onSharePressed;
  final VoidCallback? onCollabPressed;
  final VoidCallback? onArPressed;

  const BottomToolbar({
    super.key,
    required this.theme,
    required this.onInspirationPressed,
    required this.onSmoothPressed,
    required this.onSharePressed,
    this.onCollabPressed,
    this.onArPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.0,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SoftButton(
            label: tr('inspiration'),
            icon: Icons.auto_awesome_rounded,
            theme: theme,
            onTap: onInspirationPressed,
          ),
          SoftButton(
            label: tr('smooth'),
            icon: Icons.waves_rounded,
            theme: theme,
            onTap: onSmoothPressed,
          ),
          SoftButton(
            label: tr('share'),
            icon: Icons.share_rounded,
            theme: theme,
            onTap: onSharePressed,
          ),
          // Guarded Phase 4 Actions
          if (FeatureFlags.enableCollaboration && onCollabPressed != null)
            SoftButton(
              label: 'Collab',
              icon: Icons.group_outlined,
              theme: theme,
              onTap: onCollabPressed!,
            ),
          if (FeatureFlags.enableARMode && onArPressed != null)
            SoftButton(
              label: 'AR',
              icon: Icons.view_in_ar_rounded,
              theme: theme,
              onTap: onArPressed!,
            ),
        ],
      ),
    );
  }
}
