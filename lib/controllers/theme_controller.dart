import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/theme/app_theme.dart';

class ThemeController extends GetxController {
  // Reactive primary color
  final Rx<Color> primaryColor = AppColors.primaryColor.obs;

  

  // Method to change theme color dynamically
  void changeThemeColor(Color color) {
    primaryColor.value = color;

    // Optional: update GetMaterialApp theme dynamically
    Get.changeTheme(
      ThemeData(
        fontFamily: 'Poppins',
        primaryColor: color,
        scaffoldBackgroundColor: Colors.white,
        cardColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: color),
      ),
    );
  }
}
