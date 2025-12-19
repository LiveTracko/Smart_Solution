import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:smart_solutions/controllers/admin/call_log_controller.dart';
import 'package:smart_solutions/controllers/dailer_controller.dart';
import 'package:smart_solutions/controllers/login_request_controller.dart';
import 'package:smart_solutions/theme/app_theme.dart';
import 'package:smart_solutions/views/spacing_constants.dart';
import 'package:smart_solutions/widget/common_rows_card.dart';
import 'package:smart_solutions/widget/common_scaffold.dart';
import 'package:smart_solutions/widget/flutter_chiplist.dart';
import 'package:smart_solutions/widget/header_title.dart';
import 'package:smart_solutions/widget/loading_page.dart';
import 'package:smart_solutions/widget/searchbarwithclear.dart';
import 'package:smart_solutions/widget/summary_card.dart';
import 'package:smart_solutions/widget/summary_header_card.dart';
import 'package:smart_solutions/widget/text_style.dart';

class AdminCallLog extends StatefulWidget {
  final String title;
  const AdminCallLog({super.key, required this.title});

  @override
  State<AdminCallLog> createState() => _AdminCallLogState();
}

class _AdminCallLogState extends State<AdminCallLog> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController searchController = TextEditingController();

  final _adminCallLogController = Get.put(AdminCallLogController());

  final _diallerController = Get.find<DialerController>();

  final CommonRows _commonRows = CommonRows();

  final ScrollController _scrollController = ScrollController();



  @override
  void initState() {
    super.initState();
    _adminCallLogController.getteamLeaderData();
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
        isDrawer: false,
        showBack: true,
        title: 'Call Log',
        key: _scaffoldKey,
        body: Obx(
          () => _adminCallLogController.iscallLogLoading.value
              ? const LoadingPage()
              : Column(
                  children: [
                    Container(
                        color: AppColors.appBarTextColor,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              HeaderTitle(
                                  title: widget.title,
                                  style: AppTextStyle.headerTitle),
                              SearchBarWithClear(
                                  controller:
                                      _adminCallLogController.searchController,
                                  onClear: () {
                                    _adminCallLogController.clearFilters();
                                    //      _adminCallLogController.updateFilteredList();
                                  },
                                  onChanged: (value) {
                                    //     _adminCallLogController.updateFilteredList();
                                  }),
                              kVerticalSpace(5),
                              Obx(() {
                                final filterList =
                                    _adminCallLogController.filters;

                                return FilterChipList(
                                  filters: filterList,
                                  controller: _adminCallLogController
                                      .filterScrollController,
                                  selectedIndex: _adminCallLogController
                                      .selectedFilter.value,
                                  onSelected:
                                      _adminCallLogController.selectFilter,
                                );
                              }),
                              kVerticalSpace(10),
                              // Obx(() {
                              //   final data =
                              //       _adminCallLogController.callLogData[0];
                              //   return SummaryHeaderCard(
                              //     title: data.name,
                              //     duration: data.totalCallTime,
                              //     rows: [
                              //       Container(
                              //         padding: const EdgeInsets.all(5),
                              //         decoration: BoxDecoration(
                              //             color: AppColors.appBarTextColor,
                              //             borderRadius:
                              //                 BorderRadius.circular(15)),
                              //         child: Row(
                              //           children: [
                              //             const Icon(Icons.call,
                              //                 size: 16, color: Colors.blue),
                              //             const SizedBox(width: 4),
                              //             Text(data.callAttempt),
                              //             const SizedBox(width: 12),
                              //             const Icon(Icons.check_circle,
                              //                 size: 16, color: Colors.green),
                              //             const SizedBox(width: 4),
                              //             Text(data.callContacted),
                              //             const SizedBox(width: 12),
                              //             const Icon(Icons.cancel,
                              //                 size: 16, color: Colors.red),
                              //             const SizedBox(width: 4),
                              //             Text(data.callNotcontact),
                              //           ],
                              //         ),
                              //       )
                              //     ],
                              //   );
                              // }),
                            ])),
                    Expanded(
                      child: Obx(
                        () => Padding(
                          padding: EdgeInsets.only(top: 4.h),
                          child: ListView.builder(
                              itemCount:
                                  _adminCallLogController.callLogData.length -
                                      1,
                              itemBuilder: (context, index) {
                                final data = _adminCallLogController
                                    .callLogData[index + 1];

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 4),
                                  child: SummaryCard(
                                    title: data.name.toString(),
                                    duration: data.totalCallTime,
                                    rows: [
                                      Row(
                                        children: [
                                          const Icon(Icons.call,
                                              size: 16, color: Colors.blue),
                                          const SizedBox(width: 4),
                                          Text(data.callAttempt),
                                          const SizedBox(width: 10),
                                          const Icon(Icons.check_circle,
                                              size: 16, color: Colors.green),
                                          const SizedBox(width: 4),
                                          Text(data.callContacted),
                                          const SizedBox(width: 10),
                                          const Icon(Icons.cancel,
                                              size: 16, color: Colors.red),
                                          const SizedBox(width: 4),
                                          Text(data.callNotcontact),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ),
                      ),
                    ),
                  ],
                ),
        ));
  }

  String maskFirst6Digits(String number) {
    if (number.length < 6) return number; // Handle edge case
    return 'xxxxxx${number.substring(6)}';
  }
}
