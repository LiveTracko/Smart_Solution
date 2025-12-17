import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_solutions/theme/app_theme.dart';

class AppTextStyle {
  static const hintText = TextStyle(
    fontSize: 15,
    color: AppColors.secondayColor,
    fontFamily: 'Poppins',
  );

  static const textStyle = TextStyle(
    fontSize: 15,
    color: AppColors.primaryColor,
    fontFamily: 'Poppins',
  );
  static const blueHeaderTitletStyle = TextStyle(
    fontSize: 15,
    color: AppColors.primaryColor,
    fontWeight: FontWeight.bold,
    fontFamily: 'Poppins',
  );

  static const whiteHeaderTitletStyle = TextStyle(
    fontSize: 18,
    color: AppColors.backgroundColor,
    fontWeight: FontWeight.bold,
    fontFamily: 'Poppins',
  );

  static const headerTitle = TextStyle(
      fontSize: 16, color: Colors.black87, fontWeight: FontWeight.bold);

  static const smallbodyTxt =
      TextStyle(fontSize: 12, fontWeight: FontWeight.bold);
  static const body = TextStyle(
    fontSize: 14,
    color: Colors.black87,
  );

  static const label = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: Colors.grey,
  );

  static const normalHeadingTxt = TextStyle(
    fontSize: 14,
  );

  static const whiteText = TextStyle(
    fontSize: 14,
    color: Colors.white,
  );

  static const link = TextStyle(
    fontSize: 14,
    color: Colors.indigo,
    decoration: TextDecoration.underline,
  );

  static const textfieldheading = TextStyle(
      fontSize: 14, color: Colors.black87, fontWeight: FontWeight.bold);

  static const bodyBoldTxt = TextStyle(
      fontSize: 14, color: Colors.black87, fontWeight: FontWeight.bold);

  static const textfieldabove = TextStyle(
    fontSize: 10,
    color: Colors.black87,
  );

// 🟢 Common Padding Constants
  final EdgeInsets kHorizontalPadding = EdgeInsets.symmetric(horizontal: 15.w);
  final EdgeInsets kVerticalPadding = EdgeInsets.symmetric(vertical: 10.h);
  final EdgeInsets kCommonPadding = EdgeInsets.symmetric(
    horizontal: 15.w,
    vertical: 10.h,
  );

// 🟢 Common Space Widgets
  SizedBox kVerticalSpace(double height) => SizedBox(height: height.h);
  SizedBox kHorizontalSpace(double width) => SizedBox(width: width.w);

// 🟢 Frequently used preset spaces
  final SizedBox kVSpace10 = SizedBox(height: 10.h);
  final SizedBox kVSpace20 = SizedBox(height: 20.h);
  final SizedBox kHSpace10 = SizedBox(width: 10.w);
  final SizedBox kHSpace20 = SizedBox(width: 20.w);
}
