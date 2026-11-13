import 'dart:ui';
import '../core/theme.dart';
import '../models/rake_stroke.dart';

/// Generates scalable vector graphics (SVG) representation of the sand garden.
class SvgService {
  /// Converts a collection of RakeStrokes into clean, resolution-independent SVG XML.
  static String strokesToSvg({
    required List<RakeStroke> strokes,
    required SandTheme theme,
    required Size size,
  }) {
    final width = size.width > 0 ? size.width : 1080.0;
    final height = size.height > 0 ? size.height : 1440.0;

    final buffer = StringBuffer();
    buffer.writeln('<?xml version="1.0" encoding="UTF-8"?>');
    buffer.writeln(
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 $width $height" width="$width" height="$height">',
    );

    // Definitions: Sand Vertical Gradient
    buffer.writeln('  <defs>');
    buffer.writeln('    <linearGradient id="sandGrad" x1="0%" y1="0%" x2="0%" y2="100%">');
    buffer.writeln(
      '      <stop offset="0%" stop-color="${_colorToHex(theme.sandHighlight)}" stop-opacity="0.85" />',
    );
    buffer.writeln(
      '      <stop offset="50%" stop-color="${_colorToHex(theme.sandBase)}" stop-opacity="1.0" />',
    );
    buffer.writeln(
      '      <stop offset="100%" stop-color="${_colorToHex(theme.sandShadow)}" stop-opacity="0.4" />',
    );
    buffer.writeln('    </linearGradient>');
    buffer.writeln('  </defs>');

    // 1. Background Sand Surface
    buffer.writeln('  <rect width="100%" height="100%" fill="url(#sandGrad)" rx="24" />');

    // 2. Rake Groove Paths
    for (final stroke in strokes) {
      if (stroke.points.length < 2) continue;

      final pathData = _generatePathData(stroke, width, height);
      final shadowColor = _colorToHex(theme.sandShadow);
      final highlightColor = _colorToHex(theme.sandHighlight);

      // Shadow groove
      buffer.writeln(
        '  <path d="$pathData" fill="none" stroke="$shadowColor" stroke-opacity="0.75" '
        'stroke-width="${stroke.width}" stroke-linecap="round" stroke-linejoin="round" />',
      );

      // Highlight edge (-2px offset)
      buffer.writeln(
        '  <path d="$pathData" fill="none" stroke="$highlightColor" stroke-opacity="0.65" '
        'stroke-width="${stroke.width * 0.4}" stroke-linecap="round" stroke-linejoin="round" '
        'transform="translate(0, -2)" />',
      );
    }

    buffer.writeln('</svg>');
    return buffer.toString();
  }

  static String _generatePathData(RakeStroke stroke, double w, double h) {
    final sb = StringBuffer();
    final p0 = stroke.points[0];
    sb.write('M ${p0.dx * w} ${p0.dy * h} ');

    for (int i = 1; i < stroke.points.length; i++) {
      final p1 = stroke.points[i - 1];
      final p2 = stroke.points[i];
      final midX = (p1.dx + p2.dx) / 2.0 * w;
      final midY = (p1.dy + p2.dy) / 2.0 * h;
      sb.write('Q ${p1.dx * w} ${p1.dy * h}, $midX $midY ');
    }

    return sb.toString().trim();
  }

  static String _colorToHex(Color c) {
    return '#${c.value.toRadixString(16).substring(2).padLeft(6, '0')}';
  }
}

