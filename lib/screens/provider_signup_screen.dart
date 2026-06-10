import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/provider_service.dart';
import '../services/auth_service.dart';

// Web-only import
import 'upload_helper_stub.dart'
    if (dart.library.html) 'upload_helper_web.dart';

class ProviderSignupScreen extends StatefulWidget {
  const ProviderSignupScreen({super.key});

  @override
  State<ProviderSignupScreen> createState() => _ProviderSignupScreenState();
}



class _ProviderSignupScreenState extends State<ProviderSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _providerService = ProviderService();
  final _auth = AuthService();

  final businessNameController = TextEditingController();
  // final businessTypeController = TextEditingController();
  final districtController = TextEditingController();
  final addressController = TextEditingController();
  final descriptionController = TextEditingController();

  String? _selectedCategoryName;
List<Map<String, dynamic>> _categories = [];
Map<String, dynamic>? _currentUser;
bool _loadingInit = true;

  // Picked files stored as raw bytes + filename
  Uint8List? _nationalIdBytes;
  String? _nationalIdName;

  Uint8List? _tradingLicenseBytes;
  String? _tradingLicenseName;

  Uint8List? _logoBytes;
  String? _logoName;

  bool _submitting = false;

  static const Color green = Color(0xFF0F3B2E);
  static const Color lightGreen = Color(0xFFE3EFE5);

  @override
void initState() {
  super.initState();
  _initScreen();
}

