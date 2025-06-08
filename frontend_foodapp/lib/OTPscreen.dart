import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend_foodapp/Dashboard.dart';

class OTPscreen extends StatefulWidget {
  final String verificationId;

  OTPscreen({super.key, required this.verificationId});

  @override
  _OTPscreenState createState() => _OTPscreenState();
}

class _OTPscreenState extends State<OTPscreen> {
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100], // soft background
      appBar: AppBar(
        title: const Text(
          'Verify OTP',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.yellow,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.lock_open_rounded,
                size: 80,
                color: Colors.orange,
              ),
              const SizedBox(height: 20),
              const Text(
                'Enter the OTP sent to your phone',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    counterText: "",
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                    hintText: "6-digit OTP",
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  try {
                    PhoneAuthCredential credential =
                        PhoneAuthProvider.credential(
                          verificationId: widget.verificationId,
                          smsCode: otpController.text.trim(),
                        );

                    await FirebaseAuth.instance
                        .signInWithCredential(credential)
                        .then((value) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DashboardScreen(),
                            ),
                          );
                        });
                  } catch (e) {
                    log(e.toString());
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Invalid OTP. Please try again.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Verify',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
