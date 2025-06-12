import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:gram_sanjog/common/theme/theme.dart';
import 'package:gram_sanjog/controller/category_controller.dart';

import '../common/SAMPLE_NEWS.dart';
import '../common/constants.dart';
import '../common/widgets/category_tile.dart';
import '../common/widgets/compact_news_card.dart';
import '../common/widgets/news_carousal.dart';
import '../common/widgets/search_bar.dart';
import '../controller/bookmark_controller.dart';
import '../model/news_model.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CategoryController categoryController = Get.put(CategoryController());
  final bookmarkController = Get.find<BookmarkController>();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Gram Sanjog",
      //     style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),
      //   ),
      //   centerTitle: true,
      // ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 10,vertical: 50),
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
                    child: Container(//location
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Colors.black12.withOpacity(0.1),
                          borderRadius:BorderRadius.circular(10)
                      ),
                      child: IconButton(
                          onPressed: () {
                            //route to saved news page
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
              TopNewsCarousel(),

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

              //listing news for category selected
              SizedBox(
                //height: 200,
                child: Obx((){
                  var selectedCategoryId = categoryController.selectedCategoryId.value;
                  final filteredNews = sampleNewsList.where((news) => news.categoryId == selectedCategoryId).take(5).toList();

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
              //  NewsCardCompact(
              //    newsId: ,
              //   imageUrl: 'https://source.unsplash.com/random/800x600?news',
              //   title: 'Local Festival Celebrations Begin',
              //   subHeading: 'People across the region are gathering to celebrate the annual event.',
              //   upvotes: 2,
              //   shares: 3,
              //   isBookmarked: true,
              // )

            ],
          ),
        ),
      ),
    );
  }
}


