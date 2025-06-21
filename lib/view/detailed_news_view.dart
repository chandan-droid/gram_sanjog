import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gram_sanjog/common/theme/theme.dart';
import 'package:gram_sanjog/controller/bookmark_controller.dart';
import 'package:gram_sanjog/controller/category_controller.dart';
import 'package:gram_sanjog/controller/news_controller.dart';
import 'package:gram_sanjog/view/home_page_view.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../common/widgets/youtube_player_widget.dart';
import '../controller/location_controller.dart';





class NewsDetailScreen extends StatefulWidget {
  final String newsId;
  const NewsDetailScreen({super.key, required this.newsId});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  final BookmarkController bookmarkController = Get.put(BookmarkController());
  final CategoryController categoryController = Get.put(CategoryController());
  final NewsController newsController = Get.put(NewsController());
  final LocationController locationController = Get.put(LocationController());

  final PageController _pageController = PageController(viewportFraction: 1, keepPage: true);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      newsController.getNewsById(widget.newsId);
      locationController.geohashFromLocationData(newsController.currentNews.value?.locationDetails);
    });

    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (page != _currentPage) {
        setState(() {
          _currentPage = page;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary.withOpacity(0.9),
        title: Image.asset("assets/logo/logo_header.png",height: 30,),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded,size: 22,),
            color: Colors.white60,
            onPressed: () {
               Get.back();
               Get.find<NewsController>().getAllNews();
            }
        ),
        actions: [
          IconButton(
              icon: const Icon(
                  Icons.share,
                  size: 22,
              ),
              color: Colors.white60,
              onPressed: () {
                newsController.shareCurrentNews();
                newsController.incrementShares();
              }
          ),
          Obx(() => IconButton(
            onPressed: () {
              bookmarkController.toggleBookmark(widget.newsId);
            },
            icon: Icon(
              bookmarkController.isBookmarked(widget.newsId)
                  ? Icons.bookmark_added_rounded
                  : Icons.bookmark_border_rounded,
              size: 22,
              color:Colors.white60,
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
              SizedBox(
                height: 250,
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      itemCount: news.imageUrls.length + news.videoUrls.length,
                      itemBuilder: (context, index) {
                        if (index < news.imageUrls.length) {
                          final imageUrl = news.imageUrls[index];
                          return Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image)),
                          );
                        } else {
                          final videoUrl = news.videoUrls[index - news.imageUrls.length];
                          return AspectRatio(
                              aspectRatio: 16/9,
                              child: SimpleYoutubePlayer(videoUrl: videoUrl));
                        }
                      },
                    ),
                    // Left arrow
                    Align(
                      alignment: Alignment.centerLeft,
                      // left: 0,
                      // top: 20,
                      // bottom: 0,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.white70),
                        onPressed: () {
                          if (_currentPage > 0) {
                            _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                          }
                        },
                      ),
                    ),
                    // Right arrow
                    Align(
                      alignment: Alignment.centerRight,
                      // right: 0,
                      // top: 0,
                      // bottom: 0,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, color: Colors.white70),
                        onPressed: () {
                          if (_currentPage < news.imageUrls.length + news.videoUrls.length - 1) {
                            _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),


              const SizedBox(height: 12),

              // Category + Date
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Chip(
                      label: Text(categoryController.getCategoryName(news.categoryId ?? ''),style: const TextStyle(color: AppColors.primary),),
                      backgroundColor: AppColors.secondary.withAlpha(100),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat.yMd().add_jm().format(news.timestamp ?? DateTime.now()),
                      style: const TextStyle(color:AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              if (news.locationDetails != null)
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.redAccent),
                      const SizedBox(width: 4),
                      Text(
                        "${news.locationDetails?.block}, ${news.locationDetails?.district}, ${news.locationDetails?.state}",
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )
              else
                const Padding(
                  padding: EdgeInsets.only(left: 16, top: 4),
                  child: Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.redAccent),
                      SizedBox(width: 4),
                      Text(
                        "Location not available",
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 14,
                        ),
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
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                color: AppColors.accent.withOpacity(0.1),
                child: Text(
                  news.subHeading!,
                  style: const TextStyle(
                      fontSize: 18,
                      color: AppColors.textSecondary,
                      fontStyle:FontStyle.italic

                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Author
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage("assets/logo/gram_sanjog_app_icon.png"),
                      radius: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(news.createdBy ?? 'Admin'),
                    const Spacer(),
                    Text(calculateReadingTime(news.description), style: TextStyle(color: Colors.grey.shade600)),
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
                child: Obx(() {
                  final news = newsController.currentNews.value;
                  final isLiked = newsController.hasUserLiked(news!.newsId);

                  return Row(
                    children: [
                      GestureDetector(
                        onTap: () => newsController.toggleLike(news.newsId),
                        child: Row(
                          children: [
                            Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: isLiked ? Colors.red : Colors.grey,
                            ),
                            const SizedBox(width: 6),
                            Text('${news.likes ?? 0} Likes'),
                          ],
                        ),
                      ),
                      // const SizedBox(width: 20),
                      // const Icon(Icons.remove_red_eye, color: Colors.grey),
                      // const SizedBox(width: 6),
                      // Text('${news.views ?? 0} Views'),
                    ],
                  );
                })
              ),

              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }
}




String calculateReadingTime(String text) {
  const wordsPerMinute = 200;
  final wordCount = text.trim().split(RegExp(r'\s+')).length;
  final minutes = (wordCount / wordsPerMinute).ceil();
  return '$minutes min read';
}
