import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

// ─── Background images per auth step ───
const _kAuthBg = 'assets/images/auth_bg.png';
// const _kForgotBg = 'assets/images/forgot_bg.png';
const _kLoginBg = 'assets/images/login_bg.png';
const _kForgotStep1Bg = 'assets/images/forgotpassword_bg.png';
const _kVerifyBg = 'assets/images/verify_code_bg.png';
const _kResetBg = 'assets/images/crested-crane.jpg';

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
// ─────────────────── Auth Card (glass overlay) ───────────────────
class AuthCard extends StatelessWidget {
  final Widget child;
  final String bgImage;
  final Widget? header;
  final bool solidOverlay;
  final Widget? footer;
  const AuthCard({
    super.key,
    required this.child,
    this.bgImage = _kAuthBg,
    this.header,
    this.solidOverlay = false,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(bgImage, fit: BoxFit.cover),
        SafeArea(
          child: Column(
            children: [
              if (header != null)
                Padding(
                  // Standard padding (allows specific pages to override if they wrap their content)
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 20),
                  child: header!,
                ),

              // 🔥 Overlay (centered)
              Expanded(
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: solidOverlay
                          ? const Color(0xFF0F3B2E).withOpacity(0.65)
                          : Colors.white.withOpacity(0.45),
                      borderRadius: BorderRadius.circular(24),
                      border: solidOverlay
                          ? null
                          : Border.all(color: Colors.white.withOpacity(0.40)),
                    ),
                    child: child,
                  ),
                ),
              ),

              // Footer
              if (footer != null)
                Padding(
                  // Standard padding
                  padding: const EdgeInsets.only(bottom: 24),
                  child: footer!,
                ),
            ],
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
  final _contactFocus = FocusNode();

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
      header: const _AuthHeader(
        // ← move header here
        title: 'Register Account',
        subtitle: 'Create a new account',
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ← remove the _AuthHeader and its SizedBox from here
          const SizedBox(height: 8), // small top breathing room
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
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    '+256',
                    style: TextStyle(
                      color: Color(0xFF0F3B2E),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: TextField(
                      controller: _contact,
                      focusNode: _contactFocus, // ✅ YOU ADD THIS
                      style: const TextStyle(color: Color(0xFF0F3B2E)),
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.phone,
                      readOnly: false,
                      decoration: InputDecoration(
                        hintText: '770 000000',
                        hintStyle: const TextStyle(
                          fontFamily: 'IBMPlexSerif',
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
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
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
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
              keyboardType: TextInputType.text,
            ),
          ),
          const SizedBox(height: 8),
          authButton('Sign Up →', onTap: _handleRegister, loading: _loading),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Already have an account? ',
                style: TextStyle(
                  fontFamily: 'IBMPlexSerif',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 58, 58, 58),
                  shadows: [
                    Shadow(
                      blurRadius: 6,
                      color: Colors.black26,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: widget.onRegistered,
                child: const Text('Login', style: kLink),
              ),
            ],
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

  @override
  void dispose() {
    _contactFocus.dispose();
    super.dispose();
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
// ______________________________ Login ________________________ //
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
          content: Text(
            res['message'] ?? 'Check your email for the login code.',
          ),
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
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Background Image
          Image.asset(_kLoginBg, fit: BoxFit.cover),

          // 2. Content Layout
          SafeArea(
            child: Stack(
              children: [
                // HEADER: Manually positioned lower down
                Positioned(
                  top: 75, // Moves header DOWN towards the overlay
                  left: 24,
                  right: 24,
                  child: const _AuthHeader(
                    showIcon: false,
                    title: 'Welcome Back',
                    subtitle: 'Sign in to continue',
                    light: true,
                  ),
                ),

                // GREEN OVERLAY: Manually positioned higher up
                // Using Align with -0.2 moves it 20% up the screen
                Align(
                  alignment: const Alignment(0, -0.05),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F3B2E).withOpacity(0.65),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 4),
                        LabeledField(
                          label: 'Email',
                          labelColor: Colors.white,
                          field: AuthField(
                              hint: 'john.doe@example.com',
                              controller: _email),
                        ),
                        LabeledField(
                          label: 'Password',
                          labelColor: Colors.white,
                          field: AuthField(
                            hint: '********',
                            controller: _password,
                            obscure: true,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: widget.onForgotTap,
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        authButton('Sign In →',
                            onTap: _handleLogin, loading: _loading),
                      ],
                    ),
                  ),
                ),

                // FOOTER: Manually positioned higher up
                Positioned(
                  bottom: 120, // Moves footer UP towards the overlay
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          fontFamily: 'IBMPlexSerif',
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.onRegisterTap,
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            fontFamily: 'IBMPlexSerif',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
        const SnackBar(content: Text('Please enter 6-digit code')),
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
              Navigator.pop(context); // Close the dialog
              
              if (success) {
                // NAVIGATE TO HOME SCREEN DIRECTLY FROM HERE
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
                
                // Optional: Call parent callback if it does any cleanup
                widget.onVerified(); 
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handleResend() async {
    // Note: You may need to implement a 'resendLoginOtp' method in your AuthService
    // or call the login method again if your backend supports it without password re-entry.
    
    setState(() => _loading = true);
    
    // Mocking API call for UI demonstration
    // await _auth.resendOtp({'email': widget.emailNotifier.value}); 
    await Future.delayed(const Duration(seconds: 1));

    setState(() => _loading = false);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Code sent')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Background Image
          Image.asset(_kAuthBg, fit: BoxFit.cover),

          // 2. Content Layout
          SafeArea(
            child: Stack(
              children: [
                // HEADER: Positioned at top
                Positioned(
                  top: 200,
                  left: 24,
                  right: 24,
                  child: Column(
                    children: [
                      Text(
                        'Check your email',
                        style: kHeading.copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      ValueListenableBuilder<String>(
                        valueListenable: widget.emailNotifier,
                        builder: (_, email, _) => Text(
                          'We sent a 6-digit code to\n$email',
                          textAlign: TextAlign.center,
                          style: kSubHeading.copyWith(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),

                // GREEN OVERLAY: Centered
                Align(
                  alignment: const Alignment(0, 0.2),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F3B2E).withOpacity(0.65),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // OTP Input Field (White box on green overlay)
                        TextField(
                          controller: _otp,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F3B2E),
                            letterSpacing: 4,
                          ),
                          decoration: InputDecoration(
                            hintText: '------',
                            hintStyle: TextStyle(
                              letterSpacing: 4,
                              color: Colors.grey.shade400,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.25)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.25)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.white, width: 1.5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        authButton('Verify Code →',
                            onTap: _handleVerify, loading: _loading),
                      ],
                    ),
                  ),
                ),

                // FOOTER: Positioned at bottom
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 160),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Didn't receive code? ",
                          style: TextStyle(
                            fontFamily: 'IBMPlexSerif',
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: _loading ? null : _handleResend,
                          child: Text(
                            'Resend',
                            style: TextStyle(
                              fontFamily: 'IBMPlexSerif',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: _loading ? Colors.white54 : Colors.white,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// Forgot Password 
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
                widget.onCodeSent(_email.text.trim(), _contact.text.trim());
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
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Background Image
          Image.asset(_kForgotStep1Bg, fit: BoxFit.cover),

          // 2. Content Layout
          SafeArea(
            child: Stack(
              children: [
                // HEADER: Manually positioned lower down (closer to overlay)
                Positioned(
                  top: 80, // Adjusted to be lower than default top padding
                  left: 24,
                  right: 24,
                  child: _AuthHeader(
                    showIcon: false,
                    title: 'Forgot Password?',
                    subtitle:
                        'Enter your email address and we will\nsend your password reset code.',
                    light: true, // Makes description text white
                  ),
                ),

                // GREEN OVERLAY: Centered
                Align(
                  alignment: const Alignment(0, 0.1), // Slightly lower to center visually with new header pos
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F3B2E).withOpacity(0.65), // Green Overlay
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Email Field
                        LabeledField(
                          label: 'Email',
                          labelColor: Colors.white, // Label needs to be white on green
                          field: AuthField(
                            hint: 'john.doe@example.com',
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),

                        // Contact Field
                        LabeledField(
                          label: 'Contact',
                          labelColor: Colors.white,
                          field: AuthField(
                            hint: '+256 770 000000',
                            controller: _contact,
                            keyboardType: TextInputType.phone,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Green Button
                        authButton('Send Code →',
                            onTap: _handleSendCode, loading: _loading),
                      ],
                    ),
                  ),
                ),

                // FOOTER: Positioned below the green overlay
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Remember your password?',
                          style: TextStyle(
                            fontFamily: 'IBMPlexSerif',
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: widget.onBack,
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontFamily: 'IBMPlexSerif',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
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

  // Logic to handle verification
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

  // Logic to resend code
  void _handleResend() async {
    setState(() => _loading = true);
    final res = await _auth.forgotPassword({
      'email': _email.text.trim(),
      'contact': _contact.text.trim(),
    });
    setState(() => _loading = false);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(res['message'] ?? 'Code sent')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Background Image
          Image.asset(_kVerifyBg, fit: BoxFit.cover),

          // 2. Content Layout
          SafeArea(
            child: Stack(
              children: [
                // HEADER
                Positioned(
                  top: 60,
                  left: 24,
                  right: 24,
                  child: _AuthHeader(
                    showIcon: false,
                    title: 'Verify Code',
                    subtitle:
                        'Enter the six - digit code sent to your\nemail/direct contact to proceed.',
                    light: true,
                  ),
                ),

                // GREEN OVERLAY
                Align(
                  alignment: const Alignment(0, 0.25),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 247, 248, 248).withOpacity(0.45),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Reset Code Field
                        LabeledField(
                          label: 'Reset Code',
                          labelColor: Colors.white,
                          field: AuthField(
                            hint: '------',
                            controller: _code,
                            keyboardType: TextInputType.number,
                          ),
                        ),

                        // Email Field
                        LabeledField(
                          label: 'Email',
                          labelColor: Colors.white,
                          field: AuthField(
                            hint: 'john.doe@example.com',
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),

                        // Contact Field
                        LabeledField(
                          label: 'Contact',
                          labelColor: Colors.white,
                          field: AuthField(
                            hint: '+256 770 000000',
                            controller: _contact,
                            keyboardType: TextInputType.phone,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Verify Button
                        authButton('Verify Code →',
                            onTap: _handleVerify, loading: _loading),
                      ],
                    ),
                  ),
                ),

                // FOOTER
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 70),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Didn't receive a code? ",
                          style: TextStyle(
                            fontFamily: 'IBMPlexSerif',
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: _loading ? null : _handleResend,
                          child: Text(
                            'Resend',
                            style: TextStyle(
                              fontFamily: 'IBMPlexSerif',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: _loading ? Colors.white54 : Colors.white,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
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
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Background Image
          Image.asset(_kResetBg, fit: BoxFit.cover),

          // 2. Content Layout
          SafeArea(
            child: Stack(
              children: [
                // HEADER
                Positioned(
                  top: 70,
                  left: 24,
                  right: 24,
                  child: _AuthHeader(
                    showIcon: false,
                    title: 'Reset Password',
                    subtitle: 'Enter your new password and confirm it.',
                    light: true,
                  ),
                ),

                // GREEN OVERLAY
                Align(
                  alignment: const Alignment(0, 0.2),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 244, 248, 247).withOpacity(0.45),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // New Password Field
                       LabeledField(
                          label: ' New Password',
                          labelColor: Colors.white,
                          field: AuthField(
                            hint: '********',
                            controller: _newPassword,
                            obscure: true,
                          ),
                        ),

                        // Confirm Password Field
                        LabeledField(
                          label: 'Confirm Password',
                          labelColor: Colors.white,
                          field: AuthField(
                            hint: '********',
                            controller: _confirmPassword,
                            obscure: true,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Submit Button
                        authButton('Submit >', onTap: _handleReset, loading: _loading),
                      ],
                    ),
                  ),
                ),

                // FOOTER
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 90),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Remember your password?',
                          style: TextStyle(
                            fontFamily: 'IBMPlexSerif',
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: widget.onBack,
                          child: const Text(
                            'Log in',
                            style: TextStyle(
                              fontFamily: 'IBMPlexSerif',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
//  Shared Styles 
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
  decoration: TextDecoration.none,
);

// ─────────────────── Auth Header Widget ───────────────────
class _AuthHeader extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String subtitle;
  final bool showIcon; // NEW
  final bool light;

  const _AuthHeader({
    super.key,
    this.icon,
    required this.title,
    required this.subtitle,
    this.showIcon = true,
    this.light = false, // default = keep old behavior
  });

  @override
  @override
  Widget build(BuildContext context) {
    final titleStyle = kHeading.copyWith(
      color: light ? Colors.white : const Color(0xFF0F3B2E),
    );
    final subtitleStyle = kSubHeading.copyWith(
      color: light ? Colors.white70 : Colors.black54,
    );

    return Column(
      children: [
        if (showIcon && icon != null) ...[
          Icon(
            icon,
            size: 56,
            color: light ? Colors.white : const Color(0xFF0F3B2E),
          ),
          const SizedBox(height: 12),
        ],
        Text(title, style: titleStyle, textAlign: TextAlign.center),
        const SizedBox(height: 6),
        Text(subtitle, style: subtitleStyle, textAlign: TextAlign.center),
      ],
    );
  }
}

// ─────────────────── Labeled Field ───────────────────
//
// ─────────────────── Labeled Field ───────────────────
class LabeledField extends StatelessWidget {
  final String label;
  final Widget field;
  final Color? labelColor; // NEW: optional label color

  const LabeledField({
    super.key,
    required this.label,
    required this.field,
    this.labelColor, // defaults to null (uses original dark green)
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
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color:
                  labelColor ??
                  const Color(0xFF0F3B2E), // use labelColor if provided
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
  final TextInputType keyboardType;

  const AuthField({
    super.key,
    required this.hint,
    this.controller,
    this.obscure = false,
    this.keyboardType = TextInputType.text, // ← defaults to plain text keyboard
  });

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  late bool _obscureText;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscure;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        obscureText: _obscureText,

        keyboardType: widget.keyboardType,

        enableSuggestions: false,
        autocorrect: false,
        enableIMEPersonalizedLearning: false,

        textCapitalization: TextCapitalization.none, // 🔥 IMPORTANT FIX
        textInputAction: TextInputAction.done,

        enableInteractiveSelection: false, // 🔥 prevents clipboard/image strip

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
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.25)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.25)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white, width: 1.5),
          ),
          suffixIcon: widget.obscure
              ? ExcludeFocus(
                  child: Focus(
                    canRequestFocus: false,
                    child: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: const Color(0xFF0F3B2E),
                        size: 20,
                      ),
                      onPressed: () =>
                          setState(() => _obscureText = !_obscureText),
                    ),
                  ),
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
        backgroundColor: outlined
            ? Colors.transparent
            : const Color(0xFF0F3B2E),

        foregroundColor: Colors.white,
        elevation: 0,
        side: outlined
            ? const BorderSide(color: Colors.white54)
            : BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                color: Colors.white,
              ),
            ),
    ),
  );
}

class _LoginLinks extends StatelessWidget {
  const _LoginLinks();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {}, // forgot password
          child: const Text('Forgot Password?', style: kLink),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {}, // register
          child: const Text("Don't have an account? Register", style: kLink),
        ),
      ],
    );
  }
}
