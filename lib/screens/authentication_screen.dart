import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final PageController _pageController = PageController();
  final _pendingEmail = ValueNotifier<String>('');

  void _goTo(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pendingEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(18),
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            // Page 0 — Register
            RegisterPage(
              onRegistered: () => _goTo(1),
            ),
            // Page 1 — Login
            LoginPage(
              onLoginPending: (email) {
                _pendingEmail.value = email;
                _goTo(2);
              },
              onRegisterTap: () => _goTo(0),
              onForgotTap:   () => _goTo(3),
            ),
            // Page 2 — OTP
            OtpPage(
              emailNotifier: _pendingEmail,
              onVerified: () {
                // TODO: push to your HomePage instead
              },
              onBack: () => _goTo(1),
            ),
            // Page 3 — Forgot Password
            ForgotPasswordPage(
              onBack: () => _goTo(1),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────── Auth Card ───────────────────────────
class AuthCard extends StatelessWidget {
  final Widget child;
  const AuthCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          padding: const EdgeInsets.all(22),
          child: child,
        ),
      ),
    );
  }
}

// ─────────────────────────── Register Page ───────────────────────────
class RegisterPage extends StatefulWidget {
  final VoidCallback onRegistered;
  const RegisterPage({super.key, required this.onRegistered});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _firstName = TextEditingController();
  final _lastName  = TextEditingController();
  final _email     = TextEditingController();
  final _contact   = TextEditingController();
  final _password  = TextEditingController();
  final _auth      = AuthService();
  bool _loading    = false;

