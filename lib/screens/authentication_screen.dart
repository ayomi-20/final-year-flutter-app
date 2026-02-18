import 'package:flutter/material.dart';

class AuthenticationScreen extends StatefulWidget {
  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(18),
        child: PageView(
          controller: _pageController,
          children: [
            RegisterPage(
              onLoginTap: () {
                _pageController.animateToPage(
                  1,
                  duration: Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              },
            ),
            LoginPage(
              onForgotTap: () {
                _pageController.animateToPage(
                  2,
                  duration: Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              },
            ),
            ForgotPasswordPage(),
          ],
        ),
      ),
    );
  }
}

class AuthCard extends StatelessWidget {
  final Widget child;

  const AuthCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.all(22),
      child: child,
    );
  }
}

class RegisterPage extends StatelessWidget {
  final VoidCallback onLoginTap;

  const RegisterPage({required this.onLoginTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 12), // 👈 THIS NOW WORKS
        child: AuthCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/register-icon.png', height: 70),
              const SizedBox(height: 16),

              Text(
                "Register Account",
                style: TextStyle(
                  fontFamily: 'IBMPlexSerif',
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F3B2E),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text("Create a new account",
              style: TextStyle(
                fontFamily: 'IBMPlexSerif',
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Color(0xFF0F3B2E), ),
                textAlign: TextAlign.center,),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(child: authField("First name")),
                  const SizedBox(width: 9),
                  Expanded(child: authField("Last name")),
                ],
              ),
              authField("Email"),
              authField("Contact"),
              authField("Password", obscure: true),

              const SizedBox(height: 16),

              authButton("Sign Up"),

              const SizedBox(height: 20),
              GestureDetector(
                onTap: onLoginTap,
                child: Text(
                  "Already have an account? \n Login",
                  style: TextStyle(color: Color(0xFF1C5E4A)),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  final VoidCallback onForgotTap;

  const LoginPage({required this.onForgotTap});

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
              Text(
                "Welcome",
                style: TextStyle(
                  fontFamily: 'IBMPlexSerif',
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F3B2E),
                ),
              ),
              const SizedBox(height: 4),
              Text("Sign in to continue",
              style: TextStyle(
                  fontFamily: 'IBMPlexSerif',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0F3B2E),
                ),),

              const SizedBox(height: 20),

              authField("Email"),
              authField("Password", obscure: true),

              const SizedBox(height: 16),
              authButton("Sign In"),

              const SizedBox(height: 10),
              GestureDetector(
                onTap: onForgotTap,
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(color: Color(0xFF1C5E4A)),
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

              Text(
                "Forgot Password?",
                style: TextStyle(
                  fontFamily: 'IBMPlexSerif',
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F3B2E),
                ),
              ),
              const SizedBox(height: 4),
              Text(
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
      )));
  }
}

Widget authField(String hint, {bool obscure = false}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: TextField(
      obscureText: obscure,
      style: const TextStyle(
        color: Color(0xFF0F3B2E), // input text color
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontFamily: 'IBMPlexSerif',
          color: Color(0xFF1C5E4A),
          fontWeight: FontWeight.w500, // 👈 visible bold
        ),

        filled: true,
        fillColor: Colors.white,

        // 👇 Default border
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFF1C5E4A),
          ),
        ),

        // 👇 When not focused
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFF1C5E4A),
            width: 1.2,
          ),
        ),

        // 👇 When focused
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFF0F3B2E),
            width: 1.6,
          ),
        ),
      ),
    ),
  );
}


Widget authButton(String text) {
  return SizedBox(
    width: double.infinity,
    height: 48,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF1C5E4A),
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          fontFamily: 'IBMPlexSerif',
          fontWeight: FontWeight.w500, // 👈 THIS is what sticks
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () {},
      child: Text(text),
    ),
  );
}


