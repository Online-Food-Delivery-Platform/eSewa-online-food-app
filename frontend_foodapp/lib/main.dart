import 'package:flutter/material.dart';

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

      color: Colors.amberAccent,
      home: Scaffold(
        appBar: AppBar(title: const Text('Yum Yum')),
        body: const Center(child: Text('Welcome to Yum Yum!')),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
