
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gram_sanjog/common/theme/theme.dart';
import 'package:gram_sanjog/controller/auth/auth_controller.dart';
import 'package:gram_sanjog/view/auth/log_in_screen.dart';
import 'package:gram_sanjog/view/auth/sign_up_extended_screen.dart';

import '../home_page_view.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: AppColors.primary,

      body: SafeArea(
        //LayoutBuilder + ConstrainedBox + IntrinsicHeight help avoid layout overflow issues
        child: Stack(
          children: [
            //back button
            Positioned(
              top: 16,
              left: 32,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white54),
                  onPressed: () => Get.offAll(const HomePage()),
                ),
              ),
            ),

            //regd form
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Form(
                        key: formKey,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              const SizedBox(height: 32),
                              Image.asset("assets/logo/logo_header.png", height: 50),
                              const SizedBox(height: 32),
                              _buildTextField("Name*", nameController,
                                  prefixIcon: Icons.person_2_rounded,
                                  validator: (val) => val == null || val.trim().isEmpty ? "Name is required" : null),
                              const SizedBox(height: 16),
                              _buildTextField("Email*", emailController,
                                  prefixIcon: Icons.email,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (val) {
                                    if (val == null || val.trim().isEmpty) return "Email is required";
                                    final emailRegex = RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$");
                                    return emailRegex.hasMatch(val.trim()) ? null : "Enter a valid email";
                                  }),
                              const SizedBox(height: 16),
                              _buildTextField("Phone Number*", phoneController,
                                  prefixIcon: Icons.phone,
                                  keyboardType: TextInputType.phone,
                                  validator: (val) {
                                    if (val == null || val.trim().isEmpty) return "Phone number is required";
                                    return val.trim().length == 10 ? null : "Enter a valid 10-digit number";
                                  }),
                              const SizedBox(height: 16),
                              _buildTextField("Password*", passwordController,
                                  prefixIcon: Icons.lock, obscure: true,
                                  validator: (val) {
                                    if (val == null || val.trim().isEmpty) return "Password is required";
                                    return val.trim().length >= 6 ? null : "Minimum 6 characters required";
                                  }),
                              const SizedBox(height: 16),
                              _buildTextField(
                                  "Re-enter Password*", confirmPasswordController,
                                  prefixIcon: Icons.lock, obscure: true,
                                  validator: (val) {
                                    if (val == null || val.trim().isEmpty) return "Please re-enter password";
                                    return val.trim() == passwordController.text ? null : "Passwords do not match";
                                  }),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      authController.signupData.name = nameController.text;
                                      authController.signupData.email = emailController.text;
                                      authController.signupData.phoneNumber = phoneController.text;
                                      authController.signupData.password = passwordController.text;
                                      authController.signupData.confirmPassword = confirmPasswordController.text;

                                      Get.to(SignUpPageExtended());
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.highlight,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text('Proceed',
                                      style: TextStyle(fontSize: 16)),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextButton(
                                onPressed: () {
                                  Get.to(() => const LoginPage());
                                },
                                child: const Text(
                                  "Already have an account? Login",
                                  style: TextStyle(color: AppColors.highlight),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildTextField(String label, TextEditingController controller,
    {IconData? prefixIcon,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: label,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.grey.shade900,
        prefixIcon: Icon(prefixIcon, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      obscureText: obscure,
      validator: validator,
    ),
  );
}
