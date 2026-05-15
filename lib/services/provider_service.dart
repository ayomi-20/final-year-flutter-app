import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class ProviderService {
  final String baseUrl = AuthService.baseUrl;
  final AuthService _auth = AuthService();

  Future<Map<String, String>> get _authHeaders async {
    final token = await _auth.getToken();
    return {
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ── Step 1: Personal details ───────────────────────────────────────────
  Future<Map<String, dynamic>> registerStep1(Map<String, String> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/provider/register'),
      headers: {'Accept': 'application/json'},
      body: data,
    );
    final res = json.decode(response.body);
    // Save token from step1
    if (res['token'] != null) {
      await _auth.saveToken(res['token']);
    }
    return res;
  }

  // ── Step 2: Business details ───────────────────────────────────────────
  Future<Map<String, dynamic>> registerStep2(Map<String, String> data) async {
    final headers = await _authHeaders;
    final response = await http.post(
      Uri.parse('$baseUrl/provider/step2'),
      headers: headers,
      body: data,
    );
    return json.decode(response.body);
  }

  // ── Step 3: Upload documents (multipart) ──────────────────────────────
  Future<Map<String, dynamic>> uploadDocuments({
    required List<File> documents,
    File? logo,
    File? coverPhoto,
  }) async {
    final token = await _auth.getToken();
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/provider/documents'),
    );

    request.headers['Accept'] = 'application/json';
    if (token != null) request.headers['Authorization'] = 'Bearer $token';

    for (int i = 0; i < documents.length; i++) {
      request.files.add(await http.MultipartFile.fromPath(
        'documents[$i]',
        documents[i].path,
      ));
    }

    if (logo != null) {
      request.files.add(await http.MultipartFile.fromPath('logo', logo.path));
    }
    if (coverPhoto != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'cover_photo',
        coverPhoto.path,
      ));
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    return json.decode(response.body);
  }

  // ── Step 4: Submit for review ──────────────────────────────────────────
  Future<Map<String, dynamic>> submitForReview() async {
    final headers = await _authHeaders;
    final response = await http.post(
      Uri.parse('$baseUrl/provider/submit'),
      headers: headers,
    );
    return json.decode(response.body);
  }

  // ── Provider: get own profile ──────────────────────────────────────────
  Future<Map<String, dynamic>?> getMyProfile() async {
    final headers = await _authHeaders;
    final response = await http.get(
      Uri.parse('$baseUrl/provider/profile'),
      headers: headers,
    );
    if (response.statusCode == 200) return json.decode(response.body);
    return null;
  }
}