import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class FilterChipList extends StatelessWidget {
  final List<String> filters;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
   final ScrollController? controller;

  const FilterChipList({
    Key? key,
    required this.filters,
    required this.selectedIndex,
    required this.onSelected,
     this.controller,
  }) : super(key: key);

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
                selectedColor: Colors.blue.shade50,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.blue : Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
                shape: StadiumBorder(
                  side: BorderSide(
                    color: isSelected ? Colors.blue : Colors.grey.shade400,
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
