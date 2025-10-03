import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gram_sanjog/common/theme/theme.dart';
import 'package:gram_sanjog/model/user_model.dart';
import 'package:gram_sanjog/view/page_layout.dart';

import '../../service/auth_service.dart';
import '../../view/home_page_view.dart';

class AuthController extends GetxController {
  final AuthService authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Rxn<UserProfile> firebaseUser = Rxn<UserProfile>();

  final signupData = SignupData();

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // Add phone auth state
  final phoneAuthUser = Rxn<auth.User>();

  void handleAuthChanged(UserProfile? user) {
    if (user == null) {
      // User is logged out
      Get.offAllNamed('/login');
    } else {
      // User is logged in
      Get.offAllNamed('/home');
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Listen to auth state changes including phone auth
    ever(firebaseUser, handleAuthChanged);
    firebaseUser.bindStream(authService.userChanges.map((user) {
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
      }
      return null;
    }));
  }

  Future<void> signup(SignupData signupData) async {
    try {
      isLoading.value = true;
      final email = '${signupData.phoneNumber}@gramsanjog.in';

      // 1. Create user in Firebase Auth
      final userCredential = await authService.signUp(email, signupData.password);
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


        Get.to(const HomePage());

      }
    } on auth.FirebaseAuthException catch (e) {
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
      Get.offAll(() => const HomePage());
      update();
    } on auth.FirebaseAuthException catch (e) {
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

  Future<bool> handlePhoneAuthSuccess(auth.UserCredential userCredential) async {
    try {
      final user = userCredential.user;
      if (user != null) {
        phoneAuthUser.value = user;

        // Check if user exists in Firestore
        final userDoc = await _firestore.collection('users').doc(user.uid).get();

        if (!userDoc.exists) {
          // Create new user document for phone auth users
          await _firestore.collection('users').doc(user.uid).set({
            'id': user.uid,
            'phone': user.phoneNumber,
            'name': 'User${user.uid.substring(0, 4)}',
            'createdAt': DateTime.now(),
            'role': 'user',
          });
        }

        // Convert auth.User to UserProfile
        firebaseUser.value = UserProfile(
          id: user.uid,
          name: 'User${user.uid.substring(0, 4)}',
          email: user.email ?? '',
          phoneNumber: user.phoneNumber ?? '',
          country: '',
          state: '',
          district: '',
          block: '',
          gpWard: '',
          villageAddress: '',
          whatsappNumber: user.phoneNumber ?? '',
        );

        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to complete phone authentication');
      return false;
    }
  }
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