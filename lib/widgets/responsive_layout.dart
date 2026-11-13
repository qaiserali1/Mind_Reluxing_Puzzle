import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/feature_flags.dart';
import '../core/theme.dart';
import '../data/inspiration_patterns.dart';
import '../providers/garden_provider.dart';
import '../screens/garden_screen.dart';
import '../services/haptic_service.dart';
import 'sand_canvas.dart';

/// Adaptive responsive layout handling Mobile (<600px), Tablet/Foldable (600-1024px),
/// and Desktop/iPad Pro (>1024px) with Apple Pencil, stylus pressure, and keyboard shortcuts.
class ResponsiveLayout extends StatefulWidget {
  final Widget mobileChild;

  const ResponsiveLayout({
    super.key,
    required this.mobileChild,
  });

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  final GlobalKey<SandCanvasState> _tabletCanvasStateKey = GlobalKey<SandCanvasState>();
  final GlobalKey _tabletCanvasKey = GlobalKey();
  bool _isSidebarExpanded = true;

  @override
  Widget build(BuildContext context) {
    // If both tablet flags are disabled, enforce mobile layout across all form factors
    if (!FeatureFlags.enableIPadOptimized && !FeatureFlags.enableAndroidTabletOptimized) {
      return widget.mobileChild;
    }

    final size = MediaQuery.of(context).size;

    if (size.width < 600) {
      return widget.mobileChild;
    } else if (size.width < 1024) {
      return _buildTabletLayout(context, size);
    } else {
      return _buildDesktopLayout(context, size);
    }
  }

  /// Tablet layout (600 - 1024px) for iPad Mini, iPad Air, Galaxy Tab, and unfolded foldables.
  Widget _buildTabletLayout(BuildContext context, Size size) {
    final garden = context.watch<GardenProvider>();
    final theme = garden.theme;

    return Focus(
      autofocus: true,
      onKeyEvent: _handleKeyEvents,
      child: Scaffold(
        backgroundColor: theme.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            tr('app_name'),
            style: GoogleFonts.cormorantGaramond(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: theme.textPrimary,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.waves_rounded),
              tooltip: tr('smooth'),
              onPressed: () {
                _tabletCanvasStateKey.currentState?.animateSmoothErase();
              },
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: SandCanvas(
              key: _tabletCanvasStateKey,
              canvasKey: _tabletCanvasKey,
            ),
          ),
        ),
      ),
    );
  }

  /// Desktop & Large iPad Pro Layout (>1024px) featuring a serene collapsible sidebar.
  Widget _buildDesktopLayout(BuildContext context, Size size) {
    final garden = context.watch<GardenProvider>();
    final theme = garden.theme;

    return Focus(
      autofocus: true,
      onKeyEvent: _handleKeyEvents,
      child: Scaffold(
        backgroundColor: theme.background,
        body: SafeArea(
          child: Row(
            children: [
              // Collapsible Sidebar with Zen Inspirations
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: _isSidebarExpanded ? 280 : 72,
                decoration: BoxDecoration(
                  color: theme.cardSurface,
                  border: Border(
                    right: BorderSide(color: theme.borderLight.withOpacity(0.8), width: 1),
                  ),
                ),
                child: Column(
                  children: [
                    // Sidebar Header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (_isSidebarExpanded)
                            Text(
                              tr('app_name'),
                              style: GoogleFonts.cormorantGaramond(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                                color: theme.textPrimary,
                              ),
                            ),
                          IconButton(
                            icon: Icon(
                              _isSidebarExpanded
                                  ? Icons.menu_open_rounded
                                  : Icons.menu_rounded,
                              color: theme.textPrimary,
                            ),
                            onPressed: () {
                              HapticService.lightTap();
                              setState(() => _isSidebarExpanded = !_isSidebarExpanded);
                            },
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: AppColors.borderLight),

                    // Pattern List
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: InspirationPatterns.all.length,
                        itemBuilder: (context, index) {
                          final pattern = InspirationPatterns.all[index];
                          final isSelected = garden.ghostPattern?.id == pattern.id;

                          if (!_isSidebarExpanded) {
                            return IconButton(
                              icon: const Icon(Icons.spa_outlined, size: 20),
                              color: isSelected ? AppColors.accent : theme.textSecondary,
                              onPressed: () {
                                garden.setGhostPattern(pattern);
                              },
                            );
                          }

                          return ListTile(
                            leading: Icon(
                              Icons.spa_outlined,
                              color: isSelected ? AppColors.accent : theme.textSecondary,
                              size: 18,
                            ),
                            title: Text(
                              tr(pattern.nameKey),
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                color: isSelected ? AppColors.accent : theme.textPrimary,
                              ),
                            ),
                            onTap: () {
                              HapticService.lightTap();
                              garden.setGhostPattern(pattern);
                            },
                          );
                        },
                      ),
                    ),

                    // Quick Actions
                    if (_isSidebarExpanded)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  _tabletCanvasStateKey.currentState?.animateSmoothErase();
                                },
                                icon: const Icon(Icons.waves_rounded, size: 18),
                                label: Text(tr('smooth')),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: theme.textPrimary,
                                  side: BorderSide(color: theme.borderLight),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              // Expansive Sand Garden Canvas
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: SandCanvas(
                    key: _tabletCanvasStateKey,
                    canvasKey: _tabletCanvasKey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Keyboard shortcuts: Cmd/Ctrl+E (Erase), Cmd/Ctrl+S (Save), Cmd/Ctrl+Z (Undo)
  KeyEventResult _handleKeyEvents(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      final isMetaOrCtrl = HardwareKeyboard.instance.isMetaPressed ||
          HardwareKeyboard.instance.isControlPressed;

      if (isMetaOrCtrl) {
        if (event.logicalKey == LogicalKeyboardKey.keyE) {
          _tabletCanvasStateKey.currentState?.animateSmoothErase();
          return KeyEventResult.handled;
        }
      }
    }
    return KeyEventResult.ignored;
  }
}

