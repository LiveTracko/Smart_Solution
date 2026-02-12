import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/controllers/admin/call_back_controller.dart';
import 'package:smart_solutions/theme/app_theme.dart';
import 'package:smart_solutions/views/spacing_constants.dart';
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

  final _adminCallBackController = Get.put(AdminCallBackController());

  @override
  void initState() {
    super.initState();
    _adminCallBackController.getteamLeaderData();
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
        isDrawer: false,
        showBack: true,
        title: widget.title,
        key: _scaffoldKey,
        body: Obx(
          () => _adminCallBackController.isCallBackLoading.value
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
                                      _adminCallBackController.searchController,
                                  onClear: () {
                                    _adminCallBackController.clearFilters();
                                    //      _adminCallBackController.updateFilteredList();
                                  },
                                  onChanged: (value) {
                                    //     _adminCallBackController.updateFilteredList();
                                  }),
                              kVerticalSpace(5),
                              Obx(() {
                                final filterList =
                                    _adminCallBackController.filters;

                                return FilterChipList(
                                  filters: filterList,
                                  controller: _adminCallBackController
                                      .filterScrollController,
                                  selectedIndex: _adminCallBackController
                                      .selectedFilter.value,
                                  onSelected:
                                      _adminCallBackController.selectFilter,
                                );
                              }),
                              kVerticalSpace(10),
                              Obx(() {
                                final data =
                                    _adminCallBackController.callBackTotalData;

                                    
                                return SummaryHeaderCard(
                                  title: 0,
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
                              itemCount: _adminCallBackController
                                  .filteredLoginFilesData.length,
                              itemBuilder: (context, index) {
                                final data = _adminCallBackController
                                    .filteredLoginFilesData[index];

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  child: SummaryCard(
                                    imageUrl: data.profileImage.toString(),
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
                                                      text: data.todaycount,
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
                                                      text: data.monthlycount,
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
