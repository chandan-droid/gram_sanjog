import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gram_sanjog/controller/auth/auth_controller.dart';
import 'package:gram_sanjog/controller/auth/user_controller.dart';
import 'package:gram_sanjog/common/theme/theme.dart';
import 'package:gram_sanjog/view/auth/log_in_screen.dart';
import 'package:gram_sanjog/view/my_contents_page.dart';

class UserProfilePage extends StatelessWidget {
  final UserController userController = Get.find<UserController>();
  final AuthController authController = Get.find<AuthController>();

  UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      backgroundColor: AppColors.background,
      body: Obx(() {
        final user = userController.userData.value;

        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey.withOpacity(0.5),
                backgroundImage: AssetImage("assets/illustrations/user.png"),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                user.name,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            Chip(
              label: Text(
                user.email,
                style: const TextStyle(color: AppColors.primary),
              ),
              backgroundColor: AppColors.secondary.withAlpha(100),
            ),
            const SizedBox(height: 30),
            ListTile(
              tileColor: AppColors.buttonSecondary.withAlpha(100),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              title: const Text('My Contents'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: (){
                  Get.to(MyContentsPage());
              },
            ),
            const SizedBox(height: 30),
            _buildInfoTile("Phone", user.phoneNumber),
            _buildInfoTile("WhatsApp", user.whatsappNumber),
            _buildInfoTile("Country", user.country),
            _buildInfoTile("State", user.state),
            _buildInfoTile("District", user.district),
            _buildInfoTile("Block", user.block),
            _buildInfoTile("GP/Ward", user.gpWard),
            _buildInfoTile("Village/Address", user.villageAddress),
            const SizedBox(height: 30),
            TextButton.icon(
              onPressed: () {
                authController.logout();
                Get.offAll(() => const LoginPage());
              },
              icon: const Icon(Icons.logout, color: AppColors.accent),
              label: const Text(
                "Log Out",
                style: TextStyle(color: AppColors.accent),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      title: Text(label),
      subtitle: Text(value.isNotEmpty ? value : "Not Provided"),
      //trailing: const Icon(Icons.edit),
    );
  }
}
