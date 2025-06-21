import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:gram_sanjog/service/news_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../common/theme/theme.dart';
import '../model/news_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



class NewsController extends GetxController{
  final NewsService newsService = NewsService();

  var newsList = <News>[].obs;
  var currentNews = Rxn<News>();
  var isLoading = true.obs;
  RxString errorMessage = ''.obs;
  RxSet<String> likedNewsIds = <String>{}.obs;





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

      newsList.assignAll(newsData as Iterable<News>);
    }catch(e){
       errorMessage = 'Failed to load news' as RxString;
    }finally{
      isLoading.value = false;
    }
  }

  Future<void> getNewsById(String Id) async{
    try{
      isLoading.value = true;
      final news = await newsService.getNewsById(Id);
      currentNews.value = news;
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
          backgroundColor: AppColors.highlight, colorText: AppColors.buttonSecondary);
    }catch(e){
      Get.snackbar("Error", "Failed to post news",
          backgroundColor: AppColors.highlight, colorText: AppColors.buttonSecondary);
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