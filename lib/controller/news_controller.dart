import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gram_sanjog/service/news_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../common/theme/theme.dart';
import '../model/news_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user_model.dart';
import '../view/home_page_view.dart';



class NewsController extends GetxController{
  final NewsService newsService = NewsService();

  var newsList = <News>[].obs;
  var myNewsList = <News>[].obs;
  var currentNews = Rxn<News>();
  var isLoading = true.obs;
  RxString errorMessage = ''.obs;
  RxSet<String> likedNewsIds = <String>{}.obs;

  final Rxn<UserProfile> newsAuthor = Rxn<UserProfile>();  // Author of selected news






  @override
  void onInit() {
    super.onInit();
    getAllNews();
    loadLikedNews();
  }

  Future<void> getAllNews()async{
    try{
      isLoading.value = true;
      final newsData = await newsService.getAllNews();
      if (kDebugMode) {
        print('[News] Total news fetched: ${newsData.length}');
      }
      final verifiedNews = newsData.where((news) => news.status == 'verified').toList();
      if (kDebugMode) {
        print('[News] Total verified news : ${verifiedNews.length}');
      }
      newsList.assignAll(verifiedNews as Iterable<News>);
    }catch(e){
       errorMessage = 'Failed to load news' as RxString;
    }finally{
      isLoading.value = false;
    }
  }

  Future<void> getMyNews(String userId) async {
    try {
      isLoading.value = true;
      final newsData = await newsService.getAllNews();
      final myNews = newsData.where((news) => news.createdBy == userId).toList();
      myNewsList.assignAll(myNews);
    } catch (e) {
      errorMessage.value = "Failed to load your news";
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> getNewsById(String newsId) async{
    try{
      isLoading.value = true;
      final news = await newsService.getNewsById(newsId);
      currentNews.value = news;

      //preload the author name here before show news page
      final authorDoc = await FirebaseFirestore.instance.collection('user').doc(news?.createdBy).get();
      if (authorDoc.exists) {
        newsAuthor.value = UserProfile.fromJson(authorDoc.data()!);
      }
      isLoading.value = false;
    }catch(e){
      errorMessage = 'Failed to load the news.' as RxString;
      return;
    }finally{
      isLoading.value = false;
    }
  }

  Future<void> postNews(News news)async{
    try{
      isLoading.value = true;
      await newsService.postNews(news);
      Get.snackbar("Success", "News Submitted",
          backgroundColor: AppColors.success, colorText:Colors.white);
      Get.to(const HomePage());
    }catch(e){
      Get.snackbar("Error", "Failed to post news",
          backgroundColor: AppColors.error, colorText: Colors.white);
    }
  }

  Future<void> updateNews(News news) async {
    try {
      await newsService.updateNews(news);
      myNewsList.removeWhere((n) => n.newsId == news.newsId);
      myNewsList.add(news);
      //currentNews.value = news;
      Get.back();
    }catch(e){
      if (kDebugMode) {
        print("Error updating news: $e");
      }
    }
  }

  Future<void> shareCurrentNews()async{
    try{
      final response = await http.get(Uri.parse(currentNews.value!.imageUrls.first));
      final bytes = response.bodyBytes;

      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/news_image_${currentNews.value!.newsId}.jpg');
      await file.writeAsBytes(bytes);

      final text = '''
📰 *${currentNews.value!.title}*
   _${currentNews.value!.subHeading}_
   
   ${currentNews.value!.description}

    via GramSanjog
    ''';

      await SharePlus.instance.share(
        ShareParams(
          text: text,
          files: [XFile(file.path)],
        ),
      );
    }catch(e){

    }
  }

  Future<void> deleteNews(String newsId) async {
    try {
      await newsService.deleteNews(newsId);
      newsList.removeWhere((news)=>news.newsId == newsId);
      myNewsList.removeWhere((news)=>news.newsId == newsId);
    }catch(e){

    }
  }

  Future<void> loadLikedNews() async {
    final prefs = await SharedPreferences.getInstance();
    final likedIds = prefs.getStringList('likedNews') ?? [];
    likedNewsIds.value = likedIds.toSet();
  }

  Future<void> toggleLike(String newsId) async {
    if (kDebugMode) {
      print('toggleLike called for: $newsId');
    }
    final prefs = await SharedPreferences.getInstance();
    final docRef = FirebaseFirestore.instance.collection('news').doc(newsId);
    final wasLiked = likedNewsIds.contains(newsId);
    if (kDebugMode) {
      print('Was liked? $wasLiked');
    }

    // Update local UI first
    if (wasLiked) {
      likedNewsIds.remove(newsId);
      currentNews.update((n) { if (n != null) n.likes = (n.likes! - 1); });
    } else {
      likedNewsIds.add(newsId);
      currentNews.update((n) { if (n != null) n.likes = (n.likes! + 1); });
    }

    // Persist local
    await prefs.setStringList('likedNews', likedNewsIds.toList());
    if (kDebugMode) {
      print('Saved local liked: ${likedNewsIds.toList()}');
    }

    // Update Firestore
    try {
      await docRef.update({'likes': FieldValue.increment(wasLiked ? -1 : 1)});
      if (kDebugMode) {
        print('Firestore likes updated');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Firestore like error: $e');
      }
    }
  }



  bool hasUserLiked(String newsId) {
    return likedNewsIds.contains(newsId);
  }


  Future<void> incrementViews(String newsId) async {
    try {
      await newsService.incrementViews(newsId);
      currentNews.update((news) {
        if (news != null) news.views = (news.views ?? 0) + 1;
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error incrementing views: $e");
      }
    }
  }

  Future<void> incrementShares() async {
    try {
      await newsService.incrementShares(currentNews.value!.newsId);
      currentNews.update((news) {
        if (news != null) news.shares = (news.shares ?? 0) + 1;
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error incrementing shares: $e");
      }
    }
  }

}