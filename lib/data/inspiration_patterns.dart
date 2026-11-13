import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Defines an inspiration pattern that can be previewed or ghost-overlaid on the sand.
class InspirationPattern {
  final String id;
  final String nameKey;
  final List<List<Offset>> strokes; // normalized 0.0-1.0
  final double strokeWidth;

  const InspirationPattern({
    required this.id,
    required this.nameKey,
    required this.strokes,
    this.strokeWidth = 14.0,
  });
}

/// The collection of 10 handcrafted, meditative Zen patterns.
class InspirationPatterns {
  // 1. CONCENTRIC CIRCLES (3 full circles, radii 0.15, 0.25, 0.35, 24 points each)
  static final InspirationPattern concentric = InspirationPattern(
    id: 'concentric',
    nameKey: 'pattern_concentric',
    strokes: [0.15, 0.25, 0.35].map((radius) {
      const count = 24;
      return List<Offset>.generate(count + 1, (i) {
        final angle = (i % count) * 2 * math.pi / count;
        return Offset(
          0.5 + radius * math.cos(angle),
          0.5 + radius * math.sin(angle),
        );
      });
    }).toList(),
  );

  // 2. WATER RIPPLES (5 horizontal wavy lines, y: 0.25, 0.35, 0.45, 0.55, 0.65)
  static final InspirationPattern waterRipples = InspirationPattern(
    id: 'waves',
    nameKey: 'pattern_waves',
    strokes: [0.25, 0.35, 0.45, 0.55, 0.65].map((baseY) {
      const segments = 40;
      return List<Offset>.generate(segments + 1, (i) {
        final t = i / segments;
        final x = 0.15 + t * 0.70;
        final y = baseY + 0.03 * math.sin(t * 3 * 2 * math.pi);
        return Offset(x, y);
      });
    }).toList(),
  );

  // 3. SPIRAL (Archimedean spiral, 3 rotations, r: 0.05 -> 0.40, 60 points)
  static final InspirationPattern spiral = InspirationPattern(
    id: 'spiral',
    nameKey: 'pattern_spiral',
    strokes: [
      List<Offset>.generate(60, (i) {
        final t = i / 59.0;
        final theta = t * 3.0 * 2.0 * math.pi;
        final r = 0.05 + t * 0.35;
        return Offset(
          0.5 + r * math.cos(theta),
          0.5 + r * math.sin(theta),
        );
      }),
    ],
  );

  // 4. ZEN WAVES (7 curved parallel arcs from top-left to bottom-right)
  static final InspirationPattern zenWaves = InspirationPattern(
    id: 'zen_wave',
    nameKey: 'pattern_zen_wave',
    strokes: List.generate(7, (lineIdx) {
      final offset = (lineIdx - 3) * 0.08;
      const count = 30;
      return List.generate(count + 1, (i) {
        final t = i / count;
        final x = 0.15 + t * 0.70;
        final y = 0.30 + t * 0.40 + offset + 0.05 * math.sin(t * math.pi);
        return Offset(x.clamp(0.05, 0.95), y.clamp(0.05, 0.95));
      });
    }),
  );

  // 5. BAMBOO (3 vertical stalks at x=0.3, 0.5, 0.7; 4 segments each with dividers)
  static final InspirationPattern bamboo = InspirationPattern(
    id: 'bamboo',
    nameKey: 'pattern_bamboo',
    strokes: () {
      final List<List<Offset>> allStrokes = [];
      final xs = [0.3, 0.5, 0.7];
      for (final x in xs) {
        // 4 segments between y = 0.2 and 0.8
        for (int seg = 0; seg < 4; seg++) {
          final y1 = 0.20 + seg * 0.15;
          final y2 = y1 + 0.14;
          // Vertical segment line
          allStrokes.add([Offset(x, y1), Offset(x, y2)]);
          // Horizontal divider notch at joints
          allStrokes.add([Offset(x - 0.03, y1), Offset(x + 0.03, y1)]);
        }
        allStrokes.add([Offset(x - 0.03, 0.80), Offset(x + 0.03, 0.80)]);
      }
      return allStrokes;
    }(),
  );

  // 6. LEAF (Central vein + outer contour + 5 side veins)
  static final InspirationPattern leaf = InspirationPattern(
    id: 'leaf',
    nameKey: 'pattern_leaf',
    strokes: () {
      final List<List<Offset>> list = [];
      // Central vein from (0.3, 0.75) to (0.7, 0.25)
      list.add([const Offset(0.30, 0.75), const Offset(0.70, 0.25)]);

      // Leaf left contour
      list.add(List.generate(21, (i) {
        final t = i / 20.0;
        final x = 0.30 + t * 0.40 - 0.12 * math.sin(t * math.pi);
        final y = 0.75 - t * 0.50;
        return Offset(x, y);
      }));

      // Leaf right contour
      list.add(List.generate(21, (i) {
        final t = i / 20.0;
        final x = 0.30 + t * 0.40 + 0.12 * math.sin(t * math.pi);
        final y = 0.75 - t * 0.50;
        return Offset(x, y);
      }));

      // 5 pairs of side veins
      for (int i = 1; i <= 5; i++) {
        final t = i / 6.0;
        final vx = 0.30 + t * 0.40;
        final vy = 0.75 - t * 0.50;
        list.add([Offset(vx, vy), Offset(vx - 0.07, vy - 0.03)]);
        list.add([Offset(vx, vy), Offset(vx + 0.07, vy - 0.03)]);
      }
      return list;
    }(),
  );

