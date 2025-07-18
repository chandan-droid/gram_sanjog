import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:gram_sanjog/common/theme/theme.dart';
import 'package:gram_sanjog/model/user_model.dart';
import 'package:gram_sanjog/view/page_layout.dart';

import '../../service/auth_service.dart';
import '../../view/home_page_view.dart';

class AuthController extends GetxController {
  final AuthService authService = AuthService();
  Rxn<UserProfile> firebaseUser = Rxn<UserProfile>();

  final signupData = SignupData();

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
            whatsappNumber: '',
          );
        } else {
          return null;
        }
      }),
    );
    super.onInit();
  }

  Future<void> signup(SignupData signupData) async {
    try {
      isLoading.value = true;

      // 1. Create user in Firebase Auth
      final userCredential = await authService.signUp(signupData.email, signupData.password);
      final firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        // 2. Assign Firebase UID to your SignupData model
        signupData.id = firebaseUser.uid;

        // 3. Create user document in Firestore
        await authService.createUserInFirestore(signupData,firebaseUser.uid);

        Get.snackbar(
          'Success',
          'Account created successfully',
          colorText: Colors.white,
          backgroundColor: Colors.green,
        );


        Get.to(const MainPage());

      }
    } on FirebaseAuthException catch (e) {
      errorMessage.value = e.message ?? 'Signup failed';
      Get.snackbar('Error', errorMessage.value, colorText: Colors.white, backgroundColor: Colors.red);
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      Get.snackbar('Error', errorMessage.value, colorText: Colors.white, backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> login(String email, String pw) async {
    try {
      isLoading.value = true;
      await authService.login(email.trim(), pw.trim());
      Get.snackbar('Success', 'Logged in successfully',
          backgroundColor: AppColors.success,colorText: Colors.white);
      Get.offAll(() => const MainPage());
      update();
    } on FirebaseAuthException catch (e) {
      errorMessage.value = 'login failed';
      Get.snackbar('Error', 'Log in failed.',
          backgroundColor: AppColors.error,colorText: Colors.white);
      if (kDebugMode) {
        print("Auth error: ${e.code} - ${e.message}");
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await authService.logout();
    Get.snackbar('Logged out', 'You have been signed out.',
        backgroundColor: AppColors.info,colorText: Colors.white);
    update();
  }

  bool get isLoggedIn => firebaseUser.value != null;
}

class SignupData {
  String id ='';
  String name = '';
  String email = '';
  String phoneNumber = '';
  String password = '';
  String confirmPassword = '';

  String whatsappNumber = '';
  String country = '';
  String state = '';
  String district = '';
  String block = '';
  String gpWard = '';
  String villageAddress = '';
}