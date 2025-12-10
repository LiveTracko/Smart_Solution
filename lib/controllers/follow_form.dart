import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_solutions/constants/static_stored_data.dart';
import 'package:smart_solutions/controllers/common_filter_controller.dart';
import 'package:smart_solutions/models/FollowUpSubmittedList.dart';
import 'package:smart_solutions/models/all_bank_names_model.dart';
import 'package:smart_solutions/models/callBack_model.dart';
import 'package:smart_solutions/models/call_log_model.dart';
import 'package:smart_solutions/models/disbursement_model.dart';
import 'package:smart_solutions/models/team_leader_model.dart';
import 'package:smart_solutions/services/call_state_service.dart';
import 'package:smart_solutions/utils/scroll_utils.dart';
import '../constants/services.dart';
import '../services/api_service.dart';
import '../constants/api_urls.dart';
import 'dailer_controller.dart';

class FollowBackFormController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  final DialerController _dialerController = Get.put(DialerController());

  var allBankNamesList = <AllBankNamesData>[].obs;
  var followBackList = <Data>[].obs;

  var startDate = Rxn<DateTime>();
  var endDate = Rxn<DateTime>();

  var monthlybackData = <Data>[].obs;
  var dailycallbackData = <Data>[].obs;
  var callLogData = <Datum>[].obs;

  var callBackData = <CallBackData>[].obs;
  var callBackTotalData = <Totals>[].obs;

  var dailyfollowBackList = <Data>[].obs;
  var monthlyfollowBackList = <Data>[].obs;
  var filteredFollowBackList = <Data>[].obs;

  var disbursementList = <DisbursementData>[].obs;
  var disbursementTotal = <disbursementTotals>[].obs;

  var teamleaderList = <TeamleaderData>[].obs;
  var tellecallerList = <TeamleaderData>[].obs;

  RxString selectedTeamLeaders = ''.obs;
  late RxList selectedtellecaller = [].obs;
  late RxList selectedtellecallerName = [].obs;
  var allCustomerName = <Data>[].obs;
  var dateRangeList = <DateTime?>[].obs;
  late TabController callController;
  var selectedIndex = 0.obs;

  //dialog var
  var selectedTeamLeaderId = ''.obs;

// search variables
  var showSearchField = false.obs;
  var searchText = "".obs;
  double itemHeight = 45.h;
  double tellececalleritemHeight = 55.h;
  final customerNumberController = TextEditingController();

  // Pagination variables
  RxInt currentPage = 1.obs;
  final RxBool hasMore = true.obs;
  final int limit = 20;

