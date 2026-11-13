# Rake Accessibility Architecture (WCAG 2.1 AA & EN 301 549)

Rake is crafted with digital mindfulness and universal inclusivity at its core, complying with European standard EN 301 549 and Apple/Google accessibility guidelines.

## Features
1. **Screen Reader Support (VoiceOver / TalkBack)**:
   - Full semantic labeling on all controls with generous `minWidth: 56.0` and `minHeight: 56.0` targets.
   - Spoken descriptions of all 10 meditative patterns via `AccessibilityService.announcePattern`.
2. **Switch Control & Keyboards**:
   - Complete keyboard shortcuts support (`Cmd/Ctrl+E`, `Cmd/Ctrl+S`, `Cmd/Ctrl+Z`).
   - Standard Tab navigation focus rings on all interactive elements.
3. **High Contrast Mode**:
   - High contrast black-and-yellow zen sand palette (`AccessibilityService.highContrast`) automatically selectable in Settings.
4. **Reduced Motion**:
   - Detects `platformDispatcher.accessibilityFeatures.reduceMotion` and bypasses decorative transitions while preserving smooth Bezier groove rendering.

