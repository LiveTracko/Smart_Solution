import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:smart_solutions/controllers/theme_controller.dart';

class FilterChipList extends StatelessWidget {
  final List<String> filters;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final ScrollController? controller;

  FilterChipList({
    Key? key,
    required this.filters,
    required this.selectedIndex,
    required this.onSelected,
    this.controller,
  }) : super(key: key);

  final ThemeController _themeController = Get.find();
  @override
  Widget build(BuildContext context) {
    print(
        'FilterChipList BUILDING - Filters: $filters, Count: ${filters.length}');
    return Obx(
      () => SingleChildScrollView(
        controller: controller,
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(filters.length, (index) {
            final isSelected = index == selectedIndex;
            return Padding(
              padding: EdgeInsets.only(left: 15.w),
              child: ChoiceChip(
                label: Text(filters[index]),
                selected: isSelected,
                onSelected: (_) => onSelected(index),
                selectedColor:
                    _themeController.primaryColor.value.withOpacity(0.2),
                labelStyle: TextStyle(
                  color: isSelected
                      ? _themeController.primaryColor.value
                      : Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
                shape: StadiumBorder(
                  side: BorderSide(
                    color: isSelected
                        ? _themeController.primaryColor.value
                        : Colors.grey.shade400,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
