import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/controllers/theme_controller.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  final ThemeController _themeController = Get.find<ThemeController>();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 40,
        width: 40,
        child: Obx(() => CircularProgressIndicator(
              strokeWidth: 5,
              valueColor: AlwaysStoppedAnimation<Color>(
                _themeController.primaryColor.value,
              ),
            )),
      ),
    );
  }
}
