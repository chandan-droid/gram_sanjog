import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gram_sanjog/common/theme/theme.dart';
import 'package:gram_sanjog/controller/auth/auth_controller.dart';
import 'package:gram_sanjog/view/auth/phone_login_page.dart';
import 'package:gram_sanjog/view/auth/sign_up_extended_screen.dart';
import 'package:gram_sanjog/view/auth/sign_up_screen.dart';
import 'package:gram_sanjog/view/home_page_view.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController());
    TextEditingController emailController = TextEditingController();
    TextEditingController pwController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Logo
                  SizedBox(height: 200,),
                  Container(
                    margin: const EdgeInsets.all(0.8),
                    child: Image.asset(
                      "assets/logo/logo_header.png",
                      height: 50,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Email
                  TextFormField(
                    controller: emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey.shade900,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.email, color: Colors.grey),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email is required';
                      }
                      final emailRegex = RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(value.trim())) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password
                  TextFormField(
                    controller: pwController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey.shade900,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          authController.login(emailController.text, pwController.
                          text);
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
                      child: const Text('Login', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // route sign up page
                  TextButton(
                    onPressed: () {
                      Get.to(const SignUpPage());
                    },
                    child: const Text(
                      "Don't have an account? Signup",
                      style: TextStyle(color: AppColors.highlight),
                    ),
                  ),
                  // const SizedBox(height: 16),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: Divider(
                  //         color: AppColors.border,
                  //         thickness: 1,
                  //       ),
                  //     ),
                  //     Padding(
                  //       padding: const EdgeInsets.symmetric(horizontal: 16),
                  //       child: Text(
                  //         'OR',
                  //         style: TextStyle(
                  //           color: AppColors.textMuted,
                  //           fontSize: 14,
                  //           fontWeight: FontWeight.w500,
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: Divider(
                  //         color: AppColors.border,
                  //         thickness: 1,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(height: 16),
                  // OutlinedButton.icon(
                  //   onPressed: () => Get.to(() => const PhoneLoginPage()),
                  //   style: OutlinedButton.styleFrom(
                  //     padding: const EdgeInsets.symmetric(vertical: 12),
                  //     side: BorderSide(color: AppColors.border),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(8),
                  //     ),
                  //   ),
                  //   icon: Icon(
                  //     Icons.phone_android_rounded,
                  //     color: AppColors.textSecondary,
                  //   ),
                  //   label: Text(
                  //     'Continue with Phone',
                  //     style: TextStyle(
                  //       color: AppColors.textSecondary,
                  //       fontSize: 16,
                  //       fontWeight: FontWeight.w500,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
