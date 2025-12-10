import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/constants/api_urls.dart';
import 'package:smart_solutions/constants/services.dart';
import 'package:smart_solutions/constants/static_stored_data.dart';
import 'package:smart_solutions/models/call_log_model.dart';
import 'package:smart_solutions/models/team_leader_model.dart';
import 'package:smart_solutions/services/api_service.dart';

class AdminCallLogController extends GetxController {
  final ApiService _apiService = ApiService();
  var filters = <String>[].obs;
  var selectedFilter = 0.obs;
  final searchController = TextEditingController();

  var isLoading = false.obs;
  var teamleaderList = <TeamleaderData>[].obs;
  var tellecallerList = <TeamleaderData>[].obs;
  final ScrollController filterScrollController = ScrollController();
  var callLogData = <Datum>[].obs;
  var dateRangeList = <DateTime?>[].obs;

  var iscallLogLoading = false.obs;
  void selectFilter(int index) {
    selectedFilter.value = index;
  }

  @override
  void onInit() {
    getCallLogData();
    super.onInit();
  }

  void clearFilters() {
    selectedFilter.value = 0;

    searchController.clear();
  }

  void setFilters(List<String> names) {
    filters.value = ["All", ...names.toSet()];
    update();
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
          setFilters(
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

  Future<void> getCallLogData() async {
    iscallLogLoading.value = true;

    final String dateRage = dateRangeList.isNotEmpty &&
            dateRangeList.first != null &&
            dateRangeList.last != null
        ? "${dateRangeList.first},${dateRangeList.last}"
        : "";

    final formdata = {
      "daterange": dateRage,
    };

    formdata['telecaller_id'] = StaticStoredData.userId;

    try {
      final response =
          await _apiService.postRequest(APIUrls.callLoglist, formdata);

      debugPrint(
          "FollowUp calllog Response => ${response.statusCode}: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final followBackData = CallLogModel.fromJson(responseData);

        callLogData.assignAll(followBackData.data);
      } else if (response.statusCode == 204) {
        //    monthlybackData.clear(); // No data
      } else {
        logOutput("Error: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      logOutput("Exception while fetching follow-back list: $e");
    } finally {
      iscallLogLoading.value = false;
    }
  }
}
