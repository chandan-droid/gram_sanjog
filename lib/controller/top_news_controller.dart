import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../model/news_model.dart';
import '../service/news_service.dart';

class TopNewsController extends GetxController {
  final RxList<News> topNewsList = <News>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final NewsService newsService = NewsService();

  @override
  void onInit() {
    super.onInit();
    fetchTopNews();
  }

  Future<void> fetchTopNews() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final allNews = await newsService.getAllNews();
      if (kDebugMode) {
        print('[TopNews] Total news fetched: ${allNews.length}');
      }

      final topNews = allNews.where((news) => news.isFeatured == true  && news.status == 'verified').toList();

      topNewsList.assignAll(topNews);

    } catch (e) {
      errorMessage.value = 'Failed to fetch top news.';
    } finally {
      isLoading.value = false;
    }
  }
}

