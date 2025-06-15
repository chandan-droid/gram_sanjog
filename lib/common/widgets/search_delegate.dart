import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controller/bookmark_controller.dart';
import '../../controller/news_controller.dart';
import '../../controller/search_controller.dart';
import 'compact_news_card.dart';

class NewsSearchDelegate extends SearchDelegate {
  final newsController = Get.find<NewsController>();
  SearchQueryController searchController = Get.put(SearchQueryController());

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

    return Obx(() {
      final results = searchController.filteredNewsList;

      if (results.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 60, color: Colors.grey),
              SizedBox(height: 12),
              Text('No news found', style: TextStyle(fontSize: 18)),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: results.length,
        itemBuilder: (context, index) {
          final news = results[index];
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: NewsCardCompact(
              newsId: news.newsId,
              imageUrl: news.imageUrls.first,
              title: news.title,
              subHeading: news.subHeading ?? '',
              upvotes: news.likes ?? 0,
              shares: news.views ?? 0,
              isBookmarked: Get.find<BookmarkController>().isBookmarked(news.newsId),
            ),
          );
        },
      );
    });
  }


  @override
  Widget buildSuggestions(BuildContext context) {
    searchController.searchNews(query);
    final suggestions = searchController.filteredNewsList;

    if (query.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Text('Try searching for something...'),
      );
    }
    if (suggestions.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Text('Try searching for something else...'),
      );
    }

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final news = suggestions[index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.network(
              news.imageUrls.isNotEmpty ? news.imageUrls.first : '',
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
            ),
          ),
          title: Text(news.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text(news.subHeading ?? '', maxLines: 1, overflow: TextOverflow.ellipsis),
          onTap: () {
            query = news.title;
            showResults(context);
          },
        );
      },
    );
  }
}
