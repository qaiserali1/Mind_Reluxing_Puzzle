# Rake macOS Native Desktop Integration

Rake supports native macOS desktop running natively on Apple Silicon (M1/M2/M3) and Intel Macs through Flutter's native macOS desktop embedder.

## Capabilities
1. **Fluid Window Resizing**: Adapts smoothly from minimal 800x600 window to expansive 5K Retina displays.
2. **Native Menu Bar**: Implemented via `PlatformMenuBar` in `lib/features/macos/macos_menu.dart`.
3. **Keyboard Shortcuts**:
   - `Cmd + E`: Smooth/Erase sand completely.
   - `Cmd + S`: Save pattern to gallery.
   - `Cmd + ,`: Open Settings & Preferences.
   - `Cmd + P`: Share canvas.
4. **Trackpad & Mouse**: Responsive quadratic Bezier drawing with click-and-drag and trackpad velocity dampening.
5. **App Sandbox & Entitlements**: Configured for Mac App Store sandboxing with file-read-write entitlements for exporting SVG and PDF creations.

