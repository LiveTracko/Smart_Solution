import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:smart_solutions/constants/static_stored_data.dart';
import 'package:smart_solutions/routes/app_routes.dart';
import 'package:smart_solutions/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_solutions/widget/text_style.dart';

import '../controllers/theme_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkForUpdate();
    //  _checkLoginStatus(); // Check login status when the splash screen initializes
  }

  Color hexToColor(String hex) {
    hex = hex.replaceAll('#', '');

    if (hex.length == 6) {
      hex = 'FF$hex'; // add alpha if missing
    }

    return Color(int.parse(hex, radix: 16));
  }

  // Check if user is already logged in
  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString(
      'userId',
    ); // Retrieve user ID from Shared Preferences
    String? roleName = prefs.getString('roleName');
    String? number = prefs.getString('userName');
    String? colorCode = prefs.getString('themeColor');

    // Apply theme immediately
    if (colorCode != null && colorCode.isNotEmpty) {
      themeController.loadSavedTheme();
    }
    // Navigate to the appropriate screen after a delay
    Future.delayed(const Duration(seconds: 3), () {
      if (userId != null) {
        StaticStoredData.userId = userId;
        StaticStoredData.roleName = roleName ?? '';
        StaticStoredData.number = number ?? '';
        StaticStoredData.themeColor = colorCode ?? '';

        Get.offAllNamed(AppRoutes.navigationscreen);
      } else {
        StaticStoredData.userId = '';
        StaticStoredData.roleName = '';
        Get.offAllNamed(AppRoutes.login);
      }
    });
  }

  Future<void> checkForUpdate() async {
    // Skip update checks entirely in debug mode
    if (kDebugMode) {
      debugPrint("🚫 Skipping in-app update in debug mode.");
      _checkLoginStatus();
      return;
    }

    try {
      AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();

      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable &&
          updateInfo.immediateUpdateAllowed) {
        // Force the user to update immediately
        await InAppUpdate.performImmediateUpdate();
      } else {
        // No update needed
        _checkLoginStatus();
      }
    } catch (e) {
      final errorMsg = e.toString();

      // Specific handling for sideload/debug error
      if (errorMsg.contains("ERROR_APP_NOT_OWNED") ||
          errorMsg.contains("Install Error(-10)") ||
          errorMsg.contains('PlatformException(TASK_FAILURE') ||
          errorMsg.contains('java.lang.NullPointerException')) {
        debugPrint("⚠️ Skipping update: app not owned by Play Store.");
        // Don’t stop app — just continue normally
        _checkLoginStatus();
        // WidgetsBinding.instance.addPostFrameCallback((_) {
        //   navigateToHome();
        // });
      } else {
        debugPrint("❌ Update check failed: $e");
        _checkLoginStatus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor, // Background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Replace this with your app's logo image
            Image.asset(
              'assets/images/app_logo_with_name.png',
              //  'assets/images/splash_logo.png', // Make sure the path matches your image location
              height: 100.h, // Use responsive height
              width: 250.w, // Use responsive width
            ),
          ],
        ),
      ),
    );
  }
}
