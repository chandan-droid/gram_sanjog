import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../model/shorts_model.dart';

class ShortsService {
  final CollectionReference _shortsRef =
  FirebaseFirestore.instance.collection('shorts');

  /// Adds a new short video to Firestore
  Future<void> addShort(NewsShort short) async {
    try {
      await _shortsRef.add(short.toMap());
    } catch (e) {
      debugPrint('Error adding short: $e');
      rethrow;
    }
  }

  /// Fetches all shorts ordered by newest first
  Future<List<NewsShort>> fetchShorts() async {
    try {
      final snapshot = await _shortsRef
          .where('isVerified' , isEqualTo: true)
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return NewsShort.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      debugPrint('Error fetching shorts: $e');
      return [];
    }
  }

/// Like a short (commented for future use)
// Future<void> likeShort(String shortId, String userId) async {
//   await _shortsRef.doc(shortId).update({
//     'likes': FieldValue.arrayUnion([userId])
//   });
// }

/// Increment view count (commented for future use)
// Future<void> viewShort(String shortId) async {
//   await _shortsRef.doc(shortId).update({
//     'views': FieldValue.increment(1)
//   });
// }
}
