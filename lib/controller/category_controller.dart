import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/constants.dart';
import '../model/category_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/category_model.dart';

class CategoryController extends GetxController {
  RxList<Category> categories = <Category>[].obs;
  RxString selectedCategoryId = '1'.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  void selectCategory(String id) {
    // if (selectedCategoryId.value == id) {
    //   selectedCategoryId.value = "0"; // Deselect
    // } else {
    //   selectedCategoryId.value = id;
    // }
    selectedCategoryId.value = id;
  }

  String getCategoryName(String categoryId) {
    final match = categories.firstWhere(
          (cat) => cat.categoryId == categoryId,
      orElse: () => Category(categoryId: '', name: 'General'),
    );
    return match.name;
  }

  Future<void> fetchCategories() async {
    isLoading.value = true;
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('category')
          .get();

      final fetchedCategories = snapshot.docs
          .map((doc) => Category.fromJson(doc.data()))
          .toList();

      categories.assignAll(fetchedCategories);

      // ✅ Automatically select the first category (if list not empty)
      if (fetchedCategories.isNotEmpty) {
        selectedCategoryId.value = fetchedCategories.first.categoryId;
      }

    } catch (e) {
      debugPrint('Error fetching categories: $e');
      Get.snackbar("Error", "Failed to load categories.");
    } finally {
      isLoading.value = false;
    }
  }

}