  void _handleRegister() async {
    setState(() => _loading = true);

    final res = await _auth.register({
      'first_name': _firstName.text,
      'last_name':  _lastName.text,
      'email':      _email.text,
      'contact':    _contact.text,
      'password':   _password.text,
    });

    setState(() => _loading = false);
    if (!mounted) return;

    final bool success = res['message']
        ?.toString()
        .toLowerCase()
        .contains('successful') ?? false;

    _showDialog(
      title: success ? "Registered!" : "Error",
      message: res['message'] ?? 'Something went wrong',
      onOk: success ? widget.onRegistered : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/register-icon.png', height: 70),
          const SizedBox(height: 16),
          const Text("Register Account", style: kHeading),
          const SizedBox(height: 4),
          const Text("Create a new account", style: kSubHeading),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: AuthField(hint: "First name", controller: _firstName)),
            const SizedBox(width: 9),
            Expanded(child: AuthField(hint: "Last name",  controller: _lastName)),
          ]),
          AuthField(hint: "Email", controller: _email),
          AuthField(hint: "Contact",  controller: _contact),
          AuthField(hint: "Password", controller: _password, obscure: true),
          const SizedBox(height: 16),
          authButton("Sign Up", onTap: _handleRegister, loading: _loading),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: widget.onRegistered, // jump straight to login
            child: const Text(
              "Already have an account?  Login",
              style: kLink,
            ),
          ),
        ],
      ),
    );
  }

  void _showDialog({
    required String title,
    required String message,
    VoidCallback? onOk,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onOk?.call();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────── Login Page ───────────────────────────
class LoginPage extends StatefulWidget {
  final void Function(String email) onLoginPending;
  final VoidCallback onRegisterTap;
  final VoidCallback onForgotTap;

  const LoginPage({
    super.key,
    required this.onLoginPending,
    required this.onRegisterTap,
    required this.onForgotTap,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email    = TextEditingController();
  final _password = TextEditingController();
  final _auth     = AuthService();
  bool _loading   = false;

  void _handleLogin() async {
    setState(() => _loading = true);

    final res = await _auth.login({
      'email':    _email.text,
      'password': _password.text,
    });

    setState(() => _loading = false);
    if (!mounted) return;

    // Backend returns 'email' only when credentials are correct
    final String? email = res['email'];

    if (email != null) {
      // Credentials good — move to OTP screen
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Code sent"),
          content: Text(res['message'] ?? 'Check your email for the login code.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onLoginPending(email);
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } else {
      // Credentials wrong
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Error"),
          content: Text(res['message'] ?? 'Login failed.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/login-icon.png', height: 70),
          const SizedBox(height: 20),
          const Text("Welcome", style: kHeading),
          const SizedBox(height: 4),
          const Text("Sign in to continue", style: kSubHeading),
          const SizedBox(height: 20),
          AuthField(hint: "Email",    controller: _email),
          AuthField(hint: "Password", controller: _password, obscure: true),
          const SizedBox(height: 16),
          authButton("Sign In", onTap: _handleLogin, loading: _loading),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: widget.onForgotTap,
            child: const Text("Forgot Password?", style: kLink),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: widget.onRegisterTap,
            child: const Text(
              "Don't have an account?  Register",
              style: kLink,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────── OTP Page ───────────────────────────
class OtpPage extends StatefulWidget {
  final ValueNotifier<String> emailNotifier;
  final VoidCallback onVerified;
  final VoidCallback onBack;

  const OtpPage({
    super.key,
    required this.emailNotifier,
    required this.onVerified,
    required this.onBack,
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _otp   = TextEditingController();
  final _auth  = AuthService();
  bool _loading = false;

  void _handleVerify() async {
    if (_otp.text.trim().length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the 6-digit code')),
      );
      return;
    }

    setState(() => _loading = true);

    final res = await _auth.verifyLoginOtp({
      'email': widget.emailNotifier.value,
      'otp':   _otp.text.trim(),
    });

    setState(() => _loading = false);
    if (!mounted) return;

    final bool success = res['token'] != null;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(success ? "Welcome!" : "Error"),
        content: Text(res['message'] ?? 'Verification failed.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (success) widget.onVerified();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.mark_email_read_outlined,
            size: 70,
            color: Color(0xFF1C5E4A),
          ),
          const SizedBox(height: 16),
          const Text("Check your email", style: kHeading),
          const SizedBox(height: 8),
          ValueListenableBuilder<String>(
            valueListenable: widget.emailNotifier,
            builder: (_, email, __) => Text(
              "We sent a 6-digit code to\n$email",
              textAlign: TextAlign.center,
              style: kSubHeading,
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _otp,
            keyboardType: TextInputType.number,
            maxLength: 6,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 12,
              color: Color(0xFF0F3B2E),
            ),
            decoration: InputDecoration(
              counterText: '',
              hintText: '------',
              hintStyle: const TextStyle(
                letterSpacing: 12,
                color: Color(0xFF1C5E4A),
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 24),
          authButton("Verify", onTap: _handleVerify, loading: _loading),
          const SizedBox(height: 12),
          authButton("Back", onTap: widget.onBack),
        ],
      ),
    );
  }
}

// ─────────────────────────── Forgot Password ───────────────────────────
class ForgotPasswordPage extends StatefulWidget {
  final VoidCallback onBack;

  const ForgotPasswordPage({super.key, required this.onBack});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final PageController _fpController = PageController();
  final _pendingEmail   = ValueNotifier<String>('');
  final _pendingContact = ValueNotifier<String>('');

  void _goToStep(int step) {
    _fpController.animateToPage(
      step,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _fpController.dispose();
    _pendingEmail.dispose();
    _pendingContact.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _fpController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        // Step 0 — enter email & contact to request code
        _ForgotStep1(
          onBack: widget.onBack,
          onCodeSent: (email, contact) {
            _pendingEmail.value   = email;
            _pendingContact.value = contact;
            _goToStep(1);
          },
        ),
        // Step 1 — enter email, contact & the OTP code
        _ForgotStep2(
          emailNotifier:   _pendingEmail,
          contactNotifier: _pendingContact,
          onBack: () => _goToStep(0),
          onVerified: () => _goToStep(2),
        ),
        // Step 2 — enter new password & confirm
        _ForgotStep3(
          emailNotifier:   _pendingEmail,
          contactNotifier: _pendingContact,
          onBack: () => _goToStep(1),
          onDone: widget.onBack, // go back to login when done
        ),
      ],
    );
  }
}

// ── Step 1: Email + Contact → request reset code ──
class _ForgotStep1 extends StatefulWidget {
  final VoidCallback onBack;
  final void Function(String email, String contact) onCodeSent;

  const _ForgotStep1({required this.onBack, required this.onCodeSent});

  @override
  State<_ForgotStep1> createState() => _ForgotStep1State();
}

class _ForgotStep1State extends State<_ForgotStep1> {
  final _email   = TextEditingController();
  final _contact = TextEditingController();
  final _auth    = AuthService();
  bool _loading  = false;

  void _handleSendCode() async {
    if (_email.text.trim().isEmpty || _contact.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in both fields')),
      );
      return;
    }

    setState(() => _loading = true);

    final res = await _auth.forgotPassword({
      'email':   _email.text.trim(),
      'contact': _contact.text.trim(),
    });

    setState(() => _loading = false);
    if (!mounted) return;

    final bool success = res['message']
        ?.toString()
        .toLowerCase()
        .contains('sent') ?? false;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(success ? "Code Sent" : "Error"),
        content: Text(res['message'] ?? 'Something went wrong'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (success) {
                widget.onCodeSent(_email.text.trim(), _contact.text.trim());
              }
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/forgotpassword-icon.png', height: 90),
          const SizedBox(height: 16),
          const Text("Forgot Password?", style: kHeading),
          const SizedBox(height: 8),
          const Text(
            "Enter your email address and we will\nsend your password reset code.",
            textAlign: TextAlign.center,
            style: kSubHeading,
          ),
          const SizedBox(height: 24),
          AuthField(hint: "Email",   controller: _email),
          AuthField(hint: "Contact", controller: _contact),
          authButton("Send code", onTap: _handleSendCode, loading: _loading),
          const SizedBox(height: 12),
          authButton("Back", onTap: widget.onBack),
        ],
      ),
    );
  }
}

// ── Step 2: Email + Contact + Code → verify identity ──
class _ForgotStep2 extends StatefulWidget {
  final ValueNotifier<String> emailNotifier;
  final ValueNotifier<String> contactNotifier;
  final VoidCallback onBack;
  final VoidCallback onVerified;

  const _ForgotStep2({
    required this.emailNotifier,
    required this.contactNotifier,
    required this.onBack,
    required this.onVerified,
  });

  @override
  State<_ForgotStep2> createState() => _ForgotStep2State();
}

class _ForgotStep2State extends State<_ForgotStep2> {
  final _email   = TextEditingController();
  final _contact = TextEditingController();
  final _code    = TextEditingController();
  final _auth    = AuthService();
  bool _loading  = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill from step 1
    _email.text   = widget.emailNotifier.value;
    _contact.text = widget.contactNotifier.value;
  }

  void _handleVerify() async {
    if (_code.text.trim().length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the 6-digit code')),
      );
      return;
    }

    setState(() => _loading = true);

    final res = await _auth.verifyResetCode({
      'email':   _email.text.trim(),
      'contact': _contact.text.trim(),
      'otp':     _code.text.trim(),
    });

    setState(() => _loading = false);
    if (!mounted) return;

    final bool success = res['message']
        ?.toString()
        .toLowerCase()
        .contains('verified') ?? false;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(success ? "Verified" : "Error"),
        content: Text(res['message'] ?? 'Verification failed'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (success) widget.onVerified();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/forgotpassword-icon.png', height: 90),
          const SizedBox(height: 16),
          const Text("Reset Password", style: kHeading),
          const SizedBox(height: 8),
          const Text(
            "Enter your Login credentials\nand your password reset code.",
            textAlign: TextAlign.center,
            style: kSubHeading,
          ),
          const SizedBox(height: 24),
          AuthField(hint: "Email",   controller: _email),
          AuthField(hint: "Contact", controller: _contact),
          AuthField(hint: "Code",    controller: _code),
          authButton("Submit", onTap: _handleVerify, loading: _loading),
          const SizedBox(height: 12),
          authButton("Back", onTap: widget.onBack),
        ],
      ),
    );
  }
}

// ── Step 3: New password + Confirm ──
class _ForgotStep3 extends StatefulWidget {
  final ValueNotifier<String> emailNotifier;
  final ValueNotifier<String> contactNotifier;
  final VoidCallback onBack;
  final VoidCallback onDone;

  const _ForgotStep3({
    required this.emailNotifier,
    required this.contactNotifier,
    required this.onBack,
    required this.onDone,
  });

  @override
  State<_ForgotStep3> createState() => _ForgotStep3State();
}

class _ForgotStep3State extends State<_ForgotStep3> {
  final _newPassword     = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _auth            = AuthService();
  bool _loading          = false;

  void _handleReset() async {
    if (_newPassword.text.isEmpty || _confirmPassword.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in both fields')),
      );
      return;
    }

    if (_newPassword.text != _confirmPassword.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    if (_newPassword.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 6 characters')),
      );
      return;
    }

    setState(() => _loading = true);

    final res = await _auth.resetPassword({
      'email':    widget.emailNotifier.value,
      'contact':  widget.contactNotifier.value,
      'password': _newPassword.text,
    });

    setState(() => _loading = false);
    if (!mounted) return;

    final bool success = res['message']
        ?.toString()
        .toLowerCase()
        .contains('successful') ?? false;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(success ? "Done!" : "Error"),
        content: Text(res['message'] ?? 'Something went wrong'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (success) widget.onDone();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/forgotpassword-icon.png', height: 90),
          const SizedBox(height: 16),
          const Text("Reset Password", style: kHeading),
          const SizedBox(height: 8),
          const Text(
            "Enter your new password\nand confirm it.",
            textAlign: TextAlign.center,
            style: kSubHeading,
          ),
          const SizedBox(height: 24),
          AuthField(hint: "Enter new password", controller: _newPassword, obscure: true),
          AuthField(hint: "Confirm password", controller: _confirmPassword, obscure: true),
          authButton("Submit", onTap: _handleReset, loading: _loading),
          const SizedBox(height: 12),
          authButton("Back", onTap: widget.onBack),
        ],
      ),
    );
  }
}

