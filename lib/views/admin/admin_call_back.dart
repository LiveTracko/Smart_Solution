import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:smart_solutions/controllers/admin/call_back_controller.dart';
import 'package:smart_solutions/controllers/dailer_controller.dart';
import 'package:smart_solutions/theme/app_theme.dart';
import 'package:smart_solutions/views/spacing_constants.dart';
import 'package:smart_solutions/widget/common_rows_card.dart';
import 'package:smart_solutions/widget/common_scaffold.dart';
import 'package:smart_solutions/widget/flutter_chiplist.dart';
import 'package:smart_solutions/widget/header_title.dart';
import 'package:smart_solutions/widget/loading_page.dart';
import 'package:smart_solutions/widget/searchbarwithclear.dart';
import 'package:smart_solutions/widget/summary_card.dart' show SummaryCard;
import 'package:smart_solutions/widget/summary_header_card.dart';
import 'package:smart_solutions/widget/text_style.dart';

class AdminCallBack extends StatefulWidget {
  final String title;
  const AdminCallBack({super.key, required this.title});

  @override
  State<AdminCallBack> createState() => _AdminCallBackState();
}

class _AdminCallBackState extends State<AdminCallBack> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController searchController = TextEditingController();

  final _AdminCallBackController = Get.put(AdminCallBackController());
  final _diallerController = Get.find<DialerController>();
  final CommonRows _commonRows = CommonRows();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _AdminCallBackController.getteamLeaderData();
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
        isDrawer: false,
        showBack: true,
        title: widget.title,
        key: _scaffoldKey,
        body: Obx(
          () => _AdminCallBackController.isCallBackLoading.value
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
                                      _AdminCallBackController.searchController,
                                  onClear: () {
                                    _AdminCallBackController.clearFilters();
                                    //      _AdminCallBackController.updateFilteredList();
                                  },
                                  onChanged: (value) {
                                    //     _AdminCallBackController.updateFilteredList();
                                  }),
                              kVerticalSpace(5),
                              Obx(() {
                                final filterList =
                                    _AdminCallBackController.filters;

                                return FilterChipList(
                                  filters: filterList,
                                  controller: _AdminCallBackController
                                      .filterScrollController,
                                  selectedIndex: _AdminCallBackController
                                      .selectedFilter.value,
                                  onSelected:
                                      _AdminCallBackController.selectFilter,
                                );
                              }),
                              kVerticalSpace(10),
                              Obx(() {
                                final data =
                                    _AdminCallBackController.callBackTotalData;
                                return SummaryHeaderCard(
                                  title: 'Total',
                                  duration: '',
                                  rows: [
                                    Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            color: AppColors.appBarTextColor,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // TODAY
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  const TextSpan(
                                                    text: 'Today - ',
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: data.first
                                                        .todayCallbackTotal
                                                        .toString(),
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            const SizedBox(
                                              height: 20,
                                              child: VerticalDivider(
                                                color: Colors.grey,
                                                thickness: 1,
                                              ),
                                            ),

                                            // MONTHLY
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  const TextSpan(
                                                    text: 'Monthly - ',
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: data.first
                                                        .monthlyCallbackTotal
                                                        .toString(),
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ))
                                  ],
                                );
                              }),
                            ])),
                    Expanded(
                      child: Obx(
                        () => Padding(
                          padding: EdgeInsets.only(top: 4.h),
                          child: ListView.builder(
                              itemCount:
                                  _AdminCallBackController.callBackData.length,
                              itemBuilder: (context, index) {
                                final data = _AdminCallBackController
                                    .callBackData[index];

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  child: SummaryCard(
                                    title: data.name.toString(),
                                    duration: '',
                                    rows: [
                                      Container(
                                          decoration: BoxDecoration(
                                              color: AppColors.appBarTextColor,
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              // TODAY
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    const TextSpan(
                                                      text: 'Today - ',
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: data
                                                          .todayCallbackCount,
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              const SizedBox(
                                                height: 20,
                                                child: VerticalDivider(
                                                  color: Colors.grey,
                                                  thickness: 1,
                                                ),
                                              ),

                                              // MONTHLY
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    const TextSpan(
                                                      text: 'Monthly - ',
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: data
                                                          .monthlyCallbackCount,
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ))
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
