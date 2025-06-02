import "package:esewa_flutter_sdk/esewa_flutter_sdk.dart";
import "package:esewa_flutter_sdk/esewa_config.dart";
import 'package:esewa_flutter_sdk/esewa_payment.dart';
import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';
import 'package:esewa_flutter_sdk/payment_failure.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void payWithEsewa() {
  try {
    EsewaFlutterSdk.initPayment(
      esewaConfig: EsewaConfig(
        environment: Environment.test,
        clientId: 'JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R',
        secretId: 'BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==',
      ),
      esewaPayment: EsewaPayment(
        productId: "1d71jd81",
        productName: "Product One",
        productPrice: "20",
        callbackUrl: "https://example.com/callback",
      ),
      onPaymentSuccess: (EsewaPaymentSuccessResult data) {
        print('ESEWA PAYMENT SUCCESS: ${data.toJson()}');
        Get.dialog(
          AlertDialog(
            title: const Text('Payment Successful'),
            content: Text('wow '),
            actions: [
              TextButton(onPressed: () => Get.back(), child: const Text('OK')),
            ],
          ),
        );
      },
      onPaymentFailure: (data) {
        print('ESEWA PAYMENT FAILURE: ${data.toJson()}');
      },
      onPaymentCancellation: (data) {
        print('ESEWA PAYMENT CANCELLATION: ${data.toJson()}');
      },
    );
  } on Exception catch (e) {
    print('ESEWA PAYMENT ERROR: $e');
  }
}
