import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/constants/static_stored_data.dart';
import 'package:smart_solutions/theme/app_theme.dart';
import '../controllers/profile_controller.dart';

class UpdateProfilePage extends StatelessWidget {
  UpdateProfilePage({super.key});

  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Update Profile"),
          backgroundColor: AppColors.primaryColor),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Image with Edit
              Center(
                child: Obx(
                  () => Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: controller.imageFile.value != null
                            ? FileImage(controller.imageFile.value!)
                            : (controller.profileImageUrl.value.isNotEmpty
                                ? NetworkImage(controller.profileImageUrl.value)
                                : const AssetImage(
                                        "assets/images/app_login.png")
                                    as ImageProvider),
                      ),

                      // CircleAvatar(
                      //   radius: 60,
                      //   backgroundImage: controller.imageFile.value != null
                      //       ? FileImage(controller.imageFile.value!)
                      //       : const AssetImage("assets/images/app_login.png")
                      //           as ImageProvider,
                      // ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: controller.pickImage,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primaryColor),
                            child: const Icon(Icons.edit, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Name
              TextField(
                controller: controller.nameController,
                style: TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Mobile Number
              TextField(
                controller: controller.usernameController,
                readOnly: true,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  labelText: "User Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),

              // Update Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    controller.saveProfile(
                        StaticStoredData.userId,
                        controller.nameController.text,
                        StaticStoredData.number);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Update Profile",
                    style: TextStyle(fontSize: 16, color: Colors.white),
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
