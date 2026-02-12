import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/constants/api_urls.dart';
import 'package:smart_solutions/models/callBack_model.dart';
import 'package:smart_solutions/models/team_leader_model.dart';
import 'package:smart_solutions/services/api_service.dart';
import '../../models/admin/admin_loginRequest_model.dart';

class AdminCallBackController extends GetxController {
  late final String? pageType;

  AdminCallBackController({this.pageType});
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
  var isLoginFileRequestDataLoading = false.obs;

  // ============================
  // 🔹 DATA LISTS
  // ============================
  var teamleaderList = <TeamleaderData>[].obs;
  var tellecallerList = <TeamleaderData>[].obs;
  // var callBackData = <CallBackData>[].obs;
  var dateRangeList = <DateTime?>[].obs;
  late RxList selectedtellecaller = [].obs;
  var callBackTotalData = <Totals>[].obs;

  // NEW: For login request data
  var loginRequestData = <Datum>[].obs;
  var loginFilesData = <Datum>[].obs;
  RxList<Datum> filteredLoginRequestData = <Datum>[].obs;
  RxList<Datum> filteredLoginFilesData = <Datum>[].obs;
  RxString teamleaderId = ''.obs;

  RxInt todayTotal = 0.obs;
  RxInt monthlyTotal = 0.obs;

  RxBool loginRequestLoaded = false.obs;
  RxBool loginFilesLoaded = false.obs;

  @override
  void onInit() {
    super.onInit();
    getteamLeaderData();

    if (pageType == 'Login Request') {
      fetchLoginRequestOnce();
    } else {
      fetchLoginFilesOnce();
    }

    ever(filteredLoginRequestData, (_) {
      calculateRequestTotal(filteredLoginRequestData);
    });

    ever(filteredLoginFilesData, (_) {
      calculateRequestTotal(filteredLoginFilesData);
    });
  }

  Future<void> fetchLoginRequestOnce() async {
    if (loginRequestLoaded.value) return;
    loginRequestLoaded = false.obs;
    await _fetchLoginRequestData();
    loginRequestLoaded = true.obs;
  }

  Future<void> fetchLoginFilesOnce() async {
    if (loginFilesLoaded.value) return;

    loginFilesLoaded.value = false; // show loader
    await _fetchLoginFileData();
    loginFilesLoaded.value = true; // hide loader
  }

  void filterByTeamLeader({
    required List<Datum> source,
    required RxList<Datum> target,
    String? teamleaderId,
    VoidCallback? onDone,
    Function(List<Datum>)? calculateTotals,
  }) {
    if (pageType == 'Login Request') {
      // LOGIN REQUEST
      filteredLoginRequestData.assignAll(
        teamleaderId == null || teamleaderId.isEmpty
            ? loginRequestData
            : loginRequestData.where((e) => e.teamleaderId == teamleaderId),
      );

      calculateRequestTotal(filteredLoginRequestData);
    } else {
      // LOGIN FILES
      filteredLoginFilesData.assignAll(
        teamleaderId == null || teamleaderId.isEmpty
            ? loginFilesData
            : loginFilesData.where((e) => e.teamleaderId == teamleaderId),
      );
      calculateRequestTotal(filteredLoginFilesData);
    }
  }

  void selectFilter(int index) {
    selectedFilter.value = index;
    debugPrint('Selected filter: $index - ${filters[index]}');

    final teamLeaderId = getSelectedTeamLeaderId();
    filterByTeamLeader(
      source: loginRequestData,
      target: filteredLoginRequestData,
      teamleaderId: teamLeaderId,
      calculateTotals: calculateRequestTotal,
    );

    filterByTeamLeader(
      source: loginFilesData,
      target: filteredLoginFilesData,
      teamleaderId: teamLeaderId,
      calculateTotals: calculateRequestTotal,
    );
  }

  void clearFilters() {
    selectedFilter.value = 0;
    searchController.clear();
    _fetchLoginRequestData(); // Fetch all data when cleared
    _fetchLoginFileData();
  }

  void setFilters(List<String> names) {
    debugPrint('Setting filters with ${names.length} names');
    filters.value = ["All", ...names.toSet()];
  }

  String? getSelectedTeamLeaderId() {
    if (selectedFilter.value == 0) return null; // "All" selected

    if (selectedFilter.value < filters.length) {
      final selectedName = filters[selectedFilter.value];
      final tl = teamleaderList.firstWhereOrNull((e) => e.name == selectedName);
      return tl?.id;
    }
    return null;
  }

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

