import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_solutions/constants/static_stored_data.dart';
import 'package:smart_solutions/controllers/dashboard_controller.dart';
import 'package:smart_solutions/controllers/login_controllers.dart';
import 'package:smart_solutions/views/data_entry_screen.dart';
import 'package:smart_solutions/views/login_screen.dart';
import 'package:smart_solutions/views/reset_password.dart';

class CustomDrawer extends StatefulWidget {
  CustomDrawer({super.key});

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
        child: Column(
          children: <Widget>[
            Stack(children: [
              UserAccountsDrawerHeader(
                accountName: Text(
                  _userName.toUpperCase(),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                accountEmail: Text(''),
                currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white, // Set a background color
                    child: Text(
                        _userName.isNotEmpty
                            ? _userName[0].toUpperCase()
                            : "A", // Get the first letter
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Text color
                        ))),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
              ),
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
                      )))
            ]),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Add navigation logic here
              },
            ),
            ListTile(
              leading: const Icon(Icons.list_alt_rounded),
              title: const Text('Data entry list'),
              onTap: () {
                Get.to(() => DataEntryViewScreen()); // Close the drawer
                // Add navigation logic here
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About Us'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Add navigation logic here
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Reset Password'),
              onTap: () {
                Get.to(() => ChangePasswordScreen()); // Close the drawer
                // Add navigation logic here
              },
            ),
            const Divider(), // Divider for separation
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
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
      ),
    );
  }
}
