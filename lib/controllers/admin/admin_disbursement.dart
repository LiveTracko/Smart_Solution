import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/constants/api_urls.dart';
import 'package:smart_solutions/constants/services.dart';
import 'package:smart_solutions/constants/static_stored_data.dart';
import 'package:smart_solutions/models/disbursement_model.dart';
import 'package:smart_solutions/models/team_leader_model.dart';
import 'package:smart_solutions/services/api_service.dart';

class DisbursementController extends GetxController {
  final ApiService _apiService = ApiService();
  var filters = <String>[].obs;
  var selectedFilter = 0.obs;
  final searchController = TextEditingController();

  var isLoading = false.obs;
  var teamleaderList = <TeamleaderData>[].obs;
  var tellecallerList = <TeamleaderData>[].obs;
  final ScrollController filterScrollController = ScrollController();

  var dateRangeList = <DateTime?>[].obs;
  late RxList selectedtellecaller = [].obs;
  var disbursementList = <DisbursementData>[].obs;
  var disbursementTotal = <disbursementTotals>[].obs;

  var iscallDisbursedLoading = false.obs;

  @override
  void onInit() {
    getteamLeaderData(); // Load team leaders first
    getDisbursementData(); // Then load disbursement data
    super.onInit();
  }

  void selectFilter(int index) {
    selectedFilter.value = index;
    // When filter changes, fetch filtered disbursement data
    getDisbursementData();
  }

  void clearFilters() {
    selectedFilter.value = 0;
    searchController.clear();
    getDisbursementData(); // Reload all data when cleared
  }

  void setFilters(List<String> names) {
    debugPrint('Setting filters with ${names.length} names');
    filters.value = ["All", ...names.toSet()];
  }

  // Get selected team leader ID for filtering
  String? getSelectedTeamLeaderId() {
    if (selectedFilter.value == 0) return null; // "All" selected

    if (selectedFilter.value < filters.length) {
      final selectedName = filters[selectedFilter.value];
      final tl = teamleaderList.firstWhereOrNull((e) => e.name == selectedName);
      return tl?.id;
    }
    return null;
  }

  // UPDATED: Use Login Request Team Leaders API
  Future<void> getteamLeaderData([String? teamleaderId]) async {
    isLoading.value = true;
    debugPrint('=== Fetching Login Request Team Leaders for Disbursement ===');

    try {
      // Use GET request for login request team leaders
      final response = await _apiService.getRequest(
        APIUrls.loginRequestTeamLeader,
      );

      debugPrint('Team Leader Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;

        if (responseData.containsKey('data')) {
          final List<dynamic> data = responseData['data'] as List<dynamic>;
          debugPrint('Found ${data.length} team leaders');

          // Parse using your existing model
          final model = TealLeaderModel.fromJson({"data": data});

          if (teamleaderId != null && teamleaderId.isNotEmpty) {
            tellecallerList.assignAll(model.data);
          } else {
            teamleaderList.assignAll(model.data);

            // Extract names for filters
            final names = model.data.map((tl) => tl.name).toList();
            debugPrint('Team leader names: $names');

            // Set filters
            setFilters(names);
          }
        }
      } else {
        debugPrint('Team Leader API Error: ${response.statusCode}');
        // Fallback to regular team leader API if login request API fails
        await _fetchRegularTeamLeaders(teamleaderId);
      }
    } catch (e) {
      debugPrint('Exception in getteamLeaderData: $e');
      // Fallback to regular team leader API
      await _fetchRegularTeamLeaders(teamleaderId);
    } finally {
      isLoading.value = false;
      debugPrint('=== Finished Loading Team Leaders ===');
    }
  }

  // Fallback method for regular team leaders
  Future<void> _fetchRegularTeamLeaders([String? teamleaderId]) async {
    try {
      debugPrint('Trying regular team leader API as fallback...');
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
      debugPrint('Exception in _fetchRegularTeamLeaders: $e');
    }
  }

  // UPDATED: Add team leader filtering to disbursement data
  Future<void> getDisbursementData() async {
    iscallDisbursedLoading.value = true;
    debugPrint('=== Fetching Disbursement Data ===');

    final String dateRage = dateRangeList.isNotEmpty &&
            dateRangeList.first != null &&
            dateRangeList.last != null
        ? "${dateRangeList.first},${dateRangeList.last}"
        : "";

    bool hasValidTelecaller = false;
    final formdata = {
      "daterange": dateRage,
    };

    // Add team leader filter if selected (except "All")
    final teamLeaderId = getSelectedTeamLeaderId();
    if (teamLeaderId != null) {
      formdata['teamleader_id'] = teamLeaderId;
      debugPrint('Filtering disbursement by team leader ID: $teamLeaderId');
    }

    // Add telecaller IDs dynamically if the list is not empty
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
      final response = await _apiService.postRequest(
        APIUrls.disbursmentlist,
        formdata,
      );

      debugPrint('Disbursement Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;

        // Check if we have data
        if (responseData != null && responseData['data'] != null) {
          final List<dynamic> dataList = responseData['data'] as List<dynamic>;

          if (dataList.isNotEmpty) {
            final disbursement = DisbursementModel.fromJson(responseData);

            // Check if we have totals
            if (responseData.containsKey('totals')) {
              final total = disbursementTotals.fromJson(responseData['totals']);
              disbursementTotal.assign(total);
            }

            disbursementList.assignAll(disbursement.data);
            debugPrint(
                'Disbursement data loaded: ${disbursement.data.length} items');
          } else {
            debugPrint('Disbursement data list is empty');
            disbursementList.clear();
          }
        } else {
          debugPrint('No data in disbursement response');
          disbursementList.clear();
        }
      } else {
        debugPrint('Disbursement API Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Exception while fetching disbursement data: $e');
      debugPrint('Error details: ${e.toString()}');
    } finally {
      iscallDisbursedLoading.value = false;
      debugPrint('=== Finished Loading Disbursement Data ===');
    }
  }
}
