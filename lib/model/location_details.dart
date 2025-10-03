class LocationDetails {
  final String area;
  final String city;
  final String state;
  final String pincode;
  final String landmark;
  final double latitude;
  final double longitude;
  final String geohash;
  final String block;
  final String district;
  final String? address;

  LocationDetails({
    required this.area,
    required this.city,
    required this.state,
    required this.pincode,
    required this.landmark,
    required this.latitude,
    required this.longitude,
    required this.geohash,
    required this.block,
    required this.district,
    this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'area': area,
      'city': city,
      'state': state,
      'pincode': pincode,
      'landmark': landmark,
      'latitude': latitude,
      'longitude': longitude,
      'geohash': geohash,
      'block': block,
      'district': district,
      'address': address,
    };
  }

  factory LocationDetails.fromJson(Map<String, dynamic> json) {
    return LocationDetails(
      area: json['area'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      pincode: json['pincode'] as String,
      landmark: json['landmark'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      geohash: json['geohash'] as String,
      block: json['block'] as String,
      district: json['district'] as String,
      address: json['address'] as String?,
    );
  }

  @override
  String toString() {
    return '$area, $city, $district, $state - $pincode';
  }
}
