import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/constants/api_urls.dart';
import 'package:smart_solutions/constants/services.dart';
import 'package:smart_solutions/constants/static_stored_data.dart';
import 'package:smart_solutions/services/api_service.dart';
import 'package:smart_solutions/theme/app_theme.dart';

class ThemeController extends GetxController {
  Rx<Color> primaryColor = AppColors.primaryColor.obs;

  Color hexToColor(String hex) {
    hex = hex.replaceAll('#', '');

    if (hex.length == 6) {
      hex = 'FF$hex'; // add alpha if missing
    }

    return Color(int.parse(hex, radix: 16));
  }

  // Reactive primary color

  void changeThemeColor(Color color) async {
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

  String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0')}';
  }

  Future<void> saveThemeColor(
    String telecallerId,
    Color colorCode,
  ) async {
    String colorToHex(Color color) {
      return '#${color.value.toRadixString(16).padLeft(8, '0')}';
    }

    final hex = colorToHex(colorCode);

    try {
      // Prepare the fields map
      var fields = {"telecaller_id": telecallerId, "theme_color": hex};

      var response = await ApiService().postRequest(APIUrls.themeColor, fields);

      // Handle the response
      if (response.statusCode == 200) {
        Get.snackbar(
            "Theme Updated", "Your app theme has been updated successfully.",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: colorCode);
      } else {
        Get.snackbar('Error', 'Failed to update profile.');
      }
    } catch (e) {
      logOutput("An error occurred while saving the login request: $e");
    } finally {}
  }

  void _applyTheme(Color color) {
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

  void loadSavedTheme() {
    if (StaticStoredData.themeColor.isNotEmpty) {
      final color = hexToColor(StaticStoredData.themeColor);
      primaryColor.value = color;
      _applyTheme(color);
    }
  }
}
