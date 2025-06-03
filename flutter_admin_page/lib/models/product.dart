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

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['good_id'],
      name: json['good_name'],
      article: json['good_article']?.toString() ?? '',
      barcode: json['good_barcode'] ,
      category: json['cat_name']?.toString() ?? '',
      description: json['good_description']?.toString() ?? '',
      brand: json['good_brand']?.toString() ?? "No brand",
      isActive: json['active'],
      isFilled: json['filled'],
      path: json['photo_path']?.toString() ?? ''
    );
  }
}
