import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';
import '../models/rake_stroke.dart';
import 'storage_service.dart';

enum CloudSyncStatus {
  synced,
  syncing,
  offline,
}

/// Cloud synchronization service integrating Firebase Auth & Firestore with graceful offline degradation.
class CloudService {
  static final ValueNotifier<CloudSyncStatus> syncStatus =
      ValueNotifier(CloudSyncStatus.offline);

  static FirebaseAuth? _auth;
  static FirebaseFirestore? _firestore;
  static bool _isFirebaseReady = false;
  static Timer? _debounceSyncTimer;

  static String? get currentUid => _auth?.currentUser?.uid;
  static bool get isSignedIn => _auth?.currentUser != null;
  static bool get isAnonymous => _auth?.currentUser?.isAnonymous ?? true;
  static String? get userEmail => _auth?.currentUser?.email;

  /// Initializes Firebase and performs silent anonymous authentication if enabled.
  static Future<void> initialize() async {
    try {
      if (Firebase.apps.isNotEmpty) {
        _auth = FirebaseAuth.instance;
        _firestore = FirebaseFirestore.instance;
        _isFirebaseReady = true;

        // Enable offline persistence in Firestore
        _firestore?.settings = const Settings(persistenceEnabled: true);

        // Silent anonymous authentication
        if (_auth?.currentUser == null) {
          await _auth?.signInAnonymously();
        }

        syncStatus.value = CloudSyncStatus.synced;

        // Perform initial pull & merge
        await pullAndMerge();
      } else {
        syncStatus.value = CloudSyncStatus.offline;
      }
    } catch (e) {
      if (kDebugMode) debugPrint('CloudService init note: $e');
      syncStatus.value = CloudSyncStatus.offline;
    }
  }

  /// Pulls remote cloud data and merges with local storage.
  static Future<void> pullAndMerge() async {
    if (!_isFirebaseReady || currentUid == null) return;
    try {
      syncStatus.value = CloudSyncStatus.syncing;
      final doc = await _firestore?.collection('users').doc(currentUid).get();

      if (doc != null && doc.exists) {
        final data = doc.data();
        if (data != null) {
          // 1. Sync Settings
          final settings = data['settings'] as Map<String, dynamic>?;
          if (settings != null) {
            if (settings.containsKey('theme')) {
              await StorageService.setSelectedTheme(settings['theme'] as String);
            }
            if (settings.containsKey('ambientSound')) {
              await StorageService.setAmbientSound(settings['ambientSound'] as bool);
            }
            if (settings.containsKey('rakeSound')) {
              await StorageService.setRakeSound(settings['rakeSound'] as bool);
            }
            if (settings.containsKey('haptics')) {
              await StorageService.setHapticsEnabled(settings['haptics'] as bool);
            }
          }

          // 2. Sync Premium status
          final profile = data['profile'] as Map<String, dynamic>?;
          if (profile != null && profile['premium'] == true) {
            await StorageService.setPremiumUnlocked(true);
          }

          // 3. Merge Achievements
          final remoteAch = data['achievements'] as List<dynamic>?;
          if (remoteAch != null) {
            final prefs = await SharedPreferences.getInstance();
            for (final id in remoteAch) {
              await prefs.setBool('achievement_$id', true);
            }
          }
        }
      }
      syncStatus.value = CloudSyncStatus.synced;
    } catch (_) {
      syncStatus.value = CloudSyncStatus.offline;
    }
  }

  /// Schedules a debounced push to the cloud (5s after last user change).
  static void scheduleCloudPush(List<RakeStroke> strokes) {
    if (!_isFirebaseReady || currentUid == null) return;
    _debounceSyncTimer?.cancel();
    _debounceSyncTimer = Timer(const Duration(seconds: 5), () {
      pushLocalData(strokes);
    });
  }

  /// Pushes local settings, profile, and strokes to the Firestore user document.
  static Future<void> pushLocalData(List<RakeStroke> strokes) async {
    if (!_isFirebaseReady || currentUid == null) return;
    try {
      syncStatus.value = CloudSyncStatus.syncing;

      final prefs = await SharedPreferences.getInstance();
      final userDoc = _firestore?.collection('users').doc(currentUid);

      await userDoc?.set({
        'profile': {
          'lastActive': FieldValue.serverTimestamp(),
          'premium': StorageService.getPremiumUnlocked(),
        },
        'settings': {
          'theme': StorageService.getSelectedTheme(),
          'ambientSound': StorageService.getAmbientSound(),
          'rakeSound': StorageService.getRakeSound(),
          'haptics': StorageService.getHapticsEnabled(),
          'signature': StorageService.getSignature(),
        },
        'strokes': {
          'data': strokes.map((s) => s.toJson()).toList(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        'stats': {
          'totalStrokes': prefs.getInt(AppConstants.keyTotalStrokesCount) ?? 0,
          'openCount': prefs.getInt(AppConstants.keyAppOpenCount) ?? 1,
        },
      }, SetOptions(merge: true));

      syncStatus.value = CloudSyncStatus.synced;
    } catch (_) {
      syncStatus.value = CloudSyncStatus.offline;
    }
  }

  /// Upgrades an anonymous user account with Email & Password.
  static Future<bool> linkWithEmailPassword(String email, String password) async {
    if (_auth?.currentUser == null) return false;
    try {
      final credential = EmailAuthProvider.credential(email: email, password: password);
      await _auth?.currentUser?.linkWithCredential(credential);
      await pullAndMerge();
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Signs in to an existing email account.
  static Future<bool> signInWithEmailPassword(String email, String password) async {
    if (_auth == null) return false;
    try {
      await _auth?.signInWithEmailAndPassword(email: email, password: password);
      await pullAndMerge();
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Signs out of account and resets to anonymous.
  static Future<void> signOut() async {
    try {
      await _auth?.signOut();
      await _auth?.signInAnonymously();
    } catch (_) {}
  }

  /// GDPR account deletion: completely purges user data from Firestore and Auth.
  static Future<bool> deleteAccount() async {
    if (_auth?.currentUser == null) return false;
    try {
      if (currentUid != null) {
        await _firestore?.collection('users').doc(currentUid).delete();
      }
      await _auth?.currentUser?.delete();
      await signOut();
      return true;
    } catch (_) {
      return false;
    }
  }
}

