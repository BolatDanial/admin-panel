import 'package:flutter_admin_page/models/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Product>> fetchProducts() async {
  final url = Uri.parse('http://127.0.0.1:8080/admin/products');

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJhZG1pbiIsImV4cCI6MTc0ODg0NTI2Nn0.D1K_-dQdBAurbOAkfJgNYlaMhRt1Zm0BvgL69R7g50I',
  };

  try {
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final body = json.decode(utf8.decode(response.bodyBytes));

      if (body is List) {
        return body.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception('Unexpected response format: expected a list');
      }
    } else {
      throw Exception('Failed with status code: ${response.statusCode}\nBody: ${response.body}');
    }
  } catch (e) {
    throw Exception('Error fetching products: $e');
  }
}
