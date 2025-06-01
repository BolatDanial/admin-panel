// models/product.dart
class Product {
  final String id;
  final String name;
  final String article;
  final String barcode;
  final String category;
  final String description;
  final int brand;
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
      article: json['good_article'],
      barcode: json['good_barcode'] ,
      category: json['good_category'],
      description: json['good_description'],
      brand: json['good_brand'],
      isActive: json['active'],
      isFilled: json['filled'],
      path: json['photo_path']
    );
  }
}
