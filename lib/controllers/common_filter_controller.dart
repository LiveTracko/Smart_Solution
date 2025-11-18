import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonFilterController extends GetxController {
  var filters = <String>[].obs;
  var selectedFilter = 0.obs;
  final searchController = TextEditingController();

  void selectFilter(int index) {
    selectedFilter.value = index;
  }

  void clearFilters() {
    selectedFilter.value = 0;
   
    searchController.clear();
  }

  void setFilters(List<String> names) {
    filters.value = ["All", ...names.toSet()];
    update();
  }
}
