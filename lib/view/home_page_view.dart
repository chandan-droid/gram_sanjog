import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gram_sanjog/common/theme/theme.dart';
import 'package:gram_sanjog/controller/auth/user_controller.dart';
import 'package:gram_sanjog/controller/category_controller.dart';
import 'package:gram_sanjog/controller/news_controller.dart';
import 'package:gram_sanjog/controller/search_controller.dart';
import 'package:gram_sanjog/controller/top_news_controller.dart';
import 'package:gram_sanjog/view/auth/log_in_screen.dart';
import 'package:gram_sanjog/view/shorts_page.dart';
import 'package:gram_sanjog/view/profile/user_profile_page.dart';
import 'package:gram_sanjog/view/survey/survey_list_page_new.dart';

import '../common/constants.dart';
import '../common/widgets/account_drawer_header.dart';
import '../common/widgets/category_tile.dart';
import '../common/widgets/compact_news_card.dart';
import '../common/widgets/news_carousal.dart';
import '../common/widgets/search_bar.dart';
import '../common/widgets/search_delegate.dart';
import '../controller/auth/auth_controller.dart';
import '../controller/bookmark_controller.dart';
import '../controller/location_controller.dart';
import '../model/news_model.dart';
import 'add_news_screen.dart';
import 'add_shorts_page.dart';
import 'bookmark_view.dart';
import 'detailed_news_view.dart';
import 'info_pages/about_us_page.dart';
import 'info_pages/donation_page.dart';
import 'info_pages/help_support_page.dart';
import 'info_pages/imp_contacts_page.dart';
import 'info_pages/imp_links_page.dart';
import '../common/widgets/skeleton_loading.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  CategoryController categoryController = Get.put(CategoryController());
  NewsController newsController = Get.put(NewsController());
  BookmarkController bookmarkController = Get.put(BookmarkController());
  SearchQueryController searchController = Get.put(SearchQueryController());
  LocationController locationController = Get.put(LocationController());
  TopNewsController topNewsController = Get.put(TopNewsController());
  AuthController authController = Get.find<AuthController>();
  UserController userController = Get.find<UserController>();

  late final AnimationController _animationController;
  late final Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 0.125, // 1/8th of a full rotation
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    newsController.getAllNews();
    topNewsController.fetchTopNews();
    categoryController.fetchCategories();
    if (authController.firebaseUser.value != null) {
      userController.fetchUser(authController.firebaseUser.value!.id);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Obx(() {
          return Drawer(
            backgroundColor: AppColors.primary.withOpacity(0.92),
            child: SafeArea(
              child: Column(
                children: [
                  if (authController.isLoggedIn)
                    Obx(() => CustomDrawerHeader(
                      name: userController.userData.value?.name ?? '',
                      email: authController.firebaseUser.value?.email ?? '',
                      profileImage: "assets/illustrations/user.png",
                    )),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      children: [
                        if (authController.isLoggedIn &&
                            userController.userData.value?.role == 'panchayat_captain')
                          _buildDrawerItem(
                            icon: Icons.people_outline_rounded,
                            title: 'Citizen Survey',
                            onTap: () => Get.to(() => SurveyListPage(
                              surveyorId: authController.firebaseUser.value?.id ?? '',
                            )),
                          ),
                        _buildDrawerItem(
                          icon: Icons.info_outline_rounded,
                          title: 'About Us',
                          onTap: () => Get.to(() => const AboutUsPage()),
                        ),
                        _buildDrawerItem(
                          icon: Icons.bookmark_border_rounded,
                          title: 'Saved Contents',
                          onTap: () => Get.to(() => BookmarkScreen()),
                        ),
                        _buildDrawerItem(
                          icon: Icons.help_outline_rounded,
                          title: 'Help & Support',
                          subtitle: 'Grievance',
                          onTap: () => Get.to(() => HelpSupportPage(isLoggedIn: authController.isLoggedIn)),
                        ),
                        _buildDrawerItem(
                          icon: Icons.handshake_outlined,
                          title: 'Donation & Social Work',
                          onTap: () => Get.to(() => const DonationPage()),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: Colors.white24),
                  if (authController.isLoggedIn)
                    _buildDrawerItem(
                      icon: Icons.logout_rounded,
                      title: 'Log Out',
                      onTap: () => _showLogoutDialog(context),
                    )
                  else
                    _buildDrawerItem(
                      icon: Icons.login_rounded,
                      title: 'Log In',
                      onTap: () => Get.to(const LoginPage()),
                    ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        }),
      ),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        toolbarHeight: 64,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
              child: const Icon(Icons.menu_rounded, color: Colors.white),
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Image.asset(
          "assets/logo/logo_header.png",
          height: 32,
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
              child: const Icon(Icons.search_rounded, color: Colors.white),
            ),
            onPressed: () => showSearch(
              context: context,
              delegate: NewsSearchDelegate(),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      backgroundColor: AppColors.scaffoldBackground,
      body: RefreshIndicator(
        color: AppColors.accent,
        backgroundColor: Colors.white,
        onRefresh: () async {
          await Future.wait([
            newsController.getAllNews(),
            locationController.fetchLocation(),
            topNewsController.fetchTopNews(),
            categoryController.fetchCategories(),
          ]);
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    if (locationController.isLoading.value) {
                      return const LocationHeaderSkeleton();
                    }
                    return _buildLocationHeader();
                  }),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Text(
                          "Trends",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.trending_up_rounded,
                                size: 16,
                                color: AppColors.accent,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "Top Stories",
                                style: TextStyle(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(() {
                    if (topNewsController.isLoading.value) {
                      return const TopNewsSkeleton();
                    }
                    return const TopNewsCarousel();
                  }),
                  const SizedBox(height: 24),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Categories",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Obx(() {
                    if (categoryController.isLoading.value) {
                      return const CategorySkeleton();
                    }
                    return SizedBox(
                      height: 44,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        scrollDirection: Axis.horizontal,
                        itemCount: categoryController.categories.length,
                        itemBuilder: (context, index) {
                          final category = categoryController.categories[index];
                          return Obx(() {
                            final isSelected = category.categoryId == categoryController.selectedCategoryId.value;
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: CategoryTile(
                                category: category,
                                isSelected: isSelected,
                                onTap: () {
                                  categoryController.selectCategory(category.categoryId);
                                },
                              ),
                            );
                          });
                        },
                      )
                    );
                    // return const SizedBox();
                  }),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: Obx(() {
                if (newsController.isLoading.value) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => const NewsCardSkeleton(),
                      childCount: 5,
                    ),
                  );
                }

                var selectedCategoryId = categoryController.selectedCategoryId.value;
                final filteredNews = newsController.newsList
                    .where((news) => news.categoryId == selectedCategoryId)
                    .toList();

                if (filteredNews.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.article_outlined,
                              size: 48,
                              color: AppColors.textMuted,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "No stories available yet",
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final newsItem = filteredNews[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: NewsCardCompact(
                          newsId: newsItem.newsId,
                          imageUrl: newsItem.imageUrls.isNotEmpty
                              ? newsItem.imageUrls[0]
                              : 'assets/logo/gram_sanjog_app_icon_trans.png',
                          title: newsItem.title,
                          subHeading: newsItem.title,
                          upvotes: newsItem.likes!,
                          shares: newsItem.shares!,
                          isBookmarked: bookmarkController.isBookmarked(newsItem.newsId),
                        ),
                      );
                    },
                    childCount: filteredNews.length,
                  ),
                );
              }),
            ),
            const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
          ],
        ),
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotationAnimation.value * 2 * 3.14159,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: FloatingActionButton(
                backgroundColor: AppColors.accent,
                child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
                onPressed: () async {
                  _animationController.forward().then((_) {
                    _animationController.reverse();
                  });

                  if(authController.isLoggedIn) {
                    Get.to(() => const AddNewsPage());
                  } else {
                    Get.to(const LoginPage());
                  }
                },
              ),
            )
          );
        },
      ),
    );
  }

  Widget _buildLocationHeader() {
    return Obx(() {
      final location = locationController.currentLocation.value;
      if (location == null) return const SizedBox();

      return Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.location_on_rounded,
                size: 20,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${locationController.currentArea.value}, ${locationController.currentCity.value}",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${locationController.currentState.value} - ${locationController.currentPincode.value}",
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70, size: 22),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 12,
              ),
            )
          : null,
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      minLeadingWidth: 24,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Logout"),
        content: const Text("Are you sure you want to log out?"),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        actions: [
          TextButton(
            child: const Text(
              "Cancel",
              style: TextStyle(color: AppColors.textSecondary),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              authController.logout();
              authController.update();
            },
            child: const Text("Log Out"),
          ),
        ],
      ),
    );
  }
}
