import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gram_sanjog/common/constants.dart';
import 'package:gram_sanjog/common/theme/theme.dart';
import 'package:gram_sanjog/controller/news_controller.dart';
import 'package:gram_sanjog/model/news_model.dart';
import 'package:intl/intl.dart';

class AddNewsPage extends StatefulWidget {
  const AddNewsPage({super.key});

  @override
  State<AddNewsPage> createState() => _AddNewsPageState();
}

class _AddNewsPageState extends State<AddNewsPage> {
  final NewsController newsController = Get.put(NewsController());
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final subHeadingController = TextEditingController();
  final descriptionController = TextEditingController();
  final categoryController = TextEditingController();
  final adminController = TextEditingController();

  List<TextEditingController> imageUrlControllers = [TextEditingController()];
  List<TextEditingController> videoUrlControllers = [TextEditingController()];


  final location = {
    'country*': '',
    'state*': '',
    'district*': '',
    'block*': '',
    'gp*': ''
  };

  //TextEditingControllers for location
  final Map<String, TextEditingController> locationControllers = {
    'country*': TextEditingController(),
    'state*': TextEditingController(),
    'district*': TextEditingController(),
    'block*': TextEditingController(),
    'gp*': TextEditingController(),
  };


  //String currentLocation = "Location not yet retrieved";
  String selectedCategory = "";

  void addImageField() {
    setState(() {
      imageUrlControllers.add(TextEditingController());
    });
  }

  void addVideoField() {
    setState(() {
      videoUrlControllers.add(TextEditingController());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.inputBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text("Add News",style: TextStyle(color: AppColors.inputBackground),),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Title*", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),

              _buildField("Title*", titleController, true),
              _buildField("Sub Heading (optional)", subHeadingController, false),
              _buildField("Description*", descriptionController, true, maxLines: 5),

              const SizedBox(height: 10),
              const Text("Image URLs", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
              ...imageUrlControllers.map((c) => _buildField("Image URL", c, false)).toList(),
              _addButton("Add Image URL", addImageField),

              const SizedBox(height: 10),
              const Text("Video URLs", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
              ...videoUrlControllers.map((c) => _buildField("Video URL", c, false)).toList(),
              _addButton("Add Video URL", addVideoField),

              const SizedBox(height: 16),
              const Text("Location", style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: location.keys.map((key) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width / 2 - 22,
                    child: _buildField(
                        key.capitalizeFirst!,//label
                        locationControllers[key]!,//TextEditingController
                        true //isRequired
                    ),
                  );
                }).toList(),
              ),
              // const SizedBox(height: 12),
              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton(
              //     onPressed: () {
              //       setState(() {
              //         currentLocation = "Lat: 20.1, Lng: 85.8"; // simulate
              //       });
              //     },
              //     style: ElevatedButton.styleFrom(
              //         backgroundColor: AppColors.buttonSecondary,
              //         padding: const EdgeInsets.symmetric(vertical: 14)
              //     ),
              //     child: const Text("Get My Current Location",style: TextStyle(color: AppColors.buttonText),),
              //   ),
              // ),
              // const SizedBox(height: 8),
              // Text(currentLocation, style: const TextStyle(color: Colors.black54)),

              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedCategory.isEmpty ? null : selectedCategory,
                decoration: const InputDecoration(labelText: "Select a category*"),
                items: categories.map((cat) => DropdownMenuItem(
                          value: cat.categoryId ,
                          child: Text(cat.name),

                       ),
                ).toList(),
                onChanged: (val) {
                  setState(() => categoryController.text = val!,

                  );
                },
                validator: (val) => val == null || val.isEmpty ? "Select a category" : null,
              ),

              const SizedBox(height: 10),
              _buildField("Admin name", adminController, true),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final location = LocationDetails(
                        country: locationControllers['country*']!.text.trim(),
                        state: locationControllers['state*']!.text.trim(),
                        district: locationControllers['district*']!.text.trim(),
                        block: locationControllers['block*']!.text.trim(),
                        gp: locationControllers['gp*']!.text.trim(),
                      );
                      final news = News(
                        newsId: '',
                        title: titleController.text,
                        subHeading: subHeadingController.text,
                        description: descriptionController.text,
                        imageUrls: imageUrlControllers.map((c) => c.text).toList(),
                        videoUrls: videoUrlControllers.map((c) => c.text).toList(),
                        timestamp:DateTime.now(),
                        location: null,
                        locationDetails: location,
                        categoryId: categoryController.text,
                        createdBy: adminController.text,
                        verifiedBy: null,
                        status: "pending",
                        likes: 0,
                        views: 0,
                        shares: 0,
                      );
                      if (kDebugMode) {
                        print('Title: ${titleController.text}');
                        print('Subheading: ${subHeadingController.text}');
                        print('Description: ${descriptionController.text}');
                        print('Category: ${categoryController.text}');
                        print('Admin: ${adminController.text}');

                        // Print image URLs
                        for (int i = 0; i < imageUrlControllers.length; i++) {
                          print('Image URL ${i + 1}: ${imageUrlControllers[i].text}');
                        }

                        // Print video URLs
                        for (int i = 0; i < videoUrlControllers.length; i++) {
                          print('Video URL ${i + 1}: ${videoUrlControllers[i].text}');
                        }

                        // Print location fields
                        locationControllers.forEach((key, controller) {
                          print('$key: ${controller.text}');
                        });
                      }
                      print(news.toJson());
                      newsController.postNews(news);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonSecondary,
                      padding: const EdgeInsets.symmetric(vertical: 14)),
                  child: const Text("Submit News",style: TextStyle(color: AppColors.buttonText),),
                ),
              ),
            ],
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
        validator: isRequired
            ? (value) => value == null || value.trim().isEmpty ? 'Please enter $label' : null
            : null,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: AppColors.inputBackground,
          focusedBorder:const OutlineInputBorder(
              borderSide:BorderSide(color: AppColors.buttonSecondary,width: 2)
          ),
          errorBorder:const OutlineInputBorder(
              borderSide:BorderSide(color: AppColors.buttonPrimary,width: 1)
          ),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _addButton(String label, VoidCallback onPressed) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.add, color: AppColors.info),
        label: Text(label, style: const TextStyle(color: AppColors.info)),
      ),
    );
  }
}

String formatCustomTimestamp(DateTime dateTime) {
  final datePart = DateFormat('d MMMM yyyy').format(dateTime); // 19 June 2025
  final timePart = DateFormat('HH:mm:ss').format(dateTime);     // 17:24:33

  final offset = dateTime.timeZoneOffset;
  final offsetHours = offset.inHours.abs().toString().padLeft(2, '0');
  final offsetMinutes = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');
  final sign = offset.isNegative ? '-' : '+';

  return '$datePart at $timePart UTC$sign$offsetHours:$offsetMinutes';
}