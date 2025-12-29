import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/theme/app_theme.dart';
import 'package:smart_solutions/widget/common_scaffold.dart';
import '../controllers/theme_controller.dart';

class ThemeChangeScreen extends StatelessWidget {
  ThemeChangeScreen({super.key});

  // Fetch the ThemeController
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: "Theme",
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              colorButton(const Color(0xFF356EFF)),
              colorButton(const Color(0xFFC7ADEE)),
              colorButton(const Color(0xFF6BBFC9)),
              colorButton(const Color(0xFFE59CAA)),
            ]),
            SizedBox(
              height: 20.h,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              colorButton(const Color(0xFFF9E07C)),
              colorButton(const Color(0xFF8FC3FF)),
              colorButton(const Color(0xFF34C759)),
              colorButton(const Color(0xFFFF8D28)),
            ]),
            SizedBox(height: 50.h),
            Text(
              "OR",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondayColor,
                    letterSpacing: 1.2,
                  ),
            ),
            SizedBox(height: 20.h,),
            ElevatedButton.icon(
              icon: Icon(Icons.color_lens),
              label: Text("Choose Custom Color"),
              onPressed: () => _openColorPicker(context),
            ),
          ],
        ),
      ),
    );
  }

  // Color circle widget
  Widget colorButton(Color color) {
    return GestureDetector(
      onTap: () {
        themeController.changeThemeColor(color);
      },
      child: Obx(() {
        bool isSelected = themeController.primaryColor.value == color;
        return Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.grey : Colors.grey,
              width: isSelected ? 2 : 1,
            ),
          ),
        );
      }),
    );
  }

  void _openColorPicker(BuildContext context) {
    Color tempColor = themeController.primaryColor.value;

    Get.dialog(
      AlertDialog(
        title: const Text("Pick a color"),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: tempColor,
            onColorChanged: (color) {
              tempColor = color;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              themeController.changeThemeColor(tempColor);
              Get.back();
            },
            child: const Text("Apply"),
          ),
        ],
      ),
    );
  }
}
