import 'dart:async';
import 'package:flutter/material.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
@override
_SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
@override
void initState() {
super.initState();

// Move to Onboarding after 3 seconds
Timer(Duration(seconds: 3), () {
Navigator.pushReplacement(
context,
MaterialPageRoute(builder: (context) => OnboardingScreen()),
);
});
}

@override
Widget build(BuildContext context) {
  print("Using Material 3: ${Theme.of(context).useMaterial3}");
return Scaffold(
backgroundColor: const Color(0xFFE3EFE5),
body: Center(
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
// App logo or icon
Image.asset('assets/images/logo.png', height: 100),
SizedBox(height: 20),
SizedBox(height: 40),
CircularProgressIndicator(color: Colors.white),
],
),
),
);
}
}

