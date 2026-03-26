import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/controllers/admin/call_log_controller.dart';
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
import '../../constants/static_stored_data.dart';

class AdminCallLog extends StatefulWidget {
  final String title;
  const AdminCallLog({super.key, required this.title});

  @override
  State<AdminCallLog> createState() => _AdminCallLogState();
}

class _AdminCallLogState extends State<AdminCallLog> {
  final _controller = Get.put(AdminCallLogController());
  final bool isTeamLeader = StaticStoredData.roleName == 'teamleader';

  @override
  void initState() {
    super.initState();
    _controller.getTeamLeaders();
  }

  @override
  void dispose() {
    _controller.searchController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
        showBack: true,
        title: 'Call Log',
        body: Column(children: [
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
                  controller: _controller.searchController,
                  onClear: _controller.clearFilters,
                  onChanged: (_) {
                    _controller.filterCallLogs(
                        searchQuery: _controller.searchController.text);
                  },
                ),
                kVerticalSpace(5),

                // -------- FILTER CHIPS --------
                if (!isTeamLeader)
                  Obx(() => FilterChipList(
                        filters: _controller.filters,
                        controller: _controller.filterScrollController,
                        selectedIndex: _controller.selectedFilter.value,
                        onSelected: _controller.selectFilter,
                      )),

                kVerticalSpace(10),

                // -------- HEADER CARD --------
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (_controller.isCallLogLoading.value) {
                return const LoadingPage();
              }
              return Column(
                children: [
                  Obx(() {
                    // final data = _controller.callLogData.first;

                    // int total = (int.tryParse(data.callAttempt) ?? 0) +
                    //     (int.tryParse(data.callContacted) ?? 0) +
                    //     (int.tryParse(data.callNotcontact) ?? 0);

                    int attemptTotal = 0;
                    int contactedTotal = 0;
                    int notContactTotal = 0;
                    Duration totalDuration = Duration.zero;

                    for (var item in _controller.callLogData) {
                      attemptTotal += int.tryParse(item.callAttempt) ?? 0;
                      contactedTotal += int.tryParse(item.callContacted) ?? 0;
                      notContactTotal += int.tryParse(item.callNotcontact) ?? 0;

                      // Add duration
                      if (item.totalCallTime != null &&
                          item.totalCallTime.contains(':')) {
                        final parts = item.totalCallTime.split(':');

                        totalDuration += Duration(
                          hours: int.tryParse(parts[0]) ?? 0,
                          minutes: int.tryParse(parts[1]) ?? 0,
                          seconds: int.tryParse(parts[2]) ?? 0,
                        );
                      }
                    }

                    String twoDigits(int n) => n.toString().padLeft(2, '0');

                    String totalDurationString =
                        "${twoDigits(totalDuration.inHours)}:"
                        "${twoDigits(totalDuration.inMinutes.remainder(60))}:"
                        "${twoDigits(totalDuration.inSeconds.remainder(60))}";

                    int grandTotal =
                        attemptTotal + contactedTotal + notContactTotal;

                    return SummaryHeaderCard(
                      title: grandTotal,
                      duration: totalDurationString,
                      rows: [
                        Row(
                          children: [
                            const Icon(Icons.call,
                                size: 16, color: Colors.blue),
                            const SizedBox(width: 4),
                            Text(attemptTotal.toString()),
                            const SizedBox(width: 12),
                            const Icon(Icons.check_circle,
                                size: 16, color: Colors.green),
                            const SizedBox(width: 4),
                            Text(contactedTotal.toString()),
                            const SizedBox(width: 12),
                            const Icon(Icons.cancel,
                                size: 16, color: Colors.red),
                            const SizedBox(width: 4),
                            Text(notContactTotal.toString()),
                          ],
                        ),
                      ],
                    );
                  }),
                  Expanded(
                    child: Obx(() {
                      if (_controller.callLogData.isEmpty) {
                        return const Center(
                          child: Text("No call logs available"),
                        );
                      }
                      return RefreshIndicator(
                        onRefresh: () {
                          _controller.clearFilters();
                          return _controller.getCallLogData();
                        },
                        child: ListView.builder(
                            padding: EdgeInsets.only(top: 4.h),
                            itemCount: _controller.callLogData.length,
                            //  ? _controller.callLogData.length - 1
                            //  : 0,
                            itemBuilder: (context, index) {
                              final data = _controller.callLogData[index];

                              if (_controller.isCallLogLoading.value) {
                                return const LoadingPage();
                              }
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 4),
                                child: SummaryCard(
                                  imageUrl: data.profileImage.toString(),
                                  title: data.name,
                                  duration: data.totalCallTime,
                                  rows: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
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
                      );
                    }),
                  )
                ],
              );
            }),
          )
        ]));
  }
}
