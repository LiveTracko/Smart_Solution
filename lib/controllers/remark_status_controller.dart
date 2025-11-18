import 'dart:convert';
import 'package:get/get.dart';
import 'package:smart_solutions/models/all_followup_status.dart';
import 'package:smart_solutions/models/remark_status_model.dart';
import '../constants/services.dart';
import '../services/api_service.dart';
import '../constants/api_urls.dart';

class RemarkStatusController extends GetxController {
  final ApiService _apiService = ApiService();
  var remarkStatusList = <Data>[].obs;
  var isLoading = false.obs;
  var isCallback = false.obs;

  var filterFollowupStatus = <GetAllFollowupStatus>[].obs;
  @override
  void onInit() {
    super.onInit();

    // DialerController dialerController = Get.find();
    //  dialerController.fetchNextPhoneNumber();
    fetchRemarkStatus('2');
    getAllFollowupStatusName();
  }

  Future<void> fetchRemarkStatus(String status) async {
    try {
      isLoading(true);
      final response = await _apiService.postRequest(
        APIUrls.remarkStatusCode,
        {'status': status},
      ).timeout(const Duration(seconds: 20)); // 10-second timeout;

      if (response.statusCode == 200) {
        final remarkStatus = RemarkStatus.fromJson(json.decode(response.body));
        if (remarkStatus.data != null) {
          remarkStatusList.assignAll(remarkStatus.data!);
        }
      }
    } catch (e) {
      logOutput('Error fetching remark status: $e');
      Get.snackbar(
        'Error',
        'Failed to load remark status options',
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> getAllFollowupStatusName() async {
    try {
      var response = await ApiService().getRequest(APIUrls.getFollowUpStatus);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final statusList = GetAllFollowupStatus.fromJson(responseData);
        if (statusList.data.isNotEmpty) {
          filterFollowupStatus.add(statusList);
        }
      }
    } catch (e) {
      logOutput('An error occurred while fetching source list: $e');
      // Ensure loading is set to false on error as well
    }
  }
}
