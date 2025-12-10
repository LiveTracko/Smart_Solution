import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_solutions/controllers/dailer_controller.dart';
import 'package:smart_solutions/controllers/follow_form.dart';
import 'package:smart_solutions/theme/app_theme.dart';
import 'package:smart_solutions/views/spacing_constants.dart';
import 'package:smart_solutions/widget/common_rows_card.dart';
import 'package:smart_solutions/widget/common_scaffold.dart';
import 'package:smart_solutions/widget/common_title_card.dart';
import 'package:smart_solutions/widget/flutter_chiplist.dart';
import 'package:smart_solutions/widget/header_title.dart';
import 'package:smart_solutions/widget/loading_page.dart';
import 'package:smart_solutions/widget/searchbarwithclear.dart';
import 'package:smart_solutions/widget/text_style.dart';

class CallLogPage extends StatefulWidget {
  final String title;
  final bool isRefresh;
  const CallLogPage({super.key, this.isRefresh = true, required this.title});

  @override
  State<CallLogPage> createState() => _CallLogPageState();
}

class _CallLogPageState extends State<CallLogPage> {
  String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';

    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd-MM-yyyy').format(date);
    } catch (e) {
      return dateString; // if parsing fails, show original
    }
  }

  final _followBackController = Get.find<FollowBackFormController>();
  final _diallerController = Get.find<DialerController>();
  final CommonRows _commonRows = CommonRows();

  final ScrollController _scrollController = ScrollController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _followBackController.updateFilteredList();
    });

    // Add scroll listener for pagination
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      _followBackController.loadMore();
    }
  }

  @override
  void dispose() {
    _followBackController.clearFilters();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      isDrawer: true,
      showBack: false,
      title: 'Call Log',
      key: _scaffoldKey,
      body: Column(
        children: [
          Container(
              color: AppColors.appBarTextColor,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderTitle(
                        title: widget.title, style: AppTextStyle.headerTitle),
                    SearchBarWithClear(
                        controller: _followBackController.searchController,
                        onClear: () {
                          _followBackController.clearFilters();
                          _followBackController.updateFilteredList();
                        },
                        onChanged: (value) {
                          _followBackController.updateFilteredList();
                        }),
                    kVerticalSpace(10),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now(),
                              );

                              if (picked != null) {
                                _followBackController.startDate.value = picked;
                                _followBackController.updateFilteredList();
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              child: Obx(() => Text(
                                    _followBackController.startDate.value ==
                                            null
                                        ? "Start Date"
                                        : DateFormat("dd-MM-yyyy").format(
                                            _followBackController
                                                .startDate.value!),
                                    style: const TextStyle(fontSize: 14),
                                  )),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now(),
                              );

                              if (picked != null) {
                                _followBackController.endDate.value = picked;
                                _followBackController.updateFilteredList();
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              child: Obx(() => Text(
                                    _followBackController.endDate.value == null
                                        ? "End Date"
                                        : DateFormat("dd-MM-yyyy").format(
                                            _followBackController
                                                .endDate.value!),
                                    style: const TextStyle(fontSize: 14),
                                  )),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _followBackController.startDate.value = null;
                            _followBackController.endDate.value = null;
                            _followBackController.updateFilteredList();
                          },
                          icon: const Icon(Icons.clear, color: Colors.white),
                        )
                      ],
                    ),
                    kVerticalSpace(10),
                    Obx(() {
                      final filterList = _followBackController.filters;

                      return FilterChipList(
                        filters: filterList,
                        controller:
                            _followBackController.filterScrollController,
                        selectedIndex:
                            _followBackController.selectedFilter.value,
                        onSelected: _followBackController.selectFilter,
                      );
                    }),
                    kVerticalSpace(10),
                  ])),
          Expanded(child: Obx(() {
            if (_followBackController.isInitialLoading.value) {
              return const Center(child: LoadingPage());
            }
            if (_followBackController.filteredFollowBackList.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.no_sim, size: 50, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No data entries available',
                        style: TextStyle(fontSize: 16, color: Colors.grey)),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () => _followBackController.fetchFollowBackList(),
              child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(10),
                  itemCount:
                      _followBackController.filteredFollowBackList.length +
                          (_followBackController.hasMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index ==
                        _followBackController.filteredFollowBackList.length) {
                      return _followBackController.isMoreLoading.value
                          ? const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : const SizedBox.shrink();
                    }
                    var data =
                        _followBackController.filteredFollowBackList[index];

                    return CommonTitleCard(
                      leading: SvgPicture.asset('assets/images/phone_call.svg'),
                      onLeadingTap: () {
                        _diallerController.makePhoneCall(
                            data.contactNumber ?? '',
                            followUpId: data.id ?? '');
                        _followBackController.mobile.value =
                            data.contactNumber ?? "";
                        _followBackController.bankName.value =
                            data.bankName ?? "";
                        _followBackController.customerName.value =
                            data.customerName ?? "";
                        _diallerController.customerName.value =
                            data.customerName ?? '';
                        _diallerController.datatype.value = '';
                        _followBackController.remark.value = data.remark ?? '';
                        _diallerController.followup_id.value = data.id ?? '';
                        _diallerController.excel_id.value = '';
                      },
                      title: data.customerName ?? '',
                      subtitle: formatDate(data.entryDate),
                      status: data.remarkStatus ?? '',
                      statusColor: data.contactStatus == '1'
                          ? Colors.green.shade400
                          : Colors.redAccent.shade200,
                      amount: data.bankName.toString(),
                      //     showEdit: StaticStoredData.roleName != 'telecaller',
                      // onEdit: () {
                      //   dataController.editLoadData();
                      //   Get.to(DataEntryForm(
                      //     id: data.id,
                      //     tellecallerId: data.teleCallerId,
                      //     dsaId: data.dsaName,
                      //     bankerId: data.bankerId,
                      //   ));
                      // },
                      children: [
                        _commonRows.buildDoubleRow(
                          iconLeft: 'assets/images/call.svg',
                          valueLeft: maskFirst6Digits(data.contactNumber ?? ''),
                          iconRight: 'assets/images/clock.svg',
                          valueRight: data.callDuration ?? '',
                        ),
                        _commonRows.buildSingleRow(
                            'assets/images/message_dots_circle.svg',
                            data.remark ?? 'NA'),
                      ],
                    );
                  }),
            );
          }))
        ],
      ),
    );
  }

  String maskFirst6Digits(String number) {
    if (number.length < 6) return number; // Handle edge case
    return 'xxxxxx${number.substring(6)}';
  }
}
