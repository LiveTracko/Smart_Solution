import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityController extends GetxController {
  var isOnline = true.obs;

  @override
  void onInit() {
    super.onInit();
    _checkInitialConnection();

    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      final hasConnection =
          results.any((result) => result != ConnectivityResult.none);
      isOnline.value = hasConnection;

      if (!hasConnection) {
        Get.snackbar(
          "No Internet",
          "You're offline",
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
          duration: const Duration(seconds: 2),
        );
      }
    });
  }

  Future<void> _checkInitialConnection() async {
    final results = await Connectivity().checkConnectivity();
    final hasConnection =
        results.any((result) => result != ConnectivityResult.none);
    isOnline.value = hasConnection;
  }
}
