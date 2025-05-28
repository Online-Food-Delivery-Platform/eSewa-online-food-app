import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    final result =
        results.first; // Take the first one (or handle multiple if needed)

    print("Connectivity changed: $result");

    if (result == ConnectivityResult.none) {
      Get.rawSnackbar(
        messageText: Text(
          "No Internet Connection",
          style: TextStyle(color: Colors.red, fontSize: 16),
        ),
        duration: Duration(days: 1),
        borderRadius: 10,
        borderColor: Colors.red,
        backgroundColor: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        icon: Icon(Icons.wifi_off, color: Colors.red, size: 30),
        margin: EdgeInsets.zero,
      );
    } else {
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
    }
  }
}
