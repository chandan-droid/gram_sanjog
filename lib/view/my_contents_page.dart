import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gram_sanjog/common/widgets/compact_news_card.dart';
import 'package:gram_sanjog/controller/auth/user_controller.dart';
import 'package:gram_sanjog/controller/news_controller.dart';
import 'package:gram_sanjog/view/add_news_screen.dart';

import '../common/theme/theme.dart';
import '../common/widgets/my_contents_news_card.dart';
import '../controller/auth/auth_controller.dart';

class MyContentsPage extends StatefulWidget {
  MyContentsPage({super.key});

  @override
  State<MyContentsPage> createState() => _MyContentsPageState();
}

class _MyContentsPageState extends State<MyContentsPage> {
  final NewsController newsController = Get.find<NewsController>();
  final UserController userController = Get.find<UserController>();


  @override
  void initState() {
    super.initState();

    final authController = Get.find<AuthController>();
    final currentUserId = userController.userData.value?.id;

    // Ensure user data is fetched
    userController.fetchUser(currentUserId!).then((_) {
      final name = userController.userData.value?.name;
      if (name != null && name.isNotEmpty) {
        newsController.getMyNews(name);
      }
    });
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("My Uploaded Contents"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () {
                Get.to(() => const AddNewsPage());
              },
              icon: const Icon(Icons.add_circle_outline_rounded, color: Colors.white),
              label: const Text(
                "Add Content",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonSecondary,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {

                if (newsController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                final myNewsList = newsController.myNewsList;

                for (var news in newsController.myNewsList) {
                  if (kDebugMode) {
                    print("News Title: ${news.title}, CreatedBy: ${news.createdBy}");
                  }
                }

                if (myNewsList.isEmpty) {
                  return const Center(child: Text("No Contents Found"));
                }

                return ListView.builder(
                  itemCount: myNewsList.length,
                  itemBuilder: (context, index) {
                    final news = myNewsList[index];
                    return MyContentsNewsCard(
                      newsId: news.newsId,
                      imageUrl:news.imageUrls[0],
                      title: news.title,
                      subHeading: news.subHeading ?? '',
                      upvotes: news.likes ?? 0,
                      shares: news.shares ?? 0,
                      status: news.status ?? 'pending',
                      timestamp: news.timestamp,
                      onEdit: (){
                        Get.to(AddNewsPage(existingNews: news,));
                      },
                      onDelete: (){
                        newsController.deleteNews(news.newsId);
                        //newsController.update();
                      }
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
