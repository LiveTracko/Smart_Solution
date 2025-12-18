import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_solutions/controllers/profile_controller.dart';
import 'package:smart_solutions/theme/app_theme.dart';
import 'package:smart_solutions/views/hrms/attendence_detail_page.dart';
import 'package:smart_solutions/views/hrms/bank_detail_page.dart';
import 'package:smart_solutions/views/hrms/current_employement_page.dart';
import 'package:smart_solutions/views/hrms/personal_detail_screen.dart';
import 'package:smart_solutions/widget/common_scaffold.dart';
import 'package:smart_solutions/widget/text_style.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final controller = Get.find<ProfileController>();
  ImageProvider profileImage() {
    if (controller.imageFile.value != null) {
      return FileImage(controller.imageFile.value!);
    }

    if (controller.profileImageUrl.value.isNotEmpty) {
      return NetworkImage(controller.profileImageUrl.value);
    }

    return const AssetImage("assets/images/app_login.png");
  }

  Widget buildSectionTile(
    String iconPath,
    String title,
    Widget Function() pageBuilder,
  ) {
    return GestureDetector(
      onTap: () {
        Get.to(pageBuilder);
      },
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
    Get.to(() => const PersonalDetailScreen());
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: "Profile",
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: AppColors.appBarTextColor,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    CircleAvatar(radius: 55, backgroundImage: profileImage()),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _openProfileImageBottomSheet,
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
                      "Ashwini",
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
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
            decoration: BoxDecoration(
              color: AppColors.appBarTextColor,
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
                buildSectionTile("assets/hrms/user.svg", "Personal Details",
                    () => const PersonalDetailScreen()), // Updated
                Divider(height: 1, color: Colors.grey.shade300),
                buildSectionTile(
                    "assets/hrms/current_employement.svg",
                    "Current Employment",
                    () => const CurrentEmploymentPage()), // Updated
                Divider(height: 1, color: Colors.grey.shade300),
                buildSectionTile(
                    "assets/hrms/attendance_details.svg",
                    "Attendance Details",
                    () => const AttendanceModesScreen()), // Updated
                Divider(height: 1, color: Colors.grey.shade300),
                buildSectionTile("assets/hrms/bank_details.svg", "Bank Details",
                    () => const BankDetailsPage()), // Updated
                Divider(height: 1, color: Colors.grey.shade300),
                buildSectionTile(
                    "assets/hrms/user_permission.svg",
                    "User Permission",
                    () => const CurrentEmploymentPage()), // Updat
              ],
            ),
          )
        ],
      ),
    );
  }

  void _openProfileImageBottomSheet() {
    if (Get.isBottomSheetOpen == true) return;

    Get.bottomSheet(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag Handle
            Container(
              height: 4,
              width: 40,
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            Row(
              children: [
                const Expanded(
                  child: Text(
                    "Upload Profile Photo",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: const Icon(Icons.close, color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 15),

            ListTile(
              leading: SvgPicture.asset("assets/hrms/gallery.svg"),
              title: const Text("Gallery"),
              onTap: () {
                Get.back();
                controller.pickImage();
              },
            ),

            ListTile(
              leading: SvgPicture.asset("assets/hrms/camera.svg"),
              title: const Text("Camera"),
              onTap: () {
                Get.back();
                controller.pickImage();
              },
            ),
          ],
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.white,
    );
  }
}
