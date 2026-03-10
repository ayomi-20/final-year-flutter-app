import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // ⚡ This is where you put your Laravel backend URLs
  final String baseUrl = 'http://192.168.1.20:8000/api/';

  // Registration endpoint
  Future<Map<String, dynamic>> register(Map<String, String> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'), // <-- Here is your registration URL
      headers: {
  "Accept": "application/json",
},
      body: data,
    );
    return json.decode(response.body);
  }

  // Login endpoint
  Future<Map<String, dynamic>> login(Map<String, String> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'), // <-- Here is your login URL
      headers: {
  "Accept": "application/json",
},
      body: data,
    );
    return json.decode(response.body);
  }

  // Verify email endpoint
   Future<Map<String, dynamic>> verifyEmail(Map<String, String> data) async {

    final response = await http.post(
      Uri.parse("$baseUrl/verify-email"),
      body: data,
    );

    return jsonDecode(response.body);
  }
}