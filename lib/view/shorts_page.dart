import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import 'package:gram_sanjog/controller/shorts_controller.dart';
import 'package:gram_sanjog/model/shorts_model.dart';

import '../common/widgets/yt_player/yt_shorts_player.dart';
import '../common/widgets/yt_player/yt_shorts_player_iframe.dart';
import '../controller/auth/user_controller.dart';
import '../controller/category_controller.dart'; // NewsShort

class ShortsPage extends StatefulWidget {
  const ShortsPage({super.key});

  @override
  State<ShortsPage> createState() => _ShortsPageState();
}

class _ShortsPageState extends State<ShortsPage> {
  final ShortsController controller = Get.put(ShortsController());
  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    controller.loadShorts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.shortsList.isEmpty) {
          return const Center(
            child: Text("No reels available", style: TextStyle(color: Colors.white)),
          );
        }

        return PageView.builder(
          controller: pageController,
          scrollDirection: Axis.vertical,
          itemCount: controller.shortsList.length,
          itemBuilder: (context, index) {
            final NewsShort short = controller.shortsList[index];
            // controller.incrementViews(short.id); // Future: track views
            return _ReelItem(short: short);
          },
        );
      }),
    );
  }
}

class _ReelItem extends StatelessWidget {
  final NewsShort short;
  const _ReelItem({required this.short});

  bool get isYouTube =>
      short.videoUrl.contains("youtube.com") || short.videoUrl.contains("youtu.be");

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.put(UserController());
    final CategoryController categoryController = Get.put(CategoryController());

    final String categoryName = categoryController.getCategoryName(short.categoryId);

    return SafeArea(
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Positioned.fill(
            child: isYouTube
                ? YouTubeResponsivePlayer(videoUrl: short.videoUrl)
                : LocalReelPlayer(videoUrl: short.videoUrl),
          ),
          SizedBox(
            height: 200,
            child: Positioned(
            bottom: 0,
              child:Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: FutureBuilder(
              future: userController.fetchAuthor(short.createdBy),
              builder: (context, snapshot) {
                final username =
                    userController.newsAuthor.value?.name ?? 'unknown';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '@$username',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _ShowMoreCaption(caption: short.caption),

                    const SizedBox(height: 6),

                    /// 🔹 Category
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        categoryName,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 6),

                    /// 🔹 Hashtags
                    Wrap(
                      spacing: 8,
                      runSpacing: -4,
                      children: short.tags.map((tag) {
                        return Text(
                          '#${tag} ',
                          style: const TextStyle(
                            color: Colors.lightBlueAccent,
                            fontSize: 13,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


class LocalReelPlayer extends StatefulWidget {
  final String videoUrl;
  const LocalReelPlayer({super.key, required this.videoUrl});

  @override
  State<LocalReelPlayer> createState() => _LocalReelPlayerState();
}

class _LocalReelPlayerState extends State<LocalReelPlayer> {
  late VideoPlayerController _controller;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
      });

    _controller.addListener(() {
      final isCurrentlyPlaying = _controller.value.isPlaying;
      if (_isPlaying != isCurrentlyPlaying) {
        setState(() {
          _isPlaying = isCurrentlyPlaying;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? GestureDetector(
      onTap: _togglePlayPause,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
          AnimatedOpacity(
            opacity: _isPlaying ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: const Icon(Icons.play_circle_fill_rounded, size: 64, color: Colors.white),
          ),
        ],
      ),
    )
        : const Center(child: CircularProgressIndicator());
  }
}

class _ShowMoreCaption extends StatefulWidget {
  final String caption;
  const _ShowMoreCaption({required this.caption});

  @override
  State<_ShowMoreCaption> createState() => _ShowMoreCaptionState();
}

class _ShowMoreCaptionState extends State<_ShowMoreCaption> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final shouldTrim = widget.caption.length > 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.caption,
          maxLines: isExpanded ? null : 2,
          overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        if (shouldTrim)
          TextButton(
            onPressed: () => setState(() => isExpanded = !isExpanded),
            child: Text(
              isExpanded ? "Show less" : "Show more",
              style: const TextStyle(color: Colors.lightBlueAccent, fontSize: 12),
            ),
          ),
      ],
    );
  }
}

class YouTubeResponsivePlayer extends StatelessWidget {
  final String videoUrl;
  const YouTubeResponsivePlayer({super.key, required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return YouTubeIframeReelPlayer(videoUrl: videoUrl);
    } else {
      return YouTubeReelPlayer(videoUrl: videoUrl);
    }
  }
}