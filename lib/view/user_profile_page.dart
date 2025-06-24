import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gram_sanjog/controller/auth/auth_controller.dart';
import 'package:gram_sanjog/controller/auth/user_controller.dart';
import 'package:gram_sanjog/common/theme/theme.dart';
import 'package:gram_sanjog/view/auth/log_in_screen.dart';
import 'package:gram_sanjog/view/my_contents_page.dart';

import '../common/widgets/collapsible_tile.dart';

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
              child: Container(
                padding: EdgeInsets.all(3),

                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.highlight,
                    width: 3,
                  ),
                ),
                child:const CircleAvatar(
                  radius: 30,
                  backgroundImage:AssetImage("assets/illustrations/user.png"),
                  backgroundColor: Colors.white,
                ),
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
            const SizedBox(height: 10),

            Center(
              child: Text(
                user.email,
                style:
                const TextStyle(fontSize: 20,),
              ),
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
            CollapsibleProfileSection(
              title: 'Personal Information',
              content: [
                _buildInfoTile("Name", user.name),
                _buildInfoTile("Email", user.email),
                _buildInfoTile("Phone", user.phoneNumber),
                _buildInfoTile("WhatsApp", user.whatsappNumber),
              ],
            ),
            const SizedBox(height: 16),
           CollapsibleProfileSection(
            title: 'Location',
            content: [
              _buildInfoTile("Country", user.country),
              _buildInfoTile("State", user.state),
              _buildInfoTile("District", user.district),
              _buildInfoTile("Block", user.block),
              _buildInfoTile("GP/Ward", user.gpWard),
              _buildInfoTile("Village/Address", user.villageAddress),
            ],
           ),
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
      title: Text(label,style: const TextStyle(color: Colors.black),),
      subtitle: Text(value.isNotEmpty ? value : "Not Provided",style: const TextStyle(color: Colors.grey)),
      //trailing: const Icon(Icons.edit),
    );
  }
}
