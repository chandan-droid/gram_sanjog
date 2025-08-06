import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/link_model.dart';

class LinksController extends GetxController {
  var links = <LinkModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchLinks();
    super.onInit();
  }

  void fetchLinks() async {
    try {
      isLoading.value = true;
      final snapshot = await FirebaseFirestore.instance
          .collection('important_links')
          .get();

      links.value = snapshot.docs
          .map((doc) => LinkModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch links');
    } finally {
      isLoading.value = false;
    }
  }
}
