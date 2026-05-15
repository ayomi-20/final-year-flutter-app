import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class ReviewService {
  final String baseUrl = AuthService.baseUrl;
  final AuthService _auth = AuthService();

  Future<Map<String, String>> get _authHeaders async {
    final token = await _auth.getToken();
    return {
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, dynamic>> submitReview(Map<String, dynamic> data) async {
    final headers = await _authHeaders;
    final response = await http.post(
      Uri.parse('$baseUrl/tourist/reviews'),
      headers: {...headers, 'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> getServiceReviews(
    int serviceId, {
    int page = 1,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/services/$serviceId/reviews?page=$page'),
      headers: {'Accept': 'application/json'},
    );
    if (response.statusCode == 200) return json.decode(response.body);
    return {'data': []};
  }
}