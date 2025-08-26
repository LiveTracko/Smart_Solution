// connectivity_controller.dart
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';


class ConnectivityController extends GetxController {
  var isOnline = true.obs;

  @override
  void onInit() {
    super.onInit();
    _checkInitialConnection();

    Connectivity().onConnectivityChanged.listen((results) {
      final hasConnection =
          results.any((result) => result != ConnectivityResult.none);
      isOnline.value = hasConnection;
    });
  }

  Future<void> _checkInitialConnection() async {
    final results = await Connectivity().checkConnectivity();
    isOnline.value =
        results.any((result) => result != ConnectivityResult.none);
  }
}
