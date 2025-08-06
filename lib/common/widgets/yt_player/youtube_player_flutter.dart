import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';



class YoutubePlayerFlutter extends StatefulWidget {
  final String videoUrl;

  const YoutubePlayerFlutter({super.key, required this.videoUrl});

  @override
  State<YoutubePlayerFlutter> createState() => _YoutubePlayerFlutterState();
}

class _YoutubePlayerFlutterState extends State<YoutubePlayerFlutter> {
  late YoutubePlayerController _controller;
  bool isPlaying = true;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);

    _controller = YoutubePlayerController(
      initialVideoId: videoId!,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        loop: true,
        hideControls: true,
        controlsVisibleAtStart: false,
        enableCaption: false,
        showLiveFullscreenButton: false,

      ),
    );
    _controller.addListener(() {
      final isCurrentlyPlaying = _controller.value.isPlaying;
      if (isPlaying != isCurrentlyPlaying) {
        setState(() {
          isPlaying = isCurrentlyPlaying;
        });
      }
    });
  }

  void _togglePlayPause() {
    if (isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 9 / 16,
      child: Stack(
        children: [
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: false,
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
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
