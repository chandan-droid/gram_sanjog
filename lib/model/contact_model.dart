class ImportantContact {
  final String name;
  final String phone;

  ImportantContact({
    required this.name,
    required this.phone,
  });

  factory ImportantContact.fromMap(Map<String, dynamic> map) {
    return ImportantContact(
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
    );
  }
}
