import 'package:flutter/material.dart';
import 'package:tourism_app/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE3EFE5), // ← your green shade
          brightness: Brightness.light, // optional but recommended
        ),
      ),
      home: SplashScreen(),
    );
  }
}
