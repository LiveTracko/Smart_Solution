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

class AdminCallLog extends StatefulWidget {
  final String title;
  const AdminCallLog({super.key, required this.title});

  @override
  State<AdminCallLog> createState() => _AdminCallLogState();
}

class _AdminCallLogState extends State<AdminCallLog> {
  final _controller = Get.put(AdminCallLogController());

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
      body: Obx(() {
        if (_controller.isCallLogLoading.value) {
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
                    controller: _controller.searchController,
                    onClear: _controller.clearFilters,
                    onChanged: (_) {},
                  ),
                  kVerticalSpace(5),

                  // -------- FILTER CHIPS --------
                  Obx(() => FilterChipList(
                        filters: _controller.filters,
                        controller: _controller.filterScrollController,
                        selectedIndex: _controller.selectedFilter.value,
                        onSelected: _controller.selectFilter,
                      )),

                  kVerticalSpace(10),

                  // -------- HEADER CARD --------
                  Obx(() {
                    if (_controller.callLogData.isEmpty) {
                      return const SizedBox();
                    }

                    final data = _controller.callLogData.first;

                    return SummaryHeaderCard(
                      title: data.name,
                      duration: data.totalCallTime,
                      rows: [
                        Row(
                          children: [
                            const Icon(Icons.call,
                                size: 16, color: Colors.blue),
                            const SizedBox(width: 4),
                            Text(data.callAttempt),
                            const SizedBox(width: 12),
                            const Icon(Icons.check_circle,
                                size: 16, color: Colors.green),
                            const SizedBox(width: 4),
                            Text(data.callContacted),
                            const SizedBox(width: 12),
                            const Icon(Icons.cancel,
                                size: 16, color: Colors.red),
                            const SizedBox(width: 4),
                            Text(data.callNotcontact),
                          ],
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),

            // -------- LIST --------
            Expanded(
              child: Obx(() => ListView.builder(
                    padding: EdgeInsets.only(top: 4.h),
                    itemCount: _controller.callLogData.length > 1
                        ? _controller.callLogData.length - 1
                        : 0,
                    itemBuilder: (context, index) {
                      final data = _controller.callLogData[index + 1];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 4),
                        child: SummaryCard(
                          title: data.name,
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
                    },
                  )),
            ),
          ],
        );
      }),
    );
  }
}
