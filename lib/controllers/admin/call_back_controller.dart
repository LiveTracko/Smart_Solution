import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/constants/api_urls.dart';
import 'package:smart_solutions/constants/services.dart';
import 'package:smart_solutions/constants/static_stored_data.dart';
import 'package:smart_solutions/models/callBack_model.dart';
import 'package:smart_solutions/models/team_leader_model.dart';
import 'package:smart_solutions/services/api_service.dart';

class AdminCallBackController extends GetxController {
  final ApiService _apiService = ApiService();

  // ============================
  // 🔹 FILTERS & SEARCH
  // ============================
  var filters = <String>[].obs;
  var selectedFilter = 0.obs;
  final searchController = TextEditingController();
  final ScrollController filterScrollController = ScrollController();

  // ============================
  // 🔹 LOADING STATES
  // ============================
  var isLoading = false.obs;
  var isCallBackLoading = false.obs;
  var isLoginRequestTeamLeaderLoading = false.obs;
  var isLoginRequestDataLoading = false.obs;

  // ============================
  // 🔹 DATA LISTS
  // ============================
  var teamleaderList = <TeamleaderData>[].obs;
  var tellecallerList = <TeamleaderData>[].obs;
  var callBackData = <CallBackData>[].obs;
  var dateRangeList = <DateTime?>[].obs;
  late RxList selectedtellecaller = [].obs;
  var callBackTotalData = <Totals>[].obs;

  // NEW: For login request data
  var loginRequestData = <Map<String, dynamic>>[].obs;
  var filteredLoginRequestData = <Map<String, dynamic>>[].obs;

  // ============================
  // 🔹 METHODS
  // ============================
  void selectFilter(int index) {
    selectedFilter.value = index;
    debugPrint('Selected filter: $index - ${filters[index]}');

    // When filter changes, fetch filtered login request data
    if (filters.isNotEmpty && index > 0) {
      _fetchLoginRequestDataForSelectedFilter();
    } else {
      // "All" selected, fetch all data
      _fetchLoginRequestData();
    }
  }

  void clearFilters() {
    selectedFilter.value = 0;
    searchController.clear();
    _fetchLoginRequestData(); // Fetch all data when cleared
  }

  void setFilters(List<String> names) {
    debugPrint('Setting filters with ${names.length} names');
    filters.value = ["All", ...names.toSet()];
  }

  // Get selected team leader ID
  String? getSelectedTeamLeaderId() {
    if (selectedFilter.value == 0) return null; // "All" selected

    if (selectedFilter.value < filters.length) {
      final selectedName = filters[selectedFilter.value];
      final tl = teamleaderList.firstWhereOrNull((e) => e.name == selectedName);
      return tl?.id;
    }
    return null;
  }

  // ============================
  // 🔹 TEAM LEADER API (First API)
  // ============================
  Future<void> getLoginRequestTeamLeaderData() async {
    isLoginRequestTeamLeaderLoading.value = true;
    debugPrint('=== Fetching Login Request Team Leaders ===');

    try {
      final response = await _apiService.getRequest(
        APIUrls.loginRequestTeamLeader,
      );

      debugPrint('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;

        if (responseData.containsKey('data')) {
          final List<dynamic> data = responseData['data'] as List<dynamic>;

          // Parse using your existing model
          final model = TealLeaderModel.fromJson({"data": data});
          teamleaderList.assignAll(model.data);

          // Extract names for filters
          final names = model.data.map((tl) => tl.name).toList();
          setFilters(names);

          debugPrint('Team leaders loaded: ${teamleaderList.length}');

          // Load login request data after team leaders are loaded
          await _fetchLoginRequestData();
        }
      }
    } catch (e) {
      debugPrint('Exception in getLoginRequestTeamLeaderData: $e');
    } finally {
      isLoginRequestTeamLeaderLoading.value = false;
    }
  }

  // ============================
  // 🔹 LOGIN REQUEST DATA API (Second API)
  // ============================
  Future<void> _fetchLoginRequestData() async {
    isLoginRequestDataLoading.value = true;
    debugPrint('=== Fetching ALL Login Request Data ===');

    try {
      final response = await _apiService.postRequest(
        APIUrls.adminLoginRequest,
        {}, // Empty form data for all data
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;

        if (responseData.containsKey('data')) {
          final List<dynamic> data = responseData['data'] as List<dynamic>;
          _processLoginRequestData(data);
        }
      }
    } catch (e) {
      debugPrint('Exception in _fetchLoginRequestData: $e');
    } finally {
      isLoginRequestDataLoading.value = false;
    }
  }

