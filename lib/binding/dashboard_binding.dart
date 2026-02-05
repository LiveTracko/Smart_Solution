import 'package:get/get.dart';

import '../constants/static_stored_data.dart';
import '../controllers/admin/admin_disbursement.dart';
import '../controllers/admin/call_back_controller.dart';
import '../controllers/admin/call_log_controller.dart';
import '../controllers/all_disbursement_controller.dart';
import '../controllers/chartCard_controller.dart';
import '../controllers/common_filter_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/data_entry_controller.dart';
import '../controllers/login_request_controller.dart';
import '../controllers/profile_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController());
    Get.lazyPut(() => ProfileController());
    Get.lazyPut(() => ChartCardsController());
    Get.lazyPut(() => DataController());
    Get.lazyPut(() => CommonFilterController());
    Get.lazyPut(() => DisbursementController());
    Get.lazyPut(() => DisbursementDetailsController());
    Get.lazyPut(() => LoginRequestController());

    // Role-based lazy loading
    if (StaticStoredData.roleName != 'telecaller') {
      Get.lazyPut(() => AdminCallLogController());
      Get.lazyPut(() => AdminCallBackController());
    }
  }
}
