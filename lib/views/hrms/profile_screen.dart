import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_solutions/controllers/profile_controller.dart';
import 'package:smart_solutions/theme/app_theme.dart';
import 'package:smart_solutions/views/hrms/personal_detail_screen.dart';
import 'package:smart_solutions/widget/common_scaffold.dart';
import 'package:smart_solutions/widget/text_style.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ImageProvider profileImage() {
    final controller = Get.find<ProfileController>();

    if (controller.imageFile.value != null) {
      return FileImage(controller.imageFile.value!);
    }

    if (controller.profileImageUrl.value.isNotEmpty) {
      return NetworkImage(controller.profileImageUrl.value);
    }

    return const AssetImage("assets/images/app_login.png");
  }

  Widget buildSectionTile(String iconPath, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Row(
          children: [
            SvgPicture.asset(iconPath, height: 24, width: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: AppTextStyle.headerTitle,
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // Navigation methods
  void _navigateToPersonalDetails() {
    Get.to(() => PersonalDetailsScreen()); 
    
  }

  // void _navigateToCurrentEmployment() {
  //   Get.to(() => CurrentEmploymentScreen());
  // }

  // void _navigateToAttendanceDetails() {
  //   Get.to(() => AttendanceDetailsScreen());
  // }

  // void _navigateToBankDetails() {
  //   Get.to(() => BankDetailsScreen());
  // }

  // void _navigateToUserPermissions() {
  //   Get.to(() => UserPermissionsScreen());
  // }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: "Profile",
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.whiteColor,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundImage: profileImage(),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {},
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.transparent,
                              child: SvgPicture.asset(
                                "assets/hrms/pencil_with_blue_container.svg",
                                width: 30,
                                height: 30,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Shubham Hande",
                          style: AppTextStyle.headerTitle,
                        ),
                        SizedBox(height: 6),
                        Text(
                          "+91 9876543210",
                          style: AppTextStyle.bodyBoldTxt,
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Admin",
                          style: AppTextStyle.label,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      buildSectionTile(
                          "assets/hrms/user.svg", "Personal Details", _navigateToPersonalDetails), // Updated
                      Divider(height: 1, color: Colors.grey.shade300),
                      // buildSectionTile("assets/hrms/current_employement.svg",
                      //     "Current Employment", _navigateToCurrentEmployment), // Updated
                      // Divider(height: 1, color: Colors.grey.shade300),
                      // buildSectionTile("assets/hrms/attendance_details.svg",
                      //     "Attendance Details", _navigateToAttendanceDetails), // Updated
                      // Divider(height: 1, color: Colors.grey.shade300),
                      // buildSectionTile("assets/hrms/bank_details.svg",
                      //     "Bank Details", _navigateToBankDetails), // Updated
                      // Divider(height: 1, color: Colors.grey.shade300),
                      // buildSectionTile("assets/hrms/user_permission.svg",
                      //     "User Permissions", _navigateToUserPermissions), // Updated
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}