  Future<void> _fetchLoginRequestData({String? teamleaderId}) async {
    if (loginRequestData.isNotEmpty) return; // prevents re-fetch
    isLoginRequestDataLoading.value = true;
    debugPrint('=== Fetching ALL Login Request Data ===');

    try {
      final response = await _apiService.postRequest(
        APIUrls.adminLoginRequest,
        {},
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        final List list = decoded['data'];

        final allData = list.map((e) => Datum.fromJson(e)).toList();

        loginRequestData.assignAll(allData);

        // FILTER HERE
        if (teamleaderId != null && teamleaderId.isNotEmpty) {
          filteredLoginRequestData.assignAll(
              allData.where((item) => item.teamleaderId == teamleaderId));

          //   calculateRequestTotal(filteredLoginRequestData);
        } else {
          filteredLoginRequestData.assignAll(allData);
          calculateRequestTotal(filteredLoginRequestData);
        }
      }
    } catch (e) {
      debugPrint('Exception in _fetchLoginRequestData: $e');
    } finally {
      isLoginRequestDataLoading.value = false;
    }
  }

  void searchLoginRequests(String query, {String? teamleaderId}) {
    if (query.isEmpty) {
      // reset list
      filteredLoginRequestData.assignAll(
        teamleaderId == null || teamleaderId.isEmpty
            ? loginRequestData
            : loginRequestData
                .where((e) => e.teamleaderId == teamleaderId)
                .toList(),
      );

      calculateRequestTotal(filteredLoginRequestData);
      return;
    }

    final result = loginRequestData.where((item) {
      final name = item.name.toLowerCase();
      //  final mobile = item.mobile?.toLowerCase() ?? "";

      return name.contains(query.toLowerCase());
      //      mobile.contains(query.toLowerCase());
    }).toList();

    filteredLoginRequestData.assignAll(result);
    calculateRequestTotal(filteredLoginRequestData);
  }

  Future<void> _fetchLoginFileData({String? teamleaderId}) async {
    if (loginFilesData.isNotEmpty) return; // prevents re-fetch
    isLoginFileRequestDataLoading.value = true;
    debugPrint('=== Fetching ALL Login Request Data ===');

    try {
      final response = await _apiService.postRequest(
        APIUrls.adminLoginFiles,
        {},
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        final List list = decoded['data'];

        final allData = list.map((e) => Datum.fromJson(e)).toList();

        loginFilesData.assignAll(allData);

        // FILTER HERE
        if (teamleaderId != null && teamleaderId.isNotEmpty) {
          filteredLoginFilesData.assignAll(
              allData.where((item) => item.teamleaderId == teamleaderId));

          //    calculateRequestTotal(filteredLoginFilesData);
        } else {
          filteredLoginFilesData.assignAll(allData);
          calculateRequestTotal(filteredLoginFilesData);
        }
      }
    } catch (e) {
      debugPrint('Exception in _fetchLoginRequestData: $e');
    } finally {
      isLoginFileRequestDataLoading.value = false;
    }
  }

  void searchLoginFileData(String query, {String? teamleaderId}) {
    if (query.isEmpty) {
      // reset list
      filteredLoginFilesData.assignAll(
        teamleaderId == null || teamleaderId.isEmpty
            ? loginFilesData
            : loginFilesData
                .where((e) => e.teamleaderId == teamleaderId)
                .toList(),
      );

      calculateRequestTotal(filteredLoginFilesData);
      return;
    }

    final result = loginFilesData.where((item) {
      final name = item.name.toLowerCase();
      //  final mobile = item.mobile?.toLowerCase() ?? "";

      return name.contains(query.toLowerCase());
      //      mobile.contains(query.toLowerCase());
    }).toList();

    filteredLoginFilesData.assignAll(result);
    calculateRequestTotal(filteredLoginFilesData);
  }

  // Future<void> _fetchLoginRequestDataForSelectedFilter() async {
  //   isLoginRequestDataLoading.value = true;
  //   final teamLeaderId = getSelectedTeamLeaderId();

  //   if (teamLeaderId == null) {
  //     await _fetchLoginRequestData();
  //     return;
  //   }

  //   debugPrint(
  //       '=== Fetching Login Request Data for Team Leader ID: $teamLeaderId ===');

  //   try {
  //     final response = await _apiService.postRequest(
  //       APIUrls.adminLoginRequest,
  //       {'teamleader_id': teamLeaderId},
  //     );

  //     if (response.statusCode == 200) {
  //       final responseData = jsonDecode(response.body) as Map<String, dynamic>;

