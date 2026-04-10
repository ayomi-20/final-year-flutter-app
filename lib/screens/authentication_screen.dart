import 'package:flutter/material.dart';
import '../services/auth_service.dart';

// ─── Background images per auth step ───
const _kAuthBg = 'assets/images/auth_bg.png';
const _kForgotBg = 'assets/images/forgot_bg.png';

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
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // Page 0 — Register
          RegisterPage(onRegistered: () => _goTo(1)),
          // Page 1 — Login
          LoginPage(
            onLoginPending: (email) {
              _pendingEmail.value = email;
              _goTo(2);
            },
            onRegisterTap: () => _goTo(0),
            onForgotTap: () => _goTo(3),
          ),
          // Page 2 — OTP
          OtpPage(
            emailNotifier: _pendingEmail,
            onVerified: () {
              // TODO: push to HomePage
            },
            onBack: () => _goTo(1),
          ),
          // Page 3 — Forgot Password
          ForgotPasswordPage(onBack: () => _goTo(1)),
        ],
      ),
    );
  }
}

// ─────────────────── Auth Card (glass overlay) ───────────────────
class AuthCard extends StatelessWidget {
  final Widget child;
  final String bgImage;
  const AuthCard({
    super.key,
    required this.child,
    this.bgImage = _kAuthBg,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background photo
        Image.asset(bgImage, fit: BoxFit.cover),

        // Dark gradient overlay
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0x880F3B2E),
                Color(0xF00F3B2E),
              ],
              stops: [0.0, 1.0],
            ),
          ),
        ),

        // Scrollable card content
        SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.40),
                  ),
                ),
                child: child,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────── Register Page ───────────────────
class RegisterPage extends StatefulWidget {
  final VoidCallback onRegistered;
  const RegisterPage({super.key, required this.onRegistered});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _contact = TextEditingController();
  final _password = TextEditingController();
  final _auth = AuthService();
  bool _loading = false;

  void _handleRegister() async {
    setState(() => _loading = true);

    final res = await _auth.register({
      'first_name': _firstName.text,
      'last_name': _lastName.text,
      'email': _email.text,
      'contact': _contact.text,
      'password': _password.text,
    });

    setState(() => _loading = false);
    if (!mounted) return;

    final bool success =
        res['message']?.toString().toLowerCase().contains('successful') ??
            false;

    _showDialog(
      title: success ? 'Registered!' : 'Error',
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
          const _AuthHeader(
            title: 'Register Account',
            subtitle: 'Create a new account',
          ),
          const SizedBox(height: 15),
          Row(
              children: [
                Expanded(
                  child: LabeledField(
                    label: 'First Name',
                    field: AuthField(controller: _firstName, hint: 'John'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: LabeledField(
                    label: 'Last Name',
                    field: AuthField(controller: _lastName, hint: 'Doe'),
                  ),
                ),
              ],
            ),

            LabeledField(
              label: 'Email Address',
              field: AuthField(controller: _email, hint: 'john.doe@example.com'),
            ),

            // 📞 Contact field with country code
            LabeledField(
              label: 'Contact',
              field: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F3F2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('+256'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AuthField(
                      controller: _contact,
                      hint: '770 000000',
                    ),
                  ),
                ],
              ),
            ),

            LabeledField(
              label: 'Password',
              field: AuthField(
                controller: _password,
                hint: '********',
                obscure: true,
              ),
            ),
          const SizedBox(height: 8),
          authButton('Sign Up →', onTap: _handleRegister, loading: _loading),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: widget.onRegistered,
            child: const Text(
              'Already have an account?  Login',
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
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

// ─────────────────── Login Page ───────────────────
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
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _auth = AuthService();
  bool _loading = false;

  void _handleLogin() async {
    setState(() => _loading = true);

    final res = await _auth.login({
      'email': _email.text,
      'password': _password.text,
    });

    setState(() => _loading = false);
    if (!mounted) return;

    final String? email = res['email'];

    if (email != null) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Code sent'),
          content:
              Text(res['message'] ?? 'Check your email for the login code.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onLoginPending(email);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: Text(res['message'] ?? 'Login failed.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
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
          const _AuthHeader(
            icon: Icons.lock_open_rounded,
            title: 'Welcome Back',
            subtitle: 'Sign in to continue',
          ),
          const SizedBox(height: 20),
          AuthField(hint: 'Email', controller: _email),
          AuthField(hint: 'Password', controller: _password, obscure: true),
          const SizedBox(height: 8),
          authButton('Sign In →', onTap: _handleLogin, loading: _loading),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: widget.onForgotTap,
            child: const Text('Forgot Password?', style: kLink),
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

// ─────────────────── OTP Page ───────────────────
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
  final _otp = TextEditingController();
  final _auth = AuthService();
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
      'otp': _otp.text.trim(),
    });

    setState(() => _loading = false);
    if (!mounted) return;

    final bool success = res['token'] != null;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(success ? 'Welcome!' : 'Error'),
        content: Text(res['message'] ?? 'Verification failed.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (success) widget.onVerified();
            },
            child: const Text('OK'),
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
            size: 64,
            color: Colors.white,
          ),
          const SizedBox(height: 12),
          const Text('Check your email', style: kHeading),
          const SizedBox(height: 6),
          ValueListenableBuilder<String>(
            valueListenable: widget.emailNotifier,
            builder: (_, email, __) => Text(
              'We sent a 6-digit code to\n$email',
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
              color: Colors.white,
            ),
            decoration: InputDecoration(
              counterText: '',
              hintText: '------',
              hintStyle: TextStyle(
                letterSpacing: 12,
                color: Colors.white.withOpacity(0.4),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.white.withOpacity(0.25),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.white.withOpacity(0.25),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          authButton('Verify Code →',
              onTap: _handleVerify, loading: _loading),
          const SizedBox(height: 10),
          authButton('Back', onTap: widget.onBack, outlined: true),
        ],
      ),
    );
  }
}

// ─────────────────── Forgot Password ───────────────────
class ForgotPasswordPage extends StatefulWidget {
  final VoidCallback onBack;
  const ForgotPasswordPage({super.key, required this.onBack});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final PageController _fpController = PageController();
  final _pendingEmail = ValueNotifier<String>('');
  final _pendingContact = ValueNotifier<String>('');

