
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../common/theme/theme.dart';
import '../common/widgets/compact_news_card.dart';
import '../controller/bookmark_controller.dart';
import '../controller/category_controller.dart';
import '../controller/news_controller.dart';

class BookmarkScreen extends StatelessWidget{
  CategoryController categoryController = Get.put(CategoryController());
  NewsController newsController = Get.put(NewsController());
  BookmarkController bookmarkController = Get.put(BookmarkController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Center(child: Text("Saved Contents")),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,

      ),
      body: Obx((){

        final bookmarkedNews = bookmarkController.bookmarkedNewsList.toList();
        if (newsController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (bookmarkedNews.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: Text("No Saved Content Available")),
          );
        }
        return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: bookmarkedNews.length,
            itemBuilder: (context,index){
              final newsItem = bookmarkedNews[index];
              return NewsCardCompact(
                newsId: newsItem.newsId,
                imageUrl: newsItem.imageUrls[0],
                title: newsItem.title,
                subHeading: newsItem.title,
                upvotes: newsItem.likes!,
                shares: newsItem.views!,
                isBookmarked: bookmarkController.isBookmarked(newsItem.newsId),
              );
            }
        );
      }),
    );
  }

}