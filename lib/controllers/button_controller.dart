import 'package:get/get.dart';

class ToggleButtonController extends GetxController {
  var selectedIndex = 0.obs;

  void select(int index) {
    selectedIndex.value = index;
    
  }
}
