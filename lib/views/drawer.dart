import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_solutions/constants/static_stored_data.dart';
import 'package:smart_solutions/controllers/internet_checker.dart';
import 'package:smart_solutions/controllers/login_controllers.dart';
import 'package:smart_solutions/controllers/profile_controller.dart';
import 'package:smart_solutions/controllers/theme_controller.dart';
import 'package:smart_solutions/views/forget_password.dart';
import 'package:smart_solutions/views/hrms/hrm_screen.dart';
import 'package:smart_solutions/views/listing_screen.dart';
import 'package:smart_solutions/views/login_request_screen.dart';
import 'package:smart_solutions/views/login_screen.dart';
import 'package:smart_solutions/views/theme_change_screen.dart';
import 'package:smart_solutions/views/profile_view.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final ProfileController _profileController = Get.find<ProfileController>();
  String _userName = "";

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? "Name";
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    // final statusBarHeight = MediaQuery.of(context).padding.top;

    return SafeArea(
      top: true,
      child: Drawer(
        width: MediaQuery.of(context).size.width *
            0.65, // slightly wider for better visibility
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(30)),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                // ================= HEADER =================
                Container(
                  height: screenHeight.clamp(500, 900) * 0.25,
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    left: 16.w,
                    top: 16.h,
                    right: 16.w,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () => Get.to(() => ProfilePage()),
                        child: CircleAvatar(
                          radius: screenHeight * 0.05, // responsive avatar
                          backgroundColor: Colors.white,
                          backgroundImage: _profileController.imageFile.value !=
                                  null
                              ? FileImage(_profileController.imageFile.value!)
                              : (_profileController
                                      .profileImageUrl.value.isNotEmpty
                                  ? NetworkImage(
                                      _profileController.profileImageUrl.value)
                                  : const AssetImage(
                                          "assets/images/app_login.png")
                                      as ImageProvider),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        _userName.toUpperCase(),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // ================= BODY =================
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        // if (StaticStoredData.roleName == 'telecaller')
                        _drawerSvgTile(
                          'assets/drawer/pin_marker.svg',
                          'Company & Pincode',
                          () => Get.to(
                            () => ListingScreen(
                              title: 'Listing',
                              isShowBack: true,
                              isDrawer: false,
                            ),
                          ),
                        ),
                        if (StaticStoredData.roleName == 'telecaller')
                          _drawerSvgTile(
                            'assets/drawer/login_request.svg',
                            'Login Request',
                            () => Get.to(
                              () => LoginRequestScreen(
                                title: 'Login Request',
                                isShowBack: true,
                                isDrawer: false,
                              ),
                            ),
                          ),
                        // if (StaticStoredData.roleName == 'telecaller')
                        //   _drawerSvgTile(
                        //     'assets/drawer/about_us.svg',
                        //     'About Us',
                        //     () {},
                        //   ),
                        // if (StaticStoredData.roleName == 'telecaller')
                        _drawerSvgTile(
                          'assets/drawer/lock.svg',
                          'Reset Password',
                          () => Get.to(() => const ForgetView()),
                        ),
                        if (StaticStoredData.roleName == 'telecaller')
                          _drawerSvgTile(
                            'assets/drawer/login_request.svg',
                            'HRM',
                            () => Get.to(() => HrmScreen()),
                          ),
                        // if (StaticStoredData.roleName == 'telecaller')
                        _drawerSvgTile(
                          'assets/drawer/theme.svg',
                          'Theme',
                          () => Get.to(() => ThemeChangeScreen()),
                        ),
                        const Spacer(),
                        const Divider(),
                        _drawerTile(
                          'assets/drawer/log_out.svg',
                          'Log Out',
                          () async {
                            StaticStoredData.userId = '';
                            StaticStoredData.number = '';

                            _profileController.nameController.clear();
                            _profileController.usernameController.clear();
                            _profileController.imageFile.value = null;
                            _profileController.profileImageUrl.value = '';

                            if (Get.isRegistered<ProfileController>()) {
                              Get.delete<ProfileController>();
                            }

                            final prefs = await SharedPreferences.getInstance();
                            prefs.clear();

                            await Get.deleteAll(force: true);

                            // 4️⃣ Re-register GLOBAL controllers
                            Get.put(ConnectivityController(), permanent: true);
                            Get.put(ThemeController(), permanent: true);

                            Get.put(
                              LoginViewModel(),
                            );
                            Get.offAll(() => const LoginView());
                          },
                          isBottomTile: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // ================= CLOSE BUTTON =================
            Positioned(
              top: 12.h,
              right: 12.w,
              child: SafeArea(
                child: Padding(
                  padding:
                      EdgeInsets.all(8.w), // optional padding inside safe area
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: SvgPicture.asset(
                      'assets/drawer/cross.svg',
                      // width: 24.w,
                      // height: 24.h,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= SVG TILE =================
  Widget _drawerSvgTile(String asset, String title, VoidCallback onTap) {
    return ListTile(
      dense: true,
      leading: SvgPicture.asset(
        asset,
        fit: BoxFit.contain,
        colorFilter: const ColorFilter.mode(
          Colors.grey,
          BlendMode.srcIn,
        ),
      ),
      title: Text(title, style: TextStyle(fontSize: 14.sp)),
      onTap: onTap,
    );
  }

  // ================= ICON TILE =================
  Widget _drawerTile(
    String asset,
    String title,
    VoidCallback onTap, {
    bool isBottomTile = false,
  }) {
    return ListTile(
      dense: true,
      leading: SizedBox(
        width: 24.w,
        height: 24.h,
        child: SvgPicture.asset(
          asset,
          fit: BoxFit.contain,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: isBottomTile ? 16.sp : 14.sp,
          color: isBottomTile ? Colors.red : Colors.black,
        ),
      ),
      onTap: onTap,
    );
  }
}