  void _goToStep(int step) => _fpController.animateToPage(
        step,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );

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
        _ForgotStep1(
          onBack: widget.onBack,
          onCodeSent: (email, contact) {
            _pendingEmail.value = email;
            _pendingContact.value = contact;
            _goToStep(1);
          },
        ),
        _ForgotStep2(
          emailNotifier: _pendingEmail,
          contactNotifier: _pendingContact,
          onBack: () => _goToStep(0),
          onVerified: () => _goToStep(2),
        ),
        _ForgotStep3(
          emailNotifier: _pendingEmail,
          contactNotifier: _pendingContact,
          onBack: () => _goToStep(1),
          onDone: widget.onBack,
        ),
      ],
    );
  }
}

// ── Step 1: Send code ──
class _ForgotStep1 extends StatefulWidget {
  final VoidCallback onBack;
  final void Function(String email, String contact) onCodeSent;
  const _ForgotStep1({required this.onBack, required this.onCodeSent});

  @override
  State<_ForgotStep1> createState() => _ForgotStep1State();
}

class _ForgotStep1State extends State<_ForgotStep1> {
  final _email = TextEditingController();
  final _contact = TextEditingController();
  final _auth = AuthService();
  bool _loading = false;

  void _handleSendCode() async {
    if (_email.text.trim().isEmpty || _contact.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in both fields')),
      );
      return;
    }

    setState(() => _loading = true);
    final res = await _auth.forgotPassword({
      'email': _email.text.trim(),
      'contact': _contact.text.trim(),
    });
    setState(() => _loading = false);
    if (!mounted) return;

    final bool success =
        res['message']?.toString().toLowerCase().contains('sent') ?? false;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(success ? 'Code Sent' : 'Error'),
        content: Text(res['message'] ?? 'Something went wrong'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (success) {
                widget.onCodeSent(
                    _email.text.trim(), _contact.text.trim());
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthCard(
      bgImage: _kForgotBg,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _AuthHeader(
            icon: Icons.lock_reset_rounded,
            title: 'Forgot Password?',
            subtitle:
                'Enter your email address and we will\nsend your password reset code.',
          ),
          const SizedBox(height: 20),
          AuthField(hint: 'Email', controller: _email),
          AuthField(hint: 'Contact', controller: _contact),
          authButton('Send Code →',
              onTap: _handleSendCode, loading: _loading),
          const SizedBox(height: 10),
          authButton('Back', onTap: widget.onBack, outlined: true),
        ],
      ),
    );
  }
}

// ── Step 2: Verify code ──
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
  final _email = TextEditingController();
  final _contact = TextEditingController();
  final _code = TextEditingController();
  final _auth = AuthService();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _email.text = widget.emailNotifier.value;
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
      'email': _email.text.trim(),
      'contact': _contact.text.trim(),
      'otp': _code.text.trim(),
    });
    setState(() => _loading = false);
    if (!mounted) return;

    final bool success =
        res['message']?.toString().toLowerCase().contains('verified') ?? false;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(success ? 'Verified' : 'Error'),
        content: Text(res['message'] ?? 'Verification failed'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (success) widget.onVerified();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthCard(
      bgImage: _kForgotBg,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _AuthHeader(
            icon: Icons.verified_user_rounded,
            title: 'Verify Code',
            subtitle:
                'Enter your login credentials\nand your password reset code.',
          ),
          const SizedBox(height: 20),
          AuthField(hint: 'Email', controller: _email),
          AuthField(hint: 'Contact', controller: _contact),
          AuthField(hint: 'Code', controller: _code),
          authButton('Verify Code →',
              onTap: _handleVerify, loading: _loading),
          const SizedBox(height: 10),
          authButton('Back', onTap: widget.onBack, outlined: true),
        ],
      ),
    );
  }
}

