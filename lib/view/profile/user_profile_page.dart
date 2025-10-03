import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gram_sanjog/controller/auth/auth_controller.dart';
import 'package:gram_sanjog/controller/auth/user_controller.dart';
import 'package:gram_sanjog/common/theme/theme.dart';
import 'package:gram_sanjog/view/auth/log_in_screen.dart';
import 'package:gram_sanjog/view/profile/my_contents_page.dart';

import '../../common/widgets/collapsible_tile.dart';
import '../../common/widgets/editable_profile_field.dart';
import '../../model/user_model.dart';

class UserProfilePage extends StatefulWidget {

  UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final UserController userController = Get.find<UserController>();
  final AuthController authController = Get.find<AuthController>();

  late UserProfile userProfile;

  @override
  void initState() {
    super.initState();
    // Initialize the current user data from controller
    userProfile = Get.find<UserController>().userData.value!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: Obx(() {
        final user = userController.userData.value;
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Profile Header
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.highlight,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const CircleAvatar(
                          radius: 38,
                          backgroundImage: AssetImage("assets/illustrations/user.png"),
                          backgroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        user.name,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                // My Contents Section
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    tileColor: AppColors.buttonSecondary.withAlpha(100),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    title: const Text('My Contents', style: TextStyle(fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      Get.to(MyContentsPage());
                    },
                  ),
                ),
                const SizedBox(height: 24),
                // Personal Information Section
                Text('Personal Information', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: [
                        EditableProfileField(
                          label: 'Name',
                          value: user.name,
                          onEdit: (newVal) {
                            setState(() => userProfile = userProfile.copyWith(name: newVal));
                            userController.updateUser(userProfile);
                            userController.update();
                          },
                        ),
                        Divider(height: 1, color: Colors.grey[200]),
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                          title: const Text('Email', style: TextStyle(color: Colors.black)),
                          subtitle: Text(user.email.isNotEmpty ? user.email : "Not Provided", style: const TextStyle(color: Colors.grey)),
                        ),
                        Divider(height: 1, color: Colors.grey[200]),
                        EditableProfileField(
                          label: 'Phone',
                          value: user.phoneNumber,
                          onEdit: (newVal) {
                            setState(() => userProfile = userProfile.copyWith(phoneNumber: newVal));
                            userController.updateUser(userProfile);
                            userController.update();
                          },
                        ),
                        Divider(height: 1, color: Colors.grey[200]),
                        EditableProfileField(
                          label: 'WhatsApp Number',
                          value: user.whatsappNumber,
                          onEdit: (newVal) {
                            setState(() => userProfile = userProfile.copyWith(whatsappNumber: newVal));
                            userController.updateUser(userProfile);
                            userController.update();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Location Section
                Text('Location', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: [
                        EditableProfileField(
                          label: 'Country',
                          value: user.country,
                          onEdit: (newVal) {
                            setState(() => userProfile = userProfile.copyWith(country: newVal));
                            userController.updateUser(userProfile);
                            userController.update();
                          },
                        ),
                        Divider(height: 1, color: Colors.grey[200]),
                        EditableProfileField(
                          label: 'State',
                          value: user.state,
                          onEdit: (newVal) {
                            setState(() => userProfile = userProfile.copyWith(state: newVal));
                            userController.updateUser(userProfile);
                            userController.update();
                          },
                        ),
                        Divider(height: 1, color: Colors.grey[200]),
                        EditableProfileField(
                          label: 'District',
                          value: user.district,
                          onEdit: (newVal) {
                            setState(() => userProfile = userProfile.copyWith(district: newVal));
                            userController.updateUser(userProfile);
                            userController.update();
                          },
                        ),
                        Divider(height: 1, color: Colors.grey[200]),
                        EditableProfileField(
                          label: 'Block',
                          value: user.block,
                          onEdit: (newVal) {
                            setState(() => userProfile = userProfile.copyWith(block: newVal));
                            userController.updateUser(userProfile);
                            userController.update();
                          },
                        ),
                        Divider(height: 1, color: Colors.grey[200]),
                        EditableProfileField(
                          label: 'GP/Ward',
                          value: user.gpWard,
                          onEdit: (newVal) {
                            setState(() => userProfile = userProfile.copyWith(gpWard: newVal));
                            userController.updateUser(userProfile);
                            userController.update();
                          },
                        ),
                        Divider(height: 1, color: Colors.grey[200]),
                        EditableProfileField(
                          label: 'Village/Address',
                          value: user.villageAddress,
                          onEdit: (newVal) {
                            setState(() => userProfile = userProfile.copyWith(villageAddress: newVal));
                            userController.updateUser(userProfile);
                            userController.update();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Logout Button
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      authController.logout();
                      Get.offAll(() => const LoginPage());
                    },
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text(
                      "Log Out",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      title: Text(label,style: const TextStyle(color: Colors.black),),
      subtitle: Text(value.isNotEmpty ? value : "Not Provided",style: const TextStyle(color: Colors.grey)),
      trailing: IconButton(
        icon: const Icon(Icons.edit,color: Colors.grey,),
        onPressed: () {

        },),

    );
  }
}
