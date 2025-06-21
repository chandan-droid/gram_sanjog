class UserProfile {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;

  final String country;
  final String state;
  final String district;
  final String block;
  final String gpWard;
  final String villageAddress;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.country,
    required this.state,
    required this.district,
    required this.block,
    required this.gpWard,
    required this.villageAddress,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['mailId'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      country: json['country'] ?? '',
      state: json['state'] ?? '',
      district: json['district'] ?? '',
      block: json['block'] ?? '',
      gpWard: json['gpWard'] ?? '',
      villageAddress: json['villageAddress'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'mailId': email,
      'phoneNumber': phoneNumber,
      'country': country,
      'state': state,
      'district': district,
      'block': block,
      'gpWard': gpWard,
      'villageAddress': villageAddress,
    };
  }

  UserProfile copyWith({
    String? id,
    String? name,
    String? mailId,
    String? phoneNumber,
    String? country,
    String? state,
    String? district,
    String? block,
    String? gpWard,
    String? villageAddress,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: mailId ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      country: country ?? this.country,
      state: state ?? this.state,
      district: district ?? this.district,
      block: block ?? this.block,
      gpWard: gpWard ?? this.gpWard,
      villageAddress: villageAddress ?? this.villageAddress,
    );
  }
}
