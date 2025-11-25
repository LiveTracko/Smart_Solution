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
      Get.put(CommonFilterController());

  var currentStatus = 0.obs;

  @override
  void onInit() {
    super.onInit();

    loadData();

    ever(dataList, (_) => updateFilteredList());
    ever(filterController.selectedFilter, (_) => updateFilteredList());

    // ever(_chartCardsController.selectedIndex, (index) {
    //   if (index == 0) {
    //     currentStatus.value = 1;
    //   } else if (index == 1) {
    //     currentStatus.value = 2;
    //   }

    //   updateFilteredList();
    // });

    // currentStatus.value = 1;
    // updateFilteredList();

    ever(_chartCardsController.selectedIndex, (index) {
      // update status
      if (index == 0) {
        currentStatus.value = 1;
      } else if (index == 1) {
        currentStatus.value = 2;
      }

      // 🔥 reset filters COMPLETELY
      filterController.searchController.clear();
      filterController.selectedFilter.value = 0;
      filterController.clearFilters();

      // update list
      updateFilteredList();
    });

// init default
    currentStatus.value = 1;
    updateFilteredList();
  }

  void loadData() {
    dataList.assignAll(dataController.dataList);

    //  updateFilteredList();
  }

  void updateFilteredList() {
    final names = dataList
        .where((item) {
          if (currentStatus.value == 1) {
            return item.dataStatus?.toLowerCase() == 'active';
          } else if (currentStatus.value == 2) {
            return item.dataStatus?.toLowerCase() == 'inactive';
          } else {
            return item.dataStatus?.toLowerCase() == 'active';
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
        return item.dataStatus?.toLowerCase() == 'active';
      }).toList();
    } else {
      final filterText =
          filterController.filters[filterController.selectedFilter.value];

      filteredList.value = dataList.where((item) {
        if (currentStatus.value == 1) {
          return item.dataEntryStatus!.toLowerCase() ==
                  filterText.toLowerCase() &&
              item.dataStatus?.toLowerCase() == 'active';
        } else if (currentStatus.value == 2) {
          return item.dataEntryStatus!.toLowerCase() ==
                  filterText.toLowerCase() &&
              item.dataStatus?.toLowerCase() == 'inactive';
        }
        return item.dataEntryStatus!.toLowerCase() ==
                filterText.toLowerCase() &&
            item.dataStatus?.toLowerCase() == 'active';
      }).toList();
    }

    final query = filterController.searchController.text.trim().toLowerCase();

    if (query.isNotEmpty) {
      filteredList.value = filteredList.where((item) {
        return (item.customerName ?? '').toLowerCase().contains(query) ||
            (item.mobileNo ?? '').toLowerCase().contains(query) ||
            (item.bankName ?? '').toLowerCase().contains(query);
      }).toList();
    }
  }

  // void updateFilteredList() {

  //   final names = dataList
  //       .where((item) {
  //         if (currentStatus.value == 1) {
  //           return item.dataStatus?.toLowerCase() == 'active';
  //         } else if (currentStatus.value == 2) {
  //           return item.dataStatus?.toLowerCase() == 'inactive';
  //         } else {
  //           return item.dataStatus?.toLowerCase() ==
  //               'active'; // -1 means show all statuses
  //         }
  //       })
  //       .map((item) => item.dataEntryStatus ?? 'Unknown')
  //       .toList();

  //   filterController.setFilters(names);
  //   if (filterController.selectedFilter.value == 0) {
  //     filteredList.value = dataList.where((item) {
  //       if (currentStatus.value == 1) {
  //         return item.dataStatus?.toLowerCase() == 'active';
  //       } else if (currentStatus.value == 2) {
  //         return item.dataStatus?.toLowerCase() == 'inactive';
  //       }
  //       return item.dataStatus?.toLowerCase() ==
  //           'active'; // -1 means show all statuses
  //     }).toList();
  //   } else {
  //     final filterText =
  //         filterController.filters[filterController.selectedFilter.value];
  //     final selectedStatus = filterText;

  //     filteredList.value = dataList.where((item) {
  //       if (currentStatus.value == 1) {
  //         return item.dataEntryStatus!.toLowerCase() ==
  //                 selectedStatus.toLowerCase() &&
  //             item.dataStatus?.toLowerCase() == 'active';
  //       } else if (currentStatus.value == 2) {
  //         return item.dataEntryStatus!.toLowerCase() ==
  //                 selectedStatus.toLowerCase() &&
  //             item.dataStatus?.toLowerCase() == 'inactive';
  //       }
  //       return item.dataEntryStatus!.toLowerCase() ==
  //               selectedStatus.toLowerCase() &&
  //           item.dataStatus?.toLowerCase() == 'active';
  //     }).toList();
  //   }
  //   print('🔄 Filtered list updated: ${filteredList.length} items');
  // }
}
