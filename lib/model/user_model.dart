class UserProfile {
   String id;
   String name;
   String email;
   String phoneNumber;
   String whatsappNumber;
   String country;
   String state;
   String district;
   String block;
   String gpWard;
   String villageAddress;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.whatsappNumber,
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
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      whatsappNumber: json['whatsappNumber']?? '',
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
      'email': email,
      'phoneNumber': phoneNumber,
      'whatsappNumber':whatsappNumber,
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
    String? email,
    String? phoneNumber,
    String? whatsappNumber,
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
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      country: country ?? this.country,
      state: state ?? this.state,
      district: district ?? this.district,
      block: block ?? this.block,
      gpWard: gpWard ?? this.gpWard,
      villageAddress: villageAddress ?? this.villageAddress,
    );
  }
}
