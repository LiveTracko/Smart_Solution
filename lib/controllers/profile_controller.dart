import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_solutions/constants/static_stored_data.dart';
import '../constants/api_urls.dart';
import '../constants/services.dart';
import '../services/api_service.dart';
class ProfileController extends GetxController {
  
  var imageFile = Rx<File?>(null);

  final nameController = TextEditingController();
  final usernameController = TextEditingController();

  var isLoading = false.obs;
  var profileImageUrl = "".obs;

  @override
  void onInit() {
    super.onInit();
    getProfileData(StaticStoredData.userId);
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();

    Get.bottomSheet(
      Container(
        color: Colors.white,
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () async {
                final pickedFile =
                    await picker.pickImage(source: ImageSource.gallery);

                if (pickedFile != null) {
                  imageFile.value = File(pickedFile.path);

                  Get.back();
                  // ✅ AUTO SAVE AFTER SELECT
                  await saveProfile();
                } else {
                  Get.back();
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () async {
                final pickedFile =
                    await picker.pickImage(source: ImageSource.camera);

                if (pickedFile != null) {
                  imageFile.value = File(pickedFile.path);

                  Get.back(); // Close the bottom sheet before saving
                  // ✅ AUTO SAVE AFTER SELECT
                  await saveProfile();
                } else {
                  Get.back();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Save Profile (ONLY on button click)
  Future<void> saveProfile() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;

      var fields = {
        "telecaller_id": StaticStoredData.userId,
        "name": nameController.text.trim(),
        "mobileno": usernameController.text.trim(),
      };

      File? image = imageFile.value;

      var response =
          await ApiService().postRequest(APIUrls.profileUpdate, fields);

      if (image != null) {
        response = await ApiService().multipartPostRequest(
          APIUrls.profileUpdate,
          fields,
          image,
          'profile_image',
        );
      } else {
        response =
            await ApiService().postRequest(APIUrls.profileUpdate, fields);
      }

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(
            content: Text(
              "Profile updated successfully",
            ),
            backgroundColor: Colors.green,
          ),
        );

        await getProfileData(StaticStoredData.userId);


        //   Get.offAllNamed(AppRoutes.home);
      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(
            content: Text("Failed to update profile"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      logOutput("Profile error: $e");
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong"),
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ Fetch Profile
  Future<void> getProfileData(String id) async {
    try {
      isLoading.value = true;

      var response = await ApiService().postRequest(
        APIUrls.fetchProfileImage,
        {"telecaller_id": id},
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        nameController.text = data["data"]["name"] ?? "";
        usernameController.text = data["data"]["username"] ?? "";

        final imageData = data["data"]["profile_image"];

        if (imageData is String && imageData.isNotEmpty) {
          profileImageUrl.value = APIUrls.imagebaseUrl + imageData;
        } else if (imageData is Map && imageData["url"] != null) {
          profileImageUrl.value = APIUrls.imagebaseUrl + imageData["url"];
        }
      }
    } catch (e) {
      logOutput("Fetch error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    usernameController.dispose();
    super.onClose();
  }
}
