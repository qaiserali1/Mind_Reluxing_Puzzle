# Rake — App Icon & Store Graphic Specifications

This document defines the exact visual assets, geometry, color palettes, and production requirements for the **Rake** app icon, Android adaptive icons, and the Google Play Feature Graphic.

---

## 1. Design Concept & Brand Identity

The icon embodies **calm digital tactileism**:
- **Base Canvas**: Warm natural sand tone (`#E8DCC8`).
- **Rake Grooves**: Concentric, organic spiral grooves engraved into the sand (`#D4C4A8` shadow, `#F5EFE6` highlight rim).
- **Focal Stone**: A single smooth, tumbled river pebble in muted Japanese sage green (`#7FA88E`) positioned with natural asymmetry near the golden ratio intersection.
- **Philosophy**: Pure, uncluttered, recognizable at 16px and stunning at 1024px. No text, no badges, no harsh gradients.

---

## 2. Color Palette Specifications

| Element | Hex Code | RGB | Purpose |
|---|---|---|---|
| Sand Field Background | `#E8DCC8` | `232, 220, 200` | Warm cream sand foundation |
| Groove Shadow | `#D4C4A8` | `212, 196, 168` | Carved depression depth |
| Ridge Highlight | `#F5EFE6` | `245, 239, 230` | Sunlit crest of sand groove |
| River Pebble Body | `#7FA88E` | `127, 168, 142` | Muted sage green river stone |
| River Pebble Shadow | `#5E826C` | `94, 130, 108` | Cast stone contact shadow |
| Pebble Specular Dot | `#A3C4AF` | `163, 196, 175` | Soft matte diffuse reflection |

---

## 3. iOS App Store Master Icon (1024 × 1024 px)

- **Resolution**: `1024 x 1024 px`
- **Format**: PNG-24 (strictly **no alpha / transparency**).
- **Color Space**: Display P3 (sRGB fallback provided).
- **Corner Radius**: Square edges (Apple App Store Connect applies the standard `22.37%` squircle mask automatically).
- **Geometry**:
  - Center of concentric grooves: `(512, 512)`
  - Radius of outermost ripple: `420 px`
  - Stroke width of grooves: `24 px` with soft feathered edges (`4 px` blur).
  - Pebble center: `(620, 440)` with bounding diameter `160 x 140 px` rotated `18°` clockwise.

---

## 4. Android Adaptive Icon (Play Store & System Launcher)

Android requires a 2-layer adaptive icon model (`res/mipmap-anydpi-v26/ic_launcher.xml`):

### A. Layer Dimensions
- **Total Canvas**: `108 x 108 dp` (at `xxxhdpi`: `432 x 432 px`).
- **Safe Zone**: Center `66 dp` diameter circle (`264 x 264 px`). All focal elements (pebble and central spiral) must fit within this circle to avoid clipping on OEM squircles, circles, and teardrops.

### B. Background Layer (`res/drawable/ic_launcher_background.xml`)
```xml
<?xml version="1.0" encoding="utf-8"?>
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="108dp"
    android:height="108dp"
    android:viewportWidth="108"
    android:viewportHeight="108">
    <path
        android:fillColor="#E8DCC8"
        android:pathData="M0,0h108v108h-108z" />
</vector>
```

### C. Foreground Layer (`res/drawable/ic_launcher_foreground.xml`)
- Contains the carved spiral path with `#D4C4A8` stroke and the pebble `#7FA88E` with contact drop shadow.

---

## 5. Google Play Store Feature Graphic (1024 × 500 px)

The Play Store Feature Graphic is displayed at the top of the store listing and drives conversion rates.

- **Resolution**: `1024 x 500 px`
- **Format**: JPEG or 24-bit PNG (no transparency).
- **File Size**: Max 15 MB (target < 800 KB optimized).
- **Safe Zones**:
  - Keep all focal artwork and branding within the middle `800 x 360 px` zone.
  - Margins of `112 px` on left/right and `70 px` on top/bottom must contain only textured sand background to prevent cutoff across different phone aspect ratios.
- **Visual Composition**:
  - **Left 60%**: Overhead view of organic rake lines curving around two balanced pebbles on warm textured sand.
  - **Right 40%**: Clean, elegant typography:
    - Title: **Rake** in Cormorant Garamond / Serif typography (`#2D3748`).
    - Subtitle: *Zen Sand Garden* (`#5E6B7E`).
  - **Background**: Soft natural sunlight gradient flowing from top-left to bottom-right.

---

## 6. Multi-Platform Export Dimension Table

| Platform | Usage | Dimensions | Format | Notes |
|---|---|---|---|---|
| **iOS / iPadOS** | App Store Connect Master | `1024 x 1024 px` | PNG-24 (No alpha) | Master asset |
| **iOS** | iPhone Springboard (`@3x`) | `180 x 180 px` | PNG | `AppIcon-60x60@3x.png` |
| **iOS** | iPhone Springboard (`@2x`) | `120 x 120 px` | PNG | `AppIcon-60x60@2x.png` |
| **iPadOS** | iPad Pro / Air (`@2x`) | `167 x 167 px` | PNG | `AppIcon-83.5x83.5@2x.png` |
| **watchOS** | Apple Watch App Store | `1024 x 1024 px` | PNG (No alpha) | Circular framing safe |
| **watchOS** | Watch Home Screen (45mm) | `108 x 108 px` | PNG | Circular icon |
| **watchOS** | Watch Home Screen (41mm) | `88 x 88 px` | PNG | Circular icon |
| **macOS** | Application Master | `1024 x 1024 px` | PNG (Alpha allowed) | Mac squircle frame |
| **macOS** | Retina Dock (`@2x`) | `512 x 512 px` | PNG | With gentle shadow |
| **Android** | Google Play Store Master | `512 x 512 px` | PNG-32 (Alpha allowed) | Max 1024 KB |
| **Android** | Feature Graphic | `1024 x 500 px` | PNG-24 / JPEG | No transparency |
| **Web** | Apple Touch Icon | `180 x 180 px` | PNG | For website home bookmark |
| **Web** | Favicon (Standard) | `32 x 32 px` | PNG / ICO | Browser tab |
| **Web** | Favicon (Small) | `16 x 16 px` | PNG / ICO | URL bar & bookmark |

---

## 7. AI Generation Prompt for Concept Artists & Renderers

```text
Minimalist app icon design for a meditative zen sand garden mobile game, centered composition, smooth zen gravel sand with gentle concentric curved rake furrows, one small polished moss-green river stone placed organically near center, warm cream sand #E8DCC8, soft morning sunlight casting micro-shadows, hyper-clean Apple design award aesthetic, Monument Valley minimalism, no text, no interface buttons, vector-like tactile render, 8k resolution, centered, app icon framing --v 6.1 --style raw
```

