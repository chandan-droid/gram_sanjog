import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gram_sanjog/common/theme/theme.dart';
import 'package:gram_sanjog/controller/bookmark_controller.dart';
import 'package:gram_sanjog/controller/category_controller.dart';
import 'package:gram_sanjog/controller/news_controller.dart';
import 'package:intl/intl.dart';


class NewsDetailScreen extends StatefulWidget {
  final String newsId;
  const NewsDetailScreen({super.key, required this.newsId});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  final BookmarkController bookmarkController = Get.find();
  final CategoryController categoryController = Get.find();
  final NewsController newsController = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      newsController.getNewsById(widget.newsId);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Detail'),
        actions: [
          IconButton(icon: const Icon(Icons.share), onPressed: () {}),
          Obx(() => IconButton(
            onPressed: () {
              bookmarkController.toggleBookmark(widget.newsId);
            },
            icon: Icon(
              bookmarkController.isBookmarked(widget.newsId)
                  ? Icons.bookmark_added_rounded
                  : Icons.bookmark_border_rounded,
              size: 22,
              color: appTheme.iconTheme.color,
            ),
          )),
        ],
      ),
      body: Obx(() {
        final news = newsController.currentNews.value;

        if (newsController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (news == null) {
          return Center(child: Text(newsController.errorMessage.value));
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Image
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  news.imageUrls.isNotEmpty ? news.imageUrls[0] : '',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                  const Center(child: Icon(Icons.broken_image)),
                ),
              ),
              const SizedBox(height: 12),

              // Category + Date
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Chip(
                      label: Text(categoryController.getCategoryName(news.categoryId ?? '')),
                      backgroundColor: Colors.grey.shade400,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat.yMd().add_jm().format(news.timestamp ?? DateTime.now()),
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  news.title,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),

              // Author
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage: NetworkImage('https://randomuser.me/api/portraits/men/32.jpg'),
                      radius: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(news.createdBy ?? 'Admin'),
                    const Spacer(),
                    Text('4 min read', style: TextStyle(color: Colors.grey.shade600)),
                  ],
                ),
              ),

              const Divider(height: 24),

              // Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  news.description,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ),

              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Icon(Icons.favorite_border, color: Colors.red),
                    const SizedBox(width: 4),
                    Text('${news.likes ?? 0} Likes'),
                    const SizedBox(width: 16),
                    const Icon(Icons.remove_red_eye, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text('${news.views ?? 0} Views'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }
}
