import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import 'dart:typed_data';

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

  Future<List<Map<String, dynamic>>> getCategories() async {
  try {
    final headers = await _authHeaders;
    final response = await http.get(
      Uri.parse('$baseUrl/categories'),
      headers: headers,
    );
    final decoded = json.decode(response.body);
    if (decoded is List) {
      return decoded.cast<Map<String, dynamic>>();
    }
    return [];
  } catch (e) {
    return [];
  }
}

  // Step 1: Register business info
Future<Map<String, dynamic>> register(Map<String, String> data) async {
  try {
    final headers = await _authHeaders;
    final response = await http.post(
      Uri.parse('$baseUrl/provider/register'),
      headers: headers,
      body: data,
    );

    print('REGISTER STATUS: ${response.statusCode}');
    print('REGISTER BODY: ${response.body}');

    final decoded = json.decode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 201 || response.statusCode == 200) {
      return decoded;
    } else {
      return {'error': decoded['message'] ?? 'Registration failed (${response.statusCode})'};
    }
  } catch (e) {
    print('REGISTER ERROR: $e');
    return {'error': e.toString()};
  }
}

  // Step 2: Upload documents using PlatformFile (from file_picker)
  Future<Map<String, dynamic>> uploadDocuments({
    PlatformFile? nationalId,
    PlatformFile? tradingLicense,
    PlatformFile? logo,
  }) async {
    final token = await _auth.getToken();
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/provider/documents'),
    );

    request.headers['Accept'] = 'application/json';
    if (token != null) request.headers['Authorization'] = 'Bearer $token';

    if (nationalId?.bytes != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'documents[]',
        nationalId!.bytes!,
        filename: nationalId.name,
      ));
    }

    if (tradingLicense?.bytes != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'documents[]',
        tradingLicense!.bytes!,
        filename: tradingLicense.name,
      ));
    }

    if (logo?.bytes != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'logo',
        logo!.bytes!,
        filename: logo.name,
      ));
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    return json.decode(response.body);
  }

  // Step 3: Submit for review
  Future<Map<String, dynamic>> submit() async {
    final headers = await _authHeaders;
    final response = await http.post(
      Uri.parse('$baseUrl/provider/submit'),
      headers: headers,
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> uploadDocumentsBytes({
  Uint8List? nationalIdBytes,
  String? nationalIdName,
  Uint8List? tradingLicenseBytes,
  String? tradingLicenseName,
  Uint8List? logoBytes,
  String? logoName,
}) async {
  final token = await _auth.getToken();
  final request = http.MultipartRequest(
    'POST',
    Uri.parse('$baseUrl/provider/documents'),
  );

  request.headers['Accept'] = 'application/json';
  if (token != null) request.headers['Authorization'] = 'Bearer $token';

  if (nationalIdBytes != null) {
    request.files.add(http.MultipartFile.fromBytes(
      'documents[]',
      nationalIdBytes,
      filename: nationalIdName ?? 'national_id.jpg',
    ));
  }
  if (tradingLicenseBytes != null) {
    request.files.add(http.MultipartFile.fromBytes(
      'documents[]',
      tradingLicenseBytes,
      filename: tradingLicenseName ?? 'trading_license.jpg',
    ));
  }
  if (logoBytes != null) {
    request.files.add(http.MultipartFile.fromBytes(
      'logo',
      logoBytes,
      filename: logoName ?? 'logo.jpg',
    ));
  }

  final streamed = await request.send();
  final response = await http.Response.fromStream(streamed);
  return json.decode(response.body);
}

Future<Map<String, dynamic>> updateApplication(
    Map<String, String> data) async {
  try {
    final headers = await _authHeaders;
    final response = await http.patch(
      Uri.parse('$baseUrl/provider/update'),
      headers: {
        ...headers,
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );
    return json.decode(response.body);
  } catch (e) {
    return {'error': 'Connection error: $e'};
  }
}
}