Future<void> _initScreen() async {
  final results = await Future.wait([
    _auth.getUser(),
    _providerService.getCategories(),
  ]);
  setState(() {
    _currentUser = results[0] as Map<String, dynamic>?;
    _categories = results[1] as List<Map<String, dynamic>>;
    _loadingInit = false;
  });
}

  @override
  void dispose() {
    businessNameController.dispose();
    // businessTypeController.dispose();
    districtController.dispose();
    addressController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickFile(String type) async {
    if (kIsWeb) {
      // Use native HTML file input on web
      final picked = await pickFileWeb();
      if (picked == null) return;
      setState(() {
        if (type == 'national_id') {
          _nationalIdBytes = picked.bytes;
          _nationalIdName = picked.name;
        }
        if (type == 'trading_license') {
          _tradingLicenseBytes = picked.bytes;
          _tradingLicenseName = picked.name;
        }
        if (type == 'logo') {
          _logoBytes = picked.bytes;
          _logoName = picked.name;
        }
      });
    } else {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
        withData: true,
      );
      if (result == null || result.files.isEmpty) return;
      final f = result.files.first;
      setState(() {
        if (type == 'national_id') {
          _nationalIdBytes = f.bytes;
          _nationalIdName = f.name;
        }
        if (type == 'trading_license') {
          _tradingLicenseBytes = f.bytes;
          _tradingLicenseName = f.name;
        }
        if (type == 'logo') {
          _logoBytes = f.bytes;
          _logoName = f.name;
        }
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);

    final registerResult = await _providerService.register({
      'business_name': businessNameController.text.trim(),
      'business_type': _selectedCategoryName ?? '',
      'district': districtController.text.trim(),
      'address': addressController.text.trim(),
      'description': descriptionController.text.trim(),
    });

    if (!mounted) return;

    if (registerResult['error'] != null) {
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(registerResult['error'])),
      );
      return;
    }

    if (_nationalIdBytes != null ||
        _tradingLicenseBytes != null ||
        _logoBytes != null) {
      final uploadResult = await _providerService.uploadDocumentsBytes(
        nationalIdBytes: _nationalIdBytes,
        nationalIdName: _nationalIdName,
        tradingLicenseBytes: _tradingLicenseBytes,
        tradingLicenseName: _tradingLicenseName,
        logoBytes: _logoBytes,
        logoName: _logoName,
      );

      if (!mounted) return;

      if (uploadResult['error'] != null) {
        setState(() => _submitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(uploadResult['error'])),
        );
        return;
      }
    }

    await _providerService.submit();

    if (!mounted) return;
    setState(() => _submitting = false);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Application Submitted',
          style: TextStyle(
            fontFamily: 'IBMPlexSerif',
            fontWeight: FontWeight.w700,
            color: green,
          ),
        ),
        content: const Text(
          'Your provider application has been submitted. '
          'Our team will review and approve your account.',
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: green),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGreen,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: green),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Become a Provider',
          style: TextStyle(
            fontFamily: 'IBMPlexSerif',
            fontWeight: FontWeight.w700,
            color: green,
          ),
        ),
      ),
      body: _loadingInit
    ? const Center(child: CircularProgressIndicator(color: green))
    : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1C5E4A), green],
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.storefront_outlined,
                        color: Colors.white, size: 42),
                    SizedBox(height: 14),
                    Text(
                      'Grow Your Tourism Business',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'IBMPlexSerif',
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Join Twende Uganda and connect with thousands '
                      'of tourists looking for amazing experiences.',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              _sectionTitle('Account'),
Padding(
  padding: const EdgeInsets.only(bottom: 16),
  child: TextFormField(
    initialValue: _currentUser?['email'] as String? ?? '',
    readOnly: true,
    decoration: InputDecoration(
      labelText: 'Your Account (Email)',
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      suffixIcon: const Icon(Icons.lock_outline, color: Colors.grey, size: 18),
    ),
    style: const TextStyle(color: Colors.grey),
  ),
),
_sectionTitle('Business Information'),
_inputField('Business Name', businessNameController),
Padding(
  padding: const EdgeInsets.only(bottom: 16),
  child: DropdownButtonFormField<String>(
    value: _selectedCategoryName,
    decoration: InputDecoration(
      labelText: 'Business Type',
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    ),
    hint: const Text('Select business type'),
    items: _categories.map((cat) {
      return DropdownMenuItem<String>(
        value: cat['name'] as String,
        child: Text(cat['name'] as String),
      );
    }).toList(),
    onChanged: (v) => setState(() => _selectedCategoryName = v),
    validator: (v) => v == null ? 'Please select a business type' : null,
  ),
),
              _inputField('District', districtController),
              _inputField('Business Address', addressController),
              _inputField('Business Description', descriptionController,
                  maxLines: 4, required: false),

              const SizedBox(height: 10),

              _sectionTitle('Verification Documents'),

              _UploadBox(
                icon: Icons.badge_outlined,
                title: 'National ID',
                subtitle: 'Upload a clear image of your ID (JPG, PNG, PDF)',
                fileName: _nationalIdName,
                onTap: () => _pickFile('national_id'),
              ),

              _UploadBox(
                icon: Icons.business_outlined,
                title: 'Trading License',
                subtitle: 'Upload your business license (JPG, PNG, PDF)',
                fileName: _tradingLicenseName,
                onTap: () => _pickFile('trading_license'),
              ),

              _UploadBox(
                icon: Icons.photo_camera_outlined,
                title: 'Business Logo or Photo',
                subtitle: 'Upload your logo or business image (JPG, PNG)',
                fileName: _logoName,
                onTap: () => _pickFile('logo'),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: _submitting ? null : _submit,
                  child: _submitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Submit Application',
                          style: TextStyle(
                            fontFamily: 'IBMPlexSerif',
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontFamily: 'IBMPlexSerif',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: green,
          ),
        ),
      ),
    );
  }

  Widget _inputField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    bool required = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: required
            ? (v) => (v == null || v.trim().isEmpty)
                ? 'This field is required'
                : null
            : null,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _UploadBox extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? fileName;
  final VoidCallback onTap;

  static const Color green = Color(0xFF0F3B2E);
  static const Color lightGreen = Color(0xFFE3EFE5);

  const _UploadBox({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.fileName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool picked = fileName != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: picked ? green : Colors.grey.shade300,
          width: picked ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: picked ? green.withOpacity(0.15) : lightGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              picked ? Icons.check_circle_outline : icon,
              color: green,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'IBMPlexSerif',
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: green,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  picked ? fileName! : subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: picked ? green : Colors.grey.shade600,
                    fontSize: 12,
                    fontWeight:
                        picked ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onTap,
            child: Text(
              picked ? 'Change' : 'Upload',
              style: const TextStyle(color: green),
            ),
          ),
        ],
      ),
    );
  }
}