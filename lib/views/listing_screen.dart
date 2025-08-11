import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/controllers/button_controller.dart';
import 'package:smart_solutions/controllers/pin_code_controller.dart';
import 'package:smart_solutions/theme/app_theme.dart';

class ListingScreen extends StatefulWidget {
  const ListingScreen({super.key});

  @override
  State<ListingScreen> createState() => _ListingScreenState();
}

class _ListingScreenState extends State<ListingScreen> {
  final ToggleButtonController toggleController =
      Get.put(ToggleButtonController());

  final PincodeController pincodeController = Get.put(PincodeController());

  final ScrollController scrollController = ScrollController();

  final ScrollController companyScrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    // 1. Initial data fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pincodeController.fetchPincodes(); // fetch on build complete
      pincodeController.fetchCompany();
    });

    // 2. Scroll listener for pagination
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 100 &&
          !pincodeController.isLoading.value &&
          pincodeController.hasMore.value) {
        pincodeController.fetchPincodes(search: searchController.text);
      }
    });

    // 2. Scroll listener for pagination
    companyScrollController.addListener(() {
      if (companyScrollController.position.pixels >=
              companyScrollController.position.maxScrollExtent - 100 &&
          !pincodeController.iscompanyLoading.value &&
          pincodeController.companyhasMore.value) {
        pincodeController.fetchCompany(search: searchController.text);
      }
    });
  }

  onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      pincodeController.fetchCompany(search: value.trim());
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    companyScrollController.dispose();
    searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Listing Page'),
          actions: const [],
        ),
        body: Obx(() => Column(children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: TextField(
                  style: const TextStyle(color: Colors.black),
                  keyboardType: TextInputType.text,
                  controller: searchController,
                  onChanged: (value) {
                    if (_debounce?.isActive ?? false) _debounce!.cancel();

                    _debounce = Timer(const Duration(milliseconds: 400), () {
                      final trimmed = value.trim(); // use trimmed if needed

                      if (toggleController.selectedIndex.value == 0) {
                        pincodeController.companyPage.value = 1;
                        pincodeController.companyhasMore.value = true;
                        pincodeController.fetchCompany(search: trimmed);
                      } else {
                        pincodeController.page.value = 1;
                        pincodeController.hasMore.value = true;
                        pincodeController.fetchPincodes(search: trimmed);
                      }
                    });
                  },
                  decoration: InputDecoration(
                    hintText: toggleController.selectedIndex.value == 0
                        ? 'Search by Company Name'
                        : 'Search by Pincode',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                ElevatedButton(
                  onPressed: () {
                    toggleController.select(0);
                    searchController.clear(); // ✅ Clear search text
                    pincodeController.companyPage.value = 1;
                    pincodeController.companyhasMore.value = true;
                    pincodeController.fetchCompany(); // Optionally refresh
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: toggleController.selectedIndex.value == 0
                        ? AppColors.appBarColor
                        : Colors.grey[300],
                    foregroundColor: toggleController.selectedIndex.value == 0
                        ? Colors.white
                        : Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: const Text('Company Listing'),
                ),
                ElevatedButton(
                  onPressed: () {
                    toggleController.select(1);
                    searchController.clear(); // ✅ Clear search text
                    pincodeController.page.value = 1;
                    pincodeController.hasMore.value = true;
                    pincodeController.fetchPincodes(); // Optionally refresh
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: toggleController.selectedIndex.value == 1
                        ? AppColors.appBarColor
                        : Colors.grey[300],
                    foregroundColor: toggleController.selectedIndex.value == 1
                        ? Colors.white
                        : Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: const Text('Pin Code Listing'),
                ),
                const SizedBox(height: 16),
              ]),

              // Data Table
              Expanded(
                child: Obx(() {
                  if (toggleController.selectedIndex.value == 0) {
                    return _buildCompanyTable();
                  } else {
                    return _buildPincodeTable();
                  }
                }),
              ),
            ])));
  }

  /// Dummy company table
  Widget _buildCompanyTable() {
    return Obx(() {
      final list = pincodeController.companyList;

      return SingleChildScrollView(
        controller: companyScrollController,
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            DataTable(
              columnSpacing: 32,
              headingRowHeight: 50,
              dataRowHeight: 70,
              columns: const [
                //  DataColumn(label: Text('DSA Name')),
                DataColumn(
                    columnWidth: IntrinsicColumnWidth(), label: Text('Bank')),
                DataColumn(
                    columnWidth: IntrinsicColumnWidth(),
                    label: Text('Company Category')),
                DataColumn(
                    columnWidth: IntrinsicColumnWidth(),
                    label: Text('Category')),
              ],
              rows: list
                  .map((pin) => DataRow(cells: [
                        // DataCell(Text(
                        //   pin.dsaName.toString(),
                        //   style: const TextStyle(color: Colors.black),
                        // )),
                        DataCell(Text(
                          pin.bankName.toString(),
                          style: const TextStyle(color: Colors.black),
                        )),
                        DataCell(Text(
                          pin.companyName.toString(),
                          style: const TextStyle(color: Colors.black),
                        )),
                        DataCell(Text(pin.category.toString(),
                            style: const TextStyle(color: Colors.black))),
                      ]))
                  .toList(),
            ),
            if (pincodeController.iscompanyLoading.value)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      );
    });
  }

  /// Dynamic Pin Code Table
  Widget _buildPincodeTable() {
    return Obx(() {
      final list = pincodeController.pincodes;

      return SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            DataTable(
              columnSpacing: 32,
              headingRowHeight: 50,
              dataRowHeight: 50,
              columns: const [
                //    DataColumn(label: Text('DSA Name')),
                DataColumn(
                    columnWidth: IntrinsicColumnWidth(), label: Text('Bank')),
                DataColumn(
                    columnWidth: IntrinsicColumnWidth(),
                    label: Text('Pincode')),
                DataColumn(
                    columnWidth: IntrinsicColumnWidth(), label: Text('City')),
              ],
              rows: list
                  .map((pin) => DataRow(cells: [
                        // DataCell(Text(
                        //   pin.dsaName.toString(),
                        //   style: const TextStyle(color: Colors.black),
                        // )),
                        DataCell(Text(
                          pin.bankName.toString(),
                          style: const TextStyle(color: Colors.black),
                        )),
                        DataCell(Text(
                          pin.pincode.toString(),
                          style: const TextStyle(color: Colors.black),
                        )),
                        DataCell(Text(pin.city.toString(),
                            style: const TextStyle(color: Colors.black))),
                      ]))
                  .toList(),
            ),
            if (pincodeController.isLoading.value)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      );
    });
  }
}
