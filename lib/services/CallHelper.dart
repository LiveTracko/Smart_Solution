// import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';

// class CallHelper {
//   static const MethodChannel _platform = MethodChannel('direct_call');

//   static Future<void> makeDirectCall(String phoneNumber) async {
//     try {
//       await _platform
//           .invokeMethod('makeDirectCall', {'phoneNumber': phoneNumber});
//     } on PlatformException catch (e) {
//       debugPrint("Error making call: ${e.message}");
//     }
//   }
// }
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class CallHelper {
  static const MethodChannel _platform = MethodChannel('direct_call');

  static Future<void> makeDirectCall(String phoneNumber) async {
    try {
      await _platform
          .invokeMethod('makeDirectCall', {'phoneNumber': phoneNumber});
    } on PlatformException catch (e) {
      debugPrint("Error making call: ${e.message}");
    }
  }

  // static Future<bool> callStarted() async {
  //   try {
  //     final bool result = await _platform.invokeMethod('isCallPickedUp');

  //     return result;
  //   } catch (e) {
  //     return false;
  //   }
  // }
}
