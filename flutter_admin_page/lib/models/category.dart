// models/product.dart
import 'package:flutter/material.dart';

class CategoryGet {
  final String id;
  final String name;
  final String parent;

  CategoryGet({
    required this.id,
    required this.name,
    required this.parent
  });

  factory CategoryGet.fromJson(Map<String, dynamic> json) {
    return CategoryGet(
      id: json['cat_id'],
      name: json['cat_name'],
      parent: json['cat_parent']
    );
  }
}

class CategoryCreate {
  final String name;
  final String parent;
  final String keywords;
  final String photo;
  final String badKeywords;

  CategoryCreate({
    required this.name,
    required this.parent,
    required this.keywords,
    required this.photo,
    required this.badKeywords
  });
}
