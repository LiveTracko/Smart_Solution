import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/controllers/admin/admin_disbursement.dart';
import 'package:smart_solutions/theme/app_theme.dart';
import 'package:smart_solutions/utils/currency_util.dart';
import 'package:smart_solutions/views/spacing_constants.dart';
import 'package:smart_solutions/widget/common_scaffold.dart';
import 'package:smart_solutions/widget/flutter_chiplist.dart';
import 'package:smart_solutions/widget/header_title.dart';
import 'package:smart_solutions/widget/loading_page.dart';
import 'package:smart_solutions/widget/searchbarwithclear.dart';
import 'package:smart_solutions/widget/summary_card.dart' show SummaryCard;
import 'package:smart_solutions/widget/summary_header_card.dart';
import 'package:smart_solutions/widget/text_style.dart';

class AdminDisbursement extends StatefulWidget {
  final String title;
  const AdminDisbursement({super.key, required this.title});

  @override
  State<AdminDisbursement> createState() => _AdminDisbursementState();
}

class _AdminDisbursementState extends State<AdminDisbursement> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _adminDisbursementController = Get.put(DisbursementController());

  @override
  void initState() {
    super.initState();
    // Team leaders are loaded in controller's onInit()
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      isDrawer: false,
      showBack: true,
      title: widget.title,
      key: _scaffoldKey,
      body: Obx(() {
        // Show loading if either team leaders or disbursement data is loading
        if (_adminDisbursementController.isLoading.value ||
            _adminDisbursementController.iscallDisbursedLoading.value) {
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
                    controller: _adminDisbursementController.searchController,
                    onClear: _adminDisbursementController.clearFilters,
                    onChanged: (value) {
                      // Handle search if needed
                    },
                  ),

                  kVerticalSpace(5),

                  // FILTER CHIPS
                  _buildFilterChips(),

                  kVerticalSpace(10),

                  // TOTAL SUMMARY
                  _buildTotalSummary(),
                ],
              ),
            ),
            Expanded(
              child: _buildDisbursementList(),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildFilterChips() {
    return Obx(() {
      final filterList = _adminDisbursementController.filters;

      if (filterList.isEmpty) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Center(
            child: Text(
              'Loading team leaders...',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14.sp,
              ),
            ),
          ),
        );
      }

      return Container(
        height: 50.h,
        child: FilterChipList(
          filters: filterList,
          controller: _adminDisbursementController.filterScrollController,
          selectedIndex: _adminDisbursementController.selectedFilter.value,
          onSelected: _adminDisbursementController.selectFilter,
        ),
      );
    });
  }

  Widget _buildTotalSummary() {
    return Obx(() {
      final totalData = _adminDisbursementController.disbursementTotal.value;

      // If API not loaded yet
      if (totalData == null) {
        return const SizedBox.shrink();
      }

      final totalSum =
          totalData.loginCountTotal + totalData.disbursedCountTotal;

      return SummaryHeaderCard(
        title: 'Total',
        duration: 'Login Files - ${totalData.loginCountTotal}',
        rows: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: AppColors.appBarTextColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                // Total count
                Text(
                  totalSum.toString(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),

                // Amount
                Text(
                  '₹${CurrencyUtils.formatAmount(totalData.amountTotal.toString())}',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 5.h),

                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Disbursed Files - ',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      TextSpan(
                        text: totalData.disbursedCountTotal.toString(),
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

  Widget _buildDisbursementList() {
    return Obx(() {
      final data = _adminDisbursementController.disbursementList;

      if (data.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'No disbursement data available',
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
        padding: EdgeInsets.only(top: 4.h, bottom: 10.h),
        child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];

            // Calculate total for this item
            final itemTotal = (int.tryParse(item.loginCount) ?? 0) +
                (int.tryParse(item.disbursedCount) ?? 0);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              child: SummaryCard(
                title: item.name.toString(),
                duration: 'Total: $itemTotal',
                rows: [
                  Container(
                    padding: EdgeInsets.all(8.h),
                    decoration: BoxDecoration(
                      color: AppColors.appBarTextColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Amount
                        Text(
                          '₹${CurrencyUtils.formatAmount(item.amount)}',
                          style: AppTextStyle.blueHeaderTitletStyle.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.h),

                        // Login Files
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Login Files - ',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  TextSpan(
                                    text: item.loginCount,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 15.w),
                            // Disbursed Files
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Disbursed Files - ',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  TextSpan(
                                    text: item.disbursedCount,
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
