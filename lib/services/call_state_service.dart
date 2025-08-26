import 'dart:async';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/controllers/follow_form.dart';
import 'package:smart_solutions/controllers/internet_checker.dart';
import 'package:smart_solutions/controllers/remark_status_controller.dart';

class CallStateService {
  static const MethodChannel _channel =
      MethodChannel('com.smartsolutions/call_log');

  static final connectivity = Get.find<ConnectivityController>();

  static Future<int> getLastCallDuration() async {
    try {
      final duration = await _channel.invokeMethod<int>('getLastCallDuration');

      final followBackFormController = Get.find<FollowBackFormController>();
      final remarkStatusController = Get.find<RemarkStatusController>();

      followBackFormController.contacted.value =
          (duration ?? 0) > 0 ? 'Yes' : 'No';

      // First, check actual internet access before calling API
      if (connectivity.isOnline.value) {
        await remarkStatusController
            .fetchRemarkStatus(followBackFormController.contactStatus);
      }else{
        Get.snackbar('No Internet', 'Will retry when connected');
      }



      return duration ?? 0;
    } catch (e) {
      print("Error in getLastCallDuration: $e");
      return 0;
    }//
  }
}
