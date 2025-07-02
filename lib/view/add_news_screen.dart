import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gram_sanjog/common/theme/theme.dart';
import 'package:gram_sanjog/view/home_page_view.dart';
import 'package:intl/intl.dart';
import '../common/constants.dart';
import '../controller/auth/user_controller.dart';
import '../controller/news_controller.dart';

import '../controller/upload_cloudinary/image_upload_controller.dart';
import '../controller/upload_cloudinary/video_upload_controller.dart';
import '../model/news_model.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;


class AddNewsPage extends StatefulWidget {
  final News? existingNews;
  const AddNewsPage({super.key, this.existingNews});

  @override
  State<AddNewsPage> createState() => _AddNewsPageState();
}

class _AddNewsPageState extends State<AddNewsPage> {
  final NewsController newsController = Get.find<NewsController>();
  final UserController userController = Get.find<UserController>();
  final ImageUploadController controller = Get.put(ImageUploadController());
  final VideoUploadController videoController = Get.put(VideoUploadController());

  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final subHeadingController = TextEditingController();
  final descriptionController = TextEditingController();
  final categoryController = TextEditingController();
  List<TextEditingController> imageUrlControllers = [];
  List<TextEditingController> videoUrlControllers = [];

  final locationControllers = {
    'country*': TextEditingController(),
    'state*': TextEditingController(),
    'district*': TextEditingController(),
    'block*': TextEditingController(),
    'gp*': TextEditingController(),
  };

  String selectedCategory = "";
  String selectedLanguage = 'Odia';


  // void addImageField() {
  //   setState(() {
  //     imageUrlControllers.add(TextEditingController());
  //   });
  // }
  //
  // void addVideoField() {
  //   setState(() {
  //     videoUrlControllers.add(TextEditingController());
  //   });
  // }
  late quill.QuillController quillController;

