import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import '../models/rake_stroke.dart';
import 'cloud_service.dart';

/// Community item representing a publicly shared sand garden pattern.
class CommunityPatternItem {
  final String id;
  final String authorName;
  final String authorUid;
  final String theme;
  final List<RakeStroke> strokes;
  final String? base64Thumbnail;
  final int likes;
  final int reports;
  final DateTime createdAt;

  CommunityPatternItem({
    required this.id,
    required this.authorName,
    required this.authorUid,
    required this.theme,
    required this.strokes,
    this.base64Thumbnail,
    required this.likes,
    required this.reports,
    required this.createdAt,
  });

  factory CommunityPatternItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final rawStrokes = (data['strokes'] as List<dynamic>? ?? []);
    final strokes = rawStrokes
        .map((s) => RakeStroke.fromJson(s as Map<String, dynamic>))
        .toList();

    return CommunityPatternItem(
      id: doc.id,
      authorName: data['authorName'] as String? ?? 'Anonymous',
      authorUid: data['authorUid'] as String? ?? '',
      theme: data['theme'] as String? ?? 'warm',
      strokes: strokes,
      base64Thumbnail: data['thumbnail'] as String?,
      likes: (data['likes'] as num?)?.toInt() ?? 0,
      reports: (data['reports'] as num?)?.toInt() ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}

/// Service handling public community gallery feeds, uploads, likes, and content moderation reports.
class CommunityService {
  static FirebaseFirestore? get _firestore =>
      Firebase.apps.isNotEmpty ? FirebaseFirestore.instance : null;

  /// Fetches paginated community patterns excluding hidden or highly reported submissions.
  static Future<List<CommunityPatternItem>> fetchPatterns({
    DocumentSnapshot? startAfterDoc,
    int limit = 20,
  }) async {
    if (_firestore == null) return _generateMockCommunity();
    try {
      Query query = _firestore!
          .collection('community_patterns')
          .where('isHidden', isEqualTo: false)
          .where('reports', isLessThan: 3)
          .orderBy('reports')
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (startAfterDoc != null) {
        query = query.startAfterDocument(startAfterDoc);
      }

      final snapshot = await query.get();
      return snapshot.docs.map((doc) => CommunityPatternItem.fromFirestore(doc)).toList();
    } catch (_) {
      return _generateMockCommunity();
    }
  }

  /// Uploads current pattern to the public community.
  static Future<bool> uploadPattern({
    required List<RakeStroke> strokes,
    required String theme,
    required String authorName,
    required GlobalKey canvasKey,
  }) async {
    if (_firestore == null) return true; // Offline graceful success
    try {
      String? base64Thumb;
      final boundary = canvasKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary != null) {
        final img = await boundary.toImage(pixelRatio: 0.8);
        final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
        if (byteData != null) {
          base64Thumb = base64Encode(byteData.buffer.asUint8List());
        }
      }

      await _firestore!.collection('community_patterns').add({
        'authorName': authorName.trim().isEmpty ? 'Anonymous' : authorName.trim(),
        'authorUid': CloudService.currentUid ?? 'anonymous',
        'theme': theme,
        'strokes': strokes.map((s) => s.toJson()).toList(),
        'thumbnail': base64Thumb,
        'likes': 0,
        'reports': 0,
        'isHidden': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Increments like count on a public pattern.
  static Future<void> likePattern(String id) async {
    if (_firestore == null) return;
    try {
      await _firestore!.collection('community_patterns').doc(id).update({
        'likes': FieldValue.increment(1),
      });
    } catch (_) {}
  }

  /// Reports a pattern (auto-hides after 3 reports).
  static Future<void> reportPattern(String id, String reason) async {
    if (_firestore == null) return;
    try {
      final docRef = _firestore!.collection('community_patterns').doc(id);
      await docRef.update({
        'reports': FieldValue.increment(1),
      });

      final doc = await docRef.get();
      if ((doc.data()?['reports'] ?? 0) >= 3) {
        await docRef.update({'isHidden': true});
      }
    } catch (_) {}
  }

  static List<CommunityPatternItem> _generateMockCommunity() {
    return [
      CommunityPatternItem(
        id: 'mock_1',
        authorName: 'Yuki',
        authorUid: 'user_1',
        theme: 'sakura',
        strokes: [],
        likes: 18,
        reports: 0,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      CommunityPatternItem(
        id: 'mock_2',
        authorName: 'Soren',
        authorUid: 'user_2',
        theme: 'snow',
        strokes: [],
        likes: 27,
        reports: 0,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
    ];
  }
}

