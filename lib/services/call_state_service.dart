import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/controllers/follow_form.dart';
import 'package:smart_solutions/controllers/remark_status_controller.dart';

class CallStateService {
  static const MethodChannel _channel =
      MethodChannel('com.smartsolutions/call_log');

  static Future<int> getLastCallDuration() async {
    try {
      final duration = await _channel.invokeMethod<int>('getLastCallDuration');

      // Get the controller from GetX
      final followBackFormController = Get.find<FollowBackFormController>();
      final remarkStatusController = Get.find<RemarkStatusController>();
      followBackFormController.contacted.value =
          int.parse(duration.toString()) > 0 ? 'Yes' : 'No';
      remarkStatusController
          .fetchRemarkStatus(followBackFormController.contactStatus);

      return duration ?? 0;
    } catch (e) {
      print("Error reading call log: $e");
      return 0;
    }
  }
}