// ─────────────────────────── Shared Styles ───────────────────────────
const kHeading = TextStyle(
  fontFamily: 'IBMPlexSerif',
  fontSize: 28,
  fontWeight: FontWeight.w500,
  color: Color(0xFF0F3B2E),
);

const kSubHeading = TextStyle(
  fontFamily: 'IBMPlexSerif',
  fontSize: 18,
  fontWeight: FontWeight.w500,
  color: Color(0xFF0F3B2E),
);

const kLink = TextStyle(
  fontFamily: 'IBMPlexSerif',
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: Color(0xFF0F3B2E),
);

// ─────────────────────────── UI Helpers ───────────────────────────
class AuthField extends StatefulWidget {
  final String hint;
  final TextEditingController? controller;
  final bool obscure;

  const AuthField({
    super.key,
    required this.hint,
    this.controller,
    this.obscure = false,
  });

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscure;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: widget.controller,
        obscureText: _obscureText,
        enableSuggestions: false,
        autocorrect: false,
        style: const TextStyle(color: Color(0xFF0F3B2E)),
        decoration: InputDecoration(
          hintText: widget.hint,
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

          // 👁 Eye icon
          suffixIcon: widget.obscure
              ? IconButton(
                  icon: Icon(
                    _obscureText
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: const Color(0xFF1C5E4A),
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
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