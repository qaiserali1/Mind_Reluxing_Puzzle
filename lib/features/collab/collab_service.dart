import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../core/feature_flags.dart';
import '../../models/rake_stroke.dart';
import '../../services/cloud_service.dart';

/// Service managing real-time peer-to-peer collaborative zen garden sessions.
/// Guarded by FeatureFlags.enableCollaboration.
class CollabService {
  static FirebaseFirestore? get _firestore =>
      Firebase.apps.isNotEmpty ? FirebaseFirestore.instance : null;

  /// Creates a new collaborative drawing room session.
  static Future<String> createSession({required String authorName}) async {
    // Guarded: Disabled for initial launch
    if (!FeatureFlags.enableCollaboration) return '';

    final sessionId = DateTime.now().millisecondsSinceEpoch.toString().substring(7);
    if (_firestore == null) return sessionId;

    try {
      await _firestore!.collection('collab_sessions').doc(sessionId).set({
        'sessionId': sessionId,
        'hostUid': CloudService.currentUid ?? 'anonymous',
        'hostName': authorName,
        'guestName': null,
        'createdAt': FieldValue.serverTimestamp(),
        'expiresAt': DateTime.now().add(const Duration(minutes: 30)).toIso8601String(),
        'strokes': [],
      });
    } catch (_) {}
    return sessionId;
  }

  /// Subscribes to real-time incoming strokes from the session.
  static Stream<List<RakeStroke>> subscribeStrokes(String sessionId) {
    // Guarded: Disabled for initial launch
    if (!FeatureFlags.enableCollaboration) return const Stream.empty();
    if (_firestore == null) return const Stream.empty();

    return _firestore!
        .collection('collab_sessions')
        .doc(sessionId)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) return [];
      final data = snapshot.data()!;
      final rawList = data['strokes'] as List<dynamic>? ?? [];
      return rawList
          .map((item) => RakeStroke.fromJson(item as Map<String, dynamic>))
          .toList();
    });
  }

  /// Publishes a completed stroke to the shared session document.
  static Future<void> publishStroke(String sessionId, RakeStroke stroke) async {
    // Guarded: Disabled for initial launch
    if (!FeatureFlags.enableCollaboration) return;
    if (_firestore == null) return;

    try {
      await _firestore!.collection('collab_sessions').doc(sessionId).update({
        'strokes': FieldValue.arrayUnion([stroke.toJson()]),
      });
    } catch (_) {}
  }
}
