import 'package:flutter/cupertino.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'dart:typed_data';

Future<Uint8List?> generateThumbnail(String videoUrl) async {
  if (videoUrl.contains("youtube.com") || videoUrl.contains("youtu.be")) {
    return null; // Will use fallback YouTube thumbnail
  }

  try {
    return await VideoThumbnail.thumbnailData(
      video: videoUrl,
      imageFormat: ImageFormat.JPEG,
      maxHeight: 200,
      quality: 75,
    );
  } catch (e) {
    debugPrint("Thumbnail error: $e");
    return null;
  }
}


