import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_solutions/routes/app_routes.dart';
import '../controllers/internet_checker.dart';
import '../controllers/theme_controller.dart';
import '../constants/static_stored_data.dart';

class LogoutHelper {
  // Add BuildContext as a parameter
  static Future<void> logout(BuildContext context) async {
    // 1. Clear Data
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    StaticStoredData.userId = '';
    StaticStoredData.number = '';

    // 2. Clear GetX state
    // We use force: true to ensure all controllers are removed
    await Get.deleteAll(force: true);

    // 3. Navigation using Native Flutter Context
    // This bypasses "Get.offAll" and its reliance on Get.key
    if (context.mounted) {
      // Native navigation doesn't depend on Get.key
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.login,
        (route) => false, // This clears the entire backstack
      );
    }

    // 4. Re-initialize after navigation if needed
    Get.put(ConnectivityController(), permanent: true);
    Get.put(ThemeController(), permanent: true);
  }
}
