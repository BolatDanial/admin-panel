// models/product.dart
class Category {
  final String id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['cat_id'],
      name: json['cat_name'],
    );
  }
}
