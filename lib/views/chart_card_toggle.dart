import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/controllers/chartCard_controller.dart';
import 'package:smart_solutions/widget/text_style.dart';

class ChartCardsToggle extends StatelessWidget {
  List<String> data = [];
  final ChartCardsController controller = Get.put(ChartCardsController());

  ChartCardsToggle({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          // decoration: BoxDecoration(
          //   color: Colors.grey.shade200,
          //   border: Border.all(
          //     color: Colors.grey,
          //   ),
          //   borderRadius: BorderRadius.circular(2),
          // ),
          child: ToggleButtons(
              borderRadius: BorderRadius.circular(2),
              isSelected: [
                controller.selectedIndex.value == 0,
                controller.selectedIndex.value == 1
              ],
              onPressed: (index) {
                controller.selectedIndex.value = index;
              },
              color: Colors.grey.shade700, // Unselected text color
              selectedColor: Colors.black, // Selected text color
              selectedBorderColor: Colors.grey,
              fillColor: Colors.white, // Selected background
              renderBorder: true, // No inner borders
              constraints: const BoxConstraints(
                minHeight: 25,
                minWidth: 70,
              ),
              children: [
                ...data.map((item) => Text(item, style: AppTextStyle.body))
              ]),
        ),
      );
    });
  }
}
