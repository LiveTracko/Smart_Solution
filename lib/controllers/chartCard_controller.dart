import 'package:get/get.dart';

class ChartCardsController extends GetxController {
  var selectedIndex = 0.obs;

  @override
  void onClose() {
    selectedIndex.value = 0;
    super.onClose();
  }
}
