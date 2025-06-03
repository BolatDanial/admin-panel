import 'package:flutter_admin_page/models/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Product>> fetchProducts({String? emptyField, String? category}) async {
  final queryParams = {
    if (emptyField != "No" && emptyField != null) 'emptyField': emptyField,
    if (category != "All" && category != null) 'category': category,
  };

  final url = Uri.http('127.0.0.1:8000', '/admin/products', queryParams);

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJhZG1pbiIsImV4cCI6MTc0ODg4MTc3M30.4eWewTH84JyFkFX8-yyqWT_GcxPLceZnWUwDtx637ak',
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
