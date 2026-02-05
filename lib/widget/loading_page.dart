import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/controllers/theme_controller.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

ThemeController _themeController = Get.find<ThemeController>();

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
      height: 40,
      width: 40,
      child: Obx(
        () => Theme(
          data: ThemeData(
            progressIndicatorTheme: ProgressIndicatorThemeData(
              color: _themeController.primaryColor.value,
            ),
          ),
          child: const CircularProgressIndicator(
            strokeWidth: 5, // thickness of the circle
          ),
        ),
      ),
    ));
  }
}
