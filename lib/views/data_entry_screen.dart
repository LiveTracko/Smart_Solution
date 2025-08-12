import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_solutions/controllers/data_entry_controller.dart';
import 'package:smart_solutions/utils/currency_util.dart';

class AppColors {
  static const Color primaryColor = Colors.blue;
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF356EFF), // #356EFF
        centerTitle: true,
        title: const Text('Leads'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => dataController.refreshData(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                GestureDetector(
                    onTap: () async {
                      var results = await showCalendarDatePicker2Dialog(
                        context: context,
                        config: CalendarDatePicker2WithActionButtonsConfig(
                            calendarType: CalendarDatePicker2Type.range),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(
                                0xFF356EFF), // Background color #356EFF
                            border: Border.all(
                              color: AppColors
                                  .primaryColor, // Keep or change to same hex if needed
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: const Text(
                            'Date',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF356EFF), // #356EFF
                            border: Border.all(
                              color: AppColors.primaryColor,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: const Icon(
                            Icons.filter_alt_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                        )
                      ],
                    )),
                // MonthDropdown(
                //   onChanged: (value) {
                //     print("val: $value");
                //     controller.getDataOnMonth(
                //       value,
                //       DateTime.now().toString(),
                //     );
                //   },
                // ),

                const Spacer(),
                // InkWell(
                //     onTap: () {
                //       dataController.dateRangeList.clear();
                //       dataController.refreshData();
                //       // controller.clearDateRange();
                //       // controller.fetchFollowBackList();
                //     },
                // child:
                Container(
                  height: 35.h,
                  padding: const EdgeInsets.all(0),
                  decoration: BoxDecoration(

                      ///    color: AppColors.grid1.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade300),
                  child: TextButton(
                      onPressed: () {
                        dataController.dateRangeList.clear();
                        dataController.refreshData();
                      },
                      child: const Text(
                        'Clear Filter',
                        style: TextStyle(color: Colors.blue),
                      )),
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
          ), // Search Bar

          Expanded(
            child: Obx(() {
              if (dataController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
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
                      padding: const EdgeInsets.all(5),
                      itemCount: dataController.dataList.length,
                      itemBuilder: (context, index) {
                        var data = dataController.dataList[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: const Border(
                              left: BorderSide(
                                color: Color(0xFF356EFF), // Blue line
                                width: 2,
                              ),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(0.1), // Light shadow
                                offset: const Offset(0, 2), // Only downward
                                blurRadius: 4, // Softness
                                spreadRadius: 0, // No spread
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: ExpansionTile(
                              tilePadding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              childrenPadding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              expandedCrossAxisAlignment:
                                  CrossAxisAlignment.start,
                              initiallyExpanded: false,
                              trailing: Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    // Status
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: data.status?.toLowerCase() ==
                                                'active'
                                            ? Colors.green.withOpacity(0.15)
                                            : Colors.redAccent
                                                .withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        data.status.toString(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          color: data.status?.toLowerCase() ==
                                                  'active'
                                              ? Colors.green
                                              : Colors.redAccent,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),

                                    // Amount + Dropdown icon
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          CurrencyUtils.formatIndianCurrency(
                                              data.loanAmount),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Icon(
                                          Icons.expand_more,
                                          size: 20,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              title: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Color(0xFF356EFF),
                                          child: Icon(
                                            Icons.call,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                data.customerName.toString(),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                data.loginBank.toString(),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 14,
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
                              children: [
                                const Divider(thickness: 0.5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const SizedBox(height: 4),
                                    _buildDoubleRow(
                                      iconLeft: Icons.phone,
                                      valueLeft:
                                          maskFirst6Digits(data.mobileNo ?? ''),
                                      iconRight: Icons.calendar_month,
                                      valueRight: DateFormat('dd-MM-yyyy')
                                          .format(DateTime.parse(
                                              data.date.toString())),
                                    ),
                                    _buildSingleRow(
                                        Icons.comment, data.comments ?? 'NA'),
                                    const SizedBox(height: 4),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )

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
        const Text(
          ':', // Add colon here
          style: TextStyle(fontSize: 12, color: Colors.grey),
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
        const Text(
          ':', // Add colon here
          style: TextStyle(fontSize: 12, color: Colors.grey),
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
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          /// LEFT SIDE
          Expanded(
            child: Row(
              children: [
                Icon(iconLeft, size: 17, color: Colors.grey[700]),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    valueLeft,
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          /// RIGHT SIDE
          Row(
            // <-- No Expanded here, just a normal Row
            children: [
              Icon(iconRight, size: 17, color: Colors.grey[700]),
              const SizedBox(width: 4),
              Text(
                valueRight,
                style: TextStyle(
                  fontSize: 14,
                  color: textColorRight ?? Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSingleRow(IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align to top
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
