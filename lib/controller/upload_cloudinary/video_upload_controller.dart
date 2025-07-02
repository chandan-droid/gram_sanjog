import 'dart:convert';
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

class VideoUploadController extends GetxController {
  final String cloudName = 'df43ypj7r';
  final String uploadPreset = 'gms_unsigned_preset_videos';

  var isUploading = false.obs;
  final uploadedVideoUrls = <String>[].obs;

  // Store the currently picked video (file or bytes)
  Rxn<Uint8List> pickedVideoBytes = Rxn<Uint8List>(); // Web
  Rxn<io.File> pickedVideoFile = Rxn<io.File>();       // Mobile

  /// Picks a single video
  Future<void> pickVideo() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
        withData: kIsWeb, // For web: bytes
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;

        if (kIsWeb) {
          pickedVideoBytes.value = file.bytes;
          pickedVideoFile.value = null;
        } else {
          pickedVideoFile.value = io.File(file.path!);
          pickedVideoBytes.value = null;
        }
      }
    } catch (e) {
      Get.snackbar("Error picking video", e.toString());
    }
  }

  /// Uploads the currently picked video to Cloudinary and adds URL to list
  Future<void> uploadCurrentVideo() async {
    final noVideo = (kIsWeb && pickedVideoBytes.value == null) ||
        (!kIsWeb && pickedVideoFile.value == null);

    if (noVideo) {
      Get.snackbar("No Video", "Please pick a video first.");
      return;
    }

    isUploading.value = true;
    final url = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/video/upload");

    try {
      var request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = uploadPreset;

      if (kIsWeb) {
        request.files.add(http.MultipartFile.fromBytes(
          'file',
          pickedVideoBytes.value!,
          filename: 'video.mp4',
        ));
      } else {
        request.files.add(await http.MultipartFile.fromPath(
          'file',
          pickedVideoFile.value!.path,
        ));
      }

      final response = await request.send();
      if (response.statusCode == 200) {
        final res = await http.Response.fromStream(response);
        final data = json.decode(res.body);
        final videoUrl = data['secure_url'];
        uploadedVideoUrls.add(videoUrl);
        pickedVideoBytes.value = null;
        pickedVideoFile.value = null;
      } else {
        Get.snackbar("Upload Failed", "Cloudinary status ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Upload Error", e.toString());
    } finally {
      isUploading.value = false;
    }
  }

  /// Optional: Clear everything
  void reset() {
    uploadedVideoUrls.clear();
    pickedVideoBytes.value = null;
    pickedVideoFile.value = null;
  }
}
