import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // ── Change to your machine IP when testing on a physical device ────────
  // e.g. 'http://192.168.1.100:8000/api'
 static const String baseUrl = 'http://127.0.0.1:8000/api'; // Android emulator
  // static const String baseUrl = 'http://localhost:8000/api'; // iOS simulator

  // ── Token helpers ──────────────────────────────────────────────────────
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> saveUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_user', jsonEncode(user));
  }

  Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('current_user');
    return data != null ? jsonDecode(data) : null;
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('current_user');
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // ── Auth header helper ─────────────────────────────────────────────────
  Future<Map<String, String>> get _authHeaders async {
    final token = await getToken();
    return {
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ── Auth endpoints ─────────────────────────────────────────────────────
  Future<Map<String, dynamic>> register(Map<String, String> data) async {
  try {
    final response = await http
        .post(
          Uri.parse('$baseUrl/register'),
          headers: {
            'Accept': 'application/json',
          },
          body: data,
        )
        .timeout(const Duration(seconds: 15));

    return json.decode(response.body);
  } catch (e) {
    return {
      'message': 'Connection error: $e',
    };
  }
}

  Future<Map<String, dynamic>> login(Map<String, String> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Accept': 'application/json'},
      body: data,
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> verifyLoginOtp(Map<String, String> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/verify-login-otp'),
      headers: {'Accept': 'application/json'},
      body: data,
    );
    final res = json.decode(response.body);
    // Store token and user on success
    if (res['token'] != null) {
      await saveToken(res['token']);
      if (res['user'] != null) await saveUser(res['user']);
    }
    return res;
  }

  Future<Map<String, dynamic>> forgotPassword(Map<String, String> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/forgot-password'),
      headers: {'Accept': 'application/json'},
      body: data,
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> verifyResetCode(Map<String, String> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/verify-reset-code'),
      headers: {'Accept': 'application/json'},
      body: data,
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> resetPassword(Map<String, String> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reset-password'),
      headers: {'Accept': 'application/json'},
      body: data,
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> logout() async {
    final headers = await _authHeaders;
    final response = await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: headers,
    );
    await clearSession();
    return json.decode(response.body);
  }
}