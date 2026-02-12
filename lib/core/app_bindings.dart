import 'package:get/get.dart';
import 'package:smart_solutions/controllers/active_files_controller.dart';
import 'package:smart_solutions/controllers/admin/admin_disbursement.dart';
import 'package:smart_solutions/controllers/admin/call_back_controller.dart';
import 'package:smart_solutions/controllers/admin/call_log_controller.dart';
import 'package:smart_solutions/controllers/all_disbursement_controller.dart';
import 'package:smart_solutions/controllers/common_filter_controller.dart';
import 'package:smart_solutions/controllers/dailer_controller.dart';
import 'package:smart_solutions/controllers/dashboard_controller.dart';
import 'package:smart_solutions/controllers/data_entry_controller.dart';
import 'package:smart_solutions/controllers/follow_form_controller.dart';
import 'package:smart_solutions/controllers/login_request_controller.dart';
import 'package:smart_solutions/controllers/profile_controller.dart';
import '../constants/static_stored_data.dart';
import '../controllers/login_controllers.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController());
    Get.lazyPut(() => ProfileController());
    // Get.lazyPut(() => ChartCardsController());
    Get.lazyPut(() => LoginViewModel());
    Get.lazyPut(() => DialerController(), fenix: true);
    Get.lazyPut(() => DataController());
    Get.lazyPut(() => ActiveFilesController());
    Get.lazyPut(() => FollowBackFormController(), fenix: true);
    Get.lazyPut(() => CommonFilterController());
    Get.lazyPut(() => AdminCallLogController());
    Get.lazyPut(() => AdminCallBackController());
    Get.lazyPut(() => DisbursementController());
    Get.lazyPut(() => LoginRequestController());
    Get.lazyPut(() => DisbursementDetailsController());
    Get.lazyPut(() => DisbursementDetailsController());

    if (StaticStoredData.roleName != 'telecaller') {
      Get.lazyPut(() => AdminCallLogController(), fenix: true);
      Get.lazyPut(() => AdminCallBackController(), fenix: true);
    }
  }
}
