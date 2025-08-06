import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../model/shorts_model.dart';
import '../service/shorts_service.dart';

class ShortsController extends GetxController {
  final ShortsService _shortsService = ShortsService();

  var shortsList = <NewsShort>[].obs;
  var myShortsList = <NewsShort>[].obs;

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadShorts();
  }

  /// Loads all shorts from Firestore
  Future<void> loadShorts() async {
    try {
      isLoading.value = true;
      final shorts = await _shortsService.fetchShorts();
      shortsList.assignAll(shorts);
    } catch (e) {
      debugPrint('Failed to load shorts: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Upload a new short to Firestore
  Future<void> uploadShort(NewsShort short) async {
    try {
      await _shortsService.addShort(short);
      await loadShorts(); // Reload after upload
    } catch (e) {
      debugPrint('Failed to upload short: $e');
    }
  }

  /// 🔹 Get shorts by specific user
  Future<void> getMyShorts(String userId) async {
    try {
      isLoading.value = true;
      final allShorts = await _shortsService.fetchShorts();
      myShortsList.assignAll(allShorts.where((short) => short.createdBy == userId).toList());
    } catch (e) {
      debugPrint('Failed to fetch my shorts: $e');
    } finally {
      isLoading.value = false;
    }
  }

// Future<void> likeShort(String shortId, String userId) async {
//   await _shortsService.likeShort(shortId, userId);
//   await loadShorts(); // Optionally refresh after liking
// }

// Future<void> incrementViews(String shortId) async {
//   await _shortsService.viewShort(shortId);
// }
}
