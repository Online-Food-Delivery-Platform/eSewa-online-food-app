import 'package:flutter/material.dart';
import 'package:frontend_foodapp/LoginsignUp.dart';
import 'package:frontend_foodapp/SplashScreen.dart';
import 'package:frontend_foodapp/controller/dependency_injection.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:frontend_foodapp/controller/network_controller.dart';
import 'package:frontend_foodapp/controller/dependency_injection.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Ensure that the Flutter binding is initialized before running the app
  await Firebase.initializeApp();
  // Initialize Firebase
  runApp(const MyApp());
  DependencyInjection.init();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData.light(useMaterial3: true),
      title: 'YUM YUM',
      color: Colors.amberAccent,
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
