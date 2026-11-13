import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../services/audio_service.dart';
import '../services/haptic_service.dart';

/// A soothing, tactile button with a slow press scale animation (0.97)
/// and a minimum 56x56 tap target for generous accessibility.
class SoftButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final String? semanticLabel;
  final bool isPrimary;
  final SandTheme? theme;

  const SoftButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.semanticLabel,
    this.isPrimary = false,
    this.theme,
  });

  @override
  State<SoftButton> createState() => _SoftButtonState();
}

class _SoftButtonState extends State<SoftButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails _) {
    setState(() => _isPressed = true);
    HapticService.lightTap();
    AudioService.playUiTap();
  }

  void _handleTapUp(TapUpDetails _) {
    setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final sandTheme = widget.theme ?? SandTheme.warm;

    return Semantics(
      button: true,
      label: widget.semanticLabel ?? widget.label,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedScale(
          scale: _isPressed ? 0.97 : 1.0,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
          child: Container(
            constraints: const BoxConstraints(
              minWidth: 56.0,
              minHeight: 56.0,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: widget.isPrimary ? AppColors.accent : sandTheme.cardSurface,
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(
                color: widget.isPrimary
                    ? AppColors.accentSoft
                    : sandTheme.borderLight.withOpacity(0.6),
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: sandTheme.sandShadow.withOpacity(0.25),
                  blurRadius: 8.0,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.icon,
                  size: 18.0,
                  color: widget.isPrimary ? Colors.white : sandTheme.textPrimary,
                ),
                const SizedBox(width: 8.0),
                Text(
                  widget.label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: widget.isPrimary ? Colors.white : sandTheme.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
