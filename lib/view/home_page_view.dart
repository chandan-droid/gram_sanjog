import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gram_sanjog/common/theme/theme.dart';
import 'package:gram_sanjog/controller/category_controller.dart';
import 'package:gram_sanjog/controller/news_controller.dart';
import 'package:gram_sanjog/controller/search_controller.dart';

import '../common/constants.dart';
import '../common/widgets/category_tile.dart';
import '../common/widgets/compact_news_card.dart';
import '../common/widgets/news_carousal.dart';
import '../common/widgets/search_bar.dart';
import '../controller/bookmark_controller.dart';
import '../model/news_model.dart';
import 'bookmark_view.dart';
import 'detailed_news_view.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CategoryController categoryController = Get.find();
  NewsController newsController = Get.find();
  BookmarkController bookmarkController = Get.find();
  SearchQueryController searchController = Get.put(SearchQueryController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.only(left: 10,top: 50),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Flex(
                direction: Axis.horizontal,
                children: [
                  const Flexible(
                    flex:6,
                    child:SearchBarWidget()
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    flex:1,
                    child: Container(//bookmark
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Colors.black12.withOpacity(0.1),
                          borderRadius:BorderRadius.circular(10)
                      ),
                      child: IconButton(
                          onPressed: () {
                            //route to saved news page
                            Get.to(()=>BookmarkScreen());
                          },
                          icon: const Icon(Icons.bookmark)
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    flex:1,
                    child: Container(//notification
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Colors.black12.withOpacity(0.1),
                          borderRadius:BorderRadius.circular(10)
                      ),
                      child: IconButton(
                          onPressed: () {
                            //route to notification page
                          },
                          icon: const Icon(Icons.notifications)
                      ),
                    ),
                  ),

                ],
              ),
              const SizedBox(height: 20,),
              Align(alignment:Alignment.topLeft,
                  child: Text("Top News",
                    style:  Theme.of(context).textTheme.headlineMedium,)
              ),
              const SizedBox(height: 20,),

              const TopNewsCarousel(),

              const SizedBox(height: 20),
              Align(alignment:Alignment.topLeft,
                  child: Text("Categories",
                    style:  Theme.of(context).textTheme.headlineMedium,)
              ),
            
            //category selector section
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {

                    final category = categories[index];
                    return Obx(() {

                      final isSelected = (category.categoryId == categoryController.selectedCategoryId.value);
                      //category.categoryId is the ID of current category.
                      // categoryController.selectedCategoryId.value holds currently selected category ID.
                      // You compare both — if match → this tile is selected.

                      return CategoryTile(
                        category: category,
                        isSelected: isSelected,
                        onTap: () {
                          categoryController.selectCategory(category.categoryId);
                          print("Selected category ID: ${category.categoryId}");
                        },
                      );
                    });
                  },
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                //height: 200,
                child: Obx((){
                  var selectedCategoryId = categoryController.selectedCategoryId.value;
                  final filteredNews = newsController.newsList.where((news) => news.categoryId == selectedCategoryId).take(5).toList();
                  if (newsController.isLoading.value) {
                    return const CircularProgressIndicator();
                  }
                  if (filteredNews.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("No news available for this category"),
                    );
                  }
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredNews.length,
                      itemBuilder: (context,index){
                        final newsItem = filteredNews[index];
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
                })
              ),


              const SizedBox(height: 20),
              Align(alignment:Alignment.topLeft,
                  child: Text("Editor's Picks",
                    style:  Theme.of(context).textTheme.headlineMedium,)
              ),
            ],
          ),
        ),
      ),
    );
  }
}



