// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gram_sanjog/common/constants.dart';
// import 'package:gram_sanjog/common/theme/theme.dart';
// import 'package:gram_sanjog/controller/auth/user_controller.dart';
// import 'package:gram_sanjog/controller/news_controller.dart';
// import 'package:gram_sanjog/model/news_model.dart';
// import 'package:gram_sanjog/view/home_page_view.dart';
// import 'package:intl/intl.dart';
//
// class AddNewsPage extends StatefulWidget {
//   const AddNewsPage({super.key});
//
//   @override
//   State<AddNewsPage> createState() => _AddNewsPageState();
// }
//
// class _AddNewsPageState extends State<AddNewsPage> {
//   final NewsController newsController = Get.put(NewsController());
//   final UserController userController = Get.find<UserController>();
//   final _formKey = GlobalKey<FormState>();
//   final titleController = TextEditingController();
//   final subHeadingController = TextEditingController();
//   final descriptionController = TextEditingController();
//   final categoryController = TextEditingController();
//
//   List<TextEditingController> imageUrlControllers = [TextEditingController()];
//   List<TextEditingController> videoUrlControllers = [TextEditingController()];
//
//
//   final location = {
//     'country*': '',
//     'state*': '',
//     'district*': '',
//     'block*': '',
//     'gp*': ''
//   };
//
//   //TextEditingControllers for location
//   final Map<String, TextEditingController> locationControllers = {
//     'country*': TextEditingController(),
//     'state*': TextEditingController(),
//     'district*': TextEditingController(),
//     'block*': TextEditingController(),
//     'gp*': TextEditingController(),
//   };
//
//
//   //String currentLocation = "Location not yet retrieved";
//   String selectedCategory = "";
//
//   void addImageField() {
//     setState(() {
//       imageUrlControllers.add(TextEditingController());
//     });
//   }
//
//   void addVideoField() {
//     setState(() {
//       videoUrlControllers.add(TextEditingController());
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.inputBackground,
//       appBar: AppBar(
//         backgroundColor: AppColors.primary,
//         title: const Text("Add Content",style: TextStyle(color: AppColors.inputBackground),),
//         iconTheme: IconThemeData(
//           color: AppColors.inputBackground,
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text("Title*", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
//
//               _buildField("Title*", titleController, true),
//               _buildField("Sub Heading (optional)", subHeadingController, false),
//               _buildField("Description*", descriptionController, true, maxLines: 5),
//
//               const SizedBox(height: 10),
//               const Text("Image URLs", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
//               ...imageUrlControllers.map((c) => _buildField("Image URL", c, false)).toList(),
//               _addButton("Add Image URL", addImageField),
//
//               const SizedBox(height: 10),
//               const Text("Video URLs", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
//               ...videoUrlControllers.map((c) => _buildField("Video URL", c, false)).toList(),
//               _addButton("Add Video URL", addVideoField),
//
//               const SizedBox(height: 16),
//               const Text("Location", style: TextStyle(fontWeight: FontWeight.bold)),
//               Wrap(
//                 spacing: 10,
//                 runSpacing: 10,
//                 children: location.keys.map((key) {
//                   return SizedBox(
//                     width: MediaQuery.of(context).size.width / 2 - 22,
//                     child: _buildField(
//                         key.capitalizeFirst!,//label
//                         locationControllers[key]!,//TextEditingController
//                         true //isRequired
//                     ),
//                   );
//                 }).toList(),
//               ),
//               // const SizedBox(height: 12),
//               // SizedBox(
//               //   width: double.infinity,
//               //   child: ElevatedButton(
//               //     onPressed: () {
//               //       setState(() {
//               //         currentLocation = "Lat: 20.1, Lng: 85.8"; // simulate
//               //       });
//               //     },
//               //     style: ElevatedButton.styleFrom(
//               //         backgroundColor: AppColors.buttonSecondary,
//               //         padding: const EdgeInsets.symmetric(vertical: 14)
//               //     ),
//               //     child: const Text("Get My Current Location",style: TextStyle(color: AppColors.buttonText),),
//               //   ),
//               // ),
//               // const SizedBox(height: 8),
//               // Text(currentLocation, style: const TextStyle(color: Colors.black54)),
//
//               const SizedBox(height: 12),
//               DropdownButtonFormField<String>(
//                 value: selectedCategory.isEmpty ? null : selectedCategory,
//                 decoration: const InputDecoration(labelText: "Select a category*"),
//                 items: categories.map((cat) => DropdownMenuItem(
//                           value: cat.categoryId ,
//                           child: Text(cat.name),
//
//                        ),
//                 ).toList(),
//                 onChanged: (val) {
//                   setState(() => categoryController.text = val!,
//
//                   );
//                 },
//                 validator: (val) => val == null || val.isEmpty ? "Select a category" : null,
//               ),
//
//
//
//               const SizedBox(height: 20),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     if (_formKey.currentState!.validate()) {
//                       final location = LocationDetails(
//                         country: locationControllers['country*']!.text.trim(),
//                         state: locationControllers['state*']!.text.trim(),
//                         district: locationControllers['district*']!.text.trim(),
//                         block: locationControllers['block*']!.text.trim(),
//                         gp: locationControllers['gp*']!.text.trim(),
//                       );
//                       final news = News(
//                         newsId: '',
//                         title: titleController.text,
//                         subHeading: subHeadingController.text,
//                         description: descriptionController.text,
//                         imageUrls: imageUrlControllers.map((c) => c.text).toList(),
//                         videoUrls: videoUrlControllers.map((c) => c.text).toList(),
//                         timestamp:DateTime.now(),
//                         location: null,
//                         locationDetails: location,
//                         categoryId: categoryController.text,
//                         createdBy: userController.userData.value!.name,
//                         verifiedBy: null,
//                         status: "pending",
//                         likes: 0,
//                         views: 0,
//                         shares: 0,
//                       );
//
//                       if (kDebugMode) {
//                         print(news.toJson());
//                       }
//                       newsController.postNews(news);
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.buttonSecondary,
//                       padding: const EdgeInsets.symmetric(vertical: 14)),
//                   child: const Text("Submit News",style: TextStyle(color: AppColors.buttonText),),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildField(String label, TextEditingController controller, bool isRequired, {int maxLines = 1}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: TextFormField(
//         controller: controller,
//         maxLines: maxLines,
//         validator: isRequired
//             ? (value) => value == null || value.trim().isEmpty ? 'Please enter $label' : null
//             : null,
//         decoration: InputDecoration(
//           labelText: label,
//           filled: true,
//           fillColor: AppColors.inputBackground,
//           focusedBorder:const OutlineInputBorder(
//               borderSide:BorderSide(color: AppColors.buttonSecondary,width: 2)
//           ),
//           errorBorder:const OutlineInputBorder(
//               borderSide:BorderSide(color: AppColors.buttonPrimary,width: 1)
//           ),
//           border: const OutlineInputBorder(),
//         ),
//       ),
//     );
//   }
//
//   Widget _addButton(String label, VoidCallback onPressed) {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: TextButton.icon(
//         onPressed: onPressed,
//         icon: const Icon(Icons.add, color: AppColors.info),
//         label: Text(label, style: const TextStyle(color: AppColors.info)),
//       ),
//     );
//   }
// }
//
// String formatCustomTimestamp(DateTime dateTime) {
//   final datePart = DateFormat('d MMMM yyyy').format(dateTime); // 19 June 2025
//   final timePart = DateFormat('HH:mm:ss').format(dateTime);     // 17:24:33
//
//   final offset = dateTime.timeZoneOffset;
//   final offsetHours = offset.inHours.abs().toString().padLeft(2, '0');
//   final offsetMinutes = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');
//   final sign = offset.isNegative ? '-' : '+';
//
//   return '$datePart at $timePart UTC$sign$offsetHours:$offsetMinutes';
// }

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gram_sanjog/common/constants.dart';
import 'package:gram_sanjog/common/theme/theme.dart';
import 'package:gram_sanjog/controller/auth/user_controller.dart';
import 'package:gram_sanjog/controller/news_controller.dart';
import 'package:gram_sanjog/model/news_model.dart';
import 'package:gram_sanjog/view/home_page_view.dart';
import 'package:intl/intl.dart';

class AddNewsPage extends StatefulWidget {
  final News? existingNews;

  const AddNewsPage({super.key, this.existingNews});

  @override
  State<AddNewsPage> createState() => _AddNewsPageState();
}

class _AddNewsPageState extends State<AddNewsPage> {
  final NewsController newsController = Get.put(NewsController());
  final UserController userController = Get.find<UserController>();
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final subHeadingController = TextEditingController();
  final descriptionController = TextEditingController();
  final categoryController = TextEditingController();

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
  void initState() {
    super.initState();

    if (widget.existingNews != null) {
      final news = widget.existingNews!;
      titleController.text = news.title;
      subHeadingController.text = news.subHeading ?? '';
      descriptionController.text = news.description;
      imageUrlControllers = news.imageUrls.map((url) => TextEditingController(text: url)).toList();
      videoUrlControllers = news.videoUrls.map((url) => TextEditingController(text: url)).toList();
      selectedCategory = news.categoryId!;
      categoryController.text = selectedCategory;

      locationControllers['country*']!.text = news.locationDetails?.country ?? '';
      locationControllers['state*']!.text = news.locationDetails?.state ?? '';
      locationControllers['district*']!.text = news.locationDetails?.district ?? '';
      locationControllers['block*']!.text = news.locationDetails?.block ?? '';
      locationControllers['gp*']!.text = news.locationDetails?.gp ?? '';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.inputBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(widget.existingNews != null ? "Edit Content" : "Add Content",
          style: TextStyle(color: AppColors.inputBackground),
        ),
        iconTheme: IconThemeData(
          color: AppColors.inputBackground,
        ),
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
                        newsId: widget.existingNews?.newsId ?? '', // use existing ID for edit
                        title: titleController.text,
                        subHeading: subHeadingController.text,
                        description: descriptionController.text,
                        imageUrls: imageUrlControllers.map((c) => c.text).toList(),
                        videoUrls: videoUrlControllers.map((c) => c.text).toList(),
                        timestamp: widget.existingNews?.timestamp ?? DateTime.now(),
                        locationDetails: location,
                        categoryId: categoryController.text,
                        createdBy: userController.userData.value?.id ?? "Unknown User",
                        verifiedBy: widget.existingNews?.verifiedBy,
                        updatedBy: userController.userData.value?.id,
                        updatedAt: DateTime.now(),
                        status: "pending",
                        likes: widget.existingNews?.likes ?? 0,
                        views: widget.existingNews?.views ?? 0,
                        shares: widget.existingNews?.shares ?? 0,
                      );

                      if (widget.existingNews != null) {
                        newsController.updateNews(news);
                      } else {
                        newsController.postNews(news);
                      }

                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonSecondary,
                      padding: const EdgeInsets.symmetric(vertical: 14)),
                  child: Text(widget.existingNews != null ? "Update News" : "Submit News",
                    style: const TextStyle(color: AppColors.buttonText),),
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
  final datePart = DateFormat('d MMMM yyyy').format(dateTime);
  final timePart = DateFormat('HH:mm:ss').format(dateTime);

  final offset = dateTime.timeZoneOffset;
  final offsetHours = offset.inHours.abs().toString().padLeft(2, '0');
  final offsetMinutes = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');
  final sign = offset.isNegative ? '-' : '+';

  return '$datePart at $timePart UTC$sign$offsetHours:$offsetMinutes';
}