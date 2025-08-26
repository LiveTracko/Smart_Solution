
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/controllers/internet_checker.dart';

class InternetChecker extends StatelessWidget {
  final Widget child;

  const InternetChecker({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ConnectivityController>();

    return Obx(() {
      if (!controller.isOnline.value) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (Get.isSnackbarOpen) return;
          Get.snackbar(
            "No Internet",
            "You're offline",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        });
      }
      return child;
    });
  }
}
