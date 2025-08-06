import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class YouTubeIframeReelPlayer extends StatelessWidget {
  final String videoUrl;
  const YouTubeIframeReelPlayer({super.key, required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    final videoId = getYoutubeVideoId(videoUrl);

    if (!kIsWeb) {
      return const Center(child: Text("YouTube iframe only supported on Web"));
    }

    return AspectRatio(
      aspectRatio: 9 / 16,
      child: InAppWebView(
        initialData: InAppWebViewInitialData(
          data: '''
          <!DOCTYPE html>
          <html>
          <head>
            <style>
              body, html {
                margin: 0;
                padding: 0;
                height: 100%;
                overflow: hidden;
              }
              iframe {
                width: 100%;
                height: 100%;
                border: none;
              }
            </style>
          </head>
          <body>
            <iframe 
              src="https://www.youtube.com/embed/$videoId?autoplay=1&loop=1&playlist=$videoId&controls=0&modestbranding=1"
              allow="autoplay; encrypted-media"
              allowfullscreen>
            </iframe>
          </body>
          </html>
          ''',
          baseUrl: WebUri("https://www.youtube.com"),
        ),
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            mediaPlaybackRequiresUserGesture: false,
            javaScriptEnabled: true,
          ),
        ),
      ),
    );
  }

  String getYoutubeVideoId(String url) {
    Uri uri = Uri.tryParse(url) ?? Uri();
    if (uri.host.contains("youtu.be")) {
      return uri.pathSegments.first;
    }
    if (uri.queryParameters.containsKey("v")) {
      return uri.queryParameters["v"]!;
    }
    final segments = uri.pathSegments;
    if (segments.isNotEmpty) {
      return segments.last;
    }
    return '';
  }
}
