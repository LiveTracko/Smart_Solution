import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Add this import
import 'package:smart_solutions/theme/app_theme.dart';

class KeypadRowWidget extends StatelessWidget {
  final List<String> numbers;
  final List<String?> subTexts;
  final Function(String) onDialButtonPressed;

  const KeypadRowWidget({
    Key? key,
    required this.numbers,
    required this.subTexts,
    required this.onDialButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildDialButton(numbers[0], subText: subTexts[0]),
        _buildDialButton(numbers[1], subText: subTexts[1]),
        _buildDialButton(numbers[2],
            subText: subTexts.length > 2 ? subTexts[2] : null),
      ],
    );
  }

  Widget _buildDialButton(String number, {String? subText}) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(0.w), // Responsive margin
        padding: EdgeInsets.all(3.w),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: CircleAvatar(
          radius: 32,
          backgroundColor: AppColors.secondayColor,
          child: Material(
            color: AppColors.greyColor,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              splashColor: AppColors.primaryColor.withOpacity(0.3),
              highlightColor: Colors.transparent,
              onTap: () => onDialButtonPressed(number),
              child: SizedBox(
                height: 64, // circle size
                width: 64,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      number,
                      style: TextStyle(
                        fontSize: 20.sp, // Responsive font size
                        color: AppColors.secondayColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (subText != null)
                      Text(
                        subText,
                        style: TextStyle(
                          fontSize: 10.sp, // Responsive font size for subtext
                          color: AppColors.secondayColor,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


  // Build keypad row for cleaner code
  // Widget _buildKeypadRow(List<String> numbers, List<String?> subTexts) {
  //   return Expanded(
  //     child: Row(
  //       children: [
  //         _buildDialButton(numbers[0], subText: subTexts[0]),
  //         _buildDialButton(numbers[1], subText: subTexts[1]),
  //         _buildDialButton(numbers[2], subText: subTexts.length > 2 ? subTexts[2] : null),
  //       ],
  //     ),
  //   );
  // }