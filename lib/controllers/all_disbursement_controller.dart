import 'package:get/get.dart';
import 'package:smart_solutions/constants/api_urls.dart';
import 'package:smart_solutions/models/all_disbursement_details.dart';
import 'package:smart_solutions/services/api_service.dart';

class DisbursementDetailsController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<Datum> disbursementList = <Datum>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDisbursementDetails();
  }

  /// Example API call
  Future<void> fetchDisbursementDetails() async {
    try {
      isLoading.value = true;

      // 🔹 Replace with your API URL
      final response = await ApiService()
          .getRequest(APIUrls.getYearlyMonthlyDisbursedAmounts);

      if (response.statusCode == 200) {
        final result = allDisbursementDetailsFromJson(response.body);

        disbursementList.assignAll(result.data);
      } else {
        Get.snackbar('Error', 'Failed to load data');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
