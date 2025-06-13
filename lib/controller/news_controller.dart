import 'package:get/get.dart';
import 'package:gram_sanjog/service/news_service.dart';

import '../model/news_model.dart';

class NewsController extends GetxController{
  final NewsService newsService = NewsService();

  var newsList = <News>[].obs;
  var isLoading = true.obs;
  RxString errorMessage = ''.obs;

  Future<void> getAllNews()async{
    try{
      isLoading.value = true;
      final newsData = await newsService.getAllNews();
      newsList.assignAll(newsData as Iterable<News>);
    }catch(e){
       errorMessage = 'Failed to load news' as RxString;
    }finally{
      isLoading.value = false;
    }
  }

  Future<News?> getNewsById(String Id) async{
    try{
      isLoading.value = true;
      return await newsService.getNewsById(Id);
    }catch(e){
      errorMessage = 'Failed to load this news' as RxString;
      return null;
    }
  }
}