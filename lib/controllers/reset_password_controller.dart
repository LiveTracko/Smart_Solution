import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_solutions/constants/api_urls.dart';
import 'dart:convert';

import 'package:smart_solutions/constants/static_stored_data.dart';
import 'package:smart_solutions/services/api_service.dart';

class ResetPasswordController extends GetxController {
  final ApiService _apiService = ApiService();

  final TextEditingController passwordController = TextEditingController();

  RxBool isLoading = false.obs;

  Future<void> resetPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String tellercallerId = prefs.getString('t') ?? "User";
    String password = passwordController.text.trim();

    if (password.isEmpty) {
      Get.snackbar("Error", "Fields cannot be empty");
      return;
    }

    isLoading.value = true;

    try {
      var response = await _apiService.postRequest(
        APIUrls.changePassword,
        {
          "telecaller_id": StaticStoredData.userId,
          "newpassword": password,
        },
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Get.snackbar("Success", data["message"]);
        Get.offAllNamed("/navscreen"); // Navigate to login screen after reset
      } else {
        print(data["status"]);
        Get.snackbar("Error", data["message"]);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }
}
