import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/controllers/admin/admin_disbursement.dart';
import 'package:smart_solutions/controllers/dailer_controller.dart';
import 'package:smart_solutions/theme/app_theme.dart';
import 'package:smart_solutions/utils/currency_util.dart';
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

class AdminDisbursement extends StatefulWidget {
  final String title;
  const AdminDisbursement({super.key, required this.title});

  @override
  State<AdminDisbursement> createState() => _AdminDisbursementState();
}

class _AdminDisbursementState extends State<AdminDisbursement> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController searchController = TextEditingController();

  final _adminDisbursementController = Get.put(DisbursementController());
  final _diallerController = Get.find<DialerController>();
  final CommonRows _commonRows = CommonRows();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _adminDisbursementController.getteamLeaderData();
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
        isDrawer: false,
        showBack: true,
        title: widget.title,
        key: _scaffoldKey,
        body: Obx(
          () => _adminDisbursementController.iscallDisbursedLoading.value
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
                                  controller: _adminDisbursementController
                                      .searchController,
                                  onClear: () {
                                    _adminDisbursementController.clearFilters();
                                    //      _adminDisbursementController.updateFilteredList();
                                  },
                                  onChanged: (value) {
                                    //     _adminDisbursementController.updateFilteredList();
                                  }),
                              kVerticalSpace(5),
                              Obx(() {
                                final filterList =
                                    _adminDisbursementController.filters;

                                return FilterChipList(
                                  filters: filterList,
                                  controller: _adminDisbursementController
                                      .filterScrollController,
                                  selectedIndex: _adminDisbursementController
                                      .selectedFilter.value,
                                  onSelected:
                                      _adminDisbursementController.selectFilter,
                                );
                              }),
                              kVerticalSpace(10),
                              Obx(() {
                                final data = _adminDisbursementController
                                    .disbursementTotal;
                                return SummaryHeaderCard(
                                  title: 'Total',
                                  duration:
                                      'Login Files -${data.first.loginCountTotal}',
                                  rows: [
                                    Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            color: AppColors.appBarTextColor,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Column(
                                          children: [
                                            Text(
                                                '₹${CurrencyUtils.formatAmount(data.first.amountTotal.toString())}'),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                // TODAY
                                                RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      const TextSpan(
                                                        text:
                                                            'Disbursed File - ',
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: data.first
                                                            .disbursedCountTotal
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
                              itemCount: _adminDisbursementController
                                  .disbursementList.length,
                              itemBuilder: (context, index) {
                                final data = _adminDisbursementController
                                    .disbursementList[index];

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 4),
                                  child: SummaryCard(
                                    title: data.name.toString(),
                                    duration:
                                        'Login Files - ${data.loginCount}',
                                    rows: [
                                      Container(
                                          decoration: BoxDecoration(
                                              color: AppColors.appBarTextColor,
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                '₹${CurrencyUtils.formatAmount(data.amount)}',
                                                style: AppTextStyle
                                                    .blueHeaderTitletStyle
                                                    .copyWith(fontSize: 12),
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  // TODAY
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        const TextSpan(
                                                          text:
                                                              'Disbursed Files - ',
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: data
                                                              .disbursedCount,
                                                          style:
                                                              const TextStyle(
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
