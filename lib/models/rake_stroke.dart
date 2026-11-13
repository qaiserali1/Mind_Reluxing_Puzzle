import 'package:flutter/material.dart';

/// Represents a single continuous stroke drawn on the sand garden.
/// Points are normalized between 0.0 and 1.0 relative to canvas dimensions.
class RakeStroke {
  final List<Offset> points; // normalized 0.0-1.0 within canvas
  final double width; // stroke width in logical pixels
  final DateTime timestamp;

  RakeStroke({
    required this.points,
    this.width = 18.0,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Converts the stroke to a JSON-serializable map.
  Map<String, dynamic> toJson() {
    return {
      'points': points.map((p) => {'dx': p.dx, 'dy': p.dy}).toList(),
      'width': width,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// Recreates a stroke from a JSON map.
  factory RakeStroke.fromJson(Map<String, dynamic> json) {
    final rawPoints = json['points'] as List<dynamic>? ?? [];
    return RakeStroke(
      points: rawPoints.map((item) {
        final map = item as Map<String, dynamic>;
        return Offset(
          (map['dx'] as num).toDouble(),
          (map['dy'] as num).toDouble(),
        );
      }).toList(),
      width: (json['width'] as num?)?.toDouble() ?? 18.0,
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