  //       if (responseData.containsKey('data')) {
  //         final List<dynamic> data = responseData['data'] as List<dynamic>;
  //         _processLoginRequestData(data);
  //       }
  //     }
  //   } catch (e) {
  //     debugPrint('Exception in _fetchLoginRequestDataForSelectedFilter: $e');
  //   } finally {
  //     isLoginRequestDataLoading.value = false;
  //   }
  // }

  // void _processLoginRequestData(List<dynamic> data) {
  //   // Clear existing data
  //   loginRequestData.clear();

  //   // Process each record
  //   for (var item in data) {
  //     final itemMap = item as Map<String, dynamic>;

  //     // Skip the "TOTAL" row
  //     if (itemMap['name'] == 'TOTAL') continue;

  //     // Find team leader name
  //     String teamLeaderName = 'Not Assigned';
  //     if (itemMap['teamleader_id'] != null) {
  //       final tl = teamleaderList.firstWhereOrNull(
  //         (teamLeader) => teamLeader.id == itemMap['teamleader_id'].toString(),
  //       );
  //       teamLeaderName = tl?.name ?? 'Unknown';
  //     }

  //     loginRequestData.add({
  //       'name': itemMap['name']?.toString() ?? 'Unknown',
  //       'teamleader_id': itemMap['teamleader_id']?.toString(),
  //       'teamleader_name': teamLeaderName,
  //       'monthlycount': itemMap['monthlycount']?.toString() ?? '0',
  //       'todaycount': itemMap['todaycount']?.toString() ?? '0',
  //     });
  //   }

  //   debugPrint('Processed ${loginRequestData.length} login request records');

  //   // Update filtered data
  //   filteredLoginRequestData.assignAll(loginRequestData);
  // }

  // // ============================
  // // 🔹 TOTALS CALCULATION
  // // ============================
  // Map<String, int> getLoginRequestTotals() {
  //   int todayTotal = 0;
  //   int monthlyTotal = 0;

  //   for (var item in filteredLoginRequestData) {
  //     todayTotal += int.tryParse(item['todaycount']?.toString() ?? '0') ?? 0;
  //     monthlyTotal +=
  //         int.tryParse(item['monthlycount']?.toString() ?? '0') ?? 0;
  //   }

  //   return {
  //     'today': todayTotal,
  //     'monthly': monthlyTotal,
  //   };
  // }

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

    // final String dateRage = dateRangeList.isNotEmpty &&
    //         dateRangeList.first != null &&
    //         dateRangeList.last != null
    //     ? "${dateRangeList.first},${dateRangeList.last}"
    //     : "";

    // bool hasValidTelecaller = false;
    // final formdata = {
    //   "daterange": dateRage,
    // };

    // if (selectedtellecaller.isNotEmpty) {
    //   for (var i = 0; i < selectedtellecaller.length; i++) {
    //     final telecallerId = selectedtellecaller[i];
    //     formdata["telecaller_ids[$i]"] = telecallerId;
    //     hasValidTelecaller = true;
    //   }
    // }

    // if (!hasValidTelecaller) {
    //   formdata['telecaller_id'] = StaticStoredData.userId;
    // }

    try {
      final response = await _apiService.postRequest(
        APIUrls.adminLoginFiles,
        {},
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        final List list = decoded['data'];

        final allData = list.map((e) => Datum.fromJson(e)).toList();

        // if (responseData.containsKey('totals')) {
        //   final totaldata = Totals.fromJson(responseData['totals']);
        //   callBackTotalData.assign(totaldata);
        // }

        filteredLoginFilesData.assignAll(allData);

        // FILTER HERE
        if (teamleaderId.isNotEmpty) {
          filteredLoginRequestData.assignAll(
              allData.where((item) => item.teamleaderId == teamleaderId));

          calculateRequestTotal(filteredLoginRequestData);
        } else {
          filteredLoginRequestData.assignAll(allData);
          calculateRequestTotal(filteredLoginRequestData);
        }
      }
    } catch (e) {
      debugPrint('Exception in getCallBackData: $e');
    } finally {
      isCallBackLoading.value = false;
    }
  }

  void calculateRequestTotal(List<Datum> data) {
    todayTotal.value = data.fold<int>(
      0,
      (sum, item) => sum + (int.tryParse(item.todaycount ?? '0') ?? 0),
    );

    monthlyTotal.value = data.fold<int>(
      0,
      (sum, item) => sum + (int.tryParse(item.monthlycount ?? '0') ?? 0),
    );

    print(todayTotal);
    print(monthlyTotal);
  }
}
