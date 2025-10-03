import 'dart:io';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

class SurveyAttachmentController extends GetxController {
  Rxn<PlatformFile> pickedFile = Rxn<PlatformFile>();
  RxBool isUploading = false.obs;
  RxList<String> uploadedFileUrls = <String>[].obs;

  Future<void> pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );

      if (result != null && result.files.isNotEmpty) {
        pickedFile.value = result.files.first;
      } else {
        pickedFile.value = null;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick file: $e");
    }
  }

  Future<void> uploadToCloudinary() async {
    if (pickedFile.value == null) return;

    isUploading.value = true;

    final uploadUrl = Uri.parse('https://api.cloudinary.com/v1_1/df43ypj7r/auto/upload');

    try {
      final request = http.MultipartRequest('POST', uploadUrl)
        ..fields['upload_preset'] = 'gms_support_doc';  // Create this preset in Cloudinary

      if (kIsWeb) {
        request.files.add(http.MultipartFile.fromBytes(
          'file',
          pickedFile.value!.bytes!,
          filename: pickedFile.value!.name,
        ));
      } else {
        final file = File(pickedFile.value!.path!);
        request.files.add(await http.MultipartFile.fromPath('file', file.path));
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        final resData = await response.stream.bytesToString();
        final jsonData = jsonDecode(resData);
        uploadedFileUrls.add(jsonData['secure_url']);
        pickedFile.value = null; // Clear the picked file after successful upload
      } else {
        Get.snackbar('Upload Failed', 'Could not upload file to Cloudinary');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload: $e');
    } finally {
      isUploading.value = false;
    }
  }

  void removeUploadedFile(String url) {
    uploadedFileUrls.remove(url);
  }

  void clearUploads() {
    uploadedFileUrls.clear();
    pickedFile.value = null;
  }
}
