import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubeIframePlayer extends StatefulWidget {
  final String videoUrl;

  const YoutubeIframePlayer({super.key, required this.videoUrl});

  @override
  State<YoutubeIframePlayer> createState() =>
      _YoutubeIframePlayerState();
}

class _YoutubeIframePlayerState extends State<YoutubeIframePlayer> {
  late YoutubePlayerController _controller;
  bool isPlaying = true;

  @override
  void initState() {
    super.initState();
    final videoId =
        YoutubePlayerController.convertUrlToId(widget.videoUrl) ?? '';

    _controller = YoutubePlayerController(

      params: const YoutubePlayerParams(
        showControls: false,
        showFullscreenButton: true,
        enableJavaScript : false,
        mute: false,
        loop: true,
        playsInline: true,
        strictRelatedVideos: true,
        showVideoAnnotations: false,
      ),
    )..loadVideoById(videoId: videoId);

    _controller.listen((event) {
      final playing = event.playerState == PlayerState.playing;
      if (isPlaying != playing) {
        setState(() {
          isPlaying = playing;
        });
      }
    });
  }

  void _togglePlayPause() {
    if (isPlaying) {
      _controller.pauseVideo();
    } else {
      _controller.playVideo();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        YoutubePlayerScaffold(
          controller: _controller,
          builder: (context, player) {
            return AspectRatio(
              aspectRatio: 16 / 9,
              child: player,
            );
          },
        ),
        GestureDetector(
          onTap: _togglePlayPause,
          behavior: HitTestBehavior.opaque,
          child: AnimatedOpacity(
            opacity: isPlaying ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 300),
            child: const Center(
              child: Icon(
                Icons.play_circle_fill_rounded,
                size: 50,
                color: Colors.white70,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}
