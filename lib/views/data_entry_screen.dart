import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_solutions/constants/static_stored_data.dart';
import 'package:smart_solutions/controllers/data_entry_controller.dart';
import 'package:smart_solutions/utils/currency_util.dart';
import 'package:smart_solutions/views/data_entry_form.dart';
import 'package:smart_solutions/widget/common_scaffold.dart';
import 'package:smart_solutions/widget/loading_page.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF356EFF);
  // Colors.blue;
  static const Color secondaryColor = Colors.grey;
  static const Color backgroundColor = Colors.white;
}

class DataEntryViewScreen extends StatelessWidget {
  DataEntryViewScreen({super.key});
  final DataController dataController = Get.put(DataController());

  String formatDate(String? dateStr) {
    if (dateStr == null) return 'N/A';
    try {
      final DateTime date = DateTime.parse(dateStr);
      return DateFormat('dd-MM-yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: 'Leads',
      showBack: false,
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: const Text('Leads'),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.refresh),
      //       onPressed: () => dataController.refreshData(),
      //     ),
      //   ],
      // ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Obx(
              () => Row(
                children: [
                  dataController.showSearchField.value
                      ? SizedBox(
                          width: 200.w,
                          child: TextField(
                            autofocus: true,
                            style: TextStyle(color: AppColors.primaryColor),
                            decoration: InputDecoration(
                              hintText: "Search...",
                              hintStyle: const TextStyle(
                                  color: AppColors.primaryColor),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onChanged: (value) {
                              dataController.searchText.value = value;
                              dataController.refreshData(); // filter live
                            },
                          ),
                        )
                      : Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                var results =
                                    await showCalendarDatePicker2Dialog(
                                  context: context,
                                  config:
                                      CalendarDatePicker2WithActionButtonsConfig(
                                          calendarType:
                                              CalendarDatePicker2Type.range),
                                  dialogSize: const Size(325, 400),
                                  value: dataController.dateRangeList,
                                  borderRadius: BorderRadius.circular(15),
                                );

                                if (results != null) {
                                  dataController.dateRangeList.value = results;
                                  dataController.refreshData();
                                  // controller.fetchFollowBackList();
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  border: Border.all(
                                    color: AppColors.primaryColor,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: const Text(
                                  'Date',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 12.w,
                            ),
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  border: Border.all(
                                    color: AppColors.primaryColor,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: SvgPicture.asset(
                                  'assets/images/filter.svg',
                                  height: 24,
                                  width: 24,
                                )),
                          ],
                        ),

                  const Spacer(),

                  Row(
                    children: [
                      Container(
                        height: 35.h,
                        padding: const EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundColor,

                          ///    color: AppColors.grid1.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextButton(
                            onPressed: () {
                              dataController.dateRangeList.clear();
                              dataController.refreshData();
                            },
                            child: const Text(
                              'Clear Filter',
                              style: TextStyle(color: AppColors.primaryColor),
                            )),
                      ),
                      Obx(() => IconButton(
                            icon: Icon(
                              dataController.showSearchField.value
                                  ? Icons.close
                                  : Icons.search,
                              color: AppColors.primaryColor,
                              size: 25,
                            ),
                            onPressed: dataController.toggleSearch,
                          )),
                    ],
                  )
                  // Container(
                  //   padding: EdgeInsets.all(5.0.w),
                  //   decoration: BoxDecoration(
                  //     color: AppColors.grid1.withOpacity(0.3),
                  //     borderRadius: BorderRadius.circular(25),
                  //   ),
                  //   child: Icon(
                  //     Icons.clear,
                  //     size: 20.sp,
                  //   ),
                  // ),
                  //  ),
                ],
              ),
            ),
          ), // Search Bar

