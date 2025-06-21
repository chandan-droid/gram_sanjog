import 'package:cloud_firestore/cloud_firestore.dart';

class News {
  final String newsId;
  final String title;
  final String? subHeading;
  final String description;
  final List<String> imageUrls;
  final List<String> videoUrls;
  final DateTime? timestamp;
  final Location? location;
  final LocationDetails? locationDetails;
  final String? categoryId;
  final String? createdBy;
  final String? updatedBy;
  final String? updatedAt;
  final String? verifiedBy;
  final String? status;
   int? likes;
   int? views;
  int? shares;
  // final List<Report> reports;
  // final List<Source> sources;
  // final String subcategory;
  // final String contentType;

  News( {
    required this.newsId,
    required this.title,
    this.subHeading,
    required this.description,
    required this.imageUrls,
    required this.videoUrls,
    this.timestamp,
    this.location,
    required this.locationDetails,
    required this.categoryId,
    this.createdBy,
    this.updatedBy,
    this.updatedAt,
    this.verifiedBy,
    this.status,
    this.likes = 0,
    this.views = 0,
    this.shares = 0,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      newsId: json['newsId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subHeading: json['subHeading'] as String? ?? '',
      description: json['description'] as String? ?? '',
      categoryId: json['categoryId'] as String? ?? '',
      createdBy: json['createdBy'] as String? ?? '',
      imageUrls: (json['imageUrls'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      videoUrls: (json['videoUrls'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      location: json['location'] != null
          ? Location.fromJson(json['location'] as Map<String, dynamic>)
          : null,
      locationDetails: json['locationDetails'] != null
          ? LocationDetails.fromJson(json['locationDetails'] as Map<String, dynamic>)
          : null,
      views: json['views'] as int? ?? 0,
      likes: json['likes'] as int? ?? 0,
      shares: json['shares'] as int? ?? 0,
      status: json['status'] as String? ?? '',
      timestamp: (json['timestamp'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toJson() => {
    'newsId': newsId,
    'title': title,
    'subHeading': subHeading,
    'content': description,
    'imageUrls': imageUrls,
    'timestamp': timestamp?.toIso8601String(),
    'location': location?.toJson(),
    'locationDetails': locationDetails?.toJson(),
    'categoryId': categoryId,
    'createdBy': createdBy,
    'verifiedBy': verifiedBy,
    'status': status,
    'likes': likes,
    'views': views,
    'shares': shares,
  };

  News copyWith({
    String? newsId,
    String? title,
    String? subHeading,
    String? content,
    List<String>? imageUrls,
    List<String>? videoUrls,
    DateTime? timestamp,
    Location? location,
    LocationDetails? locationDetails,
    String? categoryId,
    String? createdBy,
    String? verifiedBy,
    String? status,
    int? likes,
    int? views,
    int? shares,
  }) {
    return News(
      newsId: newsId ?? this.newsId,
      title: title ?? this.title,
      subHeading: subHeading ?? this.subHeading,
      description: content ?? this.description,
      imageUrls: imageUrls ?? this.imageUrls,
      videoUrls: videoUrls ?? this.videoUrls,
      timestamp: timestamp ?? this.timestamp,
      location: location ?? this.location,
      locationDetails: locationDetails ?? this.locationDetails,
      categoryId: categoryId ?? this.categoryId,
      createdBy: createdBy ?? this.createdBy,
      verifiedBy: verifiedBy ?? this.verifiedBy,
      status: status ?? this.status,
      likes: likes ?? this.likes,
      views: views ?? this.views,
      shares: shares ?? this.shares,
    );
  }

  @override
  String toString() => 'News($title, $status, $views views)';
}


class GeoPoint {
  final double lat;
  final double lng;

  GeoPoint({required this.lat, required this.lng});

  factory GeoPoint.fromJson(Map<String, dynamic> json) => GeoPoint(
    lat: json['lat'].toDouble(),
    lng: json['lng'].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'lat': lat,
    'lng': lng,
  };
}

class Location {
  final GeoPoint geopoint;
  final String geohash;

  Location({required this.geopoint, required this.geohash});

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    geopoint: GeoPoint.fromJson(json['geopoint']),
    geohash: json['geohash'],
  );

  Map<String, dynamic> toJson() => {
    'geopoint': geopoint.toJson(),
    'geohash': geohash,
  };
}

class LocationDetails {
  final String country;
  final String state;
  final String district;
  final String block;
  final String gp;
  final String? village;

  LocationDetails( {
    required this.country,
    required this.state,
    required this.district,
    required this.block,
    required this.gp,
    this.village,
  });

  factory LocationDetails.fromJson(Map<String, dynamic> json) {
    return LocationDetails(
      country: json['country'] ?? '',
      state: json['state'] ?? '',
      district: json['district'] ?? '',
      block: json['block'] ?? '',
      gp: json['gp'] ?? '',
      village: json['village']??''
    );
  }

  Map<String, dynamic> toJson() => {
    'country': country,
    'state': state,
    'district': district,
    'block': block,
    'gp': gp,
    'village':village
  };
}
