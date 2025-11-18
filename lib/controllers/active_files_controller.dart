import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/controllers/chartCard_controller.dart';
import 'package:smart_solutions/controllers/common_filter_controller.dart';
import 'package:smart_solutions/controllers/data_entry_controller.dart';
import 'package:smart_solutions/models/data_entery_model.dart';

class ActiveFilesController extends GetxController {
  var dataList = <Data>[].obs;
  var filteredList = <Data>[].obs;
  final searchController = TextEditingController();
  final DataController dataController = Get.find<DataController>();
  final ChartCardsController _chartCardsController =
      Get.find<ChartCardsController>();

  final CommonFilterController filterController =
      Get.put(CommonFilterController());

  var currentStatus = 0.obs;

  @override
  void onInit() {
    super.onInit();

    loadData();

    ever(dataList, (_) => updateFilteredList());
    ever(filterController.selectedFilter, (_) => updateFilteredList());

    ever(_chartCardsController.selectedIndex, (index) {
      if (index == 0) {
        currentStatus.value = 1;
      } else if (index == 1) {
        currentStatus.value = 2;
      }

      updateFilteredList();
    });

    currentStatus.value = 1;
    updateFilteredList();
  }

  void loadData() {
    dataList.assignAll(dataController.dataList);

    //  updateFilteredList();
  }

  // void setupFilters(int status) {
  //   currentStatus.value = status;
  //   final itemList = status == 1
  //       ? _dashboardController.activeList
  //       : _dashboardController.inActiveList;

  //   final names =
  //       itemList.map((item) => item.StatusGroupModelName ?? 'Unknown').toList();

  //   filterController.setFilters(names);
  // }

  void updateFilteredList() {
    // final names = dataList
    //     .where((item) => currentStatus.value == 1
    //         ? item.dataStatus?.toLowerCase() == 'active'
    //         : item.dataStatus?.toLowerCase() == 'inactive')
    //     .map((item) => item.dataEntryStatus ?? 'Unknown')
    //     .toList();

    final names = dataList
        .where((item) {
          if (currentStatus.value == 1) {
            return item.dataStatus?.toLowerCase() == 'active';
          } else if (currentStatus.value == 2) {
            return item.dataStatus?.toLowerCase() == 'inactive';
          } else {
            return item.dataStatus?.toLowerCase() ==
                'active'; // -1 means show all statuses
          }
        })
        .map((item) => item.dataEntryStatus ?? 'Unknown')
        .toList();

    filterController.setFilters(names);
    if (filterController.selectedFilter.value == 0) {
      filteredList.value = dataList.where((item) {
        if (currentStatus.value == 1) {
          return item.dataStatus?.toLowerCase() == 'active';
        } else if (currentStatus.value == 2) {
          return item.dataStatus?.toLowerCase() == 'inactive';
        }
        return item.dataStatus?.toLowerCase() ==
            'active'; // -1 means show all statuses
        //  else {
        //   return true; // -1 means show all statuses
        // }
      }).toList();
    } else {
      final filterText =
          filterController.filters[filterController.selectedFilter.value];
      final selectedStatus = filterText;

      filteredList.value = dataList.where((item) {
        if (currentStatus.value == 1) {
          return item.dataEntryStatus!.toLowerCase() ==
                  selectedStatus.toLowerCase() &&
              item.dataStatus?.toLowerCase() == 'active';
        } else if (currentStatus.value == 2) {
          return item.dataEntryStatus!.toLowerCase() ==
                  selectedStatus.toLowerCase() &&
              item.dataStatus?.toLowerCase() == 'inactive';
        }
        return item.dataEntryStatus!.toLowerCase() ==
                selectedStatus.toLowerCase() &&
            item.dataStatus?.toLowerCase() == 'active';

        //  else {
        //   return item.dataEntryStatus!.toLowerCase() ==
        //       selectedStatus.toLowerCase();
        //   // -1 means show all statuses, so only filter by dataEntryStatus
        // }
      }).toList();
      //.split(' ').first;

      // filteredList.value = dataList
      //     .where((item) =>
      //         item.dataEntryStatus!.toLowerCase() ==
      //         selectedStatus.toLowerCase())
      //     .toList();
      // filteredList.value = dataList
      //     .where((item) =>
      //         item.dataEntryStatus!.toLowerCase() ==
      //             selectedStatus.toLowerCase() &&
      //         (currentStatus.value == 1
      //             ? item.dataStatus?.toLowerCase() == 'active'
      //             : item.dataStatus?.toLowerCase() == 'inactive'))
      //     .toList();
    }
    print('🔄 Filtered list updated: ${filteredList.length} items');
  }

}
