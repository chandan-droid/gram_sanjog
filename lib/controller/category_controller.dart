import 'package:get/get.dart';

class CategoryController extends GetxController {
  RxString selectedCategoryId = '0'.obs;

  void selectCategory(String id) {
    if (selectedCategoryId.value == id) {
      selectedCategoryId.value = "0";
    } else {
      selectedCategoryId.value = id;
    }
  }
}
