import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:gram_sanjog/view/auth/log_in_screen.dart';
import '../../common/theme/theme.dart';
import '../../controller/auth/user_controller.dart';
import '../../controller/upload_cloudinary/support_attachment_upload_controller.dart'; // Update the path if different

class HelpSupportPage extends StatefulWidget {
  final bool isLoggedIn;

  const HelpSupportPage({super.key, required this.isLoggedIn});

  @override
  State<HelpSupportPage> createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final SupportAttachmentController supportController = Get.put(SupportAttachmentController());
  final UserController userController = Get.find<UserController>();

  @override
  void dispose() {
    _descriptionController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Help & Support"),
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,),
      body: widget.isLoggedIn ? _buildForm() : _buildLoginPrompt(),
    );
  }

  Widget _buildLoginPrompt() {
    return Center(
      child: AlertDialog(
        title: const Text("Login Required"),
        content: const Text("You must be logged in to access Help & Support."),
        actions: [
          TextButton(
            onPressed: () {
              // Navigate to your login screen
              Get.to(const LoginPage());
            },
            child: const Text("Login"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          )
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            const Text("Describe your issue:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: "Enter your issue in detail",
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.isEmpty ? "Description required" : null,
            ),
            const SizedBox(height: 20),
            const Text("Complete Address:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _addressController,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: "Enter full address",
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.isEmpty ? "Address required" : null,
            ),
            const SizedBox(height: 20),
            const Text("Supporting Document (optional):"),
            const SizedBox(height: 8),

            Obx(() {
              final file = supportController.pickedFile.value;
              final isUploading = supportController.isUploading.value;
              final uploadedUrl = supportController.uploadedFileUrl.value;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OutlinedButton.icon(
                    icon: const Icon(Icons.attach_file),
                    label: Text(file?.name ?? "Choose File"),
                    onPressed: supportController.pickFile,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: isUploading ? null : supportController.uploadToCloudinary,
                    icon: const Icon(Icons.cloud_upload),
                    label: Text(isUploading ? "Uploading..." : "Upload"),
                  ),
                  if (uploadedUrl != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text("Uploaded: $uploadedUrl", style: const TextStyle(fontSize: 12)),
                    )
                ],
              );
            }),

            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.highlight,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: _submitForm,
              child: const Text("Submit",style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {

        // Upload file if selected and not uploaded yet
        if (supportController.pickedFile.value != null &&
            supportController.uploadedFileUrl.value == null) {
          await supportController.uploadToCloudinary();
        }

        final uploadedUrl = supportController.uploadedFileUrl.value ?? "";
        final user = userController.userData.value;

        await FirebaseFirestore.instance.collection('support_requests').add({
          'userId': user?.id ?? "anonymous",
          'name': user?.name ?? "Anonymous",
          'email': user?.email ?? "unknown@example.com",
          'description': _descriptionController.text.trim(),
          'address': _addressController.text.trim(),
          'fileUrl': uploadedUrl,
          'status': 'pending',
          'submittedAt': Timestamp.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Submitted successfully!")),
        );

        _descriptionController.clear();
        _addressController.clear();
        supportController.pickedFile.value = null;
        supportController.uploadedFileUrl.value = null;

      } catch (e) {
        Get.snackbar("Error", "Failed to submit: $e");
      }
    }
  }

}

class SupportStatus {
  static const pending = 'pending';
  static const inProgress = 'in_progress';
  static const resolved = 'resolved';
}
