import 'package:get/get.dart';
import 'package:smart_solutions/controllers/dailer_controller.dart';
import '../controllers/login_controllers.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginViewModel>(() => LoginViewModel());
    Get.lazyPut<DialerController>(() => DialerController(),);
  }
}
