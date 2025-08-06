import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubeReelPlayer extends StatefulWidget {
  final String videoUrl;
  const YouTubeReelPlayer({super.key, required this.videoUrl});

  @override
  State<YouTubeReelPlayer> createState() => _YouTubeReelPlayerState();
}

class _YouTubeReelPlayerState extends State<YouTubeReelPlayer> {
  late YoutubePlayerController _controller;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl) ?? "";

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        loop: true,
        hideControls: true,
        disableDragSeek: true,
      ),
    );

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
    return Stack(
      fit: StackFit.expand,
      children: [
        YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: false,
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _togglePlayPause,
          child: Center(
            child: AnimatedOpacity(
              opacity: _isPlaying ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: const Icon(Icons.play_circle_fill_rounded, size: 64, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
