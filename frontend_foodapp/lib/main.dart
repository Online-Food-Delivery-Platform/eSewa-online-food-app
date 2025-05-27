import 'package:flutter/material.dart';
import 'package:frontend_foodapp/LoginsignUp.dart';
import 'package:frontend_foodapp/SplashScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(useMaterial3: true),
      title: 'YUM YUM',
      color: Colors.amberAccent,
      home: SplashScreen(),

      debugShowCheckedModeBanner: false,
    );
  }
}
