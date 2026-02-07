import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/controllers/admin/call_back_controller.dart';
import 'package:smart_solutions/controllers/data_entry_controller.dart';
import 'package:smart_solutions/controllers/login_request_controller.dart';
import 'package:smart_solutions/theme/app_theme.dart';
import 'package:smart_solutions/views/spacing_constants.dart';
import 'package:smart_solutions/widget/common_scaffold.dart';
import 'package:smart_solutions/widget/flutter_chiplist.dart';
import 'package:smart_solutions/widget/header_title.dart';
import 'package:smart_solutions/widget/loading_page.dart';
import 'package:smart_solutions/widget/searchbarwithclear.dart';
import 'package:smart_solutions/widget/summary_card.dart';
import 'package:smart_solutions/widget/summary_header_card.dart';
import 'package:smart_solutions/widget/text_style.dart';

class DailyMonthlyCount extends StatefulWidget {
  final String title;
  const DailyMonthlyCount({super.key, required this.title});

  @override
  State<DailyMonthlyCount> createState() => _DailyMonthlyCountState();
}

class _DailyMonthlyCountState extends State<DailyMonthlyCount> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _adminCallBackController = Get.put(AdminCallBackController());
  final _loginRequestController = Get.find<LoginRequestController>();
  final _dataController = Get.find<DataController>();

  @override
  void initState() {
    super.initState();

    if (widget.title == 'Login Request') {
      _adminCallBackController.getLoginRequestTeamLeaderData();
    } else {
      _adminCallBackController.getteamLeaderData();
    }

    _adminCallBackController.getCallBackData();
    _dataController.fetchDataEntryList();
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      isDrawer: false,
      showBack: true,
      title: widget.title,
      key: _scaffoldKey,
      body: widget.title == 'Login Request'
          ? _buildLoginRequestScreen()
          : _buildDataEntryScreen(),
    );
  }

  Widget _buildLoginRequestScreen() {
    return Column(
      children: [
        // HEADER SECTION
        Container(
          color: AppColors.appBarTextColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderTitle(
                title: widget.title,
                style: AppTextStyle.headerTitle,
              ),

              SearchBarWithClear(
                controller: _adminCallBackController.searchController,
                onClear: _adminCallBackController.clearFilters,
                onChanged: (value) {},
              ),

              kVerticalSpace(5),

              // FILTER CHIPS
              _buildFilterChips(),

              kVerticalSpace(10),

              // TOTAL SUMMARY
              _buildLoginRequestTotalSummary(),
            ],
          ),
        ),

        // LIST SECTION
        Expanded(
          child: _buildLoginRequestList(),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return Obx(() {
      final filterList = _adminCallBackController.filters;

      if (filterList.isEmpty) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Center(
            child: Text(
              'Loading filters...',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        );
      }

      return Container(
        height: 50.h,
        child: FilterChipList(
          filters: filterList,
          controller: _adminCallBackController.filterScrollController,
          selectedIndex: _adminCallBackController.selectedFilter.value,
          onSelected: _adminCallBackController.selectFilter,
        ),
      );
    });
  }

  Widget _buildLoginRequestTotalSummary() {
    return Obx(() {
      final totals = _adminCallBackController.getLoginRequestTotals();

      return SummaryHeaderCard(
        title: 'Total',
        duration: '',
        rows: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: AppColors.appBarTextColor,
              borderRadius: BorderRadius.circular(15),
            ),
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
                        text: totals['today'].toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
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
                        text: totals['monthly'].toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildLoginRequestList() {
    return Obx(() {
      // Show loading if either team leaders or data is loading
      if (_adminCallBackController.isLoginRequestTeamLeaderLoading.value ||
          _adminCallBackController.isLoginRequestDataLoading.value) {
        return const LoadingPage();
      }

      final data = _adminCallBackController.filteredLoginRequestData;

      if (data.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'No Telecallers Available',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        );
      }

      return Padding(
        padding: EdgeInsets.only(top: 4.h),
        child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: SummaryCard(
                title: item['name'] ?? 'Unknown',
                duration: '',
                rows: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.appBarTextColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
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
                                text: item['todaycount'] ?? '0',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
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
                                text: item['monthlycount'] ?? '0',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildDataEntryScreen() {
    return Obx(() {
      if (_adminCallBackController.isCallBackLoading.value) {
        return const LoadingPage();
      }

      return Column(
        children: [
          Container(
            color: AppColors.appBarTextColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderTitle(
                  title: widget.title,
                  style: AppTextStyle.headerTitle,
                ),

                SearchBarWithClear(
                  controller: _adminCallBackController.searchController,
                  onClear: _adminCallBackController.clearFilters,
                  onChanged: (value) {},
                ),

                kVerticalSpace(5),

                // FILTER CHIPS
                Obx(() {
                  final filterList = _adminCallBackController.filters;

                  if (filterList.isEmpty) {
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Center(
                        child: Text(
                          'Loading filters...',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  }

                  return Container(
                    height: 50.h,
                    child: FilterChipList(
                      filters: filterList,
                      controller:
                          _adminCallBackController.filterScrollController,
                      selectedIndex:
                          _adminCallBackController.selectedFilter.value,
                      onSelected: _adminCallBackController.selectFilter,
                    ),
                  );
                }),

                kVerticalSpace(10),

                // TOTAL SUMMARY
                _buildDataEntryTotalSummary(),
              ],
            ),
          ),

          // LIST SECTION
          Expanded(
            child: _buildDataEntryList(),
          ),
        ],
      );
    });
  }

  Widget _buildDataEntryTotalSummary() {
    return SummaryHeaderCard(
      title: 'Total',
      duration: '',
      rows: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: AppColors.appBarTextColor,
            borderRadius: BorderRadius.circular(15),
          ),
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
                      text: _dataController.todayCount.length.toString(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
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
                      text: _dataController.monthlyCount.length.toString(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDataEntryList() {
    return Obx(() {
      final data = _adminCallBackController.callBackData;

      if (data.isEmpty) {
        return Center(
          child: Text(
            'No data available',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16.sp,
            ),
          ),
        );
      }

      return Padding(
        padding: EdgeInsets.only(top: 4.h),
        child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];

            String todayCount = _dataController.todayCount
                .where((id) => id.toString() == item.id.toString())
                .length
                .toString();

            String monthlyCount = _dataController.monthlyCount
                .where((id) => id.toString() == item.id.toString())
                .length
                .toString();

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: SummaryCard(
                title: item.name.toString(),
                duration: '',
                rows: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.appBarTextColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
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
                                text: todayCount,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
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
                                text: monthlyCount,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
