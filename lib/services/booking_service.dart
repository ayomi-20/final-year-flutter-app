import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class BookingService {
  final String baseUrl = AuthService.baseUrl;
  final AuthService _auth = AuthService();

  Future<Map<String, String>> get _authHeaders async {
    final token = await _auth.getToken();
    return {
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ── Tourist: create booking ────────────────────────────────────────────
  Future<Map<String, dynamic>> createBooking(Map<String, String> data) async {
    final headers = await _authHeaders;
    final response = await http.post(
      Uri.parse('$baseUrl/tourist/bookings'),
      headers: headers,
      body: data,
    );
    return json.decode(response.body);
  }

  // ── Tourist: my bookings ───────────────────────────────────────────────
  Future<Map<String, dynamic>> getMyBookings({int page = 1}) async {
    final headers = await _authHeaders;
    final response = await http.get(
      Uri.parse('$baseUrl/tourist/bookings?page=$page'),
      headers: headers,
    );
    if (response.statusCode == 200) return json.decode(response.body);
    return {'data': []};
  }

  // ── Tourist: cancel booking ────────────────────────────────────────────
  Future<Map<String, dynamic>> cancelBooking(
    int bookingId, {
    String? reason,
  }) async {
    final headers = await _authHeaders;
    final response = await http.patch(
      Uri.parse('$baseUrl/tourist/bookings/$bookingId/cancel'),
      headers: {...headers, 'Content-Type': 'application/json'},
      body: jsonEncode({'reason': reason}),
    );
    return json.decode(response.body);
  }

  // ── Provider: update booking status ───────────────────────────────────
  Future<Map<String, dynamic>> updateBookingStatus(
    int bookingId,
    String status, {
    String? reason,
  }) async {
    final headers = await _authHeaders;
    final response = await http.patch(
      Uri.parse('$baseUrl/provider/bookings/$bookingId'),
      headers: {...headers, 'Content-Type': 'application/json'},
      body: jsonEncode({'status': status, 'reason': reason}),
    );
    return json.decode(response.body);
  }
}