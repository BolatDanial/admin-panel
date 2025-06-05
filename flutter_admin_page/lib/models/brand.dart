// models/product.dart
class BrandGet {
  final int id;
  final String name;

  BrandGet({
    required this.id,
    required this.name,
  });

  factory BrandGet.fromJson(Map<String, dynamic> json) {
    return BrandGet(
      id: json['brand_id'],
      name: json['brand_name'],
    );
  }
}

class BrandCreate {
  final int id;
  final String name;
  final List<String> keyWords;

  BrandCreate({
    required this.id,
    required this.name,
    required this.keyWords,
  });
}
