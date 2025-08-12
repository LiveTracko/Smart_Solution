import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_solutions/constants/static_stored_data.dart';
import 'package:smart_solutions/controllers/dashboard_controller.dart';
import 'package:smart_solutions/controllers/login_controllers.dart';
import 'package:smart_solutions/views/listing_screen.dart';
import 'package:smart_solutions/views/login_screen.dart';
import 'package:smart_solutions/views/report_page.dart';
import 'package:smart_solutions/views/reset_password.dart';

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
                children: <Widget>[
                  // Header Section
                  Container(
                    height: 150,
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30, // Reduced circle size
                          backgroundColor: Colors.white,
                          child: Text(
                            _userName.isNotEmpty
                                ? _userName[0].toUpperCase()
                                : "A",
                            style: const TextStyle(
                              fontSize:
                                  25, // Adjust font size for the smaller circle
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16), // Spacer
                        Text(
                          _userName.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 15, // Reduced font size for the name
                            fontWeight: FontWeight.bold,
                            color: Colors
                                .white, // Changed text color to white for visibility
                          ),
                        ),
                      ],
                    ),
                  ),

                  ListTile(
                    leading: const Icon(Icons.list_alt),
                    title: const Text('Listing'),
                    onTap: () {
                      Get.to(() => const ListingScreen());
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.list),
                    title: const Text('Reports'),
                    onTap: () {
                      Get.to(() => const ReportPage());
                    },
                  ),
                  if (StaticStoredData.roleName == 'telecaller')
                    ListTile(
                      leading: const Icon(Icons.supervisor_account_rounded),
                      title: const Text('Customer'),
                      onTap: () {},
                    ),
                  ListTile(
                    leading: const Icon(Icons.lock),
                    title: const Text('Reset Password'),
                    onTap: () {
                      Get.to(() => const ChangePasswordScreen());
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Logout'),
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.clear();
                      StaticStoredData.userId = '';
                      Get.put(LoginViewModel());
                      Get.offAll(() => const LoginView());
                      // ignore: unused_local_variable
                      final LoginViewModel controller = Get.find();
                    },
                  ),
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
}
