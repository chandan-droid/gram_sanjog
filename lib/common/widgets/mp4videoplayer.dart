import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Mp4VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  const Mp4VideoPlayerWidget({super.key, required this.videoUrl});

  @override
  State<Mp4VideoPlayerWidget> createState() => _Mp4VideoPlayerWidgetState();
}

class _Mp4VideoPlayerWidgetState extends State<Mp4VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
          _controller.setLooping(false);
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    final videoSize = _controller.value.size;
    final aspectRatio = _controller.value.aspectRatio;
    final screenWidth = MediaQuery.of(context).size.width;

    // Limit portrait video width to avoid full stretch
    final isPortrait = aspectRatio > 1.0;
    final maxVideoWidth = isPortrait ? screenWidth * 0.5 : screenWidth;

    return Center(
      child: Container(
        //width: maxVideoWidth,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SizedBox.expand(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  VideoPlayer(_controller),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
            ),

            Container(
                width: maxVideoWidth,
                child: VideoPlayer(_controller)),
            VideoProgressIndicator(_controller, allowScrubbing: true),
            Align(
              alignment: Alignment.center,
              child: IconButton(
                icon: Icon(
                  _controller.value.isPlaying ? Icons.pause_circle : Icons.play_circle,
                  color: Colors.white,
                  size: 50,
                ),
                onPressed: () {
                  setState(() {
                    _controller.value.isPlaying ? _controller.pause() : _controller.play();
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
