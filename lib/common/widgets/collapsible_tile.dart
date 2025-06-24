import 'package:flutter/material.dart';

import '../theme/theme.dart';

class CollapsibleProfileSection extends StatelessWidget {
  final String title;
  final List<Widget> content;

  const CollapsibleProfileSection({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      collapsedTextColor:AppColors.highlight,
      collapsedIconColor: AppColors.highlight,
      textColor: AppColors.highlight,
      iconColor: AppColors.highlight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: AppColors.highlight),
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: AppColors.highlight),
      ),
      tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      collapsedBackgroundColor: AppColors.inputBackground,
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      children: content,
    );
  }
}
