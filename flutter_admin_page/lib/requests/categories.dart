import 'package:flutter_admin_page/models/category.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Category>> fetchCategories() async {
  final url = Uri.http('127.0.0.1:8000', '/admin/categories', {});

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJhZG1pbiIsImV4cCI6MTc0ODk2MjgzOX0.rYBsyAjOabAIV88_CUUz03Qh-5Sh0O6SLqefdhIfKi4',
  };

  try {
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final body = json.decode(utf8.decode(response.bodyBytes));

      if (body is List) {
        return body.map((item) => Category.fromJson(item)).toList();
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
