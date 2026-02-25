import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/controllers/chartCard_controller.dart';
import 'package:smart_solutions/controllers/common_filter_controller.dart';
import 'package:smart_solutions/controllers/data_entry_controller.dart';
import 'package:smart_solutions/models/data_entery_model.dart';

class ActiveFilesController extends GetxController {
  var filteredList = <Data>[].obs;

  final DataController dataController = Get.find<DataController>();
  final ChartCardsController _chartCardsController =
      Get.find<ChartCardsController>();

  final CommonFilterController filterController =
      Get.find<CommonFilterController>();

  final ScrollController filterScrollController = ScrollController();

  var currentStatus = 0.obs;

  Worker? _worker;

  @override
  void onInit() {
    super.onInit();

    // ever(filterController.selectedRange, (_) {
    //   dataController.fetchDataEntryList();
    // });

   // _startWorker();

    ever<List<Data>>(dataController.dataList, (_) {
      updateFilteredList();
    });

    ever(filterController.selectedFilter, (_) => updateFilteredList());

    filterController.searchController.addListener(() {
      dataController.searchText.value = filterController.searchController.text;

      dataController.fetchDataEntryList();
    });

    ever(_chartCardsController.selectedIndex, (index) {
      currentStatus.value = index == 0 ? 1 : 2;
      filterController.clearFilters();
      updateFilteredList();
    });

    currentStatus.value = 1;
  }

  void startWorker() {
    _worker = ever(filterController.selectedRange, (_) {
      dataController.fetchDataEntryList();
    });
  }

  void stopWorker() {
    _worker?.dispose();
    _worker = null;
  }

  void restartWorker() {
    stopWorker();
    startWorker();
  }

  @override
  void onClose() {
    stopWorker();
    _chartCardsController.selectedIndex.value = 0;
    filterController.searchController.removeListener(_onSearchTextChanged);
    super.onClose();
  }
  // void _handleDateChange() {
  //   final from = filterController.fromDate.value;
  //   final to = filterController.toDate.value;

  //   if (from != null && to != null) {
  //     if (!dataController.isLoading.value) {
  //       dataController.fetchDataEntryList();
  //     }
  //   }

  //   if (from == null && to == null) {
  //     if (!dataController.isLoading.value) {
  //       dataController.fetchDataEntryList();
  //     }
  //   }
  // }

  @override
  void onReady() {
    super.onReady();

    filterController.searchController.addListener(_onSearchTextChanged);
  }

  // @override
  // void onClose() {
  //   _chartCardsController.selectedIndex.value = 0;
  //   filterController.searchController.removeListener(_onSearchTextChanged);
  //   super.onClose();
  // }

  void _onSearchTextChanged() {
    updateFilteredList();
  }

  void updateFilteredList() {
    try {
      final source = dataController.dataList;

      if (source.isEmpty) {
        filteredList.clear();
        return;
      }

      List<Data> tempList = source.where((item) {
        if (currentStatus.value == 1) {
          return item.dataStatus?.toLowerCase() == 'active';
        } else if (currentStatus.value == 2) {
          return item.dataStatus?.toLowerCase() == 'inactive';
        }
        return true;
      }).toList();

      final names = tempList
          .map((e) => e.status ?? '')
          .where((e) => e.isNotEmpty)
          .toSet()
          .toList();

      filterController.setFilters(names);

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

      filteredList.assignAll(tempList);
    } catch (e) {
      filteredList.assignAll([]);
    }
  }
}
