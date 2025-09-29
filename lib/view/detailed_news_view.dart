import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gram_sanjog/common/theme/theme.dart';
import 'package:gram_sanjog/common/widgets/yt_player/youtube_player_iframe.dart';
import 'package:gram_sanjog/controller/auth/user_controller.dart';
import 'package:gram_sanjog/controller/bookmark_controller.dart';
import 'package:gram_sanjog/controller/category_controller.dart';
import 'package:gram_sanjog/controller/news_controller.dart';
import 'package:gram_sanjog/view/home_page_view.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../common/widgets/mp4videoplayer.dart';
import '../common/widgets/yt_player/youtube_player_flutter.dart';
import '../controller/location_controller.dart';

class NewsDetailScreen extends StatefulWidget {
  final String newsId;
  const NewsDetailScreen({super.key, required this.newsId});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  final BookmarkController bookmarkController = Get.put(BookmarkController());
  final CategoryController categoryController = Get.put(CategoryController());
  final NewsController newsController = Get.put(NewsController());
  final LocationController locationController = Get.put(LocationController());
  final UserController userController = Get.find<UserController>();

  final PageController _pageController =
      PageController(viewportFraction: 1, keepPage: true);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      newsController.getNewsById(widget.newsId);
      locationController.geohashFromLocationData(
          newsController.currentNews.value?.locationDetails);
    });
    if (kDebugMode) {
      print(userController.newsAuthor.value);
    }

    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (page != _currentPage) {
        setState(() {
          _currentPage = page;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    userController.newsAuthor.value = null;
    if (kDebugMode) {
      print(userController.newsAuthor.value);
    }
  }

  void _showMediaPopup(BuildContext context, int initialIndex) {
    final news = newsController.currentNews.value;
    if (news == null) return;

    showDialog(
      context: context,
      builder: (context) => MediaPopupDialog(
        imageUrls: news.imageUrls,
        videoUrls: news.videoUrls,
        initialIndex: initialIndex,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Image.asset(
          "assets/logo/logo_header.png",
          height: 30,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 22),
          color: Colors.white,
          onPressed: () {
            Get.back();
            Get.find<NewsController>().getAllNews();
            userController.newsAuthor.value = null;
          }
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, size: 22),
            color: Colors.white,
            onPressed: () {
              newsController.shareCurrentNews();
              newsController.incrementShares();
            }
          ),
          Obx(() => IconButton(
            onPressed: () => bookmarkController.toggleBookmark(widget.newsId),
            icon: Icon(
              bookmarkController.isBookmarked(widget.newsId)
                ? Icons.bookmark_rounded
                : Icons.bookmark_outline_rounded,
              size: 22,
              color: Colors.white,
            ),
          )),
        ],
      ),
      body: Obx(() {
        final news = newsController.currentNews.value;

        if (newsController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.accent)
          );
        }

        if (news == null) {
          return Center(
            child: Text(
              newsController.errorMessage.value,
              style: TextStyle(color: AppColors.textSecondary),
            )
          );
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Media Carousel
              Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      itemCount: news.imageUrls.length + news.videoUrls.length,
                      itemBuilder: (context, index) {
                        if (index < news.imageUrls.length) {
                          final imageUrl = news.imageUrls[index];
                          return GestureDetector(
                            onTap: () => _showMediaPopup(context, index),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black.withOpacity(0.1)),
                              ),
                              child: Stack(
                                children: [
                                  Image.network(
                                    imageUrl,
                                    key: ValueKey('image_$index'),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                    errorBuilder: (_, __, ___) => Center(
                                      child: Icon(Icons.broken_image,
                                        color: AppColors.textMuted.withOpacity(0.5),
                                        size: 48
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 8,
                                    top: 8,
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.zoom_in_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          final videoUrl = news.videoUrls[index - news.imageUrls.length];
                          if (videoUrl.contains('youtube.com') || videoUrl.contains('youtube')) {
                            return AspectRatio(
                              key: ValueKey('yt_$index'),
                              aspectRatio: 16 / 9,
                              child: kIsWeb
                                ? YoutubeIframePlayer(videoUrl: videoUrl)
                                : YoutubePlayerFlutter(videoUrl: videoUrl),
                            );
                          } else {
                            return Mp4VideoPlayerWidget(
                              key: ValueKey('mp4_$index'),
                              videoUrl: videoUrl
                            );
                          }
                        }
                      },
                    ),
                    // Navigation Arrows
                    if (!kIsWeb) ...[
                      _buildNavigationArrow(
                        alignment: Alignment.centerLeft,
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () {
                          if (_currentPage > 0) {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                      ),
                      _buildNavigationArrow(
                        alignment: Alignment.centerRight,
                        icon: Icons.arrow_forward_ios_rounded,
                        onTap: () {
                          if (_currentPage < news.imageUrls.length + news.videoUrls.length - 1) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                      ),
                    ],
                    // Page Indicator
                    if (news.imageUrls.length + news.videoUrls.length > 1)
                      Positioned(
                        bottom: 16,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            news.imageUrls.length + news.videoUrls.length,
                            (index) => Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentPage == index
                                  ? AppColors.accent
                                  : Colors.white.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Category, Date, and Interactions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.highlight.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.highlight),
                      ),
                      child: Text(
                        categoryController.getCategoryName(news.categoryId ?? ''),
                        style: const TextStyle(
                          color: AppColors.highlight,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      DateFormat.yMMMMd().format(news.timestamp ?? DateTime.now()),
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  news.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    height: 1.3,
                  ),
                ),
              ),

              // Subheading
              if (news.subHeading != null && news.subHeading!.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.accent.withOpacity(0.1),
                    ),
                  ),
                  child: Text(
                    news.subHeading!,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
                      height: 1.5,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 16),

              // Author and Reading Time
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.accent.withOpacity(0.1),
                      radius: 20,
                      child: Text(
                        (news.createdBy ?? 'U')[0].toUpperCase(),
                        style: TextStyle(
                          color: AppColors.accent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            news.createdBy ?? 'Unknown Author',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            calculateReadingTime(news.description),
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Like Button
                    Obx(() {
                      final isLiked = newsController.hasUserLiked(news.newsId);
                      return GestureDetector(
                        onTap: () => newsController.toggleLike(news.newsId),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isLiked
                              ? AppColors.accent.withOpacity(0.1)
                              : Colors.transparent,
                          ),
                          child: Icon(
                            isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            color: isLiked ? AppColors.accent : AppColors.textMuted,
                            size: 24,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),

              // Location
              if (news.locationDetails != null) ...[
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 18,
                          color: AppColors.accent,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "${news.locationDetails?.block}, ${news.locationDetails?.district}, ${news.locationDetails?.state}",
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Divider(height: 1),
              ),

              // Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  news.description,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildNavigationArrow({
    required AlignmentGeometry alignment,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Align(
      alignment: alignment,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

String calculateReadingTime(String text) {
  const wordsPerMinute = 200;
  final wordCount = text.trim().split(RegExp(r'\s+')).length;
  final minutes = (wordCount / wordsPerMinute).ceil();
  return '$minutes min read';
}

class ImagePopupDialog extends StatefulWidget {
  final String imageUrl;

  const ImagePopupDialog({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  @override
  State<ImagePopupDialog> createState() => _ImagePopupDialogState();
}

class _ImagePopupDialogState extends State<ImagePopupDialog> {
  late TransformationController _transformationController;
  TapDownDetails? _doubleTapDetails;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapDetails = details;
  }

  void _handleDoubleTap() {
    if (_transformationController.value != Matrix4.identity()) {
      _transformationController.value = Matrix4.identity();
    } else {
      final position = _doubleTapDetails!.localPosition;
      _transformationController.value = Matrix4.identity()
        ..translate(-position.dx * 2, -position.dy * 2)
        ..scale(3.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              color: Colors.black.withOpacity(0.7),
            ),
          ),
          InteractiveViewer(
            transformationController: _transformationController,
            minScale: 0.5,
            maxScale: 4.0,
            child: GestureDetector(
              onDoubleTapDown: _handleDoubleTapDown,
              onDoubleTap: _handleDoubleTap,
              child: Center(
                child: Image.network(
                  widget.imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        color: AppColors.accent,
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.broken_image_rounded,
                        size: 48,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load image',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: Material(
              color: Colors.transparent,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MediaPopupDialog extends StatefulWidget {
  final List<String> imageUrls;
  final List<String> videoUrls;
  final int initialIndex;

  const MediaPopupDialog({
    Key? key,
    required this.imageUrls,
    required this.videoUrls,
    required this.initialIndex,
  }) : super(key: key);

  @override
  State<MediaPopupDialog> createState() => _MediaPopupDialogState();
}

class _MediaPopupDialogState extends State<MediaPopupDialog> {
  late PageController _pageController;
  late TransformationController _transformationController;
  late int _currentPage;
  TapDownDetails? _doubleTapDetails;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    _transformationController = TransformationController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapDetails = details;
  }

  void _handleDoubleTap() {
    if (_transformationController.value != Matrix4.identity()) {
      _transformationController.value = Matrix4.identity();
    } else {
      final position = _doubleTapDetails!.localPosition;
      _transformationController.value = Matrix4.identity()
        ..translate(-position.dx * 2, -position.dy * 2)
        ..scale(3.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalItems = widget.imageUrls.length + widget.videoUrls.length;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(color: Colors.black.withOpacity(0.9)),
          ),

          // Media PageView
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: totalItems,
            itemBuilder: (context, index) {
              if (index < widget.imageUrls.length) {
                // Image View
                return InteractiveViewer(
                  transformationController: _transformationController,
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: GestureDetector(
                    onDoubleTapDown: _handleDoubleTapDown,
                    onDoubleTap: _handleDoubleTap,
                    child: Center(
                      child: Image.network(
                        widget.imageUrls[index],
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              color: AppColors.accent,
                            ),
                          );
                        },
                        errorBuilder: (_, __, ___) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.broken_image_rounded,
                              size: 48,
                              color: Colors.white.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Failed to load image',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                // Video View
                final videoUrl = widget.videoUrls[index - widget.imageUrls.length];
                if (videoUrl.contains('youtube.com') || videoUrl.contains('youtube')) {
                  return Center(
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: kIsWeb
                          ? YoutubeIframePlayer(videoUrl: videoUrl)
                          : YoutubePlayerFlutter(videoUrl: videoUrl),
                    ),
                  );
                } else {
                  return Center(
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Mp4VideoPlayerWidget(videoUrl: videoUrl),
                    ),
                  );
                }
              }
            },
          ),

          // Navigation Arrows
          if (totalItems > 1) ...[
            Positioned(
              left: 16,
              top: 0,
              bottom: 0,
              child: Center(
                child: IconButton(
                  onPressed: _currentPage > 0
                      ? () => _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          )
                      : null,
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: _currentPage > 0
                          ? Colors.white
                          : Colors.white.withOpacity(0.3),
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 16,
              top: 0,
              bottom: 0,
              child: Center(
                child: IconButton(
                  onPressed: _currentPage < totalItems - 1
                      ? () => _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          )
                      : null,
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: _currentPage < totalItems - 1
                          ? Colors.white
                          : Colors.white.withOpacity(0.3),
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ],

          // Close Button
          Positioned(
            top: 16,
            right: 16,
            child: Material(
              color: Colors.transparent,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),

          // Page Indicator
          if (totalItems > 1)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  totalItems,
                  (index) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? AppColors.accent
                          : Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),

          // Media Type Indicator
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _currentPage < widget.imageUrls.length
                        ? Icons.image_rounded
                        : Icons.play_circle_filled_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _currentPage < widget.imageUrls.length ? 'Image' : 'Video',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${_currentPage + 1}/$totalItems',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
