import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';

/// Metadata associated with a saved sand garden pattern.
class SavedPatternItem {
  final String id; // timestamp string
  final String imagePath;
  final String jsonPath;
  final String theme;
  final String signature;
  final DateTime createdAt;

  SavedPatternItem({
    required this.id,
    required this.imagePath,
    required this.jsonPath,
    required this.theme,
    required this.signature,
    required this.createdAt,
  });
}

/// Service handling local persistence, reading, and deletion of gallery items.
class GalleryService {
  static const int freeSaveLimit = 5;

  /// Retrieves the dedicated /gallery directory in application documents.
  static Future<Directory> _getGalleryDir() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final galleryDir = Directory('${docsDir.path}/gallery');
    if (!await galleryDir.exists()) {
      await galleryDir.create(recursive: true);
    }
    return galleryDir;
  }

  /// Checks if free tier user has reached the 5-pattern limit.
  static Future<bool> isFreeLimitReached() async {
    final prefs = await SharedPreferences.getInstance();
    final isPremium = prefs.getBool(AppConstants.keyPremiumUnlocked) ?? false;
    if (isPremium) return false;

    final items = await loadSavedPatterns();
    return items.length >= freeSaveLimit;
  }

  /// Captures the sand canvas as a high-resolution PNG and stores image + metadata.
  static Future<SavedPatternItem?> saveCanvasPattern({
    required GlobalKey canvasKey,
    required String theme,
    required String signature,
  }) async {
    try {
      final boundary = canvasKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return null;

      final pngBytes = byteData.buffer.asUint8List();
      final galleryDir = await _getGalleryDir();
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final imagePath = '${galleryDir.path}/$id.png';
      final jsonPath = '${galleryDir.path}/$id.json';

      // Save PNG file
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(pngBytes);

      // Save metadata JSON
      final meta = {
        'id': id,
        'theme': theme,
        'signature': signature,
        'createdAt': DateTime.now().toIso8601String(),
      };
      final jsonFile = File(jsonPath);
      await jsonFile.writeAsString(jsonEncode(meta));

      // Update SharedPreferences list
      final prefs = await SharedPreferences.getInstance();
      final currentList = prefs.getStringList(AppConstants.keySavedPatterns) ?? [];
      currentList.insert(0, id);
      await prefs.setStringList(AppConstants.keySavedPatterns, currentList);

      return SavedPatternItem(
        id: id,
        imagePath: imagePath,
        jsonPath: jsonPath,
        theme: theme,
        signature: signature,
        createdAt: DateTime.now(),
      );
    } catch (_) {
      return null;
    }
  }

  /// Loads all saved patterns sorted by creation time descending.
  static Future<List<SavedPatternItem>> loadSavedPatterns() async {
    try {
      final galleryDir = await _getGalleryDir();
      final files = galleryDir.listSync();
      final List<SavedPatternItem> items = [];

      for (final file in files) {
        if (file is File && file.path.endsWith('.json')) {
          try {
            final raw = await file.readAsString();
            final Map<String, dynamic> data = jsonDecode(raw);
            final id = data['id'] as String;
            final imagePath = '${galleryDir.path}/$id.png';

            if (File(imagePath).existsSync()) {
              items.add(SavedPatternItem(
                id: id,
                imagePath: imagePath,
                jsonPath: file.path,
                theme: data['theme'] as String? ?? 'warm',
                signature: data['signature'] as String? ?? '',
                createdAt: DateTime.tryParse(data['createdAt'] as String? ?? '') ?? DateTime.now(),
              ));
            }
          } catch (_) {}
        }
      }

      items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return items;
    } catch (_) {
      return [];
    }
  }

  /// Deletes a saved pattern item and its files.
  static Future<void> deletePattern(SavedPatternItem item) async {
    try {
      final imgFile = File(item.imagePath);
      if (await imgFile.exists()) await imgFile.delete();

      final jsonFile = File(item.jsonPath);
      if (await jsonFile.exists()) await jsonFile.delete();

      final prefs = await SharedPreferences.getInstance();
      final currentList = prefs.getStringList(AppConstants.keySavedPatterns) ?? [];
      currentList.remove(item.id);
      await prefs.setStringList(AppConstants.keySavedPatterns, currentList);
    } catch (_) {}
  }

  /// Deletes multiple patterns (bulk delete).
  static Future<void> deleteMultiple(List<SavedPatternItem> items) async {
    for (final item in items) {
      await deletePattern(item);
    }
  }
}

