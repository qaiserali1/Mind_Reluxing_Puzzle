# Rake Multi-Platform Ecosystem Guide

Rake spans seamlessly across Apple and Google ecosystems, providing a unified meditative garden experience:

| Platform | Capabilities | Key Files |
|---|---|---|
| **iOS / iPhone** | 120Hz ProMotion drawing, Haptics, Live Activities | `ios/Runner/LiveActivity/` |
| **iPadOS** | Apple Pencil pressure/tilt, Split View, Keyboard shortcuts | `lib/widgets/responsive_layout.dart` |
| **macOS** | Desktop window resizing, Native Menu Bar, Trackpad gestures | `lib/features/macos/macos_menu.dart` |
| **watchOS** | 60s Breathing exercise, Daily Pattern glance, Complications | `watch/RakeWatch/` |
| **Android Phone** | Material 3, UMP consent, Rewarded previews | `lib/main.dart` |
| **Android Tablet / Foldables** | Large canvas, S Pen, Foldable hinge posture support | `lib/widgets/responsive_layout.dart` |
| **AR Mode (iOS)** | ARKit surface detection, 3D world space sand projection | `lib/features/ar/ar_garden_screen.dart` |
| **Cloud Sync** | Real-time Co-Drawing, Firestore anonymous sync, SVG vector export | `lib/services/cloud_service.dart`, `lib/features/collab/` |

