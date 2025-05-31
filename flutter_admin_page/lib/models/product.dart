// models/product.dart
class Product {
  final String id;
  final String name;
  final String article;
  final String barcode;
  final String category;
  final String description;
  final String brand;
  final bool isActive;
  final bool isFilled;
  final String path;

  Product({
    required this.id,
    required this.name,
    required this.article,
    required this.barcode,
    required this.category,
    required this.description,
    required this.brand,
    required this.isActive,
    required this.isFilled,
    required this.path,
  });
}
