import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controller/bookmark_controller.dart';
import '../../controller/news_controller.dart';
import '../../controller/search_controller.dart';
import '../theme/theme.dart';
import 'compact_news_card.dart';

class NewsSearchDelegate extends SearchDelegate {
  final newsController = Get.find<NewsController>();
  SearchQueryController searchController = Get.put(SearchQueryController());
  @override
  TextStyle get searchFieldStyle => const TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData base = Theme.of(context);
    return base.copyWith(
      appBarTheme:  AppBarTheme(
        backgroundColor:AppColors.primary.withOpacity(0.9),
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        hintStyle: const TextStyle(color: Colors.white70),
        border: InputBorder.none,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    searchController.searchNews(query);

    // return Obx(() {
    //   final results = searchController.filteredNewsList;
    //
    //   if (results.isEmpty) {
    //     return const Center(
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           Icon(Icons.search_off, size: 60, color: AppColors.iconPrimary),
    //           SizedBox(height: 12),
    //           Text('No news found', style: TextStyle(fontSize: 18,color: AppColors.textPrimary)),
    //         ],
    //       ),
    //     );
    //   }
    //
    //   return Scaffold(
    //     backgroundColor: AppColors.background,
    //     body: ListView.builder(
    //       padding: const EdgeInsets.all(10),
    //       itemCount: results.length,
    //       itemBuilder: (context, index) {
    //         final news = results[index];
    //         return NewsCardCompact(
    //           newsId: news.newsId,
    //           imageUrl: news.imageUrls.first,
    //           title: news.title,
    //           subHeading: news.subHeading ?? '',
    //           upvotes: news.likes ?? 0,
    //           shares: news.views ?? 0,
    //           isBookmarked: Get.find<BookmarkController>().isBookmarked(news.newsId),
    //         );
    //       },
    //     ),
    //   );
    // });
    return buildSuggestions(context);
  }


  @override
  Widget buildSuggestions(BuildContext context) {
    searchController.searchNews(query);
    final suggestions = searchController.filteredNewsList;

    if (query.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: const Padding(
          padding: EdgeInsets.all(20),
          child: Text('Try searching for something...', style: TextStyle(fontSize: 18,color: AppColors.textSecondary)),
        ),
      );
    }
    if (suggestions.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: const Padding(
          padding: EdgeInsets.all(20),
          child: Text('Try searching for something else...',style: TextStyle(fontSize: 18,color: AppColors.textSecondary)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final news = suggestions[index];
          return NewsCardCompact(
                        newsId: news.newsId,
                        imageUrl: news.imageUrls.first,
                        title: news.title,
                        subHeading: news.subHeading ?? '',
                        upvotes: news.likes ?? 0,
                        shares: news.views ?? 0,
                        isBookmarked: Get.find<BookmarkController>().isBookmarked(news.newsId),
                      );
        },
      ),
    );
  }
}
