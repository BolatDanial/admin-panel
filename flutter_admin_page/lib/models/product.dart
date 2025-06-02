// models/product.dart
class Product {
  final String id;
  final String name;
  final String article;
  final String barcode;
  final String category;
  final String description;
  final int? brand;
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
    this.brand,
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
      category: json['good_category']?.toString() ?? '',
      description: json['good_description']?.toString() ?? '',
      brand: json['good_brand'] != null ? int.tryParse(json['price'].toString()) : null,
      isActive: json['active'],
      isFilled: json['filled'],
      path: json['photo_path']?.toString() ?? ''
    );
  }
}
