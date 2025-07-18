import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../model/news_model.dart';

class NewsService {
  final CollectionReference newsCollectionRef = FirebaseFirestore.instance.collection('news');
  late String generatedId ;

  // Get all news and convert to News model object list
  Future<List<News>> getAllNews() async {
    try {
      final snapshot = await newsCollectionRef.orderBy('timestamp', descending: true).get();

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

  Future<void> postNews(News news) async{
    try{
      final docRef = newsCollectionRef.doc(); // generate Firestore doc ref

      generatedId = docRef.id; //set the doc id into generatedId variable for access into controller
      final newsWithId = news.copyWith(newsId: generatedId); //create a news with newsId = GeneratedId
      await docRef.set(newsWithId.toJson()); //update the firebase doc with newsId=doc id

      if (kDebugMode) {
        print("✅ News posted successfully.");
      }
    }catch (e){
      if (kDebugMode) {
        print("❌ Error posting news: $e");
      }
    }
  }

  //delete news by id
  Future<void> deleteNews(String newsId) async {
    await newsCollectionRef.doc(newsId).delete();
  }

  //update news
  Future<void> updateNews(News news) async {
    await newsCollectionRef.doc(news.newsId).update(news.toJson());
  }

  // Get single news by ID
  Future<News?> getNewsById(String id) async {
    final doc = await newsCollectionRef.doc(id).get();

    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      data['newsId'] = doc.id;
      return News.fromJson(data);
    } else {
      return null;
    }
  }


  Future<void> incrementLikes(String newsId) async {
    await newsCollectionRef.doc(newsId).update({'likes': FieldValue.increment(1)});
  }

  Future<void> incrementViews(String newsId) async {
    await newsCollectionRef.doc(newsId).update({'views': FieldValue.increment(1)});
  }

  Future<void> incrementShares(String newsId) async {
    await newsCollectionRef.doc(newsId).update({'shares': FieldValue.increment(1)});
  }
}
