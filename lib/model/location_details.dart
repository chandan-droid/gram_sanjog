class LocationDetails {
  final double latitude;
  final double longitude;
  final String district;
  final String block;
  final String gpWard;
  final String villageStreet;
  final String state;

  LocationDetails({
    required this.latitude,
    required this.longitude,
    required this.district,
    required this.block,
    required this.gpWard,
    required this.villageStreet,
    required this.state,
  });

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'district': district,
      'block': block,
      'gpWard': gpWard,
      'villageStreet': villageStreet,
      'state': state,
    };
  }

  factory LocationDetails.fromJson(Map<String, dynamic> json) {
    return LocationDetails(
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      district: json['district'] as String? ?? '',
      block: json['block'] as String? ?? '',
      gpWard: json['gpWard'] as String? ?? '',
      villageStreet: json['villageStreet'] as String? ?? '',
      state: json['state'] as String? ?? '',
    );
  }
}
