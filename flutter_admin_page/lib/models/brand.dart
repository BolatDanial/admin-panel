// models/product.dart
class Brand {
  final int id;
  final String name;

  Brand({
    required this.id,
    required this.name,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['brand_id'],
      name: json['brand_name'],
    );
  }
}
