import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import '../services/auth_service.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final PageController _pageController = PageController();
  final AuthService authService = AuthService();
  late final AppLinks _appLinks;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  void _initDeepLinks() async {
    _appLinks = AppLinks(
      onAppLink: (Uri uri, String? _) async {
        if (uri.path == '/verify-email') {
          final token = uri.queryParameters['token'];
          if (token != null) {
            final response = await authService.verifyEmail({'token': token});
            if (!mounted) return;

            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text("Verification"),
                content: Text(response['message'] ?? "Verification failed"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _pageController.animateToPage(
                        1,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: const Text("OK"),
                  ),
                ],
              ),
            );
          }
        }
      },
    );

    // Handle the initial app link (if the app started from a link)
    try {
      final Uri? initialUri = await _appLinks.getInitialAppLink();
      if (initialUri != null && initialUri.path == '/verify-email') {
        final token = initialUri.queryParameters['token'];
        if (token != null) {
          final response = await authService.verifyEmail({'token': token});
          if (!mounted) return;

          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Verification"),
              content: Text(response['message'] ?? "Verification failed"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _pageController.animateToPage(
                      1,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      print("Failed to get initial link: $e");
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(18),
        child: PageView(
          controller: _pageController,
          children: [
            RegisterPage(
              onLoginTap: () {
                _pageController.animateToPage(
                  1,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              },
            ),
            LoginPage(
              onForgotTap: () {
                _pageController.animateToPage(
                  2,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              },
            ),
            const ForgotPasswordPage(),
          ],
        ),
      ),
    );
  }
}

class AuthCard extends StatelessWidget {
  final Widget child;

  const AuthCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.all(22),
      child: child,
    );
  }
}

class RegisterPage extends StatefulWidget {
  final VoidCallback onLoginTap;

  const RegisterPage({super.key, required this.onLoginTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();

  bool _isLoading = false;

  void handleRegister() async {
    setState(() {
      _isLoading = true;
    });

    final data = {
      'first_name': firstNameController.text,
      'last_name': lastNameController.text,
      'email': emailController.text,
      'contact': contactController.text,
      'password': passwordController.text,
      'auto_verify': '1'
    };

    final response = await authService.register(data);

    setState(() {
      _isLoading = false;
    });

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Info"),
        content: Text(response['message'] ?? 'Something went wrong'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: AuthCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/register-icon.png', height: 70),
              const SizedBox(height: 16),
              const Text(
                "Register Account",
                style: TextStyle(
                  fontFamily: 'IBMPlexSerif',
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0F3B2E),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Create a new account",
                style: TextStyle(
                  fontFamily: 'IBMPlexSerif',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0F3B2E),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: authField("First name", controller: firstNameController),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: authField("Last name", controller: lastNameController),
                  ),
                ],
              ),
              authField("Email", controller: emailController),
              authField("Contact", controller: contactController),
              authField("Password", controller: passwordController, obscure: true),
              const SizedBox(height: 16),
              authButton(
                "Sign Up",
                onTap: handleRegister,
                loading: _isLoading,
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: widget.onLoginTap,
                child: const Text(
                  "Already have an account?\nLogin",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'IBMPlexSerif',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0F3B2E),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  final VoidCallback onForgotTap;

  const LoginPage({super.key, required this.onForgotTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();
  bool _isLoading = false;

  void handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    final data = {
      'email': emailController.text,
      'password': passwordController.text,
    };

    final response = await authService.login(data);

    setState(() {
      _isLoading = false;
    });

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(response['token'] != null ? "Success" : "Error"),
        content: Text(
          response['token'] != null
              ? "Login successful!"
              : response['message'] ?? "Login failed",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: AuthCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/login-icon.png', height: 70),
              const SizedBox(height: 20),
              const Text(
                "Welcome",
                style: TextStyle(
                  fontFamily: 'IBMPlexSerif',
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0F3B2E),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Sign in to continue",
                style: TextStyle(
                  fontFamily: 'IBMPlexSerif',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0F3B2E),
                ),
              ),
              const SizedBox(height: 20),
              authField("Email", controller: emailController),
              authField("Password", controller: passwordController, obscure: true),
              const SizedBox(height: 16),
              authButton(
                "Sign In",
                onTap: handleLogin,
                loading: _isLoading,
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: widget.onForgotTap,
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(
                    fontFamily: 'IBMPlexSerif',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0F3B2E),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: AuthCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/forgotpassword-icon.png', height: 70),
              const SizedBox(height: 20),
              const Text(
                "Forgot Password?",
                style: TextStyle(
                  fontFamily: 'IBMPlexSerif',
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F3B2E),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Enter your email address and we will send you a password reset code.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'IBMPlexSerif',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0F3B2E),
                ),
              ),
              const SizedBox(height: 20),
              authField("Email"),
              authField("Contact"),
              const SizedBox(height: 16),
              authButton("Send Code"),
            ],
          ),
        ),
      ),
    );
  }
}

Widget authField(
  String hint, {
  TextEditingController? controller,
  bool obscure = false,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Color(0xFF0F3B2E)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontFamily: 'IBMPlexSerif',
          color: Color(0xFF1C5E4A),
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );
}

Widget authButton(
  String text, {
  VoidCallback? onTap,
  bool loading = false,
}) {
  return SizedBox(
    width: double.infinity,
    height: 48,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1C5E4A),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: loading ? null : onTap,
      child: loading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Text(text),
    ),
  );
}