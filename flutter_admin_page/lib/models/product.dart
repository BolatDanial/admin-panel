// models/product.dart
class ProductGet {
  final String id;
  final String name;
  final String article;
  final String barcode;
  final String category;
  final String description;
  final String brand;
  final String path;

  ProductGet({
    required this.id,
    required this.name,
    required this.article,
    required this.barcode,
    required this.category,
    required this.description,
    required this.brand,
    required this.path,
  });

  factory ProductGet.fromJson(Map<String, dynamic> json) {
    return ProductGet(
      id: json['good_id'],
      name: json['good_name'],
      article: json['good_article']?.toString() ?? '',
      barcode: json['good_barcode'] ,
      category: json['cat_name']?.toString() ?? '',
      description: json['good_description']?.toString() ?? '',
      brand: json['brand_name']?.toString() ?? "No brand",
      path: json['photo_path']?.toString() ?? ''
    );
  }
}

class ProductCreate {
  final String id;
  final String name;
  final String article;
  final String barcode;
  final String category;
  final String description;
  final int brand;
  final String path;

  ProductCreate({
    required this.id,
    required this.name,
    required this.article,
    required this.barcode,
    required this.category,
    required this.description,
    required this.brand,
    required this.path,
  });
}
