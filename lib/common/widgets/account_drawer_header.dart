import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gram_sanjog/common/theme/theme.dart';

import '../../view/profile/user_profile_page.dart';

class CustomDrawerHeader extends StatelessWidget {
  final String name;
  final String email;
  final String profileImage;

  const CustomDrawerHeader({
    super.key,
    required this.name,
    required this.email,
    required this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
        border: Border(
          bottom: BorderSide(color: Colors.white24),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(3),

            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.highlight,
                width: 3,
              ),
            ),
            child:CircleAvatar(
              radius: 22,
              backgroundImage: AssetImage(profileImage),
              backgroundColor: Colors.white,
            ),
          ),

          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.isNotEmpty ? name : 'Guest User',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  email.isNotEmpty ? email : 'example@email.com',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
              onPressed: (){
                Get.to(UserProfilePage());
              },
              icon: Icon(Icons.arrow_forward_ios_rounded))
        ],
      ),
    );
  }
}
