import 'dart:async';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/controllers/dailer_controller.dart';
import 'package:smart_solutions/controllers/follow_form_controller.dart';
import 'package:smart_solutions/controllers/internet_checker.dart';
import 'package:smart_solutions/controllers/remark_status_controller.dart';

class CallStateService {
  static const MethodChannel _channel = MethodChannel(
    'com.smartsolutions/call_log',
  );

  static final connectivity = Get.find<ConnectivityController>();

  // static Future<int> getLastCallDuration() async {
  //   try {
  //     final duration = await _channel.invokeMethod<int>('getLastCallDuration');

  //     final followBackFormController = Get.find<FollowBackFormController>();
  //     final remarkStatusController = Get.find<RemarkStatusController>();

  //     followBackFormController.contacted.value =
  //         (duration ?? 0) > 0 ? 'Yes' : 'No';

  //     // Wait for GetX to update all reactive bindings
  //     await Future.delayed(const Duration(milliseconds: 100));

  //     String statusForAPI = followBackFormController.contactStatus;

  //     // First, check actual internet access before calling API
  //     if (connectivity.isOnline.value) {
  //       await remarkStatusController.fetchRemarkStatus(statusForAPI);
  //     } else {
  //       Get.snackbar('No Internet', 'Will retry when connected');

  //       // Wait until online again
  //       ever(connectivity.isOnline, (bool connected) async {
  //         if (connected) {
  //           await remarkStatusController.fetchRemarkStatus(statusForAPI);
  //           // Get.snackbar('Internet Restored', 'Data synced successfully');
  //         }
  //       });
  //     }

  //     return duration ?? 0;
  //   } catch (e) {
  //     print("Error in getLastCallDuration: $e");
  //     return 0;
  //   }
  // }

  // static Future<Map<dynamic, dynamic>> getLastCallInfo() async {
  //   final result = await _channel.invokeMethod('getLastCallInfo');
  //   return Map<dynamic, dynamic>.from(result);
  // }

  // static Future<Map<dynamic, dynamic>>
  // getLastCallInfo() async {
  //   await Future.delayed(const Duration(milliseconds: 100));
  //   try {
  //     final result = await _channel.invokeMethod('getLastCallInfo');
  //     final callMap = Map<dynamic, dynamic>.from(result);

  //     // Get your controllers
  //     final dialerController = Get.find<DialerController>();
  //     final followBackFormController = Get.find<FollowBackFormController>();
  //     final remarkStatusController = Get.find<RemarkStatusController>();

  //     // Extract info from callMap
  //     //  final callType = callMap['type']?.toString() ?? 'unknown';
  //     final callDuration = (callMap['duration'] ?? 0) as int;
  //     final name = callMap['name']?.toString() ?? '';
  //     final number =
  //         callMap['number'].toString().replaceAll(RegExp(r'^\+91\s*'), '');
  //     //callMap['number']?.toString() ?? '';

  //     // Only clear for missed calls (duration == 0)
  //     if (callDuration == 0) {
  //       dialerController.customerName.value = name;
  //       followBackFormController.mobile.value = number;
  //       followBackFormController.contacted.value = 'No';
  //       dialerController.elapsedTimeInSeconds.value = callDuration;
  //       await remarkStatusController.fetchRemarkStatus('2');
  //     } else {
  //       // Incoming or outgoing call → keep info
  //       dialerController.customerName.value = name;
  //       followBackFormController.mobile.value = number;
  //       followBackFormController.contacted.value = 'Yes';
  //       dialerController.elapsedTimeInSeconds.value = callDuration;
  //       await remarkStatusController.fetchRemarkStatus('1');
  //     }

  //     // Give GetX time to update reactive fields
  //     await Future.delayed(const Duration(milliseconds: 50));

  //     // Call API if online
  //     if (connectivity.isOnline.value) {
  //       String statusForAPI = followBackFormController.contactStatus;
  //       await remarkStatusController.fetchRemarkStatus(statusForAPI);
  //     } else {
  //       Get.snackbar('No Internet', 'Will retry when connected');
  //       ever(connectivity.isOnline, (bool connected) async {
  //         if (connected) {
  //           String statusForAPI = followBackFormController.contactStatus;
  //           await remarkStatusController.fetchRemarkStatus(statusForAPI);
  //         }
  //       });
  //     }

  //     return callMap;
  //   } catch (e) {
  //     print("Error in getLastCallInfo: $e");
  //     return {};
  //   }
  // }

  static Future<Map<dynamic, dynamic>> getLastCallInfo() async {
    await Future.delayed(const Duration(milliseconds: 100));

    try {
      final result = await _channel.invokeMethod('getLastCallInfo');
      final callMap = Map<dynamic, dynamic>.from(result);

      final dialerController = Get.find<DialerController>();
      final followController = Get.find<FollowBackFormController>();
      final remarkController = Get.find<RemarkStatusController>();

      final int callDuration = (callMap['duration'] ?? 0) as int;
      final String name = callMap['name']?.toString() ?? '';
      final String number =
          callMap['number']?.toString().replaceAll(RegExp(r'^\+91\s*'), '') ??
              '';

      // Update common fields
      dialerController.customerName.value = name;

      followController.mobile.value = number;
      dialerController.elapsedTimeInSeconds.value = callDuration;

      // Determine contacted status
      final bool isContacted = callDuration > 0;
      followController.isDurationAvailable.value = callDuration < 0;

      followController.contacted.value = isContacted ? 'Yes' : 'No';

      // API status value
      final String apiStatus = isContacted ? '1' : '2';

      // Fetch remark status ONLY ONCE
      if (connectivity.isOnline.value) {
        await remarkController.fetchRemarkStatus(apiStatus);
      } else {
        Get.snackbar('No Internet', 'Will retry when connected');
      }

      return callMap;
    } catch (e) {
      // debugPrint("Error in getLastCallInfo: $e");
      return {};
    }
  }
}
