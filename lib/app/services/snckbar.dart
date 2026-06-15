import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnack {
  static void error(String msg) {
    Get.snackbar(
      "Error",
      msg,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      backgroundColor: Colors.red.withOpacity(0.9),
      colorText: Colors.white,
      borderRadius: 12,
    );
  }

  static void success(String msg) {
    Get.snackbar(
      "Success",
      msg,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      backgroundColor: Colors.green.withOpacity(0.9),
      colorText: Colors.white,
      borderRadius: 12,
    );
  }
}
