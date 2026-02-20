import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/constants/api_urls.dart';
import 'package:smart_solutions/constants/static_stored_data.dart';
import 'package:smart_solutions/models/company_list_model.dart';
import 'package:smart_solutions/models/pin_code_list.dart';
import 'package:smart_solutions/services/api_service.dart';

class PincodeController extends GetxController {
  var pincodes = <Datum>[].obs;
  var companyList = <CompanyData>[].obs;
  final ApiService _apiService = ApiService();
  var page = 1.obs;
  var companyPage = 1.obs;
  var isLoading = false.obs;
  var iscompanyLoading = false.obs;
  var companyhasMore = true.obs;
  var hasMore = true.obs;
  final int companylimit = 50;
  final int limit = 50;
  final searchQuery = ''.obs;
  final searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchPincodes();
    fetchCompany();
  }

  Future<void> fetchPincodes({String? search, bool reset = false}) async {
    if (reset) {
      page.value = 1;
      hasMore.value = true;
      pincodes.clear();
    }

    // If no more data, return early
    if (!hasMore.value && !reset) return;

    isLoading.value = true;

    try {
      final Map<String, String> body = {
        'telecaller_id': StaticStoredData.userId,
        'page': page.value.toString(),
        'limit': limit.toString(),
      };

      if (search != null && search.isNotEmpty) {
        body['search'] = search;
        // If search changes, reset the list
        if (page.value == 1) {
          pincodes.clear();
        }
      }

      final response = await _apiService.postRequest(APIUrls.pinCodelist, body);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> data = jsonData['data'];

        final List<Datum> result = data.map((e) => Datum.fromJson(e)).toList();

        if (result.length < limit) {
          // No more data to load
          hasMore.value = false;
        }

        pincodes.addAll(result);
        page.value++;
      } else {
        hasMore.value = false;
        // Optional: Show error
        // Get.snackbar('Error', 'Failed to fetch data');
      }
    } catch (e) {
      debugPrint("Fetch Pincodes Error: $e");
      hasMore.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> fetchPincodes({String? search, bool reset = false}) async {
  //   if (reset) {
  //     page.value = 1;
  //     hasMore.value = true;
  //     pincodes.clear();
  //   }

  //   isLoading.value = true;

  //   final Map<String, String> body = {
  //     'telecaller_id': StaticStoredData.userId,
  //     'page': page.value.toString(),
  //     'limit': limit.toString(),
  //   };

  //   if (search != null && search.isNotEmpty) {
  //     body['search'] = search;
  //     if (page.value == 1) {
  //       pincodes.clear();
  //       isLoading.value = true;
  //     }
  //   }

  //   final response = await _apiService.postRequest(APIUrls.pinCodelist, body);

  //   if (response.statusCode == 200) {
  //     final jsonData = json.decode(response.body);
  //     final List<dynamic> data = jsonData['data'];

  //     final List<Datum> result = data.map((e) => Datum.fromJson(e)).toList();
  //     pincodes.addAll(result);
  //     page++;
  //   } else {
  //     //   Get.snackbar('Error', 'Failed to fetch data');
  //   }

  //   isLoading.value = false;
  // }

  Future<void> fetchCompany({String? search, bool reset = false}) async {
    if (reset) {
      companyPage.value = 1;
      companyhasMore.value = true;
      companyList.clear();
    }

    if (iscompanyLoading.value || !companyhasMore.value) return;

    iscompanyLoading.value = true;

    try {
      final Map<String, String> body = {
        'telecaller_id': StaticStoredData.userId,
        'page': companyPage.value.toString(),
        'limit': companylimit.toString(),
      };

      if (search != null && search.isNotEmpty) {
        body['search'] = search;
      }

      final response = await _apiService.postRequest(APIUrls.companylist, body);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> data = jsonData['data'];

        final result = data.map((e) => CompanyData.fromJson(e)).toList();

        if (result.isEmpty) {
          companyhasMore.value = false;
        } else {
          companyList.addAll(result);
          companyPage.value++;
        }
      } else {
        companyhasMore.value = false;
      }
    } catch (e) {
      print("fetchCompany error: $e");
    } finally {
      iscompanyLoading.value = false;
    }
  }

  // Future<void> fetchCompany({String? search}) async {
  //   if (iscompanyLoading.value) return;

  //   iscompanyLoading.value = true;

  //   final Map<String, String> body = {
  //     'telecaller_id': StaticStoredData.userId,
  //     'page': companyPage.value.toString(),
  //     'limit': companylimit.toString(),
  //   };

  //   if (search != null && search.isNotEmpty) {
  //     body['search'] = search;
  //     if (companyPage.value == 1) {
  //       companyList.clear();
  //       companyhasMore.value = true;
  //     }
  //   }

  //   final response = await _apiService.postRequest(APIUrls.companylist, body);

  //   if (response.statusCode == 200) {
  //     final jsonData = json.decode(response.body);
  //     final List<dynamic> data = jsonData['data'];

  //     final List<companyData> result =
  //         data.map((e) => companyData.fromJson(e)).toList();
  //     companyList.addAll(result);
  //     companyPage++;
  //       } else {
  //     //  Get.snackbar('Error', 'Failed to fetch data');
  //   }

  //   iscompanyLoading.value = false;
  // }

  void resetPagination() {
    pincodes.clear();
    page.value = 1;
    hasMore.value = true;
    fetchPincodes();
  }
}