          Expanded(
            child: Obx(() {
              if (dataController.isLoading.value) {
                return const Center(child: LoadingPage());
              } else if (dataController.dataList.isEmpty) {
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
              } else {
                return RefreshIndicator(
                  onRefresh: () => dataController.refreshData(),
                  child: ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: dataController.dataList.length,
                      itemBuilder: (context, index) {
                        var data = dataController.dataList[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: const Border(
                              left: BorderSide(
                                color: Color(0xFF356EFF), // Blue line
                                width: 3,
                              ),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(0.2), // Light shadow
                                offset: const Offset(0, 4), // Only downward
                                blurRadius: 8, // Softness
                                spreadRadius: 0, // No spread
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ExpansionTile(
                                minTileHeight: 60,
                                tilePadding: const EdgeInsets.symmetric(
                                    horizontal: 0.0, vertical: 0.0),
                                shape: const RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.transparent, width: 0),
                                ),
                                childrenPadding: EdgeInsets.zero,
                                expandedCrossAxisAlignment:
                                    CrossAxisAlignment.start,
                                initiallyExpanded: false,
                                leading: SvgPicture.asset(
                                    'assets/images/dialler.svg'),
                                title: Text(
                                  data.customerName.toString(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 15),
                                ),
                                subtitle: Text(
                                  data.loginBank.toString(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 12),
                                ),
                                trailing: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    StaticStoredData.roleName != 'telecaller' &&
                                            StaticStoredData.roleName !=
                                                'teamleader'
                                        ? GestureDetector(
                                            onTap: () {
                                              Get.to(DataEntryForm(
                                                id: data.id,
                                                tellecallerId:
                                                    data.teleCallerId,
                                                dsaId: data.dsaName,
                                                bankerId: data.bankerId,
                                              ));
                                            },
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8),
                                                child: SvgPicture.asset(
                                                    'assets/images/edit.svg')),
                                          )
                                        : const SizedBox.shrink(),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 25),
                                      child: Text(
                                        data.status.toString(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: data.status?.toLowerCase() ==
                                                  'active'
                                              ? Colors.green
                                              : Colors.redAccent.shade100,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsetsGeometry.only(
                                                  right: 5),
                                          child: Text(
                                            CurrencyUtils.formatIndianCurrency(
                                                data.loanAmount),
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                        ),
                                        const Icon(Icons.keyboard_arrow_down,
                                            size: 18, color: Colors.black),
                                      ],
                                    )
                                  ],
                                ),
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const SizedBox(height: 4),
                                      StaticStoredData.roleName != 'telecaller'
                                          ? _buildDoubleRow(
                                              iconLeft: Icons.headphones,
                                              valueLeft: data.tcName ?? '',
                                              iconRight: Icons.verified_user,
                                              valueRight: data.tlName ?? '')
                                          : const SizedBox.shrink(),
                                      const SizedBox(height: 4),
                                      _buildDoubleRow(
                                          iconLeft: Icons.phone,
                                          valueLeft: maskFirst6Digits(
                                              data.mobileNo ?? ''),
                                          iconRight: Icons.calendar_month,
                                          valueRight: DateFormat('dd-MM-yyyy')
                                              .format(DateTime.parse(
                                                  data.date.toString()))),
                                      _buildSingleRow(
                                          Icons.comment, data.comments ?? 'NA'),
                                      const SizedBox(height: 4),
                                    ],
                                  ),
                                ]),
                          ),
                        );
                      }),

                  // ListView.builder(
                  //   padding: const EdgeInsets.all(8.0),
                  //   itemCount: dataController.dataList.length,
                  //   itemBuilder: (context, index) {
                  //     var data = dataController.dataList[index];
                  //     return Card(
                  //       color: const Color.fromARGB(255, 227, 237, 248),
                  //       margin: const EdgeInsets.symmetric(
                  //         horizontal: 8.0,
                  //         vertical: 6.0,
                  //       ),
                  //       elevation: 2,
                  //       child: Padding(
                  //         padding: const EdgeInsets.all(5.0),
                  //         child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             // Row(
                  //             //   mainAxisAlignment:
                  //             //       MainAxisAlignment.spaceBetween,
                  //             //   children: [
                  //             //     Expanded(
                  //             //       child: Text(
                  //             //         data.customerName ?? 'N/A',
                  //             //         style: const TextStyle(
                  //             //           color: AppColors.textColor2,
                  //             //           fontWeight: FontWeight.bold,
                  //             //           fontSize: 16,
                  //             //         ),
                  //             //       ),
                  //             //     ),
                  //             //     Container(
                  //             //       padding: const EdgeInsets.symmetric(
                  //             //           horizontal: 8.0, vertical: 4.0),
                  //             //       decoration: BoxDecoration(
                  //             //         color: AppColors.grid2,
                  //             //         borderRadius: BorderRadius.circular(4),
                  //             //       ),
                  //             //       child: Text(
                  //             //         formatDate(data.date),
                  //             //         style: const TextStyle(
                  //             //           fontSize: 13,
                  //             //           color: AppColors.appBarColor,
                  //             //         ),
                  //             //       ),
                  //             //     ),
                  //             //   ],
                  //             // ),

                  //             ListTile(
                  //               dense: true,
                  //               visualDensity:
                  //                   const VisualDensity(vertical: -4),
                  //               contentPadding: const EdgeInsets.symmetric(
                  //                   horizontal: 10, vertical: 6),
                  //               tileColor: Colors.grey[100],
                  //               shape: RoundedRectangleBorder(
                  //                 borderRadius: BorderRadius.circular(6),
                  //               ),
                  //               title: Row(
                  //                 mainAxisAlignment:
                  //                     MainAxisAlignment.spaceBetween,
                  //                 children: [
                  //                   Text(
                  //                     data.customerName ?? 'N/A',
                  //                     style: const TextStyle(
                  //                       fontSize: 13,
                  //                       fontWeight: FontWeight.w600,
                  //                       color: AppColors.textColor2,
                  //                     ),
                  //                     overflow: TextOverflow.ellipsis,
                  //                   ),
                  //                   Container(
                  //                     padding: const EdgeInsets.symmetric(
                  //                         horizontal: 6, vertical: 2),
                  //                     decoration: BoxDecoration(
                  //                       color: AppColors.grid2,
                  //                       borderRadius: BorderRadius.circular(4),
                  //                     ),
                  //                     child: Text(
                  //                       formatDate(data.date),
                  //                       style: const TextStyle(
                  //                         fontSize: 11,
                  //                         color: AppColors.appBarColor,
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //               subtitle: Column(
                  //                 children: [
                  //                   const SizedBox(height: 4),
                  //                   _buildDoubleRow(
                  //                     iconLeft: Icons.phone,
                  //                     valueLeft: maskFirst6Digits(
                  //                             data.mobileNo ?? '') ??
                  //                         'N/A',
                  //                     iconRight: Icons.currency_exchange,
                  //                     valueRight:
                  //                         CurrencyUtils.formatIndianCurrency(
                  //                             data.loanAmount),
                  //                   ),
                  //                   _buildDoubleRow(
                  //                     iconLeft: Icons.account_balance,
                  //                     valueLeft: data.loginBank ?? 'N/A',
                  //                     iconRight: Icons.verified_user,
                  //                     valueRight: data.status ?? 'N/A',
                  //                     textColorRight:
                  //                         (data.status?.toLowerCase() ==
                  //                                 'active')
                  //                             ? Colors.green
                  //                             : Colors.redAccent.shade100,
                  //                   ),
                  //                   _buildSingleRow(
                  //                       Icons.comment, data.comments ?? 'NA'),
                  //                 ],
                  //               ),
                  //             )

                  //             // _buildDetailItem(
                  //             //   'Mobile',
                  //             //   data.mobileNo ?? 'N/A',
                  //             // ),
                  //             // _buildDivider(),
                  //             // _buildDetailItem(
                  //             //   'Loan',
                  //             //   CurrencyUtils.formatIndianCurrency(
                  //             //       data.loanAmount),
                  //             // ),
                  //             // _buildDivider(),
                  //             // _buildDetailItem(
                  //             //   'Bank',
                  //             //   data.loginBank ?? 'N/A',
                  //             //   textColor: AppColors.secondayColor,
                  //             // ),
                  //             // _buildDivider(),
                  //             // _buildStatusItem(
                  //             //   'Comments',
                  //             //   (data.comments ?? 'NA').toString(),
                  //             // ),
                  //             // _buildDivider(),
                  //             // _buildStatusItem(
                  //             //   'Status',
                  //             //   data.status ?? 'N/A',
                  //             //   textColor:
                  //             //       data.status?.toLowerCase() == 'active'
                  //             //           ? Colors.green
                  //             //           : Colors.redAccent.shade100,
                  //             // ),
                  //           ],
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // ),
                );
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, {Color? textColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          ':', // Add colon here
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(width: 4),
        Expanded(
          flex: 4,
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              color: textColor ?? const Color.fromARGB(255, 43, 42, 42),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusItem(String label, String value,
      {Color? textColor, int? maxLines}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          ':', // Add colon here
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(width: 4),
        Expanded(
          flex: 4,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: textColor ?? const Color.fromARGB(255, 43, 42, 42),
            ),
            softWrap: true,
            overflow:
                maxLines != null ? TextOverflow.ellipsis : TextOverflow.visible,
            maxLines: maxLines,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: Colors.grey,
      height: 20,
      thickness: 1,
    );
  }

  Widget _buildDoubleRow({
    required IconData iconLeft,
    required String valueLeft,
    required IconData iconRight,
    required String valueRight,
    Color? textColorRight,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(iconLeft, size: 14, color: Colors.grey[700]),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    valueLeft,
                    style: const TextStyle(fontSize: 12, color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(iconRight, size: 14, color: Colors.grey[700]),
                const SizedBox(width: 4),
                Text(
                  valueRight,
                  style: TextStyle(
                    fontSize: 12,
                    color: textColorRight ?? Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleRow(IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey[700]),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.black),
              maxLines: 10,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildSingleRow(IconData icon, String value) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 2),
  //     child: Row(
  //       children: [
  //         Icon(icon, size: 14, color: Colors.grey[700]),
  //         const SizedBox(width: 4),
  //         Text(
  //           value,
  //           style: const TextStyle(fontSize: 12),
  //           maxLines: 1,
  //           overflow: TextOverflow.ellipsis,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void showDetailsDialogue(String content) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                content,
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
        );
      },
    );
  }

  String maskFirst6Digits(String number) {
    if (number.length < 6) return number; // Handle edge case
    return 'xxxxxx${number.substring(6)}';
  }
}
