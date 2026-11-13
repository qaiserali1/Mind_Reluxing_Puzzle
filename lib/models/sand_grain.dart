import 'dart:math';
import 'package:flutter/material.dart';

/// Represents an individual grain of sand rendered onto the canvas background.
class SandGrain {
  final Offset position; // Normalized coordinates (0.0 to 1.0)
  final double size; // Size in logical pixels (1.0 to 3.0)
  final double opacity; // Opacity (0.15 to 0.40)

  const SandGrain({
    required this.position,
    required this.size,
    required this.opacity,
  });

  /// Generates a randomized list of grains (default 1000) using a fixed or seeded random.
  static List<SandGrain> generate({int count = 1000, int seed = 42}) {
    final random = Random(seed);
    return List.generate(count, (_) {
      return SandGrain(
        position: Offset(random.nextDouble(), random.nextDouble()),
        size: 1.0 + random.nextDouble() * 2.0, // 1.0 - 3.0 px
        opacity: 0.15 + random.nextDouble() * 0.25, // 0.15 - 0.40
      );
    });
  }
}

