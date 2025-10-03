import 'package:cloud_firestore/cloud_firestore.dart';
import 'location_details.dart';

class SurveyModel {
  final String id;
  final String citizenName;
  final String phoneNumber;
  final String aadharNumber;
  final LocationDetails location;
  final List<String> attachmentUrls;
  final String notes;
  final String surveyorId;
  final DateTime createdAt;
  final String category;
  final String status;

  SurveyModel({
    required this.id,
    required this.citizenName,
    required this.phoneNumber,
    required this.aadharNumber,
    required this.location,
    required this.attachmentUrls,
    required this.notes,
    required this.surveyorId,
    required this.createdAt,
    required this.category,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'citizenName': citizenName,
      'phoneNumber': phoneNumber,
      'aadharNumber': aadharNumber,
      'location': location.toJson(),
      'attachmentUrls': attachmentUrls,
      'notes': notes,
      'surveyorId': surveyorId,
      'createdAt': Timestamp.fromDate(createdAt),
      'category': category,
      'status': status,
    };
  }

  factory SurveyModel.fromJson(Map<String, dynamic> json) {
    return SurveyModel(
      id: json['id'] as String,
      citizenName: json['citizenName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      aadharNumber: json['aadharNumber'] as String,
      location: LocationDetails.fromJson(json['location'] as Map<String, dynamic>),
      attachmentUrls: List<String>.from(json['attachmentUrls']),
      notes: json['notes'] as String,
      surveyorId: json['surveyorId'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      category: json['category'] as String,
      status: json['status'] as String,
    );
  }
}
