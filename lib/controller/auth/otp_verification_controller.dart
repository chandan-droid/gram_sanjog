import 'dart:async';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OtpVerificationController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final phoneNumber = ''.obs;
  final verificationId = ''.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final resendTimer = 0.obs;
  Timer? _timer;

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  Future<void> sendOTP(String phone) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      phoneNumber.value = phone;

      await _auth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          Get.back(result: true);
        },
        verificationFailed: (FirebaseAuthException e) {
          isLoading.value = false;
          errorMessage.value = e.message ?? 'Verification failed';
        },
        codeSent: (String verId, int? resendToken) {
          verificationId.value = verId;
          isLoading.value = false;
          _startResendTimer();
        },
        codeAutoRetrievalTimeout: (String verId) {
          verificationId.value = verId;
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = e.toString();
    }
  }

  Future<bool> verifyOTP(String otp) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: otp,
      );

      await _auth.signInWithCredential(credential);
      isLoading.value = false;
      return true;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Invalid OTP. Please try again.';
      return false;
    }
  }

  void _startResendTimer() {
    resendTimer.value = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimer.value > 0) {
        resendTimer.value--;
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> resendOTP() async {
    if (resendTimer.value == 0) {
      await sendOTP(phoneNumber.value);
    }
  }
}
