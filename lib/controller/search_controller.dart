
 import 'package:get/get.dart';
import 'package:gram_sanjog/controller/news_controller.dart';

import '../model/news_model.dart';

class SearchQueryController extends GetxController{
  final NewsController newsController = Get.put(NewsController());

  var searchQuery = ''.obs;
  var filteredNewsList = <News>[].obs;

  @override
  void onInit(){
    super.onInit();
    newsController.getAllNews();
  }

  void searchNews(String query){
    searchQuery.value = query;
    if(query.isEmpty){
      filteredNewsList.assignAll(newsController.newsList);
    }else{
      final lowerCaseQuery = query.toLowerCase();
      final results = newsController.newsList.where(
          (news){
            return (news.title.toLowerCase().contains(lowerCaseQuery))||
                (news.subHeading!.toLowerCase().contains(lowerCaseQuery))||
                (news.description.toLowerCase().contains(lowerCaseQuery)?? false);
          }
      ).toList();
      filteredNewsList.assignAll(results);

    }
  }
}