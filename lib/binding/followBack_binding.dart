import 'package:get/get.dart';

import '../controllers/follow_form_controller.dart';

class FollowBackFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FollowBackFormController());
  }
}
