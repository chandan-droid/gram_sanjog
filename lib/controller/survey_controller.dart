import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/survey_model.dart';
import '../model/location_details.dart';
import '../service/location_helper.dart';
import 'upload_cloudinary/survey_attachment_controller.dart';

class SurveyController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final attachmentController = Get.put(SurveyAttachmentController());

  final RxList<SurveyModel> surveys = <SurveyModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final currentLocation = Rxn<LocationDetails>();

  @override
  void onInit() {
    super.onInit();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    try {
      final location = await LocationHelper.getCurrentLocation();
      currentLocation.value = location;
    } catch (e) {
      errorMessage.value = 'Failed to get location: $e';
    }
  }

  Future<void> refreshLocation() async {
    try {
      final location = await LocationHelper.getCurrentLocation();
      currentLocation.value = location;
    } catch (e) {
      errorMessage.value = 'Failed to get location: $e';
      Get.snackbar(
        'Error',
        'Failed to update location: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> addSurvey({
    required String citizenName,
    required String phoneNumber,
    required String aadharNumber,
    required String landmark,
    required String notes,
    required String surveyorId,
    required String category,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Get current location
      if (currentLocation.value == null) {
        await _initializeLocation();
      }

      if (currentLocation.value == null) {
        throw 'Unable to get location details';
      }

      final location = currentLocation.value!;

      // Get uploaded attachment URLs
      final attachmentUrls = attachmentController.uploadedFileUrls;
      if (attachmentUrls.isEmpty) {
        throw 'Please upload at least one photo';
      }

      // Create survey document with enhanced location details
      DocumentReference docRef = _firestore.collection('surveys').doc();
      final survey = SurveyModel(
        id: docRef.id,
        citizenName: citizenName,
        phoneNumber: phoneNumber,
        aadharNumber: aadharNumber,
        location: LocationDetails(
          area: location.area,
          city: location.city,
          state: location.state,
          pincode: location.pincode,
          landmark: landmark,
          latitude: location.latitude,
          longitude: location.longitude,
          geohash: location.geohash,
          block: location.block,
          district: location.district,
          address: location.address,
        ),
        attachmentUrls: attachmentUrls.toList(),
        notes: notes,
        surveyorId: surveyorId,
        createdAt: DateTime.now(),
        category: category,
        status: 'pending',
      );

      // Convert to JSON and save
      final data = survey.toJson();
      print('Saving survey data: $data');
      await docRef.set(data);

      // Refresh the surveys list
      await fetchSurveys(surveyorId);

      // Clear attachments after successful upload
      attachmentController.clearUploads();

      Get.back();
      Get.snackbar(
        'Success',
        'Survey added successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error adding survey: $e');
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to add survey: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSurveys(String surveyorId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      print('Fetching surveys for surveyorId: $surveyorId');

      final QuerySnapshot snapshot = await _firestore
          .collection('surveys')
          .where('surveyorId', isEqualTo: surveyorId)
          .get();

      print('Found ${snapshot.docs.length} surveys');

      final List<SurveyModel> fetchedSurveys = [];
      for (var doc in snapshot.docs) {
        try {
          final data = doc.data() as Map<String, dynamic>;
          print('Processing survey document: ${doc.id}');
          print('Document data: $data');

          // Ensure the ID is included in the data
          if (!data.containsKey('id')) {
            data['id'] = doc.id;
          }

          final survey = SurveyModel.fromJson(data);
          fetchedSurveys.add(survey);
        } catch (e) {
          print('Error processing survey document ${doc.id}: $e');
          continue;
        }
      }

      surveys.value = fetchedSurveys;
      print('Successfully loaded ${surveys.length} surveys');

    } catch (e) {
      print('Error fetching surveys: $e');
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load surveys: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateSurveyStatus(String surveyId, String status) async {
    try {
      await _firestore.collection('surveys').doc(surveyId).update({
        'status': status,
      });
      await fetchSurveys(surveys.firstWhere((s) => s.id == surveyId).surveyorId);
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to update survey status',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