  Future<void> _fetchLoginRequestDataForSelectedFilter() async {
    isLoginRequestDataLoading.value = true;
    final teamLeaderId = getSelectedTeamLeaderId();

    if (teamLeaderId == null) {
      await _fetchLoginRequestData();
      return;
    }

    debugPrint(
        '=== Fetching Login Request Data for Team Leader ID: $teamLeaderId ===');

    try {
      final response = await _apiService.postRequest(
        APIUrls.adminLoginRequest,
        {'teamleader_id': teamLeaderId},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;

        if (responseData.containsKey('data')) {
          final List<dynamic> data = responseData['data'] as List<dynamic>;
          _processLoginRequestData(data);
        }
      }
    } catch (e) {
      debugPrint('Exception in _fetchLoginRequestDataForSelectedFilter: $e');
    } finally {
      isLoginRequestDataLoading.value = false;
    }
  }

  void _processLoginRequestData(List<dynamic> data) {
    // Clear existing data
    loginRequestData.clear();

    // Process each record
    for (var item in data) {
      final itemMap = item as Map<String, dynamic>;

      // Skip the "TOTAL" row
      if (itemMap['name'] == 'TOTAL') continue;

      // Find team leader name
      String teamLeaderName = 'Not Assigned';
      if (itemMap['teamleader_id'] != null) {
        final tl = teamleaderList.firstWhereOrNull(
          (teamLeader) => teamLeader.id == itemMap['teamleader_id'].toString(),
        );
        teamLeaderName = tl?.name ?? 'Unknown';
      }

      loginRequestData.add({
        'name': itemMap['name']?.toString() ?? 'Unknown',
        'teamleader_id': itemMap['teamleader_id']?.toString(),
        'teamleader_name': teamLeaderName,
        'monthlycount': itemMap['monthlycount']?.toString() ?? '0',
        'todaycount': itemMap['todaycount']?.toString() ?? '0',
      });
    }

    debugPrint('Processed ${loginRequestData.length} login request records');

    // Update filtered data
    filteredLoginRequestData.assignAll(loginRequestData);
  }

  // ============================
  // 🔹 TOTALS CALCULATION
  // ============================
  Map<String, int> getLoginRequestTotals() {
    int todayTotal = 0;
    int monthlyTotal = 0;

    for (var item in filteredLoginRequestData) {
      todayTotal += int.tryParse(item['todaycount']?.toString() ?? '0') ?? 0;
      monthlyTotal +=
          int.tryParse(item['monthlycount']?.toString() ?? '0') ?? 0;
    }

    return {
      'today': todayTotal,
      'monthly': monthlyTotal,
    };
  }

  // ============================
  // 🔹 REGULAR METHODS (for other screens)
  // ============================
  Future<void> getteamLeaderData([String? teamleaderId]) async {
    isLoading.value = true;

    try {
      final response = await _apiService.postRequest(
        APIUrls.teamleaderlist,
        {"teamleader_id": teamleaderId ?? ''},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        final model = TealLeaderModel.fromJson(responseData);

        if (teamleaderId != null && teamleaderId.isNotEmpty) {
          tellecallerList.assignAll(model.data);
        } else {
          teamleaderList.assignAll(model.data);
          final names = model.data.map((tl) => tl.name).toList();
          setFilters(names);
        }
      }
    } catch (e) {
      debugPrint('Exception in getteamLeaderData: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getCallBackData() async {
    isCallBackLoading.value = true;

    final String dateRage = dateRangeList.isNotEmpty &&
            dateRangeList.first != null &&
            dateRangeList.last != null
        ? "${dateRangeList.first},${dateRangeList.last}"
        : "";

    bool hasValidTelecaller = false;
    final formdata = {
      "daterange": dateRage,
    };

    if (selectedtellecaller.isNotEmpty) {
      for (var i = 0; i < selectedtellecaller.length; i++) {
        final telecallerId = selectedtellecaller[i];
        formdata["telecaller_ids[$i]"] = telecallerId;
        hasValidTelecaller = true;
      }
    }

    if (!hasValidTelecaller) {
      formdata['telecaller_id'] = StaticStoredData.userId;
    }

    try {
      final response = await _apiService.postRequest(
        APIUrls.callBacklist,
        formdata,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        final data = CallBackModel.fromJson(responseData);

        if (responseData.containsKey('totals')) {
          final totaldata = Totals.fromJson(responseData['totals']);
          callBackTotalData.assign(totaldata);
        }

        callBackData.assignAll(data.data);
      }
    } catch (e) {
      debugPrint('Exception in getCallBackData: $e');
    } finally {
      isCallBackLoading.value = false;
    }
  }
}
