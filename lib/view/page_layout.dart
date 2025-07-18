// view/main_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gram_sanjog/view/shorts_page.dart';
import '../common/theme/theme.dart';
import 'home_page_view.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  final pages = [
    const HomePage(),
    const ShortsPage(), // New page
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.primary,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: Colors.white70,
        iconSize: 20,
        selectedFontSize: 14,
        unselectedFontSize: 12,
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.article_rounded),
            label: 'Articles',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library_rounded),
            label: 'Shorts',
          ),
        ],
      ),
    );
  }
}
