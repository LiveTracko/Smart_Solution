import 'package:flutter/material.dart';
import 'package:smart_solutions/theme/app_theme.dart';
import 'package:smart_solutions/widget/common_scaffold.dart';

class ProfileListPage extends StatelessWidget {
  const ProfileListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: 'Profile',
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- PROFILE HEADER ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryColor, AppColors.primaryColor],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      const CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage('assets/profile.png'),
                          backgroundColor: Colors.white),
                      Positioned(
                          bottom: 0,
                          right: 4,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.indigo,
                                width: 2,
                                strokeAlign: BorderSide.strokeAlignOutside,
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.white,
                              child: IconButton(
                                icon: const Icon(Icons.edit,
                                    size: 16, color: Colors.indigo),
                                onPressed: () {
                                  // edit image logic
                                },
                              ),
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Shashi Chanyal",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    "Admin",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            // --- DETAILS LIST ---
            const SizedBox(height: 20),
            _buildListTile(Icons.person, "Personal Details", context),
            _buildListTile(Icons.work, "Current Employment", context),
            _buildListTile(Icons.settings, "Custom Details", context),
            _buildListTile(Icons.access_time, "Attendance Details", context),
            _buildListTile(Icons.account_balance, "Bank Details", context),
            _buildListTile(Icons.security, "User Permission", context),
          ],
        ),
      ),
    );
  }

  // Widget _buildListTile(IconData icon, String title, BuildContext context) {
  //   return Card(
  //     margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //     child: ListTile(
  //       leading: Icon(icon, color: Colors.indigo),
  //       title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
  //       trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
  //       onTap: () {
  //         // Navigate to details page
  //       },
  //     ),
  //   );
  // }
  Widget _buildListTile(IconData icon, String title, BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: Colors.blue.shade800,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primaryColor, width: 2),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.primaryColor,
            fontSize: 16,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
            color: AppColors.primaryColor,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_forward_ios_rounded,
              size: 14, color: Colors.white),
        ),
        onTap: () {
          // Navigate to details page
        },
      ),
    );
  }
}