  // 7. MOUNTAINS (Zigzag mountain range with 4 peaks at y=0.3, valleys at y=0.6)
  static final InspirationPattern mountains = InspirationPattern(
    id: 'mountains',
    nameKey: 'pattern_mountains',
    strokes: [
      const [
        Offset(0.10, 0.60),
        Offset(0.20, 0.32),
        Offset(0.32, 0.58),
        Offset(0.45, 0.28),
        Offset(0.58, 0.59),
        Offset(0.70, 0.30),
        Offset(0.82, 0.60),
        Offset(0.90, 0.35),
      ],
      // Ridge shadows
      const [Offset(0.20, 0.32), Offset(0.24, 0.60)],
      const [Offset(0.45, 0.28), Offset(0.48, 0.60)],
      const [Offset(0.70, 0.30), Offset(0.74, 0.60)],
    ],
  );

  // 8. SUN RAYS (12 straight lines radiating from center (0.5, 0.4), length 0.3)
  static final InspirationPattern sunRays = InspirationPattern(
    id: 'sunrays',
    nameKey: 'pattern_sunrays',
    strokes: () {
      final List<List<Offset>> list = [];
      const count = 12;
      const center = Offset(0.5, 0.4);
      for (int i = 0; i < count; i++) {
        final angle = i * 2 * math.pi / count;
        final start = Offset(
          center.dx + 0.08 * math.cos(angle),
          center.dy + 0.08 * math.sin(angle),
        );
        final end = Offset(
          center.dx + 0.32 * math.cos(angle),
          center.dy + 0.32 * math.sin(angle),
        );
        list.add([start, end]);
      }
      return list;
    }(),
  );

  // 9. LOTUS FLOWER (8 petals around center (0.5, 0.5), radius 0.3)
  static final InspirationPattern lotus = InspirationPattern(
    id: 'lotus',
    nameKey: 'pattern_lotus',
    strokes: () {
      final List<List<Offset>> petals = [];
      const center = Offset(0.5, 0.5);
      const count = 8;
      for (int i = 0; i < count; i++) {
        final angle = i * 2 * math.pi / count;
        final petalTip = Offset(
          center.dx + 0.28 * math.cos(angle),
          center.dy + 0.28 * math.sin(angle),
        );
        final sideAngle1 = angle - 0.25;
        final sideAngle2 = angle + 0.25;
        final ctrl1 = Offset(
          center.dx + 0.16 * math.cos(sideAngle1),
          center.dy + 0.16 * math.sin(sideAngle1),
        );
        final ctrl2 = Offset(
          center.dx + 0.16 * math.cos(sideAngle2),
          center.dy + 0.16 * math.sin(sideAngle2),
        );
        petals.add([center, ctrl1, petalTip]);
        petals.add([petalTip, ctrl2, center]);
      }
      return petals;
    }(),
  );

  // 10. MINIMAL TREE (Trunk 0.5, 0.85 to 0.5, 0.4 + 4 branches with leaf clusters)
  static final InspirationPattern tree = InspirationPattern(
    id: 'tree',
    nameKey: 'pattern_tree',
    strokes: () {
      final List<List<Offset>> list = [];
      // Trunk
      list.add([const Offset(0.5, 0.85), const Offset(0.5, 0.42)]);

      // 4 branches
      final branchTargets = [
        const Offset(0.30, 0.30),
        const Offset(0.38, 0.22),
        const Offset(0.62, 0.22),
        const Offset(0.70, 0.30),
      ];

      for (final tip in branchTargets) {
        list.add([const Offset(0.5, 0.45), tip]);
        // Leaf cluster (mini circle at tip)
        const clusterPoints = 12;
        list.add(List.generate(clusterPoints + 1, (i) {
          final a = (i % clusterPoints) * 2 * math.pi / clusterPoints;
          return Offset(
            tip.dx + 0.05 * math.cos(a),
            tip.dy + 0.05 * math.sin(a),
          );
        }));
      }
      return list;
    }(),
  );

  static final List<InspirationPattern> all = [
    concentric,
    waterRipples,
    spiral,
    zenWaves,
    bamboo,
    leaf,
    mountains,
    sunRays,
    lotus,
    tree,
  ];

  static InspirationPattern getById(String id) {
    return all.firstWhere((p) => p.id == id, orElse: () => concentric);
  }
}

