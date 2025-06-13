import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/news_model.dart';

class NewsService {
  final CollectionReference localNewsCollection = FirebaseFirestore.instance.collection('news');

  // Get all news and convert to News model object list
  Future<List<News>> getAllNews() async {
    final snapshot = await localNewsCollection.get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['newsId'] = doc.id; // Attach doc ID
      return News.fromJson(data);
    }).toList();
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
