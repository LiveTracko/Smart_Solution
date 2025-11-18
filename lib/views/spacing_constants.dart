import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 🟢 Common Padding Constants
final EdgeInsets kHorizontalPadding = EdgeInsets.symmetric(horizontal: 16.w);
final EdgeInsets kVerticalPadding = EdgeInsets.symmetric(vertical: 12.h);
final EdgeInsets kCommonPadding = EdgeInsets.symmetric(
  horizontal: 16.w,
  vertical: 12.h,
);

// 🟢 Common Space Widgets
SizedBox kVerticalSpace(double height) => SizedBox(height: height.h);
SizedBox kHorizontalSpace(double width) => SizedBox(width: width.w);

// 🟢 Frequently used preset spaces
final SizedBox kVSpace10 = SizedBox(height: 10.h);
final SizedBox kVSpace20 = SizedBox(height: 20.h);
final SizedBox kHSpace10 = SizedBox(width: 10.w);
final SizedBox kHSpace20 = SizedBox(width: 20.w);
