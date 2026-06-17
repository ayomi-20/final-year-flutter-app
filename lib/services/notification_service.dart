import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class NotificationService {
  final String baseUrl = AuthService.baseUrl;
  final AuthService _auth = AuthService();

  Future<Map<String, String>> get _authHeaders async {
    final token = await _auth.getToken();
    return {
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, dynamic>> getNotifications({String filter = 'all'}) async {
    try {
      final headers = await _authHeaders;
      final response = await http.get(
        Uri.parse('$baseUrl/notifications?filter=$filter'),
        headers: headers,
      );
      if (response.statusCode == 200) return json.decode(response.body);
      return {'data': []};
    } catch (e) {
      return {'data': []};
    }
  }

  Future<int> getUnreadCount() async {
    try {
      final headers = await _authHeaders;
      final response = await http.get(
        Uri.parse('$baseUrl/notifications/unread-count'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['unread_count'] ?? 0;
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }

  Future<void> markRead(int id) async {
    try {
      final headers = await _authHeaders;
      await http.patch(
        Uri.parse('$baseUrl/notifications/$id/read'),
        headers: headers,
      );
    } catch (_) {}
  }

  Future<void> markAllRead() async {
    try {
      final headers = await _authHeaders;
      await http.patch(
        Uri.parse('$baseUrl/notifications/mark-all-read'),
        headers: headers,
      );
    } catch (_) {}
  }

  Future<void> deleteNotification(int id) async {
    try {
      final headers = await _authHeaders;
      await http.delete(
        Uri.parse('$baseUrl/notifications/$id'),
        headers: headers,
      );
    } catch (_) {}
  }
}