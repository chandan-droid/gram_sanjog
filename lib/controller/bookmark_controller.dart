import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class BookmarkController extends GetxController {
  final storage = GetStorage();

  final RxList<String> bookmarks = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadBookmarks();
  }

  void loadBookmarks() {
    final rawBookmarks = storage.read('bookmarks');
    if (rawBookmarks != null) {
      bookmarks.assignAll(List<String>.from(rawBookmarks));
    }
  }

  void toggleBookmark(String newsId) {
    if (bookmarks.contains(newsId)) {
      bookmarks.remove(newsId);
    } else {
      bookmarks.add(newsId);
    }
    storage.write('bookmarks', bookmarks);
    print(storage.hasData('bookmarks'));
    print(storage.read('bookmarks'));
  }

  bool isBookmarked(String newsId) {
    return bookmarks.contains(newsId);
  }
}
