import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
              final primary = _themeController.primaryColor.value;

              return Padding(
                padding: EdgeInsets.only(left: 12.w),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: primary.withOpacity(.05),
                              blurRadius: 3,
                              offset: const Offset(0, 3),
                            )
                          ]
                        : [],
                  ),
                  child: ChoiceChip(
                    // avatar: isSelected
                    //     ? Icon(Icons.check_circle,
                    //         size: 16, color: AppColors.textColor)
                    //     : null,
                    showCheckmark: false,
                    label: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Text(filters[index]),
                    ),
                    selected: isSelected,
                    onSelected: (_) => onSelected(index),
                    backgroundColor: Colors.white,
                    selectedColor: primary.withOpacity(.12),
                    elevation: isSelected ? 2 : 0,
                    pressElevation: 0,
                    labelStyle: TextStyle(
                      color: isSelected ? primary : Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: isSelected ? primary : Colors.grey.shade300,
                        width: 1.2,
                      ),
                    ),
                  ),
                ),
              );
            }),
          )

          //  Row(
          //   children: List.generate(filters.length, (index) {
          //     final isSelected = index == selectedIndex;
          //     return Padding(
          //       padding: EdgeInsets.only(left: 15.w),
          //       child: ChoiceChip(
          //         label: Text(filters[index]),
          //         selected: isSelected,
          //         onSelected: (_) => onSelected(index),
          //         selectedColor:
          //             _themeController.primaryColor.value.withOpacity(0.2),
          //         labelStyle: TextStyle(
          //           color: isSelected
          //               ? _themeController.primaryColor.value
          //               : Colors.grey.shade700,
          //           fontWeight: FontWeight.w500,
          //         ),
          //         shape: StadiumBorder(
          //           side: BorderSide(
          //             color: isSelected
          //                 ? _themeController.primaryColor.value
          //                 : Colors.grey.shade400,
          //           ),
          //         ),
          //       ),
          //     );
          //   }),
          // ),

          ),
    );
  }
}
