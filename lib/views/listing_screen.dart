import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/controllers/button_controller.dart';
import 'package:smart_solutions/controllers/chartCard_controller.dart';
import 'package:smart_solutions/controllers/pin_code_controller.dart';
import 'package:smart_solutions/controllers/theme_controller.dart';
import 'package:smart_solutions/theme/app_theme.dart';
import 'package:smart_solutions/views/chart_card_toggle.dart';
import 'package:smart_solutions/views/spacing_constants.dart';
import 'package:smart_solutions/widget/common_scaffold.dart';
import 'package:smart_solutions/widget/common_title_card.dart';
import 'package:smart_solutions/widget/searchbarwithclear.dart';

class ListingScreen extends StatefulWidget {
  String title;
  bool isShowBack = false;
  bool isDrawer = false;
  ListingScreen(
      {super.key,
      required this.title,
      required this.isShowBack,
      required this.isDrawer});

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
  final ChartCardsController _chartCardsController =
      Get.find<ChartCardsController>();
  final ThemeController themeController = Get.find<ThemeController>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    //   // 1. Initial data fetch
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     pincodeController.fetchPincodes(); // fetch on build complete
    //     pincodeController.fetchCompany();
    //   });

    //   // 2. Scroll listener for pagination
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 100 &&
          !pincodeController.isLoading.value &&
          pincodeController.hasMore.value) {
        pincodeController.fetchPincodes(search: searchController.text);
      }
    });

    //   // 2. Scroll listener for pagination
    companyScrollController.addListener(() {
      if (companyScrollController.position.pixels >=
              companyScrollController.position.maxScrollExtent - 100 &&
          !pincodeController.iscompanyLoading.value &&
          pincodeController.companyhasMore.value) {
        pincodeController.fetchCompany(search: searchController.text);
      }
    });
  }

  // onSearchChanged(String value) {
  //   if (_debounce?.isActive ?? false) _debounce!.cancel();

  //   _debounce = Timer(const Duration(milliseconds: 500), () {
  //     pincodeController.fetchCompany(search: value.trim());
  //   });

  @override
  void dispose() {
    Future.microtask(() {
      _debounce?.cancel();
      searchController.dispose();
      _chartCardsController.selectedIndex.value = 0;
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
        title: 'Listing Page',
        showBack: true,
        key: _scaffoldKey,
        body: Column(children: [
          Container(
            color: AppColors.appBarTextColor,
            child: Column(
              children: [
                ChartCardsToggle(
                    height: 40,
                    width: 170,
                    fontSize: 15,
                    verticalPadding: 10,
                    horizontalPadding: 0,
                    data: const ['Company Listing ', 'Pincode Listing']),
                kVerticalSpace(10),
                Obx(() {
                  // 🔥 Clear search when toggling
                  searchController.clear();
                  _debounce?.cancel();

                  return SearchBarWithClear(
                    key: ValueKey(_chartCardsController.selectedIndex.value),
                    controller: searchController,
                    focusNode: FocusNode(),
                    showDatePickerIcon: false,
                    textInputType:
                        _chartCardsController.selectedIndex.value == 0
                            ? TextInputType.text
                            : TextInputType.number,
                    //  showDatePickerIcon: false,
                    onClear: () {
                      searchController.clear();
                      _debounce?.cancel();

                      if (_chartCardsController.selectedIndex.value == 0) {
                        pincodeController.companyPage.value = 1;
                        pincodeController.companyhasMore.value = true;
                        pincodeController.companyList.clear();
                        pincodeController.fetchCompany(search: "");
                      } else {
                        pincodeController.page.value = 1;
                        pincodeController.hasMore.value = true;
                        pincodeController.pincodes.clear();
                        pincodeController.fetchPincodes(search: "");
                      }
                    },
                    onChanged: (value) {
                      if (_debounce?.isActive ?? false) _debounce!.cancel();
                      _debounce = Timer(const Duration(milliseconds: 400), () {
                        final trimmed = value.trim();

                        if (_chartCardsController.selectedIndex.value == 0) {
                          pincodeController.companyPage.value = 1;
                          pincodeController.companyhasMore.value = true;
                          pincodeController.companyList.clear();
                          pincodeController.fetchCompany(search: trimmed);
                        } else {
                          pincodeController.page.value = 1;
                          pincodeController.hasMore.value = true;
                          pincodeController.pincodes.clear();
                          pincodeController.fetchPincodes(search: trimmed);
                        }
                      });
                    },
                  );
                }),
                kVerticalSpace(15)
              ],
            ),
          ),

          // TextField(
          //   key: ValueKey(toggleController.selectedIndex.value),
          //   style: const TextStyle(color: Colors.black),
          //   keyboardType: toggleController.selectedIndex.value == 0
          //       ? TextInputType.text
          //       : TextInputType.number,
          //   controller: searchController,
          //   onChanged: (value) {
          //     if (_debounce?.isActive ?? false) _debounce!.cancel();

          //     _debounce = Timer(const Duration(milliseconds: 400), () {
          //       final trimmed = value.trim(); // use trimmed if needed

          //       if (toggleController.selectedIndex.value == 0) {
          //         pincodeController.companyPage.value = 1;
          //         pincodeController.companyhasMore.value = true;
          //         pincodeController.fetchCompany(search: trimmed);
          //       } else {
          //         pincodeController.page.value = 1;
          //         pincodeController.hasMore.value = true;
          //         pincodeController.fetchPincodes(search: trimmed);
          //       }
          //     });
          //   },
          //   decoration: InputDecoration(
          //     hintText: toggleController.selectedIndex.value == 0
          //         ? 'Search by Company Name'
          //         : 'Search by Pincode',
          //     prefixIcon: const Icon(Icons.search),
          //     border: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(5),
          //       borderSide: const BorderSide(color: Colors.white),
          //     ),
          //     filled: true,
          //     fillColor: Colors.white12,
          //   ),
          // ),

          // Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          //   Expanded(
          //     child: ElevatedButton.icon(
          //       icon: SvgPicture.asset(
          //         'assets/images/company_listing.svg',
          //         color: toggleController.selectedIndex.value == 0
          //             ? AppColors.appBarTextColor
          //             : AppColors.primaryColor,
          //       ),
          //       onPressed: () {
          //         toggleController.select(0);
          //         searchController.clear(); // ✅ Clear search text
          //         pincodeController.companyPage.value = 1;
          //         pincodeController.companyhasMore.value = true;
          //         pincodeController.fetchCompany(); // Optionally refresh
          //       },
          //       style: ElevatedButton.styleFrom(
          //         backgroundColor: toggleController.selectedIndex.value == 0
          //             ? AppColors.primaryColor
          //             : Colors.white,
          //         foregroundColor: toggleController.selectedIndex.value == 0
          //             ? Colors.white
          //             : Colors.black,
          //         padding: const EdgeInsets.symmetric(
          //             horizontal: 8, vertical: 8),
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(10),
          //         ),
          //         elevation: 4,
          //       ),
          //       label: const Text(
          //         'Company Listing',
          //         style:
          //             TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          //       ),
          //     ),
          //   ),
          //   const SizedBox(width: 16),
          //   Expanded(
          //     child: ElevatedButton.icon(
          //       icon: Image.asset(
          //         'assets/images/pincode.png',
          //         color: toggleController.selectedIndex.value == 1
          //             ? AppColors.appBarTextColor
          //             : AppColors.primaryColor,
          //       ),
          //       onPressed: () {
          //         toggleController.select(1);
          //         searchController.clear(); // ✅ Clear search text
          //         pincodeController.page.value = 1;
          //         pincodeController.hasMore.value = true;
          //         pincodeController.fetchPincodes(); // Optionally refresh
          //       },
          //       style: ElevatedButton.styleFrom(
          //         backgroundColor: toggleController.selectedIndex.value == 1
          //             ? AppColors.primaryColor
          //             : Colors.white,
          //         foregroundColor: toggleController.selectedIndex.value == 1
          //             ? Colors.white
          //             : Colors.black,
          //         padding: const EdgeInsets.symmetric(
          //             horizontal: 8, vertical: 8),
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(10),
          //         ),
          //         elevation: 4,
          //       ),
          //       label: const Text(
          //         'Pin Code Listing',
          //         style:
          //             TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          //       ),
          //     ),
          //   ),
          //   const SizedBox(height: 16),
          // ]),

          // Data Table
          Expanded(
            child: Obx(() {
              if (_chartCardsController.selectedIndex.value == 0) {
                return _buildCompanyTable();
              } else {
                return _buildPincodeTable();
              }
            }),
          ),
        ]));
  }

  /// Dummy company table
  // Widget _buildCompanyTable() {
  //   return Obx(() {
  //     final list = pincodeController.companyList;

  //     return SingleChildScrollView(
  //       //  controller: companyScrollController,
  //       scrollDirection: Axis.vertical,
  //       child: Column(
  //         children: [
  //           const SizedBox(height: 8),
  //           DataTable(
  //             columnSpacing: 32,
  //             headingRowHeight: 50,
  //             dataRowHeight: 70,
  //             headingRowColor: MaterialStateProperty.all(
  //                 AppColors.greyColor.withOpacity(0.9)),
  //             columns: const [
  //               //  DataColumn(label: Text('DSA Name')),
  //               DataColumn(
  //                   columnWidth: IntrinsicColumnWidth(),
  //                   label: Text(
  //                     'Bank',
  //                     style: TextStyle(color: AppColors.primaryColor),
  //                   )),
  //               DataColumn(
  //                   columnWidth: IntrinsicColumnWidth(),
  //                   label: Text('Company Category',
  //                       style: TextStyle(color: AppColors.primaryColor))),
  //               DataColumn(
  //                   columnWidth: IntrinsicColumnWidth(),
  //                   label: Text('Category',
  //                       style: TextStyle(color: AppColors.primaryColor))),
  //             ],
  //             rows: list
  //                 .map((pin) => DataRow(cells: [
  //                       // DataCell(Text(
  //                       //   pin.dsaName.toString(),
  //                       //   style: const TextStyle(color: Colors.black),
  //                       // )),
  //                       DataCell(Text(
  //                         pin.bankName.toString(),
  //                         style: const TextStyle(color: Colors.black),
  //                       )),
  //                       DataCell(Text(
  //                         pin.companyName.toString(),
  //                         style: const TextStyle(color: Colors.black),
  //                       )),
  //                       DataCell(Text(pin.category.toString(),
  //                           style: const TextStyle(color: Colors.black))),
  //                     ]))
  //                 .toList(),
  //           ),
  //           if (pincodeController.iscompanyLoading.value)
  //             const Padding(
  //               padding: EdgeInsets.all(16.0),
  //               child: CircularProgressIndicator(),
  //             ),
  //         ],
  //       ),
  //     );
  //   });
  // }

  Widget _buildCompanyTable() {
    return Obx(() {
      final list = pincodeController.companyList;
      final loading = pincodeController.iscompanyLoading.value;

      if (loading && list.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      return ListView.builder(
          padding: const EdgeInsets.all(10),
          controller: companyScrollController,
          itemCount: list.length + 1,
          itemBuilder: (_, index) {
            if (index == list.length) {
              return pincodeController.iscompanyLoading.value
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : const SizedBox();
            }

            final data = list[index];
            return CommonTitleCard(
                leading: SvgPicture.asset(
                  'assets/images/bank.svg',
                  color: themeController.primaryColor.value,
                ),
                title: data.bankName.toString(),
                subtitle: data.companyName.toString(),
                amount: data.category.toString(),
                onExpansionChanged: null,
                children: const []);
          });
    });
  }

  /// Dynamic Pin Code Table
  Widget _buildPincodeTable() {
    return Obx(() {
      final list = pincodeController.pincodes;
      final loading = pincodeController.isLoading.value;

      if (loading && list.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      return ListView.builder(
          padding: const EdgeInsets.all(10),
          controller: scrollController,
          itemCount: list.length + 1,
          itemBuilder: (_, i) {
            if (i == list.length) {
              return pincodeController.isLoading.value
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : const SizedBox();
            }

            final data = list[i];

            return CommonTitleCard(
                leading: SvgPicture.asset(
                  'assets/images/bank.svg',
                  color: themeController.primaryColor.value,
                ),
                title: data.bankName.toString(),
                subtitle: data.city.toString(),
                amount: data.pincode.toString(),
                children: const []);
          });
    });

    // SingleChildScrollView(
    //   //     controller: scrollController,
    //   scrollDirection: Axis.vertical,
    //   child: Column(
    //     children: [
    //       const SizedBox(height: 8),
    //       DataTable(
    //         columnSpacing: 32,
    //         headingRowHeight: 50,
    //         dataRowHeight: 50,
    //         headingTextStyle: const TextStyle(
    //             color: AppColors.primaryColor, fontWeight: FontWeight.bold),
    //         headingRowColor: MaterialStateProperty.all(
    //             AppColors.greyColor.withOpacity(0.9)),
    //         columns: const [
    //           //    DataColumn(label: Text('DSA Name')),
    //           DataColumn(
    //               columnWidth: IntrinsicColumnWidth(), label: Text('Bank')),
    //           DataColumn(
    //               columnWidth: IntrinsicColumnWidth(),
    //               label: Text('Pincode')),
    //           DataColumn(
    //               columnWidth: IntrinsicColumnWidth(), label: Text('City')),
    //         ],
    //         rows: list
    //             .map((pin) => DataRow(cells: [
    //                   // DataCell(Text(
    //                   //   pin.dsaName.toString(),
    //                   //   style: const TextStyle(color: Colors.black),
    //                   // )),
    //                   DataCell(Text(
    //                     pin.bankName.toString(),
    //                     style: const TextStyle(color: Colors.black),
    //                   )),
    //                   DataCell(Text(
    //                     pin.pincode.toString(),
    //                     style: const TextStyle(color: Colors.black),
    //                   )),
    //                   DataCell(Text(pin.city.toString(),
    //                       style: const TextStyle(color: Colors.black))),
    //                 ]))
    //             .toList(),
    //       ),
    //       if (pincodeController.isLoading.value)
    //         const Padding(
    //           padding: EdgeInsets.all(16.0),
    //           child: LoadingPage(),
    //         ),
    //     ],
    //   ),
    // );
  }
}
