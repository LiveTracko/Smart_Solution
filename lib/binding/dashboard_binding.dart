import 'package:get/get.dart';
import 'package:smart_solutions/controllers/active_files_controller.dart';
import 'package:smart_solutions/controllers/dailer_controller.dart'
    show DialerController;
import 'package:smart_solutions/controllers/follow_form_controller.dart';

import '../constants/static_stored_data.dart';
import '../controllers/admin/admin_disbursement.dart';
import '../controllers/admin/call_back_controller.dart';
import '../controllers/admin/call_log_controller.dart';
import '../controllers/all_disbursement_controller.dart';
import '../controllers/chartCard_controller.dart';
import '../controllers/common_filter_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/data_entry_controller.dart';
import '../controllers/login_controllers.dart';
import '../controllers/login_request_controller.dart';
import '../controllers/profile_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    print('Dashboard binding initialization');
    Get.lazyPut(() => DashboardController(), fenix: true);
    Get.lazyPut(() => ProfileController(), fenix: true);
    Get.lazyPut(() => LoginViewModel(), fenix: true);
    Get.lazyPut(() => DialerController(), fenix: true);
    Get.lazyPut(() => DataController(), fenix: true);
    Get.lazyPut(() => ActiveFilesController(), fenix: true);
    Get.lazyPut(() => FollowBackFormController(), fenix: true);
    Get.lazyPut(() => CommonFilterController(), fenix: true);
    Get.lazyPut(() => DisbursementController(), fenix: true);
    Get.lazyPut(() => LoginRequestController(), fenix: true);
    Get.lazyPut(() => DisbursementDetailsController(), fenix: true);
    Get.lazyPut(() => DisbursementDetailsController(), fenix: true);
    Get.lazyPut(() => ChartCardsController(), fenix: true);

    // Get.lazyPut(() => ConnectivityController(), fenix: true);
    // Get.lazyPut(() => ThemeController(), fenix: true);

    if (StaticStoredData.roleName != 'telecaller') {
      Get.lazyPut(() => AdminCallLogController(), fenix: true);
      Get.lazyPut(() => AdminCallBackController(), fenix: true);
    }
  }

// class DashboardBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut(() => DashboardController(),);
//     Get.lazyPut(() => ProfileController());
//     Get.lazyPut(() => ChartCardsController());
//     Get.lazyPut(() => DataController());
//     Get.lazyPut(() => CommonFilterController());
//     Get.lazyPut(() => DisbursementController());
//     Get.lazyPut(() => DisbursementDetailsController());
//     Get.lazyPut(() => LoginRequestController());

//     // Role-based lazy loading
//     if (StaticStoredData.roleName != 'telecaller') {
//       Get.lazyPut(() => AdminCallLogController());
//       Get.lazyPut(() => AdminCallBackController());
//     }
//   }
}
