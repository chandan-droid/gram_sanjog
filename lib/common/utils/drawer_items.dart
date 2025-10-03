import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../view/info_pages/about_us_page.dart';
import '../../view/info_pages/donation_page.dart';
import '../../view/info_pages/help_support_page.dart';
import '../../view/survey/survey_list_page.dart';


class DrawerItems {
  static List<Widget> getDrawerItems({
    required bool isLoggedIn,
    required UserProfile? userData,
    required String userId,
    required Function(BuildContext) showLogoutDialog,
    required Widget Function({
      required IconData icon,
      required String title,
      String? subtitle,
      required VoidCallback onTap,
    }) buildDrawerItem,
  }) {
    List<Widget> items = [];

    // Add survey option for panchayat captains
    if (isLoggedIn && userData?.role == 'panchayat_captain') {
      items.add(buildDrawerItem(
        icon: Icons.assessment_rounded,
        title: 'Citizen Surveys',
        onTap: () => Get.to(() => SurveyListPage(surveyorId: userId)),
      ));
    }

    // Add standard menu items
    items.addAll([
      buildDrawerItem(
        icon: Icons.info_outline_rounded,
        title: 'About Us',
        onTap: () => Get.to(() => const AboutUsPage()),
      ),
      buildDrawerItem(
        icon: Icons.bookmark_border_rounded,
        title: 'Saved Contents',
        onTap: () => Get.toNamed('/bookmarks'),
      ),
      buildDrawerItem(
        icon: Icons.help_outline_rounded,
        title: 'Help & Support',
        subtitle: 'Grievance',
        onTap: () => Get.to(() => HelpSupportPage(isLoggedIn: isLoggedIn)),
      ),
      buildDrawerItem(
        icon: Icons.handshake_outlined,
        title: 'Donation & Social Work',
        onTap: () => Get.to(() => const DonationPage()),
      ),
    ]);

    return items;
  }
}
