import 'package:cloud_firestore/cloud_firestore.dart';
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
          print(' Failed to parse doc ${doc.id}: $e');
          return null;
        }
      }).whereType<News>().toList();

    } catch (e, stack) {
      print('Firestore fetch error: $e');
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
}
