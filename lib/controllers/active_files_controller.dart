import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/controllers/chartCard_controller.dart';
import 'package:smart_solutions/controllers/common_filter_controller.dart';
import 'package:smart_solutions/controllers/data_entry_controller.dart';
import 'package:smart_solutions/models/data_entery_model.dart';

class ActiveFilesController extends GetxController {
  var dataList = <Data>[].obs;
  var filteredList = <Data>[].obs;

  final DataController dataController = Get.find<DataController>();
  final ChartCardsController _chartCardsController =
      Get.find<ChartCardsController>();

  final CommonFilterController filterController =
      Get.find<CommonFilterController>();

  final ScrollController filterScrollController = ScrollController();

  var currentStatus = 0.obs;

  @override
  void onInit() {
    super.onInit();

    loadData();

    // Listen for changes that should trigger filtering
    ever(dataList, (_) => updateFilteredList());
    ever(filterController.selectedFilter, (_) => updateFilteredList());
    ever(filterController.selectedDate, (_) => updateFilteredList());
    ever(filterController.isDateSelected, (_) => updateFilteredList());

    // Listen to chart card changes
    ever(_chartCardsController.selectedIndex, (index) {
      if (index == 0) {
        currentStatus.value = 1; // Active
      } else if (index == 1) {
        currentStatus.value = 2; // Inactive
      }

      // Reset all filters
      filterController.clearFilters();

      // Update list
      updateFilteredList();
    });

    // Initialize
    currentStatus.value = 1;
    updateFilteredList();
  }

  @override
  void onReady() {
    super.onReady();
    // Listen to search text changes using a different approach
    filterController.searchController.addListener(_onSearchTextChanged);
  }

  @override
  void onClose() {
    // Clean up the listener
    filterController.searchController.removeListener(_onSearchTextChanged);
    super.onClose();
  }

  void _onSearchTextChanged() {
    updateFilteredList();
  }

  void loadData() {
    dataList.assignAll(dataController.dataList);
  }

  void updateFilteredList({String query = ''}) {
    // 1️⃣ Build filter names for chips
    final names = dataList
        .map((e) => e.status ?? '')
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();
    filterController.setFilters(names);

    // 🔥 Clear old list before filtering
    filteredList.clear();
    try {
      // Step 1: Filter by current status (Active/Inactive)
      List<Data> tempList = dataList.where((item) {
        if (currentStatus.value == 1) {
          return item.dataStatus?.toLowerCase() == 'active';
        } else if (currentStatus.value == 2) {
          return item.dataStatus?.toLowerCase() == 'inactive';
        }
        return item.dataStatus?.toLowerCase() == 'active';
      }).toList();

      // Step 2: Apply date filter if selected
      if (filterController.isDateSelected.value &&
          filterController.selectedDate.value != null) {
        final selectedDate = filterController.selectedDate.value!;
        tempList = tempList.where((item) {
          if (item.date == null) return false;
          try {
            final itemDate = DateTime.parse(item.date.toString());
            // Compare only year, month, day (ignore time)
            return itemDate.year == selectedDate.year &&
                itemDate.month == selectedDate.month &&
                itemDate.day == selectedDate.day;
          } catch (e) {
            print('Date parsing error: $e');
            return false;
          }
        }).toList();
      }

      // Step 3: Apply status filter from chips
      if (filterController.selectedFilter.value > 0 &&
          filterController.selectedFilter.value <
              filterController.filters.length) {
        final filterText =
            filterController.filters[filterController.selectedFilter.value];

        if (filterText != 'All') {
          tempList = tempList.where((item) {
            return item.dataEntryStatus?.toLowerCase() ==
                filterText.toLowerCase();
          }).toList();
        }
      }

      // Step 4: Apply text search
      final query = filterController.searchController.text.trim().toLowerCase();
      if (query.isNotEmpty) {
        tempList = tempList.where((item) {
          return (item.customerName ?? '').toLowerCase().contains(query) ||
              (item.tcName ?? '').toLowerCase().contains(query) ||
              (item.tlName ?? '').toLowerCase().contains(query) ||
              (item.mobileNo ?? '').toLowerCase().contains(query) ||
              (item.bankName ?? '').toLowerCase().contains(query) ||
              (item.comments ?? '').toLowerCase().contains(query);
        }).toList();
      }

      // Update the filtered list
      filteredList.assignAll(tempList);
    } catch (e) {
      print('Error in updateFilteredList: $e');
      filteredList.assignAll([]);
    }
  }
}
