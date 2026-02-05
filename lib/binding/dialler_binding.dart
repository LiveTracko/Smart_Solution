import 'package:get/get.dart';

import '../controllers/dailer_controller.dart';

class DialerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DialerController());
  }
}
