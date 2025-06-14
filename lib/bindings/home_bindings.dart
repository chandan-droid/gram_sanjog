import 'package:get/get.dart';
import 'package:gram_sanjog/controller/bookmark_controller.dart';
import 'package:gram_sanjog/controller/category_controller.dart';
import '../controller/news_controller.dart';
import '../controller/top_news_controller.dart';

class HomeBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewsController>(() => NewsController());
    Get.lazyPut<CategoryController>(() => CategoryController());
    Get.lazyPut<BookmarkController>(() => BookmarkController());
  }
}
