import 'package:get/get.dart';
import 'package:gram_sanjog/service/news_service.dart';
import '../model/news_model.dart';

class NewsController extends GetxController{
  final NewsService newsService = NewsService();

  var newsList = <News>[].obs;
  var currentNews = Rxn<News>();
  var isLoading = true.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getAllNews();
  }
  Future<void> getAllNews()async{
    try{
      isLoading.value = true;
      final newsData = await newsService.getAllNews();
      print('[News] Total news fetched: ${newsData.length}');

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
}