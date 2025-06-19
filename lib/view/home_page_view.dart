import 'dart:ui';

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
import '../controller/location_controller.dart';
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
  LocationController locationController = Get.put(LocationController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Drawer(
          backgroundColor: AppColors.primary.withOpacity(0.5),
          child: SafeArea(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // const UserAccountsDrawerHeader(
                //   decoration: BoxDecoration(color: Colors.transparent),
                //   accountName: Text(
                //     "John Dev",
                //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                //   ),
                //   accountEmail: Text("sandra_a88@gmail.com"),
                //   currentAccountPicture: CircleAvatar(
                //     backgroundImage: AssetImage("assets/logo/gram_sanjog_app_icon_trans.png"),
                //   ),
                //   arrowColor: Colors.white60,
                // ),
                ListTile(
                  leading:const Icon(Icons.home_rounded,color: Colors.white60),
                  title: const Text('Home',style: TextStyle(color: Colors.white60),),
                  onTap: () {
                    Get.offAll(const HomePage());
                  },
                ),
                ListTile(
                  leading:const Icon(Icons.bookmark,color: Colors.white60),
                  title: const Text('Saved News',style: TextStyle(color: Colors.white60),),
                  onTap: () {
                    Get.to(()=>BookmarkScreen());
                  },
                ),
                // ListTile(
                //   leading:const Icon(Icons.settings,color: Colors.white60),
                //   title: const Text('Settings',style: TextStyle(color: Colors.white60),),
                //   onTap: () {
                //
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: AppColors.primary.withOpacity(0.9),
        iconTheme: const IconThemeData(color: Colors.white60),
        toolbarHeight: 60,
        scrolledUnderElevation: 30,
        title: Container(
          margin: const EdgeInsets.all(0.8),
          child: Image.asset("assets/logo/logo_header.png",height: 30,),
        ),
        actions: const [
          SearchBarWidget(),
          SizedBox(width: 10),
        ],
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        minimum: const EdgeInsets.only(left: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Obx(() {
                if (locationController.error.isNotEmpty) {
                  return Center(child: Text(locationController.error.value));
                }

                final location = locationController.currentLocation.value;

                if (location == null) {
                  return const Text("Fetching Location...");
                }

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 18, color: AppColors.accent),
                          const SizedBox(width: 6),
                          Text(
                            "${locationController.currentArea.value}, "
                                "${locationController.currentCity.value}",
                            style: const TextStyle(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const SizedBox(width: 24), // align with above icon
                          Text(
                            "${locationController.currentState.value} - ${locationController.currentPincode.value}",
                            style: const TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  )

                );
              }),
              const SizedBox(height: 10),

              const Align(alignment:Alignment.topLeft,
                  child: Text("Top News",
                    style:  TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      fontSize: 28
                    )
                  )
              ),
              const SizedBox(height: 12,),
              const TopNewsCarousel(),
              const SizedBox(height: 12),
              const Align(alignment:Alignment.topLeft,
                  child: Text("Categories",
                    style:  TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        fontSize: 28
                    ))
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
                  // final isForYou = (selectedCategoryId == '0'); //used filter for 'for you' section
                  // final filteredNews = isForYou
                  //     ? bookmarkController.bookmarkedNewsList.toList()
                  //     :newsController.newsList.where((news) => news.categoryId == selectedCategoryId).take(5).toList();
                  final filteredNews =newsController.newsList.where((news) => news.categoryId == selectedCategoryId).toList();
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
                          imageUrl:  (newsItem.imageUrls.isNotEmpty)
                              ? newsItem.imageUrls[0]
                              : 'assets/logo/gram_sanjog_app_icon_trans.png',
                          title: newsItem.title,
                          subHeading: newsItem.title,
                          upvotes: newsItem.likes!,
                          shares: newsItem.shares!,
                          isBookmarked: bookmarkController.isBookmarked(newsItem.newsId),
                        );
                      }
                  );
                })
              ),


              // const SizedBox(height: 20),
              // Align(alignment:Alignment.topLeft,
              //     child: Text("Editor's Picks",
              //       style:  Theme.of(context).textTheme.headlineMedium,)
              // ),
            ],
          ),
        ),
      ),
    );
  }
}



