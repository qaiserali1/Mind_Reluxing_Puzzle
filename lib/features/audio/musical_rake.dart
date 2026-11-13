import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/feature_flags.dart';

/// Musical Rake engine that maps canvas stroke coordinates to gentle pentatonic tones.
/// Guarded by FeatureFlags.enableMusicalRake.
class MusicalRake extends StatelessWidget {
  const MusicalRake({super.key});

  @override
  Widget build(BuildContext context) {
    // Guarded: Disabled for initial launch
    if (!FeatureFlags.enableMusicalRake) {
      return const SizedBox.shrink();
    }
    return const SizedBox.shrink();
  }

  static bool get isEnabled => FeatureFlags.enableMusicalRake;

  // Japanese Insen pentatonic scale frequencies (D, Eb, G, A, C)
  static const List<double> _pentatonicScale = [
    293.66, // D4
    311.13, // Eb4
    392.00, // G4
    440.00, // A4
    523.25, // C5
    587.33, // D5
  ];

  /// Calculates harmonic frequency from normalized touch position.
  static double getPitchFromOffset(Offset normalizedOffset) {
    if (!FeatureFlags.enableMusicalRake) return 440.0;

    final index = (normalizedOffset.dx * (_pentatonicScale.length - 1))
        .round()
        .clamp(0, _pentatonicScale.length - 1);
    return _pentatonicScale[index];
  }
}
