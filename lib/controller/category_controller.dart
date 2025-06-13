import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/constants.dart';
import '../model/category_model.dart';

class CategoryController extends GetxController {
  RxString selectedCategoryId = '0'.obs;

  void selectCategory(String id) {
    if (selectedCategoryId.value == id) {
      selectedCategoryId.value = "0";
    } else {
      selectedCategoryId.value = id;
    }
  }

  String getCategoryName(String categoryId) {
    final match = categories.firstWhere(
          (cat) => cat.categoryId == categoryId,
      orElse: () => Category(categoryId: '', name: 'General', icon: Icons.help),
    );
    return match.name;
  }
}
