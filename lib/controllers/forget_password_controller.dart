import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/constants/api_urls.dart';
import 'package:smart_solutions/services/api_service.dart';

class ForgetPasswordController extends GetxController {
  RxBool isverifying = false.obs;
  RxBool isverifyingotp = false.obs;
  RxBool isresetting = false.obs;
  Future<bool?> verifyMobileNo(String mobileNo) async {
    try {
      isverifying.value = true; // Set loading state to true
      final response = await ApiService().postRequest(
          APIUrls.verifyMobileNo, {'mobile': mobileNo},
          type: "reset");

      if (response.statusCode == 200) {
        // Handle successful verification
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(
            content: Text(
              "Mobile number verified successfully",
            ),
            backgroundColor: Colors.green,
          ),
        );

        return true;
      } else {
        isverifying.value = false; // Set loading state to false
        // Handle error
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(
            content: Text("Failed to verify mobile number"),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
    } catch (e) {
      isverifying.value = false; // Set loading state to false
      // Handle network or other errors
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text("An error occurred while verifying mobile number"),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    } finally {
      isverifying.value = false; // Ensure loading state is reset
    }
  }

  Future<bool> verifyOtp(String mobileNo, String otp) async {
    try {
      isverifyingotp(true);
      final response = await ApiService().postRequest(
          APIUrls.verifyOtp, {'mobile': mobileNo, 'otp': otp},
          type: "reset");

      if (response.statusCode == 200) {
        // Handle successful OTP verification
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(
            content: Text("OTP verified successfully"),
            backgroundColor: Colors.green,
          ),
        );
        return true;
      } else {
        isverifyingotp(false);
        // Handle error
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(
            content: Text("Failed to verify OTP"),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    } catch (e) {
      isverifyingotp(false);
      // Handle network or other errors
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text("An error occurred while verifying OTP"),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    } finally {
      isverifyingotp(false);
    }
  }

  Future<bool> resetPassword(String mobileNo, String newPassword) async {
    try {
      isresetting(true);
      final response = await ApiService().postRequest(
          APIUrls.resetPassword, {'mobile': mobileNo, 'password': newPassword},
          type: "reset");

      if (response.statusCode == 200) {
        // Handle successful password reset
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(
            content: Text("Password reset successfully"),
            backgroundColor: Colors.green,
          ),
        );
        return true;
      } else {
        isresetting(false);
        // Handle error
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(
            content: Text("Failed to reset password"),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
    } catch (e) {
      isresetting(false);
      // Handle network or other errors
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text("An error occurred while resetting password"),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    } finally {
      isresetting(false);
    }
  }
}
