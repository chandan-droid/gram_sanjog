import 'package:get/get.dart';
import '../common/SAMPLE_NEWS.dart';
import '../model/news_model.dart';

class TopNewsController extends GetxController {
  final RxList<News> topNewsList = <News>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTopNews();
  }

  void fetchTopNews() async {
    topNewsList.assignAll(sampleNewsList.where((news) => news.views! > 1000).take(10).toList());
  }
}
