import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gram_sanjog/common/theme/theme.dart';
import 'package:gram_sanjog/common/widgets/my_contents_news_card.dart';
import 'package:gram_sanjog/controller/auth/auth_controller.dart';
import 'package:gram_sanjog/controller/auth/user_controller.dart';
import 'package:gram_sanjog/controller/news_controller.dart';
import 'package:gram_sanjog/controller/shorts_controller.dart';
import 'package:gram_sanjog/view/add_news_screen.dart';
import 'package:gram_sanjog/view/shorts_page.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../common/widgets/video_thumbnail.dart';
import '../add_shorts_page.dart';

class MyContentsPage extends StatefulWidget {
  const MyContentsPage({super.key});

  @override
  State<MyContentsPage> createState() => _MyContentsPageState();
}

class _MyContentsPageState extends State<MyContentsPage> with SingleTickerProviderStateMixin {
  final NewsController newsController = Get.find<NewsController>();
  final ShortsController shortsController = Get.put(ShortsController());
  final UserController userController = Get.find<UserController>();

  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    final currentUserId = userController.userData.value?.id;
    if (currentUserId != null && currentUserId.isNotEmpty) {
      userController.fetchUser(currentUserId).then((_) {
        final id = userController.userData.value?.id;
        if (id != null && id.isNotEmpty) {
          newsController.getMyNews(id);
          shortsController.getMyShorts(id); // 🔹 Fetch user's shorts
        }
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("My Uploaded Contents"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        // bottom: TabBar(
        //   controller: _tabController,
        //   tabs: const [
        //     Tab(icon: Icon(Icons.article), text: 'News'),
        //     Tab(icon: Icon(Icons.video_collection), text: 'Shorts'),
        //   ],
        // ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {


              // showModalBottomSheet(
              //   context: context,
              //   shape: const RoundedRectangleBorder(
              //     borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              //   ),
              //   builder: (BuildContext context) {
              //     return Padding(
              //       padding: const EdgeInsets.all(24),
              //       child: Column(
              //         mainAxisSize: MainAxisSize.min,
              //         children: [
              //           Text("What do you want to add?", style: Theme.of(context).textTheme.titleLarge),
              //           const SizedBox(height: 16),
              //           ElevatedButton.icon(
              //             onPressed: () {
              //               Navigator.pop(context); // Close sheet
              //               Get.to(() => const AddNewsPage());
              //             },
              //             icon: const Icon(Icons.article_outlined),
              //             label: const Text("Add News"),
              //             style: ElevatedButton.styleFrom(
              //               backgroundColor: AppColors.highlight,
              //               foregroundColor: Colors.white,
              //               minimumSize: const Size.fromHeight(48),
              //             ),
              //           ),
              //           const SizedBox(height: 10),
              //           ElevatedButton.icon(
              //             onPressed: () {
              //               Navigator.pop(context); // Close sheet
              //               Get.to(() => const AddReelPage()); // Create this screen
              //             },
              //             icon: const Icon(Icons.video_collection_outlined),
              //             label: const Text("Add Shorts"),
              //             style: ElevatedButton.styleFrom(
              //               backgroundColor: AppColors.accent,
              //               foregroundColor: Colors.white,
              //               minimumSize: const Size.fromHeight(48),
              //             ),
              //           ),
              //         ],
              //       ),
              //     );
              //   },
              // );
            },
            icon: const Icon(Icons.add_circle_outline_rounded, color: Colors.white),
            label: const Text("Add Content", style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonSecondary,
            ),
          ),
          const SizedBox(height: 10),
          _buildNewsTab(),
          // Expanded(
          //   child: TabBarView(
          //     controller: _tabController,
          //     children: [
          //       _buildNewsTab(),
          //       _buildShortsTab(),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  /// 🔹 Tab 1: News Content
  Widget _buildNewsTab() {
    return Obx(() {
      if (newsController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final myNewsList = newsController.myNewsList;
      if (myNewsList.isEmpty) {
        return const Center(child: Text("No News Found"));
      }

      return ListView.builder(
        itemCount: myNewsList.length,
        itemBuilder: (context, index) {
          final news = myNewsList[index];
          return MyContentsNewsCard(
            newsId: news.newsId,
            imageUrl: news.imageUrls.isNotEmpty
                ? news.imageUrls[0]
                : 'https://via.placeholder.com/150',
            title: news.title,
            subHeading: news.subHeading ?? '',
            upvotes: news.likes ?? 0,
            shares: news.shares ?? 0,
            status: news.status ?? 'pending',
            timestamp: news.timestamp,
            onEdit: () {
              Get.to(() => AddNewsPage(existingNews: news));
            },
            onDelete: () {
              newsController.deleteNews(news.newsId);
            },
          );
        },
      );
    });
  }

  /// 🔹 Tab 2: Shorts Content
  Widget _buildShortsTab() {
    return Obx(() {
      if (shortsController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final myShortsList = shortsController.myShortsList;
      if (myShortsList.isEmpty) {
        return const Center(child: Text("No Shorts Found"));
      }

      return GridView.builder(
        padding: const EdgeInsets.all(4),
        itemCount: myShortsList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          childAspectRatio: 9 / 16,
        ),
        itemBuilder: (context, index) {
          final short = myShortsList[index];
          final isYouTube = short.videoUrl.contains("youtube.com") || short.videoUrl.contains("youtu.be");
          final thumbnailUrl = isYouTube
              ? getYouTubeThumbnail(short.videoUrl)
              : null; // You can use `generateThumbnail` for local/cloud videos if needed

          return GestureDetector(
            onTap: () {
              Get.to(() => const ShortsPage());
            },
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: thumbnailUrl != null
                          ? NetworkImage(thumbnailUrl)
                          : const AssetImage('assets/illustrations/user.png') as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Center(
                  child: Icon(Icons.play_circle_fill, color: Colors.white70, size: 32),
                ),
              ],
            ),
          );
        },
      );
    });
  }
  String? getYouTubeThumbnail(String url) {
    final videoId = YoutubePlayer.convertUrlToId(url);
    if (videoId != null) {
      return 'https://img.youtube.com/vi/$videoId/0.jpg';
    }
    return null;
  }

}
