import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/constants/api_urls.dart';
import 'package:smart_solutions/constants/static_stored_data.dart';
import 'package:smart_solutions/models/call_log_model.dart';
import 'package:smart_solutions/models/team_leader_model.dart';
import 'package:smart_solutions/services/api_service.dart';

import '../common_filter_controller.dart';

class AdminCallLogController extends GetxController {
  final ApiService _apiService = ApiService();

  // UI state
  final searchController = TextEditingController();
  final ScrollController filterScrollController = ScrollController();

  var isCallLogLoading = false.obs;
  var isTeamLeaderLoading = false.obs;

  // Filters
  var filters = <String>[].obs;
  var selectedFilter = 0.obs;

  // Data
  var teamLeaderList = <TeamleaderData>[].obs;
  // var callLogData = <Datum>[].obs;

  RxList<Datum> callLogData = <Datum>[].obs;
  List<Datum> _originalCallLog = [];

  final CommonFilterController filterController =
      Get.find<CommonFilterController>();

  @override
  void onInit() {
    super.onInit();
    getCallLogData(teamLeaderId: StaticStoredData.userId);
  }

  // ---------------- TEAM LEADER FILTER API ----------------
  Future<void> getTeamLeaders() async {
    isTeamLeaderLoading.value = true;

    try {
      final response =
          await _apiService.getRequest(APIUrls.loginRequestTeamLeader);

      if (response.statusCode == 200) {
        final model = TealLeaderModel.fromJson(jsonDecode(response.body));

        teamLeaderList.assignAll(model.data);

        filters.assignAll([
          "All",
          ...teamLeaderList.map((e) => e.name).toSet(),
        ]);
      }
    } catch (e) {
      debugPrint("Team leader API error: $e");
    } finally {
      isTeamLeaderLoading.value = false;
    }
  }

  // ---------------- FILTER SELECTION ----------------
  void selectFilter(int index) {
    selectedFilter.value = index;

    // if (index == 0) {
    //   getCallLogData();
    // } else {

    String? teamleader = getSelectedTeamLeaderId();
    filterCallLogs(teamLeaderId: teamleader);
    // }
  }

  String? getSelectedTeamLeaderId() {
    if (selectedFilter.value == 0) return null; // "All" selected

    if (selectedFilter.value < filters.length) {
      final selectedName = filters[selectedFilter.value];
      final tl = teamLeaderList.firstWhereOrNull((e) => e.name == selectedName);
      return tl?.id;
    }
    return null;
  }

  void clearFilters() {
    selectedFilter.value = 0;
    searchController.clear();

    getCallLogData();
  }

  // ---------------- CALL LOG API ----------------
  Future<void> getCallLogData({String? teamLeaderId}) async {
    isCallLogLoading.value = true;

    final formData = {
      "telecaller_id": teamLeaderId ?? StaticStoredData.userId,
    };

    try {
      final response =
          await _apiService.postRequest(APIUrls.callLoglist, formData);

      if (response.statusCode == 200) {
        final model = CallLogModel.fromJson(jsonDecode(response.body));

        _originalCallLog = model.data;

        // Initially show all data
        callLogData.assignAll(_originalCallLog);
      }
    } catch (e) {
      debugPrint("Call log API error: $e");
      callLogData.clear();
    } finally {
      isCallLogLoading.value = false;
    }
  }

  void filterCallLogs({
    String? teamLeaderId,
    String? searchQuery,
  }) {
    List<Datum> filteredList = _originalCallLog;

    // Filter by team leader
    if (teamLeaderId != null && teamLeaderId.isNotEmpty) {
      filteredList =
          filteredList.where((e) => e.teamleaderId == teamLeaderId).toList();
    }

    // Filter by search
    if (searchQuery != null && searchQuery.isNotEmpty) {
      filteredList = filteredList.where((e) {
        return e.name.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    callLogData.assignAll(filteredList);
  }
}
