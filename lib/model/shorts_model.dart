import 'package:cloud_firestore/cloud_firestore.dart';

class NewsShort {
  final String id; // Unique ID for the short
  final String videoUrl; // Cloudinary or YouTube video link
  final String caption; // Combined headline + description
  final String categoryId; // e.g., Politics, Sports
  final String createdBy; // Publisher or reporter name
  final DateTime timestamp; // When it was published
  final List<String> tags; // Hashtags like #Election2025
  final bool isVerified;
  final String? verifiedBy;

  // Future-use fields:
  // final int likes;
  // final int views;
  // final int commentsCount;
  // final bool isSaved;

  NewsShort({
    required this.id,
    required this.videoUrl,
    required this.caption,
    required this.categoryId,
    required this.createdBy,
    required this.timestamp,
    required this.tags,
    this.isVerified = false,
    this.verifiedBy,
    // this.likes = 0,
    // this.views = 0,
    // this.commentsCount = 0,
    // this.isSaved = false,
  });

  factory NewsShort.fromMap(Map<String, dynamic> data, String docId) {
    return NewsShort(
      id: docId,
      videoUrl: data['videoUrl'] ?? '',
      caption: data['caption'] ?? '',
      categoryId: data['categoryId'] ?? '',
      createdBy: data['source'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      tags: List<String>.from(data['tags'] ?? []),
      isVerified: data['isVerified'] ?? false,
      verifiedBy: data['verifiedBy'], // ✅ READ from Firestore
      // likes: data['likes'] ?? 0,
      // views: data['views'] ?? 0,
      // commentsCount: data['commentsCount'] ?? 0,
      // isSaved: data['isSaved'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'videoUrl': videoUrl,
      'caption': caption,
      'categoryId': categoryId,
      'source': createdBy,
      'timestamp': timestamp,
      'tags': tags,
      'isVerified': isVerified,
      'verifiedBy': verifiedBy, // ✅ WRITE to Firestore
      // 'likes': likes,
      // 'views': views,
      // 'commentsCount': commentsCount,
      // 'isSaved': isSaved,
    };
  }
}
