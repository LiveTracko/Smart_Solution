import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/constants/api_urls.dart';
import 'package:smart_solutions/constants/static_stored_data.dart';
import 'package:smart_solutions/models/call_log_model.dart';
import 'package:smart_solutions/models/team_leader_model.dart';
import 'package:smart_solutions/services/api_service.dart';

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
  var callLogData = <Datum>[].obs;

  @override
  void onInit() {
    super.onInit();
    getCallLogData(); // default load
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

    if (index == 0) {
      getCallLogData();
    } else {
      final telecallerId = teamLeaderList[index - 1].id;
      getCallLogData(teamLeaderId: telecallerId);
    }
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
        callLogData.assignAll(model.data);
      } else {
        callLogData.clear();
      }
    } catch (e) {
      debugPrint("Call log API error: $e");
      callLogData.clear();
    } finally {
      isCallLogLoading.value = false;
    }
  }
}
