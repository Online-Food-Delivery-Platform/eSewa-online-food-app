import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend_foodapp/LoginSignUp.dart';
import 'package:frontend_foodapp/Dashboard.dart';

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
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        debugPrint("User is logged in, navigating to Dashboard");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      } else {
        debugPrint("User not logged in, navigating to LoginSignUp");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginsignUp()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.yellow,
        child: Center(
          child: Image.asset('assets/YUMYUM1.png', width: 200, height: 200),
        ),
      ),
    );
  }
}
