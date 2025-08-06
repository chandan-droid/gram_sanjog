import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../common/theme/theme.dart';
import '../controller/auth/user_controller.dart';
import '../controller/category_controller.dart';
import '../controller/shorts_controller.dart';
import '../controller/upload_cloudinary/video_upload_controller.dart';
import '../model/shorts_model.dart';

class AddReelPage extends StatefulWidget {
  const AddReelPage({super.key});

  @override
  State<AddReelPage> createState() => _AddReelPageState();
}

class _AddReelPageState extends State<AddReelPage> {
  final captionController = TextEditingController();
  final youtubeUrlController = TextEditingController();
  final tagsController = TextEditingController();


  final ShortsController shortsController = Get.put(ShortsController());
  final VideoUploadController videoUploadController = Get.put(VideoUploadController());
  final CategoryController categoryController = Get.put(CategoryController());
  final userController = Get.find<UserController>();

  @override
  void dispose() {
    captionController.dispose();
    youtubeUrlController.dispose();
    videoUploadController.dispose();
    tagsController.dispose();
    super.dispose();
  }

  void submitReel() async {
    final caption = captionController.text.trim();
    final ytUrl = youtubeUrlController.text.trim();

    final videoUrl = ytUrl.isNotEmpty
        ? ytUrl
        : (videoUploadController.uploadedVideoUrls.isNotEmpty
        ? videoUploadController.uploadedVideoUrls.last
        : null);

    if (caption.isEmpty || videoUrl == null) {
      Get.snackbar(
        "Missing Info",
        "Please provide a caption and a video (YouTube link or upload)",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    final tagsText = tagsController.text.trim();
    final tags = tagsText.isNotEmpty
        ? tagsText
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .cast<String>()
        .toList()
        : <String>[];



    final currentUserId = userController.userData.value?.id ?? "unknown";
    final selectedCategoryId = categoryController.selectedCategoryId.value;

    final short = NewsShort(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      videoUrl: videoUrl,
      caption: caption,
      categoryId: selectedCategoryId,
      createdBy: currentUserId,
      timestamp: DateTime.now(),
      tags: tags ,
      isVerified: false
    );

    await shortsController.uploadShort(short);

    Get.snackbar(
      "Success",
      "Reel uploaded successfully",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    captionController.clear();
    youtubeUrlController.clear();
    videoUploadController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Shorts"),
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            //caption
            const Text("Caption *"),
            TextField(
              controller: captionController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "What's happening in this?",
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            //tags
            const Text("Hashtags (comma-separated)"),
            TextField(
              controller: tagsController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "e.g. festival,local,breaking",
              ),
            ),
            const SizedBox(height: 24),

            //category
            const Text("Select Category"),
            Obx(() {
              if (categoryController.isLoading.value) {
                return const CircularProgressIndicator();
              }

              return DropdownButtonFormField<String>(
                value: categoryController.selectedCategoryId.value,
                items: categoryController.categories
                    .map((category) => DropdownMenuItem<String>(
                  value: category.categoryId,
                  child: Text(category.name),
                ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    categoryController.selectCategory(value);
                  }
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Select category",
                ),
              );
            }),
            const SizedBox(height: 24),

            const Text("Add via YouTube link"),
            TextField(
              controller: youtubeUrlController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Paste YouTube video URL",
              ),
            ),
            const SizedBox(height: 12),

            const Divider(height: 40),

            const Text("OR Upload Video"),
            Obx(() {
              final isUploading = videoUploadController.isUploading.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (videoUploadController.pickedVideoFile.value != null)
                    Text("Picked file: ${videoUploadController.pickedVideoFile.value!.path.split('/').last}"),
                  ElevatedButton.icon(
                    onPressed: videoUploadController.pickVideo,
                    icon: const Icon(Icons.video_call),
                    label: const Text("Pick Video"),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: isUploading
                        ? null
                        : () async {
                      await videoUploadController.uploadCurrentVideo();
                    },
                    icon: const Icon(Icons.cloud_upload),
                    label: Text(isUploading ? "Uploading..." : "Upload to Cloudinary"),
                  ),
                ],
              );
            }),

            const SizedBox(height: 40),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppColors.accent,
              ),
              onPressed: submitReel,
              label: const Text(
                "Submit Shorts",
                style: TextStyle(color: Colors.white),
              ),
              icon: const Icon(Icons.send, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
