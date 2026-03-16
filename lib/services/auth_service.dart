import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = 'http://localhost:8000/api';

  Future<Map<String, dynamic>> register(Map<String, String> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {"Accept": "application/json"},
      body: data,
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> login(Map<String, String> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {"Accept": "application/json"},
      body: data,
    );
    return json.decode(response.body);
  }

  // Sends email + otp to the new endpoint
  Future<Map<String, dynamic>> verifyLoginOtp(Map<String, String> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/verify-login-otp'),
      headers: {"Accept": "application/json"},
      body: data,
    );
    return json.decode(response.body);
  }

  // Step 1 — send reset OTP to email
Future<Map<String, dynamic>> forgotPassword(Map<String, String> data) async {
  final response = await http.post(
    Uri.parse('$baseUrl/forgot-password'),
    headers: {"Accept": "application/json"},
    body: data,
  );
  return json.decode(response.body);
}

// Step 2 — verify email + contact + OTP
Future<Map<String, dynamic>> verifyResetCode(Map<String, String> data) async {
  final response = await http.post(
    Uri.parse('$baseUrl/verify-reset-code'),
    headers: {"Accept": "application/json"},
    body: data,
  );
  return json.decode(response.body);
}

// Step 3 — submit new password
Future<Map<String, dynamic>> resetPassword(Map<String, String> data) async {
  final response = await http.post(
    Uri.parse('$baseUrl/reset-password'),
    headers: {"Accept": "application/json"},
    body: data,
  );
  return json.decode(response.body);
}
}