import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonFilterController extends GetxController {
  var filters = <String>[].obs;
  var selectedFilter = 0.obs;
  final searchController = TextEditingController();

  Rxn<DateTimeRange> selectedRange = Rxn<DateTimeRange>();
  RxBool isDateRangeSelected = false.obs;

  void selectFilter(int index) {
    selectedFilter.value = index;
  }

  void clearFilters() {
    selectedFilter.value = 0;
    searchController.clear();
    clearDateFilter();
  }

  void clearDateFilter() {
    selectedFilter.value = 0;

    isDateRangeSelected.value = false;
  }

  void setSelectedDate(DateTime start, DateTime end) {
    selectedRange.value = DateTimeRange(start: start, end: end);
    isDateRangeSelected.value = true;
  }

  // void setSelectedDate(DateTime? startDate, DateTime? endDate) {
  //   fromDate.value = startDate;
  //   toDate.value = endDate;

  //   fromDate.refresh();
  //   toDate.refresh();
  //   isDateRangeSelected.value = true;
  // }

  void setFilters(List<String> names) {
    filters.value = ["All", ...names.toSet()];
    update();
  }
}
