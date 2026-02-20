import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_solutions/controllers/theme_controller.dart';
import 'package:smart_solutions/routes/app_routes.dart';

import '../constants/static_stored_data.dart';
import '../controllers/internet_checker.dart';

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
    Get.deleteAll(force: true);

    Get.offAllNamed(AppRoutes.login);
    // 4. Re-initialize after navigation if needed
    Get.put(ConnectivityController(), permanent: true);
    Get.put(ThemeController(), permanent: true);
  }
}
