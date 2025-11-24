import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbar {
  static void error(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.withOpacity(0.9),
      colorText: Colors.white,
      borderRadius: 12,
      margin: const EdgeInsets.all(12),
      icon: const Icon(Icons.error, color: Colors.white),
      duration: const Duration(seconds: 3),
      barBlur: 15,
      overlayBlur: 0,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    );
  }

  static void success(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green.withOpacity(0.9),
      colorText: Colors.white,
      borderRadius: 12,
      margin: const EdgeInsets.all(12),
      icon: const Icon(Icons.check_circle, color: Colors.white),
      duration: const Duration(seconds: 2),
      barBlur: 15,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    );
  }
}
