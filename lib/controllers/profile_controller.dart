import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_solutions/constants/api_urls.dart';
import 'package:smart_solutions/constants/services.dart';
import 'package:smart_solutions/constants/static_stored_data.dart';
import 'package:smart_solutions/services/api_service.dart';
import 'package:smart_solutions/views/dashboard_screen.dart';

class ProfileController extends GetxController {
  // Observables
  var imageFile = Rx<File?>(null);
  var nameController = TextEditingController();
  var usernameController = TextEditingController();
  var isLoading = false.obs;
  var profileImageUrl = "".obs;

  @override
  onInit() async {
    super.onInit();
    usernameController.text = StaticStoredData.number;
    imageFile.value = null;
    await getProfileData(StaticStoredData.userId);
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
                }
                Get.back(); // Close bottom sheet
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
                }
                Get.back(); // Close bottom sheet
              },
            ),
          ],
        ),
      ),
    );
  }
  

  // Save login request
  Future<void> saveProfile(
    String telecallerId,
    String name,
    String mobileNo,
  ) async {
    isLoading(true);
    try {
      // Prepare the fields map
      var fields = {
        "telecaller_id": telecallerId,
        "name": name,
        "mobileno": mobileNo,
      };

      // If image is selected, include it in multipart
      File? image = imageFile.value;

      // ignore: prefer_typing_uninitialized_variables
      var response;
      if (image != null) {
        response = await ApiService().multipartPostRequest(
          APIUrls.profileUpdate,
          fields,
          imageFile.value,
          'profile_image',
        );
      } else {
        // Without image
        response =
            await ApiService().postRequest(APIUrls.profileUpdate, fields);
      }

      // Handle the response
      if (response.statusCode == 200) {
        Get.snackbar(
          "Profile Updated",
          "Name: $name",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.2),
        );

        Get.offAll(() => const DashboardScreen());
      } else {
        Get.snackbar('Error', 'Failed to update profile.');
      }
    } catch (e) {
      logOutput("An error occurred while saving the login request: $e");
    } finally {
      isLoading(false); // Stop loading
    }
  }

  Future<void> getProfileData(String telecallerId) async {
    isLoading(true);
    try {
      var fields = {
        "telecaller_id": telecallerId,
      };

      // Call GET or POST depending on backend
      var response =
          await ApiService().postRequest(APIUrls.fetchProfileImage, fields);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        nameController.text = data["data"]["name"] ?? "";
        //    usernameController.text = data["data"]["username"] ?? "";
        // Case 1: profile_image is a string (URL or filename)
        if (data["data"]["profile_image"] is String) {
          profileImageUrl.value =
              APIUrls.imagebaseUrl + data["data"]["profile_image"];
        }

        // Case 2: profile_image is an object with "url"
        else if (data["data"]["profile_image"] is Map &&
            data["data"]["profile_image"]["url"] != null) {
          profileImageUrl.value =
              APIUrls.imagebaseUrl + data["data"]["profile_image"]["url"];
        }
      } else {
        Get.snackbar('Error', 'Failed to fetch profile.');
      }
    } catch (e) {
      logOutput("Error fetching profile: $e");
    } finally {
      isLoading(false);
    }
  }
}
