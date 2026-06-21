import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Call this right after the user signs up or signs in for the first time
  Future<void> createUserProfileIfNotExists(User user) async {
    final doc = _db.collection('users').doc(user.uid);
    final snapshot = await doc.get();

    if (!snapshot.exists) {
      await doc.set({
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName ?? user.email?.split('@')[0] ?? 'Angler',
        'xp': 0,
        'fishCount': 0,
        'friends': [],
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // Get a user's profile as a single future
  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.data();
  }

  // Stream a user's profile — auto-updates the UI when data changes
  Stream<Map<String, dynamic>?> streamUserProfile(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((snap) => snap.data());
  }

  // Add XP and increment fish count when a fish is logged
  Future<void> recordFishCaught(String uid, {int xpEarned = 10}) async {
    await _db.collection('users').doc(uid).update({
      'xp': FieldValue.increment(xpEarned),
      'fishCount': FieldValue.increment(1),
    });
  }
}