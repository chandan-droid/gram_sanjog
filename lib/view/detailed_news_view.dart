import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gram_sanjog/common/SAMPLE_NEWS.dart';
import 'package:gram_sanjog/common/theme/theme.dart';
import 'package:gram_sanjog/controller/bookmark_controller.dart';
import 'package:gram_sanjog/controller/category_controller.dart';
import 'package:intl/intl.dart';

import '../common/constants.dart';
import '../model/news_model.dart';

class NewsDetailScreen extends StatefulWidget {
  final String newsId;
  const NewsDetailScreen({super.key, required this.newsId});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  final BookmarkController bookmarkController = Get.put(BookmarkController());
  final CategoryController categoryController = Get.put(CategoryController());
  News? selectedNews;

  void fetchNews(){
    final News news = sampleNewsList.firstWhere(
        (news)=>news.newsId == widget.newsId
    );
    setState(() {
      selectedNews = news;
    });
  }
  @override
  void initState() {
    super.initState();
    fetchNews();
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
            icon:Icon(
              bookmarkController.isBookmarked(widget.newsId)
                  ? Icons.bookmark_added_rounded
                  : Icons.bookmark_border_rounded,
              size: 22,
              color: appTheme.iconTheme.color,
            ),
          )
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Header Image
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                selectedNews!.imageUrls[0],
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 12),

            // Category + Date
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Chip(
                    label:  Text(categoryController.getCategoryName(selectedNews!.categoryId ?? '')),
                    backgroundColor: Colors.grey.shade400,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat.yMd().add_jm().format(selectedNews!.timestamp ?? DateTime.now()),
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // News Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                selectedNews!.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Author Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: NetworkImage('https://randomuser.me/api/portraits/men/32.jpg'),
                    radius: 16,
                  ),
                  const SizedBox(width: 8),
                   Text(selectedNews!.createdBy??'Admin'),
                  const Spacer(),
                  Text('4 min read', style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
            ),

            const Divider(height: 24),

            // News Content
             Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedNews!.description,
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

    );
  }
}
