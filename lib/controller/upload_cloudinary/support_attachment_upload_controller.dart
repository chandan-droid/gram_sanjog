
import 'dart:io';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

class SupportAttachmentController extends GetxController {
  Rxn<PlatformFile> pickedFile = Rxn<PlatformFile>();
  RxBool isUploading = false.obs;
  RxnString uploadedFileUrl = RxnString();

  Future<void> pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
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


  Future<void> uploadToCloudinary() async  {
    if (pickedFile.value == null) return;

    isUploading.value = true;

    final uploadUrl = Uri.parse('https://api.cloudinary.com/v1_1/df43ypj7r/auto/upload');

    final request = http.MultipartRequest('POST', uploadUrl)
      ..fields['upload_preset'] = 'gms_support_doc';

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
      uploadedFileUrl.value = jsonData['secure_url'];
    } else {
      Get.snackbar('Upload Failed', 'Could not upload file to Cloudinary');
    }

    isUploading.value = false;
  }
}
