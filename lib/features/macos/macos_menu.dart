import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/feature_flags.dart';

/// Configures the native macOS menu bar with calm, standard shortcuts.
/// Guarded by FeatureFlags.enableMacOS.
class MacOsMenuBar extends StatelessWidget {
  final Widget? child;
  final VoidCallback? onNewGarden;
  final VoidCallback? onSaveGarden;
  final VoidCallback? onShareGarden;
  final VoidCallback? onEraseGarden;
  final VoidCallback? onOpenSettings;

  const MacOsMenuBar({
    super.key,
    this.child,
    this.onNewGarden,
    this.onSaveGarden,
    this.onShareGarden,
    this.onEraseGarden,
    this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    // Guarded: Disabled for initial launch
    if (!FeatureFlags.enableMacOS) {
      return child ?? const SizedBox.shrink();
    }

    return PlatformMenuBar(
      menus: buildMenus(
        onNewGarden: onNewGarden ?? () {},
        onSaveGarden: onSaveGarden ?? () {},
        onShareGarden: onShareGarden ?? () {},
        onEraseGarden: onEraseGarden ?? () {},
        onOpenSettings: onOpenSettings ?? () {},
      ),
      child: child ?? const SizedBox.shrink(),
    );
  }

  static List<PlatformMenuItem> buildMenus({
    required VoidCallback onNewGarden,
    required VoidCallback onSaveGarden,
    required VoidCallback onShareGarden,
    required VoidCallback onEraseGarden,
    required VoidCallback onOpenSettings,
  }) {
    // Guarded: Disabled for initial launch
    if (!FeatureFlags.enableMacOS) return const [];

    return [
      PlatformMenu(
        label: 'Rake',
        menus: [
          PlatformMenuItemGroup(
            members: [
              PlatformMenuItem(
                label: 'About Rake',
                onSelected: () {},
              ),
              PlatformMenuItem(
                label: 'Preferences...',
                shortcut: const SingleActivator(LogicalKeyboardKey.comma, meta: true),
                onSelected: onOpenSettings,
              ),
            ],
          ),
          PlatformMenuItemGroup(
            members: [
              PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.quit),
            ],
          ),
        ],
      ),
      PlatformMenu(
        label: 'File',
        menus: [
          PlatformMenuItem(
            label: 'Smooth Garden',
            shortcut: const SingleActivator(LogicalKeyboardKey.keyE, meta: true),
            onSelected: onEraseGarden,
          ),
          PlatformMenuItem(
            label: 'Save Pattern',
            shortcut: const SingleActivator(LogicalKeyboardKey.keyS, meta: true),
            onSelected: onSaveGarden,
          ),
          PlatformMenuItem(
            label: 'Share...',
            shortcut: const SingleActivator(LogicalKeyboardKey.keyP, meta: true),
            onSelected: onShareGarden,
          ),
        ],
      ),
      PlatformMenu(
        label: 'Window',
        menus: [
          PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.minimizeWindow),
          PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.zoomWindow),
          PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.toggleFullScreen),
        ],
      ),
    ];
  }
}
