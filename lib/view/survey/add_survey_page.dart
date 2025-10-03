import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../common/theme/theme.dart';
import '../../controller/survey_controller.dart';
import '../../controller/auth/auth_controller.dart';
import '../../controller/location_controller.dart';
import '../../controller/upload_cloudinary/survey_attachment_controller.dart';

class AddSurveyPage extends StatefulWidget {
  const AddSurveyPage({Key? key}) : super(key: key);

  @override
  State<AddSurveyPage> createState() => _AddSurveyPageState();
}

class _AddSurveyPageState extends State<AddSurveyPage> {
  final _formKey = GlobalKey<FormState>();
  final _surveyController = Get.put(SurveyController());
  final _authController = Get.find<AuthController>();
  final _locationController = Get.find<LocationController>();
  final _attachmentController = Get.find<SurveyAttachmentController>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _aadharController = TextEditingController();
  final _notesController = TextEditingController();
  final _landmarkController = TextEditingController();

  String _selectedCategory = 'Health';
  final List<String> _categories = ['Health', 'Education', 'Infrastructure', 'Social Welfare', 'Other'];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _aadharController.dispose();
    _notesController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text('Add Citizen Survey', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Citizen Details'),
                _buildTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  validator: (v) => v?.isEmpty ?? true ? 'Name is required' : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  validator: (v) => v?.length != 10 ? 'Enter valid phone number' : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _aadharController,
                  label: 'Aadhar Number',
                  keyboardType: TextInputType.number,
                  maxLength: 12,
                  validator: (v) => v?.length != 12 ? 'Enter valid Aadhar number' : null,
                ),
                const SizedBox(height: 24),

                _buildSectionTitle('Category'),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCategory,
                      isExpanded: true,
                      items: _categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedCategory = value);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                _buildSectionTitle('Location Details'),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border.withOpacity(0.5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(
                        controller: _landmarkController,
                        label: 'Landmark*',
                        validator: (v) => v?.isEmpty ?? true ? 'Landmark is required' : null,
                      ),
                      const SizedBox(height: 16),
                      Obx(() {
                        final location = _surveyController.currentLocation.value;
                        if (location == null) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLocationDetail('Area', location.area),
                            _buildLocationDetail('Block', location.block),
                            _buildLocationDetail('District', location.district),
                            _buildLocationDetail('City', location.city),
                            _buildLocationDetail('State', location.state),
                            _buildLocationDetail('PIN', location.pincode),
                            const Divider(height: 24),
                            _buildLocationDetail(
                              'Coordinates',
                              '${location.latitude.toStringAsFixed(6)}, ${location.longitude.toStringAsFixed(6)}',
                            ),
                            if (location.address != null)
                              _buildLocationDetail('Address', location.address!),
                          ],
                        );
                      }),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: _surveyController.refreshLocation,
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Refresh Location'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.accent,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                _buildSectionTitle('Attachments'),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Obx(() {
                        if (_attachmentController.uploadedFileUrls.isNotEmpty) {
                          return Column(
                            children: [
                              SizedBox(
                                height: 100,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _attachmentController.uploadedFileUrls.length,
                                  padding: const EdgeInsets.all(8),
                                  itemBuilder: (context, index) {
                                    final url = _attachmentController.uploadedFileUrls[index];
                                    return Stack(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(right: 8),
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            image: DecorationImage(
                                              image: NetworkImage(url),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 8,
                                          child: IconButton(
                                            icon: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.black.withOpacity(0.5),
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                            ),
                                            onPressed: () => _attachmentController.removeUploadedFile(url),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              const Divider(),
                            ],
                          );
                        }
                        return const SizedBox();
                      }),
                      Obx(() => Column(
                        children: [
                          if (_attachmentController.pickedFile.value != null)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Selected: ${_attachmentController.pickedFile.value!.name}',
                                style: TextStyle(color: AppColors.textSecondary),
                              ),
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton.icon(
                                onPressed: _attachmentController.isUploading.value
                                    ? null
                                    : _attachmentController.pickFile,
                                icon: const Icon(Icons.photo_camera),
                                label: const Text('Take Photo'),
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.accent,
                                  padding: const EdgeInsets.all(16),
                                ),
                              ),
                              if (_attachmentController.pickedFile.value != null)
                                TextButton.icon(
                                  onPressed: _attachmentController.isUploading.value
                                      ? null
                                      : _attachmentController.uploadToCloudinary,
                                  icon: _attachmentController.isUploading.value
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        )
                                      : const Icon(Icons.upload),
                                  label: Text(
                                    _attachmentController.isUploading.value
                                        ? 'Uploading...'
                                        : 'Upload',
                                  ),
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColors.accent,
                                    padding: const EdgeInsets.all(16),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                _buildSectionTitle('Additional Notes'),
                _buildTextField(
                  controller: _notesController,
                  label: 'Notes',
                  maxLines: 4,
                ),
                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  child: Obx(() => ElevatedButton(
                    onPressed: _surveyController.isLoading.value
                        ? null
                        : () {
                            if (_formKey.currentState?.validate() ?? false) {
                              if (_attachmentController.uploadedFileUrls.isEmpty) {
                                Get.snackbar(
                                  'Error',
                                  'Please add at least one photo',
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                                return;
                              }

                              _surveyController.addSurvey(
                                citizenName: _nameController.text,
                                phoneNumber: _phoneController.text,
                                aadharNumber: _aadharController.text,
                                landmark: _landmarkController.text,
                                notes: _notesController.text,
                                surveyorId: _authController.firebaseUser.value?.id ?? '',
                                category: _selectedCategory,
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _surveyController.isLoading.value
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Submit Survey',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  )),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    int? maxLength,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.accent, width: 2),
        ),
      ),
    );
  }

  Widget _buildLocationDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
