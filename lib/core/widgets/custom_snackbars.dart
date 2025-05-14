import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackbars {
  // Function to show success Snackbar with dynamic text
  void showSuccessSnackbar({required String title, required String message}) {
    Get.snackbar(
      title,
      message,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      borderRadius: 10,
      margin: const EdgeInsets.all(10),
      duration: const Duration(seconds: 2),
    );
  }

  // Function to show error Snackbar with dynamic text
  void showErrorSnackbar({required String title, required String message}) {
    Get.snackbar(
      title,
      message,
      icon: const Icon(Icons.error, color: Colors.white),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      borderRadius: 10,
      margin: const EdgeInsets.all(10),
      duration: const Duration(seconds: 2),
    );
  }

  // Function to show info Snackbar with dynamic text
  void showInfoSnackbar({required String title, required String message}) {
    Get.snackbar(
      title,
      message,
      icon: const Icon(Icons.info, color: Colors.white),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      borderRadius: 10,
      margin: const EdgeInsets.all(10),
      duration: const Duration(seconds: 2),
    );
  }

  // Function to show warning Snackbar with dynamic text
  void showWarningSnackbar({required String title, required String message}) {
    Get.snackbar(
      title,
      message,
      icon: const Icon(Icons.warning, color: Colors.white),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      borderRadius: 10,
      margin: const EdgeInsets.all(10),
      duration: const Duration(seconds: 2),
    );
  }
}
