import 'package:flutter/material.dart';

class ProviderSignupScreen extends StatefulWidget {
  const ProviderSignupScreen({super.key});

  @override
  State<ProviderSignupScreen> createState() =>
      _ProviderSignupScreenState();
}

class _ProviderSignupScreenState
    extends State<ProviderSignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController businessNameController =
      TextEditingController();

  final TextEditingController businessTypeController =
      TextEditingController();

  final TextEditingController districtController =
      TextEditingController();

  final TextEditingController addressController =
      TextEditingController();

  final TextEditingController descriptionController =
      TextEditingController();

  bool _submitting = false;

  static const Color green = Color(0xFF0F3B2E);
  static const Color lightGreen = Color(0xFFE3EFE5);

  Future<void> submitApplication() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _submitting = true;
    });

    // TODO:
    // Connect to backend API later

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _submitting = false;
    });

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          "Application Submitted",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: green,
          ),
        ),
        content: const Text(
          "Your provider application has been submitted successfully. "
          "Our team will review and approve your account.",
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: green,
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text(
              "OK",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: green,
          ),
        ),
      ),
    );
  }

  Widget inputField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "This field is required";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget uploadBox({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: lightGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: green,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          TextButton(
            onPressed: () {
              // TODO:
              // File picker later
            },
            child: const Text(
              "Upload",
              style: TextStyle(color: green),
            ),
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
          icon: const Icon(
            Icons.arrow_back,
            color: green,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Become a Provider",
          style: TextStyle(
            color: green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              // HEADER CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF1C5E4A),
                      green,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.storefront_outlined,
                      color: Colors.white,
                      size: 42,
                    ),

                    SizedBox(height: 14),

                    Text(
                      "Grow Your Tourism Business",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),

                    SizedBox(height: 8),

                    Text(
                      "Join Twende Uganda and connect "
                      "with thousands of tourists looking "
                      "for amazing experiences.",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // BUSINESS INFO
              sectionTitle("Business Information"),

              inputField(
                label: "Business Name",
                controller: businessNameController,
              ),

              inputField(
                label: "Business Type",
                controller: businessTypeController,
              ),

              inputField(
                label: "District",
                controller: districtController,
              ),

              inputField(
                label: "Business Address",
                controller: addressController,
              ),

              inputField(
                label: "Business Description",
                controller: descriptionController,
                maxLines: 4,
              ),

              const SizedBox(height: 10),

              // VERIFICATION
              sectionTitle("Verification Documents"),

              uploadBox(
                icon: Icons.badge_outlined,
                title: "National ID",
                subtitle:
                    "Upload a clear image of your ID",
              ),

              uploadBox(
                icon: Icons.business_outlined,
                title: "Trading License",
                subtitle:
                    "Upload your business license",
              ),

              uploadBox(
                icon: Icons.photo_camera_outlined,
                title: "Business Logo or Photo",
                subtitle:
                    "Upload your logo or business image",
              ),

              const SizedBox(height: 30),

              // SUBMIT BUTTON
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(16),
                    ),
                  ),
                  onPressed:
                      _submitting ? null : submitApplication,
                  child: _submitting
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Submit Application",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
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
}