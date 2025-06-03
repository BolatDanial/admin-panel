import 'package:flutter_admin_page/models/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<ProductGet>> fetchProducts({String? emptyField, String? category, String? search}) async {
  final queryParams = {
    if (emptyField != "No" && emptyField != null) 'emptyField': emptyField,
    if (category != "All" && category != null) 'category': category,
    if (search != "" && search != null) 'search': search,
  };

  final url = Uri.http('127.0.0.1:8000', '/admin/products', queryParams);

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJhZG1pbiIsImV4cCI6MTc0ODk2MjgzOX0.rYBsyAjOabAIV88_CUUz03Qh-5Sh0O6SLqefdhIfKi4',
  };

  try {
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final body = json.decode(utf8.decode(response.bodyBytes));

      if (body is List) {
        return body.map((item) => ProductGet.fromJson(item)).toList();
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

Future<void> postProduct(ProductCreate product) async {
  final url = Uri.parse('http://127.0.0.1:8000/admin/products');
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJhZG1pbiIsImV4cCI6MTc0ODk2MjgzOX0.rYBsyAjOabAIV88_CUUz03Qh-5Sh0O6SLqefdhIfKi4',
  };

  final body = jsonEncode({
    "good_id": product.id,
    "good_name": product.name,
    "good_article": product.article,
    "good_barcode": product.barcode,
    "good_description": product.description,
    "photo_path": "@",
    "good_category": product.category,
    "good_brand": product.brand
  });

  try {
    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Request failed: Error: $e');
  }
}

Future<void> deleteProduct(String id) async {
  final url = Uri.parse('http://127.0.0.1:8000/admin/products/$id');
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJhZG1pbiIsImV4cCI6MTc0ODk2MjgzOX0.rYBsyAjOabAIV88_CUUz03Qh-5Sh0O6SLqefdhIfKi4',
  };

  try {
    final response = await http.delete(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Request failed: Error: $e');
  }
}