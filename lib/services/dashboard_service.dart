import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class DashboardService {
  final String baseUrl = AuthService.baseUrl;
  final AuthService _auth = AuthService();

  Future<Map<String, String>> get _authHeaders async {
    final token = await _auth.getToken();
    return {
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ── Public home data ───────────────────────────────────────────────────
  Future<Map<String, dynamic>> getHomeData() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/home'),
        headers: {'Accept': 'application/json'},
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return {};
    } catch (e) {
      return {};
    }
  }

  // ── Services list ──────────────────────────────────────────────────────
  Future<Map<String, dynamic>> getServices({
    String? category,
    String? region,
    String? search,
    String sort = 'popular',
    int page = 1,
  }) async {
    try {
      final params = <String, String>{
        'sort': sort,
        'page': page.toString(),
        if (category != null) 'category': category,
        if (region != null) 'region': region,
        if (search != null) 'search': search,
      };

      final uri = Uri.parse('$baseUrl/services').replace(queryParameters: params);
      final response = await http.get(uri, headers: {'Accept': 'application/json'});

      if (response.statusCode == 200) return json.decode(response.body);
      return {'data': []};
    } catch (e) {
      return {'data': []};
    }
  }

  // ── Single service ─────────────────────────────────────────────────────
  Future<Map<String, dynamic>?> getService(String slug) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/services/$slug'),
        headers: {'Accept': 'application/json'},
      );
      if (response.statusCode == 200) {
        return json.decode(response.body)['service'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // ── Tourist stats ──────────────────────────────────────────────────────
  Future<Map<String, dynamic>> getTouristStats() async {
    try {
      final headers = await _authHeaders;
      final response = await http.get(
        Uri.parse('$baseUrl/tourist/stats'),
        headers: headers,
      );
      if (response.statusCode == 200) return json.decode(response.body);
      return {};
    } catch (e) {
      return {};
    }
  }

  // ── Provider stats ─────────────────────────────────────────────────────
  Future<Map<String, dynamic>> getProviderStats() async {
    try {
      final headers = await _authHeaders;
      final response = await http.get(
        Uri.parse('$baseUrl/provider/stats'),
        headers: headers,
      );
      if (response.statusCode == 200) return json.decode(response.body);
      return {};
    } catch (e) {
      return {};
    }
  }

  // ── System/Admin stats ─────────────────────────────────────────────────
  Future<Map<String, dynamic>> getSystemStats() async {
    try {
      final headers = await _authHeaders;
      final response = await http.get(
        Uri.parse('$baseUrl/system/stats'),
        headers: headers,
      );
      if (response.statusCode == 200) return json.decode(response.body);
      return {};
    } catch (e) {
      return {};
    }
  }

  Future<Map<String, dynamic>> getAdminStats() async {
    try {
      final headers = await _authHeaders;
      final response = await http.get(
        Uri.parse('$baseUrl/admin/stats'),
        headers: headers,
      );
      if (response.statusCode == 200) return json.decode(response.body);
      return {};
    } catch (e) {
      return {};
    }
  }
}