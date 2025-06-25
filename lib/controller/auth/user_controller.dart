import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../model/user_model.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  var userData = Rxn<UserProfile>();
  final Rxn<UserProfile> newsAuthor = Rxn<UserProfile>();  // Author of selected news

  Future<void> fetchUser(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('user').doc(uid).get();
      if (doc.exists) {
        userData.value = UserProfile.fromJson(doc.data()!);
      } else {
        if (kDebugMode) {
          print("User document not found.");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching user: $e");
      }
    }
  }
  Future<void> fetchAuthor(String uid) async {
    final userDoc = await FirebaseFirestore.instance.collection('user').doc(uid).get();
    if (userDoc.exists) {
      newsAuthor.value = UserProfile.fromJson(userDoc.data()!);
    }
  }
  void clearUser() {
    userData.value = null;
  }
}
