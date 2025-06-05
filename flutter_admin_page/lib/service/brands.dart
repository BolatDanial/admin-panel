import 'package:flutter_admin_page/models/brand.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<BrandGet>> fetchBrands() async {
  final url = Uri.http('127.0.0.1:8000', '/admin/brands', {});

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJhZG1pbiIsImV4cCI6MTc0OTEzMjE5OX0.L_FhCe8Dp18Kkntm6M_9B403gCBLT70gdrNyQjXzNpQ',
  };

  try {
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final body = json.decode(utf8.decode(response.bodyBytes));

      if (body is List) {
        return body.map((item) => BrandGet.fromJson(item)).toList();
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

Future<void> postBrand(BrandCreate brand) async {
  final url = Uri.parse('http://127.0.0.1:8000/admin/brands');
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJhZG1pbiIsImV4cCI6MTc0OTEzMjE5OX0.L_FhCe8Dp18Kkntm6M_9B403gCBLT70gdrNyQjXzNpQ',
  };

  final body = jsonEncode({
    "brand_id": brand.id,
    "brand_name": brand.name,
    "brand_keywords": brand.keyWords,
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