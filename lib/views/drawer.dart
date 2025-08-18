import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_solutions/constants/static_stored_data.dart';
import 'package:smart_solutions/controllers/dashboard_controller.dart';
import 'package:smart_solutions/controllers/login_controllers.dart';
import 'package:smart_solutions/models/dashBoardToday_model.dart';
import 'package:smart_solutions/views/dashboard_screen.dart';
import 'package:smart_solutions/views/listing_screen.dart';
import 'package:smart_solutions/views/login_screen.dart';
import 'package:smart_solutions/views/report_page.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final DashboardController _dashboardController =
      Get.put(DashboardController());
  String _userName = ""; // Default text while loading

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName =
          prefs.getString('userName') ?? "name"; // Default name if not found
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      child: Drawer(
        width: MediaQuery.of(context).size.width * 0.6,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Color(0xFFFFFFFF), Color(0xFF356EFF)],
              stops: [0.7788, 1.0],
            ),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  // ===== HEADER =====
                  Container(
                    height: 150,
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.indigo.shade700,
                          child: Text(
                            _userName.isNotEmpty
                                ? _userName[0].toUpperCase()
                                : "A",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          _userName.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ===== TOP GROUP =====
                  ListTile(
                    leading: const Icon(Icons.list_alt),
                    title: const Text('Listing'),
                    onTap: () => Get.to(() => const ListingScreen()),
                  ),
                  ListTile(
                    leading: const Icon(Icons.list),
                    title: const Text('Reports'),
                    onTap: () => Get.to(() => const ReportPage()),
                  ),
                  if (StaticStoredData.roleName == 'telecaller')
                    ListTile(
                      leading: const Icon(Icons.supervisor_account_rounded),
                      title: const Text('Customer'),
                      onTap: () {},
                    ),

                  const Spacer(), // pushes the next section to the bottom

                  // ===== BOTTOM GROUP =====
                  const Divider(),
                  _drawerTile(Icons.home, 'Home', () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.clear();
                    StaticStoredData.userId = '';
                    Get.put(DashboardTodayModel());
                    Get.offAll(() => const DashboardScreen());
                  }),
                  _drawerTile(Icons.info_rounded, 'About us', () {}),
                  _drawerTile(Icons.lock, 'Reset Password', () {}),
                  _drawerTile(Icons.logout, 'Logout', () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.clear();
                    StaticStoredData.userId = '';
                    Get.put(LoginViewModel());
                    Get.offAll(() => const LoginView());
                  }),
                ],
              ),

              // Close button
              Positioned(
                top: 10,
                right: 10,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    onPressed: () {
                      _dashboardController.toggleDrawer();
                      Get.back();
                    },
                    icon: const Icon(Icons.close),
                  ),
                ),
              ),
            ],
          ),
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
      visualDensity: const VisualDensity(vertical: -2),
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
