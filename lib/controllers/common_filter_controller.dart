import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonFilterController extends GetxController {
  var filters = <String>[].obs;
  var selectedFilter = 0.obs;
  final searchController = TextEditingController();
  
  // Add date filtering properties
  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  RxBool isDateSelected = false.obs;

  void selectFilter(int index) {
    selectedFilter.value = index;
  }

  void clearFilters() {
    selectedFilter.value = 0;
    searchController.clear();
    clearDateFilter(); // Also clear date filter
  }

  void clearDateFilter() {
    selectedDate.value = null;
    isDateSelected.value = false;
  }

  void setSelectedDate(DateTime? date) {
    selectedDate.value = date;
    isDateSelected.value = date != null;
  }

  void setFilters(List<String> names) {
    filters.value = ["All", ...names.toSet()];
    update();
  }
}