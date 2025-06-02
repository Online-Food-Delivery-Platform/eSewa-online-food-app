// wrapper.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend_foodapp/Dashboard.dart';
import 'package:frontend_foodapp/LoginsignUp.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return const DashboardScreen(); // Already logged in
    } else {
      return const LoginsignUp(); // Not logged in
    }
  }
}
