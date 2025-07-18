import 'package:flutter/cupertino.dart';

class Category {
  final String categoryId;
  final String name;

  Category({
    required this.categoryId,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['categoryId'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'name': name,
    };
  }

  Category copyWith({
    String? categoryId,
    String? name,
  }) {
    return Category(
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
    );
  }

  @override
  String toString() => 'Category($categoryId, $name)';
}
