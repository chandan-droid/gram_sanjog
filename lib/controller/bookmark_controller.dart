import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gram_sanjog/controller/news_controller.dart';

import '../model/news_model.dart';

class BookmarkController extends GetxController {
  final storage = GetStorage();
  late final NewsController newsController = Get.put(NewsController());
  final RxList<String> bookmarkedNewsIds = <String>[].obs;
  final RxList<News> bookmarkedNewsList = <News>[].obs;


  @override
  void onInit() {
    super.onInit();
    loadBookmarksId();
    loadBookmarkedNews();
  }

  void loadBookmarksId() {
    final rawBookmarks = storage.read('bookmarks');
    if (rawBookmarks != null) {
      bookmarkedNewsIds.assignAll(List<String>.from(rawBookmarks));
    }
  }

  Future<void> loadBookmarkedNews() async {
    loadBookmarksId();
    for (String id in bookmarkedNewsIds) {
      await newsController.getNewsById(id);
      final news = newsController.currentNews.value;
      if (news != null) {
        bookmarkedNewsList.add(news);
      }
    }
  }

  void toggleBookmark(String newsId) async {
    if (bookmarkedNewsIds.contains(newsId)) {
      bookmarkedNewsIds.remove(newsId); //Remove its ID from bookmarks.

      //Remove the actual News object from bookmarkedNewsList.
      bookmarkedNewsList.removeWhere((news) => news.newsId == newsId);

    } else {
      bookmarkedNewsIds.add(newsId);//Add the news ID to the bookmarks list.

      // Try to get the news from the existing newsList (avoid triggering currentNews updates)
      final existingNews = newsController.newsList.firstWhereOrNull((news) => news.newsId == newsId);

      if (existingNews != null) {
        bookmarkedNewsList.add(existingNews);
      } else {
        // If not found in list, fetch from backend, but avoid touching currentNews
        final fetchedNews = await newsController.newsService.getNewsById(newsId);
        if (fetchedNews != null) {
          bookmarkedNewsList.add(fetchedNews);
        }
      }
    }

    storage.write('bookmarks', bookmarkedNewsIds);
  }


  bool isBookmarked(String newsId) {
    return bookmarkedNewsIds.contains(newsId);
  }
}
