import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/views/hrms/hrm_items.dart';
import 'package:smart_solutions/views/hrms/profile_screen.dart';
import 'package:smart_solutions/widget/common_scaffold.dart';
import 'package:smart_solutions/widget/hrm_card.dart';

class HrmScreen extends StatelessWidget {
  const HrmScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // Each item contains icon, title, and the screen widget to open
    final List<HrmItem> hrmItems = [
      HrmItem(
        icon: "assets/hrms/profile.svg",
        title: "Profile",
        page: const ProfileScreen(),
      ),
      HrmItem(
        icon: "assets/hrms/mark_attendance.svg",
        title: "Mark Attendance",
        page: Scaffold(body: Center(child: Text("Mark Attendance Page"))),
      ),
      HrmItem(
        icon: "assets/hrms/view_attendance.svg",
        title: "View Attendance",
        page: Scaffold(body: Center(child: Text("View Attendance Page"))),
      ),
      HrmItem(
        icon: "assets/hrms/request_leave.svg",
        title: "Request Leave",
        page: Scaffold(body: Center(child: Text("Request Leave Page"))),
      ),
      HrmItem(
        icon: "assets/hrms/documents.svg",
        title: "Documents",
        page: Scaffold(body: Center(child: Text("Documents Page"))),
      ),
      HrmItem(
        icon: "assets/hrms/holiday_list.svg",
        title: "Holiday List",
        page: Scaffold(body: Center(child: Text("Holiday List Page"))),
      ),
    ];

    return CommonScaffold(
      title: "HRM",
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: GridView.builder(
          itemCount: hrmItems.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 1.1,
          ),
          itemBuilder: (context, index) {

            final item = hrmItems[index];

            return HrmCard(
              iconPath: item.icon,
              title: item.title,
              onTap: () => Get.to(() => item.page),
            );
          },
        ),
      ),
    );
  }
}
