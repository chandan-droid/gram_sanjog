import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../model/news_model.dart';

class NewsService {
  final CollectionReference localNewsCollection = FirebaseFirestore.instance.collection('news');

  // Get all news and convert to News model object list
  Future<List<News>> getAllNews() async {
    try {
      final snapshot = await localNewsCollection.get();

      return snapshot.docs.map((doc) {
        try {
          final data = doc.data() as Map<String, dynamic>;
          data['newsId'] = doc.id;
          return News.fromJson(data);

        } catch (e) {
          if (kDebugMode) {
            print(' Failed to parse doc ${doc.id}: $e');
          }
          return null;
        }
      }).whereType<News>().toList();

    } catch (e, stack) {
      if (kDebugMode) {
        print('Firestore fetch error: $e');
      }
      return [];
    }
  }


  // Get single news by ID
  Future<News?> getNewsById(String id) async {
    final doc = await localNewsCollection.doc(id).get();

    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      data['newsId'] = doc.id;
      return News.fromJson(data);
    } else {
      return null;
    }
  }

  Future<void> incrementLikes(String newsId) async {
    await localNewsCollection.doc(newsId).update({'likes': FieldValue.increment(1)});
  }

  Future<void> incrementViews(String newsId) async {
    await localNewsCollection.doc(newsId).update({'views': FieldValue.increment(1)});
  }

  Future<void> incrementShares(String newsId) async {
    await localNewsCollection.doc(newsId).update({'shares': FieldValue.increment(1)});
  }
}