  @override
  void initState() {
    super.initState();
    if (widget.existingNews != null) {
      final news = widget.existingNews!;
      titleController.text = news.title;
      subHeadingController.text = news.subHeading ?? '';
      descriptionController.text = news.description;
      imageUrlControllers = news.imageUrls.map((url) => TextEditingController(text: url)).toList();
      videoUrlControllers = news.videoUrls.map((url) => TextEditingController(text: url)).toList();
      selectedCategory = news.categoryId ?? '';
      categoryController.text = selectedCategory;
      selectedLanguage = widget.existingNews!.language ?? 'Odia';
      locationControllers['country*']!.text = news.locationDetails?.country ?? '';
      locationControllers['state*']!.text = news.locationDetails?.state ?? '';
      locationControllers['district*']!.text = news.locationDetails?.district ?? '';
      locationControllers['block*']!.text = news.locationDetails?.block ?? '';
      locationControllers['gp*']!.text = news.locationDetails?.gp ?? '';

      quillController = quill.QuillController(
        document: quill.Document()..insert(0, news.description).trim(),
        selection: const TextSelection.collapsed(offset: 0),
      );
    }else{
      quillController = quill.QuillController.basic();
    }
  }
  @override
  void dispose() {
    // Get.delete<ImageUploadController>();
    // Get.delete<VideoUploadController>();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor:AppColors.highlight,
        title: Text(
          widget.existingNews != null ? "Edit News" : "Add News",
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Container(
          width: screenWidth ,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20,),
                  //title and subheading
                  _buildField("Title*", titleController, true),
                  const SizedBox(width: 20),
                  _buildField("Sub Heading", subHeadingController, false),
                  const SizedBox(height: 20),

                  //description
                  //_buildField("Description*", descriptionController, true, maxLines: 5),
                  const Text("Description", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),

                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        quill.QuillToolbar.simple(
                          configurations: quill.QuillSimpleToolbarConfigurations(
                            controller: quillController,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 300,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: quill.QuillEditor.basic(
                            configurations: quill.QuillEditorConfigurations(
                              controller: quillController,
                              checkBoxReadOnly: true,
                              sharedConfigurations: const quill.QuillSharedConfigurations(
                                locale: Locale('en'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                  ),
                  const SizedBox(height: 30),

                  const Text("Image URLs", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),

                  Obx(() {
                    Widget preview;

                    if (kIsWeb && controller.pickedImageBytes.value != null) {
                      preview = Image.memory(controller.pickedImageBytes.value!, height: 150);
                    } else if (!kIsWeb && controller.pickedImageFile.value != null) {
                      preview = Image.file(controller.pickedImageFile.value!, height: 150);
                    } else {
                      preview = const Text("No image selected.");
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            height: 60,
                            child: preview),
                        const SizedBox(height: 10),

                        ElevatedButton.icon(
                          onPressed: controller.pickImage,
                          icon: const Icon(Icons.image),
                          label: const Text("Pick Image"),
                        ),

                        const SizedBox(height: 10),

                        ElevatedButton.icon(
                          onPressed: controller.isUploading.value
                              ? null
                              : () async {
                            await controller.uploadCurrentImage();

                            //  Add uploaded URL to imageUrlControllers
                            if (controller.uploadedImageUrls.isNotEmpty) {
                              final lastUrl = controller.uploadedImageUrls.last;
                              setState(() {
                                imageUrlControllers.add(TextEditingController(text: lastUrl));
                              });
                            }
                          },
                          icon: const Icon(Icons.cloud_upload),
                          label: controller.isUploading.value
                              ? const Text("Uploading...")
                              : const Text("Upload & Add"),
                        ),

                        const SizedBox(height: 10),

                        Wrap(
                          spacing: 10,
                          children: controller.uploadedImageUrls
                              .map((url) => Image.network(url, height: 60))
                              .toList(),
                        ),
                      ],
                    );
                  }),
                  SizedBox(height: 12,),
                  ...imageUrlControllers.asMap().entries.map((entry) {
                    final index = entry.key;
                    final controller = entry.value;
                    return Row(
                      children: [
                        Expanded(child: _buildField("Image URL", controller, false)),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              imageUrlControllers.removeAt(index);
                            });
                          },
                        ),
                      ],
                    );
                  }).toList(),

                  //_addButton("Add Image", addImageField),

                  const SizedBox(height: 30),
                  const Text("Video URLs", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Obx(() {
                    Widget preview;

                    if (kIsWeb && videoController.pickedVideoBytes.value != null) {
                      preview =  const Text("Video picked.");
                    } else if (!kIsWeb && videoController.pickedVideoFile.value != null) {
                      preview = Text("Picked file: ${videoController.pickedVideoFile.value!.path.split('/').last}");
                    } else {
                      preview = const Text("No video selected.");
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        preview,
                        const SizedBox(height: 10),

                        ElevatedButton.icon(
                          onPressed: videoController.pickVideo,
                          icon: const Icon(Icons.video_collection),
                          label: const Text("Pick Video"),
                        ),

                        const SizedBox(height: 10),

                        ElevatedButton.icon(
                          onPressed: videoController.isUploading.value
                              ? null
                              : () async {
                            await videoController.uploadCurrentVideo();

                            if (videoController.uploadedVideoUrls.isNotEmpty) {
                              final lastUrl = videoController.uploadedVideoUrls.last;
                              setState(() {
                                videoUrlControllers.add(TextEditingController(text: lastUrl));
                              });
                            }
                          },
                          icon: const Icon(Icons.cloud_upload),
                          label: videoController.isUploading.value
                              ? const Text("Uploading...")
                              : const Text("Upload & Add"),
                        ),

                        const SizedBox(height: 10),

                        Wrap(
                          spacing: 10,
                          children: videoController.uploadedVideoUrls
                              .map((url) => Text(url, style: const TextStyle(fontSize: 12)))
                              .toList(),
                        ),
                      ],
                    );
                  }),
                  SizedBox(height: 12,),
                  ...videoUrlControllers.asMap().entries.map((entry) {
                    final index = entry.key;
                    final controller = entry.value;
                    return Row(
                      children: [
                        Expanded(child: _buildField("Video URL", controller, false)),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              videoUrlControllers.removeAt(index);
                            });
                          },
                        ),
                      ],
                    );
                  }).toList(),
                  //_addButton("Add Video URL", addVideoField),

                  const SizedBox(height: 30),
                  const Text("Location Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: locationControllers.entries.map((entry) {
                      return SizedBox(
                        width: screenWidth > 1100 ? 200 : screenWidth / 2 - 60,
                        child: _buildField(entry.key, entry.value, true),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 30),
                  DropdownButtonFormField<String>(
                    value: selectedLanguage,
                    decoration: const InputDecoration(
                      labelText: "Select Language*",
                      border: OutlineInputBorder(),
                    ),
                    items: languages.map((lang) => DropdownMenuItem(
                      value: lang,
                      child: Text(lang),
                    )).toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedLanguage = val ?? 'Odia';
                      });
                    },
                    validator: (val) => val == null || val.isEmpty ? "Select a language" : null,
                  ),

                  const SizedBox(height: 30),
                  DropdownButtonFormField<String>(
                    value: selectedCategory.isEmpty ? null : selectedCategory,
                    decoration: const InputDecoration(
                      labelText: "Select a category*",
                      border: OutlineInputBorder(),
                    ),
                    items: categories.map((cat) => DropdownMenuItem(
                      value: cat.categoryId,
                      child: Text(cat.name),
                    )).toList(),
                    onChanged: (val) {
                      setState(() {
                        categoryController.text = val ?? '';
                        selectedCategory = val ?? '';
                      });
                    },
                    validator: (val) => val == null || val.isEmpty ? "Select a category" : null,
                  ),

                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          //Validate description
                          final plainDescription = quillController.document.toPlainText().trim();
                          if (plainDescription.isEmpty) {
                            Get.snackbar("Missing Description", "Please enter a description.",
                                backgroundColor: AppColors.error, colorText: Colors.white);
                            return;
                          }

                          // Validate at least one image
                          final hasAtLeastOneImage = imageUrlControllers.any((c) => c.text.trim().isNotEmpty);
                          if (!hasAtLeastOneImage) {
                            Get.snackbar("Missing Image", "Please upload at least one image.",
                                backgroundColor: AppColors.error, colorText: Colors.white);
                            return;
                          }

                          final location = LocationDetails(
                            country: locationControllers['country*']!.text.trim(),
                            state: locationControllers['state*']!.text.trim(),
                            district: locationControllers['district*']!.text.trim(),
                            block: locationControllers['block*']!.text.trim(),
                            gp: locationControllers['gp*']!.text.trim(),
                          );

                          final news = News(
                            newsId: widget.existingNews?.newsId ?? '',
                            title: titleController.text,
                            subHeading: subHeadingController.text,
                            description: quillController.document.toPlainText(),
                            imageUrls: imageUrlControllers.map((c) => c.text).toList(),
                            videoUrls: videoUrlControllers.map((c) => c.text).toList(),
                            timestamp: widget.existingNews?.timestamp ?? DateTime.now(),
                            locationDetails: location,
                            categoryId: categoryController.text,
                            createdById: userController.userData.value?.id ,
                            language: selectedLanguage,
                            createdBy: userController.userData.value?.name ?? "Unknown User",
                            verifiedBy: widget.existingNews?.verifiedBy,
                            updatedBy: userController.userData.value?.id,
                            updatedAt: DateTime.now(),
                            status:  widget.existingNews?.createdBy == 'Admin'? 'verified':"pending",
                            likes: widget.existingNews?.likes ?? 0,
                            views: widget.existingNews?.views ?? 0,
                            shares: widget.existingNews?.shares ?? 0,
                          );

                          try {
                            if (widget.existingNews != null) {
                              await newsController.updateNews(news);
                              Get.snackbar("Success", "News Updated", backgroundColor: Colors.green, colorText: Colors.white);
                            } else {
                              await newsController.postNews(news);
                              Get.snackbar("Success", "News Submitted", backgroundColor: Colors.green, colorText: Colors.white);
                            }

                            //  Go back after success
                            newsController.update();
                            Get.to(()=>HomePage());
                          } catch (e) {
                            Get.snackbar("Error", "Failed to submit news", backgroundColor: Colors.red, colorText: Colors.white);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.highlight,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        widget.existingNews != null ? "Update News" : "Submit News",
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, bool isRequired, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: isRequired ? (value) => value == null || value.trim().isEmpty ? 'Please enter $label' : null : null,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _addButton(String label, VoidCallback onPressed) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.add, color: Colors.deepPurple),
      label: Text(label, style: const TextStyle(color: Colors.deepPurple)),
    );
  }
}

String formatCustomTimestamp(DateTime dateTime) {
  final datePart = DateFormat('d MMMM yyyy').format(dateTime);
  final timePart = DateFormat('HH:mm:ss').format(dateTime);
  final offset = dateTime.timeZoneOffset;
  final offsetHours = offset.inHours.abs().toString().padLeft(2, '0');
  final offsetMinutes = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');
  final sign = offset.isNegative ? '-' : '+';
  return '$datePart at $timePart UTC$sign$offsetHours:$offsetMinutes';
}
