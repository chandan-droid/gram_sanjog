
class News {
  final String newsId;
  final String title;
  final String content;
  final List<String> imageUrls;
  final DateTime timestamp;
  final Location location;
  final String categoryId;
  final String createdBy;
  final String verifiedBy;
  final String status;
  final int likes;
  final int views;

  News({
    required this.newsId,
    required this.title,
    required this.content,
    required this.imageUrls,
    required this.timestamp,
    required this.location,
    required this.categoryId,
    required this.createdBy,
    required this.verifiedBy,
    required this.status,
    this.likes = 0,
    this.views = 0,
  });

  factory News.fromJson(Map<String, dynamic> json) => News(
    newsId: json['newsId'],
    title: json['title'],
    content: json['content'],
    imageUrls: List<String>.from(json['imageUrls']),
    timestamp: DateTime.parse(json['timestamp']),
    location: Location.fromJson(json['location']),
    categoryId: json['categoryId'],
    createdBy: json['createdBy'],
    verifiedBy: json['verifiedBy'],
    status: json['status'],
    likes: json['likes'] ?? 0,
    views: json['views'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'newsId': newsId,
    'title': title,
    'content': content,
    'imageUrls': imageUrls,
    'timestamp': timestamp.toIso8601String(),
    'location': location.toJson(),
    'categoryId': categoryId,
    'createdBy': createdBy,
    'verifiedBy': verifiedBy,
    'status': status,
    'likes': likes,
    'views': views,
  };

  News copyWith({
    String? title,
    String? content,
    List<String>? imageUrls,
    DateTime? timestamp,
    Location? location,
    String? categoryId,
    String? createdBy,
    String? verifiedBy,
    String? status,
    int? likes,
    int? views,
  }) {
    return News(
      newsId: newsId,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrls: imageUrls ?? this.imageUrls,
      timestamp: timestamp ?? this.timestamp,
      location: location ?? this.location,
      categoryId: categoryId ?? this.categoryId,
      createdBy: createdBy ?? this.createdBy,
      verifiedBy: verifiedBy ?? this.verifiedBy,
      status: status ?? this.status,
      likes: likes ?? this.likes,
      views: views ?? this.views,
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