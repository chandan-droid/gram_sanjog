import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../view/auth/otp_verification_page.dart';

class PhoneLoginController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> startPhoneLogin(String phoneNumber) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Format phone number if not in international format
      String formattedNumber = phoneNumber;
      if (!phoneNumber.startsWith('+')) {
        // Add Indian country code if not present
        formattedNumber = '+91$phoneNumber';
      }

      // Validate phone number format
      if (!_isValidPhoneNumber(formattedNumber)) {
        errorMessage.value = 'Please enter a valid phone number';
        isLoading.value = false;
        return false;
      }

      // Navigate to OTP verification page
      final result = await Get.to(() => OtpVerificationPage(
            phoneNumber: formattedNumber,
          ));

      isLoading.value = false;
      return result ?? false;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = e.toString();
      return false;
    }
  }

  bool _isValidPhoneNumber(String phoneNumber) {
    // Basic validation for Indian phone numbers
    if (phoneNumber.startsWith('+91')) {
      return phoneNumber.length == 13 && phoneNumber.substring(1).isNumericOnly;
    }
    // For numbers without country code
    return phoneNumber.length == 10 && phoneNumber.isNumericOnly;
  }
}
