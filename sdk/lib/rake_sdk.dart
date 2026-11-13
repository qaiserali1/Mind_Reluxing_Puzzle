library rake_sdk;

export 'widgets/rake_embed.dart';

import 'package:flutter/material.dart';
import 'widgets/rake_embed.dart';

/// Public interface for the Rake Zen Garden Developer SDK.
class RakeSDK {
  static String? _apiKey;

  /// Initializes the Rake SDK with your developer API key.
  static Future<void> initialize({required String apiKey}) async {
    _apiKey = apiKey;
  }

  /// Embeds an interactive or read-only zen sand garden canvas.
  static Widget embedCanvas({
    Color sandColor = const Color(0xFFE8DCC8),
    Color grooveColor = const Color(0xFFD4C4A8),
    double strokeWidth = 16.0,
    bool readOnly = false,
    ValueChanged<int>? onStrokeCountChanged,
  }) {
    return RakeEmbedCanvas(
      sandColor: sandColor,
      grooveColor: grooveColor,
      strokeWidth: strokeWidth,
      readOnly: readOnly,
      onStrokeCountChanged: onStrokeCountChanged,
    );
  }
}

