import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/controllers/chartCard_controller.dart';
import 'package:smart_solutions/widget/text_style.dart';

class ChartCardsToggle extends StatelessWidget {
  final List<String> data;

  final double height;
  final double width;
  final double fontSize;
  final double horizontalPadding;
  final double verticalPadding;
  final double borderRadius;

  final ChartCardsController controller = Get.find<ChartCardsController>();

  ChartCardsToggle({
    super.key,
    required this.data,
    this.height = 25,
    this.width = 70,
    this.fontSize = 12,
    this.horizontalPadding = 20,
    this.verticalPadding = 10,
    this.borderRadius = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding.w,
          vertical: verticalPadding.h,
        ),
        child: ToggleButtons(
          borderRadius: BorderRadius.circular(borderRadius),
          isSelected: [
            controller.selectedIndex.value == 0,
            controller.selectedIndex.value == 1,
          ],
          onPressed: (index) {
            controller.selectedIndex.value = index;
            FocusManager.instance.primaryFocus?.unfocus();
          },
          color: Colors.grey.shade700,
          selectedColor: Colors.black,
          selectedBorderColor: Colors.grey,
          fillColor: Colors.white,
          constraints: BoxConstraints(
            minHeight: height.h,
            minWidth: width.w,
          ),
          children: data
              .map(
                (item) => Text(
                  item,
                  style: AppTextStyle.body.copyWith(
                    fontSize: fontSize.sp,
                  ),
                ),
              )
              .toList(),
        ),
      );
    });
  }
}
