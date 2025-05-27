import 'package:flutter/material.dart';
import 'package:frontend_foodapp/LoginSignUp.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    debugPrint("Splash screen started");
    Future.delayed(const Duration(seconds: 3), () {
      debugPrint("Navigating to LoginSignUp");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginsignUp()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.yellow,
        child: Center(child: Image.asset('assets/YUMYUM1.png')),
      ),
    );
  }
}
