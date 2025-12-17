import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_solutions/constants/static_stored_data.dart';
import 'package:smart_solutions/controllers/login_controllers.dart';
import 'package:smart_solutions/controllers/profile_controller.dart';
import 'package:smart_solutions/views/hrms/hrm_screen.dart';
import 'package:smart_solutions/views/listing_screen.dart';
import 'package:smart_solutions/views/login_screen.dart';
import 'package:smart_solutions/views/update_profile_screen.dart';
import 'package:smart_solutions/views/profile_view.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final ProfileController _profileController = Get.find<ProfileController>();
  String _userName = ""; // Default text while loading

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? "name";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 100.h),
      child: Drawer(
        width: MediaQuery.of(context).size.width * 0.6,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.zero,
            topRight: Radius.circular(30),
          ),
        ),
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color(0xFFFFFFFF),
                    Color(0xFF356EFF),
                  ],
                  stops: [0.7788, 1.0],
                ),
              ),
              child: Column(
                children: [
                  // ===== HEADER =====
                  Container(
                    height: 150,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () => Get.to(() => UpdateProfilePage()),
                              child: CircleAvatar(
                                radius: 45,
                                backgroundColor: Colors.indigo.shade700,
                                backgroundImage: _profileController
                                            .imageFile.value !=
                                        null
                                    ? FileImage(
                                        _profileController.imageFile.value!)
                                    : (_profileController
                                            .profileImageUrl.value.isNotEmpty
                                        ? NetworkImage(_profileController
                                            .profileImageUrl.value)
                                        : const AssetImage(
                                                "assets/images/app_login.png")
                                            as ImageProvider),
                              ),
                            ),
                            const SizedBox(
                              width: 11,
                              height: 5,
                            ),
                            Text(
                              _userName.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ===== TOP GROUP =====
                  ListTile(
                    leading: const Icon(Icons.list_alt),
                    title: const Text('Listing'),
                    onTap: () => Get.to(() => ListingScreen(
                          title: 'Listing',
                          isShowBack: true,
                          isDrawer: false,
                        )),
                  ),
                  // ListTile(
                  //   leading: const Icon(Icons.list),
                  //   title: const Text('Reports'),

                  //   onTap: () => Get.to(() => const ReportPage()),
                  // ),
                  if (StaticStoredData.roleName == 'telecaller')
                    ListTile(
                      leading: const Icon(Icons.supervisor_account_rounded),
                      title: const Text('Customer'),
                      onTap: () {},
                    ),
                  //
                  if (StaticStoredData.roleName == 'telecaller')
                    ListTile(
                      leading: const Icon(Icons.supervisor_account_rounded),
                      title: const Text('Profile'),
                      onTap: () => Get.to(() => ProfilePage()),
                    ),

                  if (StaticStoredData.roleName == 'telecaller')
                    ListTile(
                      leading: const Icon(Icons.supervisor_account_rounded),
                      title: const Text('Attendence'),
                      onTap: () => Get.to(() => const HrmScreen()),
                    ),

                  // if (StaticStoredData.roleName == 'telecaller')
                  //   ListTile(
                  //       leading: const Icon(Icons.supervisor_account_rounded),
                  //       title: const Text('Fllow up Record'),
                  //       onTap: () => Get.to(() => FollowBackListScreen())),
                  const Spacer(),

                  // ===== BOTTOM GROUP =====
                  const Divider(),
                  // _drawerTile(Icons.home, 'Home', () async {
                  //   SharedPreferences prefs =
                  //       await SharedPreferences.getInstance();
                  //   prefs.clear();
                  //   StaticStoredData.userId = '';
                  //   Get.put(DashboardTodayModel());
                  //   Get.offAll(() => DashboardScreen());
                  // }),
                  _drawerTile(Icons.info_rounded, 'About us', () {}),
                  _drawerTile(Icons.lock, 'Reset Password', () {}),
                  _drawerTile(Icons.logout, 'Logout', () async {
                    // Clear stored static data
                    StaticStoredData.userId = '';
                    StaticStoredData.number = '';

                    // Clear controller values
                    _profileController.nameController.clear();
                    _profileController.usernameController.clear();
                    _profileController.imageFile.value = null;
                    _profileController.profileImageUrl.value = '';

                    // Delete the ProfileController instance
                    if (Get.isRegistered<ProfileController>()) {
                      Get.delete<ProfileController>();
                    }

                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.clear();
                    StaticStoredData.userId = '';
                    Get.put(LoginViewModel());
                    Get.offAll(() => LoginView());
                  }),
                ],
              ),
            ),

            // Close button
            Positioned(
                top: 15,
                right: 15,
                child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: SvgPicture.asset('assets/images/cross.svg'))),
          ],
        ),
      ),
    );
  }

// Reusable ListTile with compact spacing

  Widget _drawerTile(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isBottomTile = false, // flag to style differently
  }) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity(vertical: -2),
      leading: Icon(
        icon,
        size: isBottomTile ? 28 : 22, // bigger icon for bottom tiles
        color: Colors.black87,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: isBottomTile ? 16 : 14, // bigger text for bottom tiles
          fontWeight: isBottomTile ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      onTap: onTap,
    );
  }
}
