import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:gram_sanjog/common/theme/theme.dart';
import 'package:gram_sanjog/model/user_model.dart';

import '../../service/auth_service.dart';
import '../../view/home_page_view.dart';

class AuthController extends GetxController {
  final AuthService authService = AuthService();
  Rxn<UserProfile> firebaseUser = Rxn<UserProfile>();

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    firebaseUser.bindStream(
      authService.userChanges.map((user) {
        if (user != null) {
          return UserProfile(
            id: user.uid,
            name: user.displayName ?? '',
            email: user.email ?? '',
            phoneNumber: user.phoneNumber ?? '',
            country: '',
            state: '',
            district: '',
            block: '',
            gpWard: '',
            villageAddress: '',
          );
        } else {
          return null;
        }
      }),
    );
    super.onInit();
  }


  Future<void> login(String email, String pw) async{
    try{
      isLoading.value = true;
      await authService.login(email.trim(), pw.trim());
      Get.snackbar('Success',
          'Logged in successfully',
          colorText:AppColors.success
      );
      Get.offAll(() => HomePage());
      update();
    }on FirebaseAuthException catch(e){
      errorMessage.value = 'login failed';
      Get.snackbar('Success',
          'Log in failed.',
          colorText:AppColors.error
      );
      if (kDebugMode) {
        print("Auth error: ${e.code} - ${e.message}");
      }
    }finally {
      isLoading.value = false;
    }

  }
  Future<void> logout() async {
    await authService.logout();
    Get.snackbar('Logged out', 'You have been signed out.');
    update();
  }
  bool get isLoggedIn => firebaseUser.value != null;

}