import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class SimpleYoutubePlayer extends StatefulWidget {
  final String videoUrl;

  const SimpleYoutubePlayer({super.key, required this.videoUrl});

  @override
  State<SimpleYoutubePlayer> createState() => _SimpleYoutubePlayerState();
}

class _SimpleYoutubePlayerState extends State<SimpleYoutubePlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayerController.convertUrlToId(widget.videoUrl);

    _controller = YoutubePlayerController.fromVideoId(
      videoId: videoId!,
      params: const YoutubePlayerParams(
        showControls: true,
        //showFullscreenButton: true,
        mute: false,
        strictRelatedVideos: true,
        showVideoAnnotations: false, 

      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerScaffold(
      controller: _controller,
      builder: (context, player) {
        return AspectRatio(
          aspectRatio: 16 / 9,
          child: player,
        );
      },
    );
  }
}
