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
  RxList<DisbursementData> disbursementList = <DisbursementData>[].obs;
  RxList<DisbursementData> allDisbursementList = <DisbursementData>[].obs;

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
  // Future<void> getDisbursementData() async {
  //   iscallDisbursedLoading.value = true;

  //   try {
  //     final response =
  //         await _apiService.postRequest(APIUrls.getDisbursementForAdmin, {});

  //     debugPrint('📥 Disbursement API Response: ${response.body}');

  //     if (response.statusCode == 200) {
  //       final json = jsonDecode(response.body);

  //       final model = DisbursementModel.fromJson(json);
  //       allDisbursementList.assignAll(model.data);
  //       disbursementList.assignAll(model.data);
  //     }
  //   } catch (e) {
  //     debugPrint('❌ Disbursement error: $e');
  //   } finally {
  //     iscallDisbursedLoading.value = false;
  //   }
  // }

  Future<void> getDisbursementData({String? query}) async {
    iscallDisbursedLoading.value = true;

    try {
      // Fetch only once
      if (allDisbursementList.isEmpty) {
        final response =
            await _apiService.postRequest(APIUrls.getDisbursementForAdmin, {});

        if (response.statusCode == 200) {
          final json = jsonDecode(response.body);
          final model = DisbursementModel.fromJson(json);
          allDisbursementList.assignAll(model.data);
        }
      }

      // SEARCH FILTER
      if (query != null && query.isNotEmpty) {
        final filtered = allDisbursementList.where((item) {
          final name = item.name.toLowerCase();
          // final mobile = item.mobile?.toLowerCase() ?? "";

          return name.contains(query.toLowerCase());
          //||
          //  mobile.contains(query.toLowerCase());
        }).toList();

        disbursementList.assignAll(filtered);
      } else {
        disbursementList.assignAll(allDisbursementList);
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
    if (index == 0) {
      disbursementList.assignAll(allDisbursementList);
      return;
    }

    final leader = teamleaderList[index - 1];

    disbursementList.assignAll(
      allDisbursementList.where((e) => e.id == leader.id).toList(),
    );
  }

  void clearFilters() {
    selectedFilter.value = 0;
    searchController.clear();
    getDisbursementData();
  }
}
