import 'package:flutter/cupertino.dart';

class Category {
  final String categoryId;
  final String name;
  final IconData icon;

  Category({
    required this.categoryId,
    required this.name,
    required this.icon,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['categoryId'],
      name: json['name'],
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'name': name,
      'icon': icon,
    };
  }

  Category copyWith({
    String? categoryId,
    String? name,
    IconData? icon,
  }) {
    return Category(
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      icon: icon ?? this.icon,
    );
  }

  @override
  String toString() => 'Category($categoryId, $name)';
}