// scroll chiplist
  final ScrollController filterScrollController = ScrollController();

  final RxBool isInitialLoading = true.obs;
  final RxBool isMoreLoading = true.obs;

  final TextEditingController searchController = TextEditingController();

  final CommonFilterController commonFilterController =
      Get.put(CommonFilterController());

  @override
  void onInit() async {
    ever(followBackList, (_) => updateFilteredList());
    ever(selectedFilter, (_) => updateFilteredList());

    await fetchFollowBackList();
    // 1️⃣ When text changes, update observable
    customerNumberController.addListener(() {
      mobile.value = customerNumberController.text;
    });

    // 2️⃣ When observable changes, update text
    ever<String>(mobile, (number) {
      if (customerNumberController.text != number) {
        customerNumberController.text = number;
        customerNumberController.selection = TextSelection.fromPosition(
          TextPosition(offset: number.length),
        );
      }
    });

    callController = TabController(length: 4, vsync: this);
    callController.addListener(() {
      if (!callController.indexIsChanging) {
        selectedIndex.value = callController.index;
      }
    });

    // loadData();

    super.onInit();
  }

  Future<void> loadData(bool isRefresh) async {
    isBankAndStatusLoading(true);
    try {
      await getAllBanks();
      await getDisbursementData();
      if (isRefresh) {
        await CallStateService.getLastCallInfo();
      }
    } catch (e) {
      print("Error while loading data: $e");
    } finally {
      isBankAndStatusLoading(false);
    }
  }

  void toggleSearch() {
    showSearchField.value = !showSearchField.value;
  }

  var selectedStatuses = <String>[].obs;

  void toggleStatus(String status) {
    if (selectedStatuses.contains(status)) {
      selectedStatuses.remove(status);
    } else {
      selectedStatuses.add(status);
    }
  }

  Future<void> applyStatusFilter() async {
    try {
      isLoading(true);
      followBackList.clear();
      await fetchFollowBackList();
    } finally {
      isLoading(false);
    }
  }

  //search controller

  var filters = <String>[].obs;
  var selectedFilter = 0.obs;

  // Form fields
  var loanAmount = ''.obs;
  var customerName = ''.obs;
  var mobile = ''.obs;
  var bankName = ''.obs;
  var dataType = ''.obs;
  var contacted = 'No'.obs;
  var remarkStatus = ''.obs;
  var remark = ''.obs;
  var telecallerId = StaticStoredData.userId.obs;

  // var followupDate = DateTime.now().obs;
  // Change followupDate to accept null
  var followupDate = Rx<DateTime?>(null);
  var fromDate = Rx<DateTime?>(null);
  var toDate = Rx<DateTime?>(null);

  final fromDateController = TextEditingController(text: "");
  final toDateController = TextEditingController(text: "");

  var isLoading = false.obs;
  var isFormSubmitted = false.obs;
  var isBankAndStatusLoading = false.obs;
  var iscallBackLoading = false.obs;
  var iscallLogLoading = false.obs;
  var iscallDisbursedLoading = false.obs;

  var isdailyCallLoading = false.obs;
  var isMonthlyCallLoading = false.obs;

  // Convert contacted status to API format
  String get contactStatus => contacted.value == 'Yes' ? '1' : '2';

  void clearDateRange() {
    dateRangeList.clear();
    selectedStatuses.clear();
  }

  Future<void> fetchFollowBackList({bool loadMore = false}) async {
    if (loadMore) {
      isMoreLoading.value = true;
    } else {
      isInitialLoading.value = true;
      currentPage.value = 1;
      hasMore.value = true;
      followBackList.clear();
      allCustomerName.clear();
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final secureType = prefs.getInt('secureType');
    final String dateRage = dateRangeList.isNotEmpty &&
            dateRangeList.first != null &&
            dateRangeList.last != null
        ? "${dateRangeList.first},${dateRangeList.last}"
        : "";

    final Map<String, dynamic> formData = {
      "telecaller_id": StaticStoredData.userId,
      "daterange": dateRage,
      "page": currentPage.value.toString(),
      "secure_type": secureType.toString(),
    };

    if (searchText.value.isNotEmpty) {
      formData['search'] = searchText.value.trim();
    }

    if (selectedStatuses.isNotEmpty) {
      for (var i = 0; i < selectedStatuses.length; i++) {
        formData["status[$i]"] = selectedStatuses[i];
      }
    }

    try {
      var response = await _apiService.postRequest(
        APIUrls.updatedcalllog,
        formData,
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var model = FollowUpSubmitedList.fromJson(data);
        var newItems = model.data ?? [];

        if (loadMore) {
          followBackList.addAll(newItems);
        } else {
          followBackList.assignAll(newItems);
        }

        hasMore.value = newItems.length >= limit;
        if (newItems.isNotEmpty) currentPage++;
      } else {
        hasMore.value = false;
      }
    } catch (_) {
      hasMore.value = false;
    }

    isInitialLoading.value = false;
    isMoreLoading.value = false;
  }

  // Method to load more data

  Future<void> getDailyMonthlyCallbackData(String dateRange) async {
    // isLoading.value = true;
    isdailyCallLoading.value = true;
    isMonthlyCallLoading.value = true;

    try {
      // final String dateRage = dateRangeList.isNotEmpty &&
      //         dateRangeList.first != null &&
      //         dateRangeList.last != null
      //     ? "${dateRangeList.first},${dateRangeList.last}"
      //     : "";

      bool hasValidTelecaller = false;
      final formdata = {"daterange": dateRange};

      //Add telecaller IDs dynamically if the list is not empty
      if (selectedtellecaller.isNotEmpty) {
        for (var i = 0; i < selectedtellecaller.length; i++) {
          final telecallerId = selectedtellecaller[i];

          formdata["telecaller_ids[$i]"] = telecallerId;
          hasValidTelecaller = true;
        }
      }

      // If no valid telecaller IDs were added, fallback to current user
      if (!hasValidTelecaller) {
        formdata['telecaller_id'] = StaticStoredData.userId;
      }

      final response =
          await _apiService.postRequest(APIUrls.callBackdData, formdata);

      debugPrint(
          "FollowUp callback Response => ${response.statusCode}: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final followBackData = FollowUpSubmitedList.fromJson(responseData);

        // Assign to observable list
        if (dateRange == "1") {
          dailycallbackData.assignAll(followBackData.data ?? []);
        } else {
          monthlybackData.assignAll(followBackData.data ?? []);
        }
      } else if (response.statusCode == 204) {
        monthlybackData.clear(); // No data
      } else {
        logOutput("Error: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      logOutput("Exception while fetching follow-back list: $e");
    } finally {
      isdailyCallLoading.value = false;
      isMonthlyCallLoading.value = false;
    }
  }

  Future<void> getCallBackData() async {
    iscallBackLoading.value = true;

    final String dateRage = dateRangeList.isNotEmpty &&
            dateRangeList.first != null &&
            dateRangeList.last != null
        ? "${dateRangeList.first},${dateRangeList.last}"
        : "";

    bool hasValidTelecaller = false;
    final formdata = {
      "daterange": dateRage,
    };

    //Add telecaller IDs dynamically if the list is not empty
    if (selectedtellecaller.isNotEmpty) {
      for (var i = 0; i < selectedtellecaller.length; i++) {
        final telecallerId = selectedtellecaller[i];

        formdata["telecaller_ids[$i]"] = telecallerId;
        hasValidTelecaller = true;
      }
    }

    // If no valid telecaller IDs were added, fallback to current user
    if (!hasValidTelecaller) {
      formdata['telecaller_id'] = StaticStoredData.userId;
    }

    try {
      final response =
          await _apiService.postRequest(APIUrls.callBacklist, formdata);

      debugPrint(
          "callback Response => ${response.statusCode}: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final data = CallBackModel.fromJson(responseData);
        final totaldata = Totals.fromJson(responseData['totals']);

        callBackData.assignAll(data.data);
        callBackTotalData.assign(totaldata);
      } else if (response.statusCode == 204) {
        monthlybackData.clear(); // No data
      } else {
        logOutput("Error: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      logOutput("Exception while fetching follow-back list: $e");
    } finally {
      iscallBackLoading.value = false;
    }
  }

  Future<void> getCallLogData() async {
    iscallLogLoading.value = true;

    final String dateRage = dateRangeList.isNotEmpty &&
            dateRangeList.first != null &&
            dateRangeList.last != null
        ? "${dateRangeList.first},${dateRangeList.last}"
        : "";

    bool hasValidTelecaller = false;
    final formdata = {
      "daterange": dateRage,
    };

    //Add telecaller IDs dynamically if the list is not empty
    if (selectedtellecaller.isNotEmpty) {
      for (var i = 0; i < selectedtellecaller.length; i++) {
        final telecallerId = selectedtellecaller[i];

        formdata["telecaller_ids[$i]"] = telecallerId;
        hasValidTelecaller = true;
      }
    }

    // If no valid telecaller IDs were added, fallback to current user
    if (!hasValidTelecaller) {
      formdata['telecaller_id'] = StaticStoredData.userId;
    }
    try {
      final response =
          await _apiService.postRequest(APIUrls.callLoglist, formdata);

      debugPrint(
          "FollowUp calllog Response => ${response.statusCode}: ${response.body}");

      if (response.statusCode == 200) {
        print(response.body);
        final responseData = jsonDecode(response.body);
        final followBackData = CallLogModel.fromJson(responseData);

        callLogData.assignAll(followBackData.data);
      } else if (response.statusCode == 204) {
        monthlybackData.clear(); // No data
      } else {
        logOutput("Error: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      logOutput("Exception while fetching follow-back list: $e");
    } finally {
      iscallLogLoading.value = false;
    }
  }

  Future<void> getDisbursementData() async {
    iscallDisbursedLoading.value = true;
    final String dateRage = dateRangeList.isNotEmpty &&
            dateRangeList.first != null &&
            dateRangeList.last != null
        ? "${dateRangeList.first},${dateRangeList.last}"
        : "";

    bool hasValidTelecaller = false;
    final formdata = {
      "daterange": dateRage,
    };

    //Add telecaller IDs dynamically if the list is not empty
    if (selectedtellecaller.isNotEmpty) {
      for (var i = 0; i < selectedtellecaller.length; i++) {
        final telecallerId = selectedtellecaller[i];

        formdata["telecaller_ids[$i]"] = telecallerId;
        hasValidTelecaller = true;
      }
    }

    // If no valid telecaller IDs were added, fallback to current user
    if (!hasValidTelecaller) {
      formdata['telecaller_id'] = StaticStoredData.userId;
    }

    try {
      final response =
          await _apiService.postRequest(APIUrls.disbursmentlist, formdata);

      debugPrint(
          "FollowUp callback Response => ${response.statusCode}: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final disbursement = DisbursementModel.fromJson(responseData);
        final total = disbursementTotals.fromJson(responseData['totals']);

        disbursementList.assignAll(disbursement.data);
        disbursementTotal.assign(total);
      } else {
        logOutput("Error: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      logOutput("Exception while fetching follow-back list: $e");
    } finally {
      iscallDisbursedLoading.value = false;
    }
  }

  Future<void> getteamLeaderData([String? teamleaderId]) async {
    isLoading.value = true;

    try {
      final response = await _apiService.postRequest(
        APIUrls.teamleaderlist,
        {
          "teamleader_id": teamleaderId ?? '',
        },
      );

      debugPrint(
          "FollowUp callback Response => ${response.statusCode}: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final teamleader = TealLeaderModel.fromJson(responseData);

        if (teamleaderId != null && teamleaderId.isNotEmpty) {
          tellecallerList.assignAll(teamleader.data);
        } else {
          teamleaderList.assignAll(teamleader.data);
          commonFilterController.setFilters(
            teamleaderList.map((e) => e.name).toList(),
          );
        }
      } else {
        logOutput("Error: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      logOutput("Exception while fetching follow-back list: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> submitFollowUp() async {
    try {
      isFormSubmitted(true);

      final Map<String, dynamic> formData = {
        'mobile': mobile.value,
        'name': _dialerController.customerName.value,
        'data_type': dataType.value,
        'bank_name':
            bankName.value.isEmpty ? allBankNamesList.first.id : bankName.value,
        // 'followup_date':
        //     '${followupDate.value.year}-${followupDate.value.month}-${followupDate.value.day}',

        'followup_date': followupDate.value != null
            ? '${followupDate.value!.year}-${followupDate.value!.month}-${followupDate.value!.day}'
            : '-',

        'contact_status': contactStatus,
        'remark_status': remarkStatus.value,
        'remark': remark.value,
        'telecaller_id': telecallerId.value,
        'call_duration': _dialerController
            .formatElapsedTime(_dialerController.elapsedTimeInSeconds.value),
        'salary': _dialerController.salary.value,
        'excel_id': _dialerController.excel_id.value,
        'followup_id': _dialerController.followup_id.value,
      };
      logOutput("$formData");
      final response =
          await _apiService.postRequest(APIUrls.followListData, formData);

      _dialerController.elapsedTimeInSeconds.value = 0;
      logOutput(response.body);
      if (response.statusCode == 200) {
        //   final result = FollowUpDetails.fromJson(json.decode(response.body));

        // Wait a bit (simulate save time)
        // await Future.delayed(const Duration(milliseconds: 500));

        _dialerController.handleFormSubmitAndFetchNext();
        fetchFollowBackList();
        Get.showSnackbar(
          GetSnackBar(
            title: 'Success',
            message: 'Follow up saved successfully',
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.shade400,
            margin: const EdgeInsets.all(12),
            borderRadius: 8,
          ),
        );
        Get.back(); // close first
        // await _dashboardController
        //     .fetchDashboardData(true); // Fetch monthly data
        // await _dashboardController.fetchDashboardData(false);

        clearForm();
        return true;
      } else {
        throw Exception('Failed to submit form');
      }
    } catch (e) {
      logOutput('Error submitting form: $e');
      return false;
      //  Get.snackbar('Error', 'Failed to submit follow up form');
    } finally {
      isFormSubmitted(false);
    }
  }

  // void updateFilteredFollowBackList(String query) {
  //   if (query.isEmpty) {
  //     filteredFollowBackList.assignAll(followBackList);
  //   } else {
  //     filteredFollowBackList.assignAll(
  //       followBackList.where((item) {
  //         final name = item.customerName?.toLowerCase() ?? '';

  //         final mobile = item.contactNumber?.toLowerCase() ?? '';
  //         final bank = item.bankName?.toLowerCase() ?? '';
  //         final searchQuery = query.toLowerCase();
  //         return name.contains(searchQuery) ||
  //             mobile.contains(searchQuery) ||
  //             bank.contains(searchQuery);
  //       }).toList(),
  //     );
  //   }
  // }

  Future<void> getAllBanks() async {
    try {
      var body = {'': ''};
      var response = await ApiService().postRequest(APIUrls.allBankNames, body);

      if (response.statusCode == 200) {
        final remarkStatus = AllBankNames.fromJson(json.decode(response.body));
        if (remarkStatus.data != null) {
          allBankNamesList.assignAll(remarkStatus.data!);
        }
      }
    } catch (e) {
      log('an error occured while fetching banks $e');
    } finally {}
  }

  void clearForm() {
    customerName.value = '';
    mobile.value = '';
    bankName.value = '';
    dataType.value = '';
    _dialerController.datatype.value = '';
    contacted.value = 'No';
    remarkStatus.value = '';
    remark.value = '';
    // followupDate.value = DateTime.now();
    // followupDate.value = null;

    _dialerController.elapsedTimeInSeconds.value = 0;
    // _dialerController.excel_id.value = '';
    _dialerController.followup_id.value = '';
  }

  void setFromDate(DateTime date) {
    fromDate.value = date;
    fromDateController.text =
        DateFormat("yyyy-MM-dd").format(date); // Update TextField
    update();
  }

  // Function to set To Date
  void setToDate(DateTime date) {
    toDate.value = date;
    toDateController.text =
        DateFormat("yyyy-MM-dd").format(date); // Update TextField
    update();
  }

  void getDataOnMonth(String toDate, String fromDate) async {
    isLoading.value = true;

    try {
      if (toDate.isNotEmpty && fromDate.isNotEmpty) {
        debugPrint(" date range --> $toDate,$fromDate");

        var response = await _apiService.postRequest(
          APIUrls.followUpSubmitedData,
          {
            "telecaller_id": StaticStoredData.userId,
            "daterange": "$fromDate,$toDate"
          },
        );

        debugPrint(
            " data in filter -->  ${response.statusCode} ${response.body}");

        if (response.statusCode == 200) {
          var responseData = jsonDecode(response.body);
          print(responseData);
          var followBackData = FollowUpSubmitedList.fromJson(responseData);
          followBackList.value = followBackData.data ?? [];
        } else if (response.statusCode == 204) {
          followBackList.clear();
        } else {
          logOutput("Error: ${response.statusCode} - ${response.reasonPhrase}");
        }
      }
    } catch (e) {
      logOutput("Exception fetching follow-back list: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Create a method to handle these calls
  Future<void> getAllDashboardData({
    required var dashboardController,
  }) async {
    await Future.microtask(() async {
      // Dashboard related API calls
      await dashboardController.getTimeGraph();
      await dashboardController.getActiveData(status: 1);
      await dashboardController.getActiveData(status: 2);

      // Follow back form related API calls
      await getCallBackData();
      await getCallLogData();
      await getDisbursementData();
    });
  }

  // set filterlist

  // void updateFilteredList() {
  //   final names = followBackList.map((e) => e.remarkStatus ?? '').toList();

  //   commonFilterController.setFilters(names);
  // }

  void updateFilteredList({String query = ''}) {
    // 1️⃣ Update filter chip list (remarkStatus)
    final names = followBackList
        .map((e) => e.remarkStatus ?? '')
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();

    setFilters(names);

    // 2️⃣ Apply search + chip filter
    final search = query.toLowerCase();
    final selected = selectedFilter.value;

    filteredFollowBackList.assignAll(
      followBackList.where((item) {
        final name = item.customerName?.toLowerCase() ?? '';
        final mobile = item.contactNumber?.toLowerCase() ?? '';
        final bank = item.bankName?.toLowerCase() ?? '';
        final remark = item.remarkStatus?.toLowerCase() ?? '';

        // Search filter
        final searchMatch = search.isEmpty ||
            name.contains(search) ||
            mobile.contains(search) ||
            bank.contains(search);

        // Chip filter
        final chipMatch =
            selected == 0 ? true : remark == names[selected - 1].toLowerCase();

        return searchMatch && chipMatch;
      }).toList(),
    );

    final searchText = searchController.text.trim().toLowerCase();

    if (searchText.isNotEmpty) {
      filteredFollowBackList.value = filteredFollowBackList.where((item) {
        return (item.customerName ?? '').toLowerCase().contains(searchText) ||
            (item.contactNumber ?? '').toLowerCase().contains(searchText) ||
            (item.bankName ?? '').toLowerCase().contains(searchText);
      }).toList();
    }
  }

  // Method to refresh data (pull to refresh)

  Future<void> loadMore() async {
    if (!isLoading.value && hasMore.value) {
      await fetchFollowBackList(loadMore: true);
    }
  }

  // Call this when search or filters change
  Future<void> onSearchOrFilterChanged() async {
    currentPage.value = 1;
    hasMore.value = true;
    await fetchFollowBackList(loadMore: false);
  }

  void selectFilter(int index) {
    selectedFilter.value = index;
  }

  void clearFilters() {
    selectedFilter.value = 0;

    ScrollUtils.scrollToStart(filterScrollController);
    searchController.clear();
  }

  void setFilters(List<String> names) {
    filters.value = ["All", ...names.toSet()];
    update();
  }
}
