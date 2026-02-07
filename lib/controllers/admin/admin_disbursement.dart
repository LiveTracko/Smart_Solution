import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/constants/api_urls.dart';
import 'package:smart_solutions/models/disbursement_model.dart';
import 'package:smart_solutions/models/team_leader_model.dart';
import 'package:smart_solutions/services/api_service.dart';

class DisbursementController extends GetxController {
  final ApiService _apiService = ApiService();

  /// Loading flags
  final isLoading = false.obs;
  final iscallDisbursedLoading = false.obs;

  /// Filters
  final filters = <String>[].obs;
  final selectedFilter = 0.obs;
  final searchController = TextEditingController();
  final filterScrollController = ScrollController();

  /// Data
  final teamleaderList = <TeamleaderData>[].obs;
  final disbursementList = <DisbursementData>[].obs;

  /// Totals (single object)
  final disbursementTotal = Rxn<disbursementTotals>();

  @override
  void onInit() {
    super.onInit();
    getteamLeaderData();
    getDisbursementData(); // initial load (All)
  }

  // ---------------- TEAM LEADERS ----------------
  Future<void> getteamLeaderData() async {
    isLoading.value = true;
    try {
      final response =
          await _apiService.getRequest(APIUrls.loginRequestTeamLeader);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final model = TealLeaderModel.fromJson(json);

        teamleaderList.assignAll(model.data);
        filters.assignAll(['All', ...model.data.map((e) => e.name)]);
      }
    } catch (e) {
      debugPrint('❌ Team leader error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------- DISBURSEMENT ----------------
  Future<void> getDisbursementData() async {
    iscallDisbursedLoading.value = true;

    try {
      /// 🔑 IMPORTANT: send teamleader_id
      Map<String, dynamic> body = {};

      if (selectedFilter.value != 0) {
        final leader = teamleaderList[selectedFilter.value - 1];
        body['teamleader_id'] = leader.id;
      }

      debugPrint('📤 Disbursement API Body: $body');

      final response = await _apiService.postRequest(
        APIUrls.getDisbursementForAdmin,
        body,
      );

      debugPrint('📥 Disbursement API Response: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        final model = DisbursementModel.fromJson(json);
        disbursementList.assignAll(model.data);

        if (json['totals'] != null) {
          disbursementTotal.value = disbursementTotals.fromJson(json['totals']);
        }
      }
    } catch (e) {
      debugPrint('❌ Disbursement error: $e');
    } finally {
      iscallDisbursedLoading.value = false;
    }
  }

  // ---------------- FILTER ----------------
  void selectFilter(int index) {
    selectedFilter.value = index;
    getDisbursementData(); // 🔥 re-call API with teamleader_id
  }

  void clearFilters() {
    selectedFilter.value = 0;
    searchController.clear();
    getDisbursementData();
  }
}