// ── Step 3: Reset password ──
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
  final _newPassword = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _auth = AuthService();
  bool _loading = false;

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
        const SnackBar(
            content: Text('Password must be at least 6 characters')),
      );
      return;
    }

    setState(() => _loading = true);
    final res = await _auth.resetPassword({
      'email': widget.emailNotifier.value,
      'contact': widget.contactNotifier.value,
      'password': _newPassword.text,
    });
    setState(() => _loading = false);
    if (!mounted) return;

    final bool success =
        res['message']?.toString().toLowerCase().contains('successful') ??
            false;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(success ? 'Done!' : 'Error'),
        content: Text(res['message'] ?? 'Something went wrong'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (success) widget.onDone();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthCard(
      bgImage: _kForgotBg,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _AuthHeader(
            icon: Icons.lock_rounded,
            title: 'Reset Password',
            subtitle: 'Enter your new password\nand confirm it.',
          ),
          const SizedBox(height: 20),
          AuthField(
              hint: 'Enter new password',
              controller: _newPassword,
              obscure: true),
          AuthField(
              hint: 'Confirm password',
              controller: _confirmPassword,
              obscure: true),
          authButton('Submit →', onTap: _handleReset, loading: _loading),
          const SizedBox(height: 10),
          authButton('Back', onTap: widget.onBack, outlined: true),
          const SizedBox(height: 10),
          const Text('You can now log in  Login', style: kLink),
        ],
      ),
    );
  }
}

// ─────────────────── Shared Styles ───────────────────
const kHeading = TextStyle(
  fontFamily: 'IBMPlexSerif',
  fontSize: 26,
  fontWeight: FontWeight.w700,
  color: Color(0xFF0F3B2E), // dark green
);

const kSubHeading = TextStyle(
  fontFamily: 'IBMPlexSerif',
  fontSize: 15,
  fontWeight: FontWeight.w400,
  color: Colors.black54, // softer text
);

const kLink = TextStyle(
  fontFamily: 'IBMPlexSerif',
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: Color(0xFF0F3B2E),
  decoration: TextDecoration.underline,
);

// ─────────────────── Auth Header Widget ───────────────────
class _AuthHeader extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String subtitle;

  const _AuthHeader({
  this.icon,
  required this.title,
  required this.subtitle,
});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 56, color: const Color(0xFF0F3B2E)),
          const SizedBox(height: 12),
        ],
        Text(title, style: kHeading, textAlign: TextAlign.center),
        const SizedBox(height: 6),
        Text(subtitle, style: kSubHeading, textAlign: TextAlign.center),
      ],
    );
  }
}

// ─────────────────── Labeled Field ───────────────────
class LabeledField extends StatelessWidget {
  final String label;
  final Widget field;

  const LabeledField({
    super.key,
    required this.label,
    required this.field,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F3B2E),
            ),
          ),
          const SizedBox(height: 6),
          field,
        ],
      ),
    );
  }
}

// ─────────────────── Auth Field ───────────────────
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
      padding: const EdgeInsets.only(bottom: 16),
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
          color: Colors.grey,
          fontWeight: FontWeight.w400,
          fontSize: 14,
          ),
          filled: true,
          fillColor: const Color(0xFFF1F3F2),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(color: Colors.white.withOpacity(0.25)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(color: Colors.white.withOpacity(0.25)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white, width: 1.5),
          ),
          suffixIcon: widget.obscure
              ? IconButton(
                  icon: Icon(
                    _obscureText
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.white54,
                    size: 20,
                  ),
                  onPressed: () =>
                      setState(() => _obscureText = !_obscureText),
                )
              : null,
        ),
      ),
    );
  }
}

// ─────────────────── Auth Button ───────────────────
Widget authButton(
  String text, {
  VoidCallback? onTap,
  bool loading = false,
  bool outlined = false,
}) {
  return SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor:
          outlined ? Colors.transparent : const Color(0xFF0F3B2E),

        foregroundColor:
        Colors.white,
            elevation: 0,
            side: outlined
                ? const BorderSide(color: Colors.white54)
                : BorderSide.none,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
      onPressed: loading ? null : onTap,
      child: loading
          ? SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Text(
              text,
              style: TextStyle(
                fontFamily: 'IBMPlexSerif',
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: outlined ? Colors.white : const Color(0xFF0F3B2E),
              ),
            ),
    ),
  );
}