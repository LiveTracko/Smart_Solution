import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchBarWithClear extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onClear;
  final ValueChanged<String> onChanged;
  final TextInputType textInputType;
  final FocusNode? focusNode;

  const SearchBarWithClear({
    Key? key,
    required this.controller,
    required this.onClear,
    required this.onChanged,
    this.textInputType = TextInputType.text,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 40,
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                onChanged: onChanged,
                keyboardType: textInputType,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search Text Here',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  isDense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: onClear,
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                decoration: TextDecoration.underline,
              ),
            ),
            child: const Text('Clear Filters'),
          ),
          // GestureDetector(
          //   onTap: onClear,
          //   child: const Text(
          //     'Clear Filters',
          //     style: TextStyle(
          //         color: Colors.red,
          //         fontWeight: FontWeight.w500,
          //         decoration: TextDecoration.underline,
          //         decorationColor: Colors.red,
          //         decorationThickness: 2),
          //   ),
          // ),
        ],
      ),
    );
  }
}
