import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/constants/static_stored_data.dart';
import '../constants/services.dart';
import '../services/api_service.dart';
import '../constants/api_urls.dart';

class NotificationController extends GetxController {
  final ApiService _apiService = ApiService();
  List notificationData = [].obs;
  var isLoading = true.obs;
  Rx<int> unreadCount = 0.obs;

  @override
  void onInit() {
    getNotificationList();
    super.onInit();
  }

  void getNotificationList() async {
    try {
      var response = await _apiService.postRequest(
        APIUrls.getnotificationData,
        {
          "telecaller_id": StaticStoredData.userId,
        },
      );

      debugPrint(" data -->  ${response.statusCode} ${response.body}");

      if (response.statusCode == 200) {
        try {
          final responseData = jsonDecode(response.body);

          final contacts = responseData['data'];
          if (contacts is List) {
            notificationData = List<Map<String, dynamic>>.from(contacts);
            unreadCount.value =
                notificationData.where((item) => item['is_read'] == '0').length;
            isLoading.value = false;
          } else {
            logOutput("Unexpected format for total_attempt_contact");
            notificationData = [];
          }
        } catch (e) {
          logOutput("Error decoding or parsing response: $e");
          notificationData = [];
        }
      } else if (response.statusCode == 204) {
        notificationData.clear();
      }
    } catch (e) {
      print(e);
    }
  }

  void updateNotificatioData() async {
    try {
      var response = await _apiService.postRequest(
        APIUrls.updatenotificationData,
        {
          "telecaller_id": StaticStoredData.userId,
        },
      );

      debugPrint(" data -->  ${response.statusCode} ${response.body}");

      if (response.statusCode == 200) {
        print('Notification updated successfull');
      }
    } catch (e) {
      print('update notification data $e');
    }
  }
}
