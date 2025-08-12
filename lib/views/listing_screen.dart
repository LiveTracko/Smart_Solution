import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/controllers/button_controller.dart';
import 'package:smart_solutions/controllers/pin_code_controller.dart';
import 'package:smart_solutions/theme/app_theme.dart';
import 'package:smart_solutions/utils/customAppbar.dart';

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
        // appBar: AppBar(
        //   backgroundColor: const Color(0xFF356EFF), // your blue color
        //   centerTitle: true,
        //   title: const Text('Listing Page'),
        //   actions: const [],
        // ),
        body: Obx(
      () => Stack(children: [
        const SizedBox(height: 130, child: CurvedAppBar(title: 'Listing Page')),
        Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35), topRight: Radius.circular(35)),
            ),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
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
                    fillColor: Colors.white,
                  ),
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                ElevatedButton(
                  onPressed: () {
                    toggleController.select(0);
                    searchController.clear();
                    pincodeController.companyPage.value = 1;
                    pincodeController.companyhasMore.value = true;
                    pincodeController.fetchCompany();
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.resolveWith<Color>((states) {
                      if (toggleController.selectedIndex.value == 0) {
                        return const Color(0xFF356EFF); // selected blue
                      }
                      return Colors.white; // unselected white
                    }),
                    foregroundColor:
                        MaterialStateProperty.resolveWith<Color>((states) {
                      if (toggleController.selectedIndex.value == 0) {
                        return Colors.white; // selected text/icon white
                      }
                      return Colors.black; // unselected text/icon black
                    }),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: toggleController.selectedIndex.value == 0
                            ? BorderSide.none // no border when selected
                            : const BorderSide(
                                color: Colors.black,
                                width: 1), // black border unselected
                      ),
                    ),
                    elevation: MaterialStateProperty.all(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.list_alt_outlined,
                        size: 20,
                        color: toggleController.selectedIndex.value == 0
                            ? Colors.white
                            : Colors.black,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Company Listing',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: toggleController.selectedIndex.value == 0
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    toggleController.select(1);
                    searchController.clear();
                    pincodeController.page.value = 1;
                    pincodeController.hasMore.value = true;
                    pincodeController.fetchPincodes();
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.resolveWith<Color>((states) {
                      return toggleController.selectedIndex.value == 1
                          ? const Color(0xFF356EFF) // selected blue
                          : Colors.white; // unselected white
                    }),
                    foregroundColor:
                        MaterialStateProperty.resolveWith<Color>((states) {
                      return toggleController.selectedIndex.value == 1
                          ? Colors.white // selected white text/icon
                          : Colors.black; // unselected black text/icon
                    }),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: toggleController.selectedIndex.value == 1
                            ? BorderSide.none // no border when selected
                            : const BorderSide(
                                color: Colors.black,
                                width: 1), // black border unselected
                      ),
                    ),
                    elevation: MaterialStateProperty.all(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 20,
                        color: toggleController.selectedIndex.value == 1
                            ? Colors.white
                            : Colors.black,
                      ),
                      Text(
                        'Pin Code Listing',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: toggleController.selectedIndex.value == 1
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
              const SizedBox(
                height: 10,
              ),

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
            ]),
          ),
        ),
      ]),
    ));
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
              headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  return Colors
                      .grey[200]; // light grey background for header row
                },
              ),
              columns: const [
                DataColumn(
                  columnWidth: IntrinsicColumnWidth(),
                  label: Text(
                    'Bank',
                    style: TextStyle(color: Colors.indigo),
                  ),
                ),
                DataColumn(
                  columnWidth: IntrinsicColumnWidth(),
                  label:
                      Text('Pincode', style: TextStyle(color: Colors.indigo)),
                ),
                DataColumn(
                  columnWidth: IntrinsicColumnWidth(),
                  label: SizedBox(
                    width: 120,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'City',
                        style: TextStyle(color: Colors.indigo),
                      ),
                    ),
                  ),
                ),
              ],
              rows: list
                  .map(
                    (pin) => DataRow(
                      cells: [
                        DataCell(Text(
                          pin.bankName.toString(),
                          style: const TextStyle(color: Colors.black),
                        )),
                        DataCell(Text(
                          pin.pincode.toString(),
                          style: const TextStyle(color: Colors.black),
                        )),
                        DataCell(
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              pin.city.toString(),
                              style: const TextStyle(color: Colors.black),
                              maxLines: 1,
                              overflow: TextOverflow
                                  .ellipsis, // prevents wrapping, shows "..."
                              softWrap: false,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
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
