import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeaveController extends GetxController {
  var leaveType = ''.obs;
  var fromDate = Rxn<DateTime>();
  var toDate = Rxn<DateTime>();
  var reason = ''.obs;
  var isSubmitting = false.obs;
  var halfDaySession = ''.obs;

  void updateLeaveType(String? value) => leaveType.value = value.toString();
  void updateFromDate(DateTime date) => fromDate.value = date;
  void updateToDate(DateTime date) => toDate.value = date;
  void updateReason(String value) => reason.value = value;

  void updateHalfDaySession(String? value) {
    if (value != null) halfDaySession.value = value;
  }

  Future<void> submitLeave(BuildContext context) async {
    if (leaveType.value.isEmpty ||
        fromDate.value == null ||
        toDate.value == null ||
        reason.value.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isSubmitting.value = true;
    await Future.delayed(const Duration(seconds: 1)); // simulate API call
    isSubmitting.value = false;

    Get.snackbar('Success', 'Leave request submitted successfully ✅',
        snackPosition: SnackPosition.BOTTOM);

    Get.back(); // navigate back
  }
}
