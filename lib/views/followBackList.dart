import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_solutions/constants/services.dart';
import 'package:smart_solutions/controllers/dailer_controller.dart';
import 'package:smart_solutions/controllers/follow_form.dart';
import 'package:smart_solutions/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FollowBackListScreen extends StatelessWidget {
  final FollowBackFormController controller =
      Get.put(FollowBackFormController());
  final DialerController _dialerController = Get.put(DialerController());
  final TextEditingController _searchController = TextEditingController();
  final FollowBackFormController _formController =
      Get.put(FollowBackFormController());

  FollowBackListScreen({Key? key}) : super(key: key);

  Future<void> onRefresh() async {
    controller.fetchFollowBackList();
  }

  String _formatDate(String dateString) {
    try {
      // Try to parse the date properly, handling different formats
      DateTime parsedDate = DateFormat('yyyy-M-d').parse(dateString);
      return DateFormat('dd-MM-yyyy').format(parsedDate);
    } catch (e) {
      return 'Invalid Date'; // Handle parsing errors gracefully
    }
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    DateTime now = DateTime.now();
    DateTime initialDate = isFromDate
        ? controller.fromDate.value ?? now
        : controller.toDate.value ?? controller.fromDate.value ?? now;

    DateTime firstDate = isFromDate
        ? DateTime(2000)
        : controller.fromDate.value ?? DateTime(2000);
    DateTime lastDate = DateTime(2100);

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      if (isFromDate) {
        controller.setFromDate(pickedDate);

        // // Reset `toDate` if it's before `fromDate`
        // if (controller.toDate.value != null && controller.toDate.value!.isBefore(pickedDate)) {
        //   controller.setToDate(pickedDate);
        // }
      } else {
        controller.setToDate(pickedDate);
      }
    }

    debugPrint("pickedDate: $pickedDate");

    if (controller.fromDate.value != null && controller.toDate.value != null) {
      controller.getDataOnMonth(
        DateFormat('d-M-yyyy').format(controller.fromDate.value!),
        DateFormat('d-M-yyyy').format(controller.toDate.value!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Follow - Up',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.appBarColor,
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: Padding(
          padding: EdgeInsets.all(16.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Obx(() {
              //   return Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       // Expanded(
              //       //   child: SizedBox(
              //       //     width: 100,
              //       //     height: 50,
              //       //     child: TextField(
              //       //       style: TextStyle(color: Colors.black),
              //       //       readOnly: true,
              //       //       decoration: const InputDecoration(
              //       //         labelText: "From Date",
              //       //         suffixIcon: Icon(Icons.calendar_today),
              //       //         border: OutlineInputBorder(),
              //       //       ),
              //       //       controller: controller.fromDateController
              //       //         ..text = DateFormat("yyyy-MM-dd").format(
              //       //             controller.fromDate.value ?? DateTime.now()),
              //       //       onTap: () => {_selectDate(context, true)},
              //       //     ),
              //       //   ),
              //       // ),
              //       // Expanded(
              //       //   child: SizedBox(
              //       //     width: 100,
              //       //     height: 50,
              //       //     child: TextField(
              //       //       style: TextStyle(color: Colors.black),
              //       //       readOnly: true,
              //       //       decoration: const InputDecoration(
              //       //         labelText: "to Date",
              //       //         suffixIcon: Icon(Icons.calendar_today),
              //       //         border: OutlineInputBorder(),
              //       //       ),
              //       //       controller: controller.toDateController
              //       //         ..text = DateFormat("yyyy-MM-dd").format(
              //       //             controller.toDate.value ?? DateTime.now()),
              //       //       onTap: () => {_selectDate(context, false)},
              //       //     ),
              //       //   ),
              //       // ),

              //       // DatePickerDialog(

              //       //     firstDate: DateTime.now(), lastDate: DateTime.now()),
              //       //    DatePickerDialog(
              //       //     firstDate: DateTime.now(), lastDate: DateTime.now())
              //     ],
              //   );
              // }),

              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      var results = await showCalendarDatePicker2Dialog(
                        context: context,
                        config: CalendarDatePicker2WithActionButtonsConfig(
                          calendarType: CalendarDatePicker2Type.range,
                        ),
                        dialogSize: const Size(325, 400),
                        value: controller.dateRangeList,
                        borderRadius: BorderRadius.circular(15),
                      );

                      if (results != null) {
                        controller.dateRangeList.value = results;
                        controller.fetchFollowBackList();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        border: Border.all(
                          color: AppColors.primaryColor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: const Row(
                        children: [
                          Text(
                            'Filter',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.filter_alt,
                            color: Colors.white,
                            size: 20,
                          )
                        ],
                      ),
                    ),
                  ),
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
                  Container(
                    height: 35.h,
                    padding: const EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      color: AppColors.grid1.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                        onPressed: () {
                          controller.clearDateRange();
                          controller.fetchFollowBackList();
                        },
                        child: const Text(
                          'Clear Filter',
                          style: TextStyle(color: Colors.blue),
                        )),
                  )
                  // InkWell(
                  //   onTap: () {
                  //     controller.clearDateRange();
                  //     controller.fetchFollowBackList();
                  //   },
                  //   child: Container(
                  //     padding: EdgeInsets.all(5.0.w),
                  //     decoration: BoxDecoration(
                  //       color: AppColors.grid1.withOpacity(0.3),
                  //       borderRadius: BorderRadius.circular(25),
                  //     ),
                  //     child: Icon(
                  //       Icons.close,
                  //       size: 20.sp,
                  //     ),
                  //   ),
                  // ),
                ],
              ), // Search Bar
              // Padding(
              //   padding: const EdgeInsets.all(12.0),
              //   child:
              //    TextField(
              //     controller: _searchController,
              //     style: const TextStyle(color: AppColors.textColor2),
              //     decoration: InputDecoration(
              //       hintText: 'Search by name, mobile, or bank...',
              //       hintStyle: const TextStyle(color: Colors.grey),
              //       prefixIcon: const Icon(Icons.search, color: Colors.grey),
              //       filled: true,
              //       fillColor: Colors.white,
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //     ),
              //     onChanged: (value) {
              //       controller.updateFilteredFollowBackList(value);
              //     },
              //   ),
              // ),

              SizedBox(
                height: 16.h,
              ),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final displayedList =
                      controller.filteredFollowBackList.isEmpty
                          ? controller.followBackList
                          : controller.filteredFollowBackList;

                  if (displayedList.isEmpty) {
                    return const Center(
                        child: Text("No follow-up data available"));
                  }

                  return ListView.builder(
                    itemCount: displayedList.length,
                    itemBuilder: (context, index) {
                      final item = displayedList[index];
                      // DateTime? followbackdate = DateTime.now();
                      // print(' this is the follow back dat $followbackdate');
                      // if (item.followupDate != null &&
                      //     item.followupDate!.isNotEmpty) {
                      //   followbackdate = DateTime.tryParse(item.followupDate!);
                      // }

                      // DateTime? FollowUpDate = null;
                      // if (item.followupDate != null ||
                      //     item.followupDate!.isNotEmpty ||
                      //     item.followupDate != "-") {
                      //   FollowUpDate = DateTime.tryParse(item.followupDate!);
                      // }

                      DateTime? entryDate = DateTime.now();
                      if (item.entryDate != null &&
                          item.entryDate!.isNotEmpty) {
                        entryDate = DateTime.tryParse(item.entryDate!);
                      }
                      return ExpansionTile(
                        tilePadding:
                            const EdgeInsets.symmetric(horizontal: 0.0),
                        childrenPadding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 0),
                        expandedCrossAxisAlignment: CrossAxisAlignment.start,
                        initiallyExpanded: false,
                        title: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                logOutput(_dialerController.customerName.value);
                                logOutput(
                                    "${_dialerController.isCallOngoing.value}");
                                if (!_dialerController.isCallOngoing.value) {
                                  _dialerController.makePhoneCall(
                                    item.contactNumber ?? '',
                                    followUpId: item.id ?? '',
                                  );
                                }

                                _formController.mobile.value =
                                    item.contactNumber ?? "";
                                _formController.bankName.value =
                                    item.bankName ?? "";
                                _formController.customerName.value =
                                    item.customerName ?? "";
                                _dialerController.customerName.value =
                                    item.customerName ?? '';
                                // _dialerController.customerLoan.value =
                                //     '';
                                // _dialerController.customerName.value =
                                //     item.customerName ?? "";
                                _dialerController.datatype.value = '';
                                _formController.remark.value =
                                    item.remark ?? '';
                                _dialerController.followup_id.value =
                                    item.id ?? '';
                                _dialerController.excel_id.value =
                                    item.excelDataId ?? '';
                              },
                              child: const CircleAvatar(
                                  backgroundColor: AppColors.primaryColor,
                                  radius: 18,
                                  child: Icon(
                                    Icons.call,
                                    color: Colors.white,
                                  )),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.customerName.toString()),
                                Text(
                                  softWrap: true,
                                  style: const TextStyle(fontSize: 11),
                                  DateFormat('dd-MM-yyyy hh:mm:ss a').format(
                                      DateTime.parse(
                                          item.entryDate.toString())),
                                ),
                              ],
                            )
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    item.remarkStatus.toString(),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    softWrap: true,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: item.contactStatus == '1'
                                          ? Colors.green.shade700
                                          : Colors.orange.shade700,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 15,
                                  ),
                                ]),
                            Padding(
                              padding: const EdgeInsetsGeometry.only(right: 15),
                              child: Text(
                                item.bankName.toString(),
                                softWrap: true,
                                style: const TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                        children: [
                          _buildDoubleRow(
                              iconLeft: Icons.call,
                              valueLeft: maskFirst6Digits(
                                  item.contactNumber.toString()),
                              iconRight: item.followupDate != "-" &&
                                      item.followupDate!.isNotEmpty
                                  ? Icons.schedule
                                  : null,
                              valueRight: DateFormat('dd-MM-yyyy').format(
                                  DateTime.parse(item.entryDate.toString()))),
                          _buildSingleRow(
                              Icons.comment,
                              item.remark!.isNotEmpty
                                  ? item.remark.toString()
                                  : 'No comment')
                        ],
                      );
                    },
                  );

                  // ListView.builder(
                  //   itemCount: displayedList.length,
                  //   itemBuilder: (context, index) {
                  //     final item = displayedList[index];
                  //     // DateTime? followbackdate = DateTime.now();
                  //     // print(' this is the follow back dat $followbackdate');
                  //     // if (item.followupDate != null &&
                  //     //     item.followupDate!.isNotEmpty) {
                  //     //   followbackdate = DateTime.tryParse(item.followupDate!);
                  //     // }

                  //     // DateTime? FollowUpDate = null;
                  //     // if (item.followupDate != null ||
                  //     //     item.followupDate!.isNotEmpty ||
                  //     //     item.followupDate != "-") {
                  //     //   FollowUpDate = DateTime.tryParse(item.followupDate!);
                  //     // }

                  //     DateTime? entryDate = DateTime.now();
                  //     if (item.entryDate != null &&
                  //         item.entryDate!.isNotEmpty) {
                  //       entryDate = DateTime.tryParse(item.entryDate!);
                  //     }

                  //     return Card(
                  //       elevation: 2,
                  //       margin: EdgeInsets.only(bottom: 16.h),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(12.r),
                  //       ),
                  //       child: Padding(
                  //         padding: EdgeInsets.all(10.0.w),
                  //         child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Row(
                  //               mainAxisAlignment:
                  //                   MainAxisAlignment.spaceBetween,
                  //               children: [
                  //                 Row(
                  //                   children: [
                  //                     Icon(
                  //                       Icons.person,
                  //                       color: AppColors.primaryColor,
                  //                       size: 20.sp,
                  //                     ),
                  //                     SizedBox(width: 8.w),
                  //                     SizedBox(
                  //                       width: 170.w,
                  //                       child: Text(
                  //                         item.customerName ?? '',
                  //                         overflow: TextOverflow.ellipsis,
                  //                         style: TextStyle(
                  //                           fontWeight: FontWeight.bold,
                  //                           fontSize: 16.sp,
                  //                           color: Colors.black87,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //                 Container(
                  //                   padding: EdgeInsets.symmetric(
                  //                     horizontal: 7.w,
                  //                     vertical: 6.h,
                  //                   ),
                  //                   decoration: BoxDecoration(
                  //                     color: item.contactStatus == '1'
                  //                         ? AppColors.grid1.withOpacity(0.3)
                  //                         : AppColors.grid2.withOpacity(0.3),
                  //                     borderRadius: BorderRadius.circular(20.r),
                  //                   ),
                  //                   child: ConstrainedBox(
                  //                     constraints: BoxConstraints(
                  //                       maxWidth:
                  //                           90.w, // Adjust the width as needed
                  //                     ),
                  //                     child: Text(
                  //                       maxLines:
                  //                           1, // Ensures text stays in one line
                  //                       overflow: TextOverflow
                  //                           .clip, // Adds "..." if text overflows

                  //                       softWrap: true,
                  //                       item.remarkStatus.toString(),

                  //                       // item.contactStatus == '1'
                  //                       //     ? 'CONTACTED'
                  //                       //     : 'NOT CONTACTED',
                  //                       style: TextStyle(
                  //                         color: item.contactStatus == '1'
                  //                             ? Colors.green.shade700
                  //                             : Colors.orange.shade700,
                  //                         fontSize: 12.sp,
                  //                         fontWeight: FontWeight.w500,
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //             SizedBox(height: 16.h),
                  //             Column(
                  //               children: [
                  //                 Obx(
                  //                   () => GestureDetector(
                  //                     onTap: () {
                  //                       logOutput(_dialerController
                  //                           .customerName.value);
                  //                       logOutput(
                  //                           "${_dialerController.isCallOngoing.value}");
                  //                       if (!_dialerController
                  //                           .isCallOngoing.value) {
                  //                         _dialerController.makePhoneCall(
                  //                           item.contactNumber ?? '',
                  //                           followUpId: item.id ?? '',
                  //                         );
                  //                       }

                  //                       _formController.mobile.value =
                  //                           item.contactNumber ?? "";
                  //                       _formController.bankName.value =
                  //                           item.bankName ?? "";
                  //                       _formController.customerName.value =
                  //                           item.customerName ?? "";
                  //                       _dialerController.customerName.value =
                  //                           item.customerName ?? '';
                  //                       // _dialerController.customerLoan.value =
                  //                       //     '';
                  //                       // _dialerController.customerName.value =
                  //                       //     item.customerName ?? "";
                  //                       _dialerController.datatype.value = '';
                  //                       _formController.remark.value =
                  //                           item.remark ?? '';
                  //                       _dialerController.followup_id.value =
                  //                           item.id ?? '';
                  //                       _dialerController.excel_id.value =
                  //                           item.excelDataId ?? '';
                  //                     },
                  //                     child: Row(
                  //                       children: [
                  //                         Expanded(
                  //                           child: FollowBackListWidget(
                  //                             icon: Icons.phone,
                  //                             text: _dialerController
                  //                                     .isCallOngoing.value
                  //                                 ? "NA"
                  //                                 : 'Tap to call',
                  //                           ),
                  //                         ),
                  //                         Expanded(
                  //                           child: FollowBackListWidget(
                  //                             icon: Icons.account_balance,
                  //                             text: item.bankName ?? '',
                  //                           ),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 const SizedBox(height: 20),
                  //                 Row(
                  //                   children: [
                  //                     Expanded(
                  //                       child: FollowBackListWidget(
                  //                         icon: Icons.calendar_today,
                  //                         text: entryDate != null
                  //                             ? DateFormat('dd-MM-yyyy')
                  //                                 .format(entryDate)
                  //                             : 'No Date',
                  //                       ),
                  //                     ),
                  //                     Expanded(
                  //                       child: FollowBackListWidget(
                  //                         icon: Icons.access_time,
                  //                         text: entryDate != null
                  //                             ? DateFormat('hh:mm a ')
                  //                                 .format(entryDate)
                  //                             //     +
                  //                             // "o'clock"
                  //                             : 'No Time',
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //                 if (item.followupDate != null &&
                  //                     item.remarkStatus == "Callback")
                  //                   Padding(
                  //                     padding: EdgeInsets.only(top: 16.h),
                  //                     child: FollowBackListWidget(
                  //                       icon: Icons.perm_contact_calendar,
                  //                       text: item.followupDate != null
                  //                           ? _formatDate(item.followupDate!)
                  //                           : 'No Date',
                  //                       color: Colors.red,
                  //                     ),
                  //                   ),
                  //                 SizedBox(
                  //                   height: 16.h,
                  //                 ),
                  //                 Row(
                  //                   children: [
                  //                     Icon(
                  //                       Icons.mark_unread_chat_alt,
                  //                       size: 16.sp, // Responsive icon size
                  //                       color: AppColors.secondayColor,
                  //                     ),
                  //                     SizedBox(width: 8.w), // Responsive width
                  //                     Expanded(
                  //                       child: Text(
                  //                         (item.remark ?? "NA").isEmpty
                  //                             ? "No comments"
                  //                             : item.remark ?? "No comments",
                  //                         style: TextStyle(
                  //                           color: AppColors.secondayColor,
                  //                           fontSize:
                  //                               14.sp, // Responsive font size
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ],
                  //             )
                  //           ],
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoubleRow({
    required IconData iconLeft,
    required String valueLeft,
    IconData? iconRight,
    required String valueRight,
    Color? textColorRight,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(iconRight, size: 14, color: Colors.grey[700]),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    valueRight,
                    style: TextStyle(
                      fontSize: 12,
                      color: textColorRight ?? Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
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
      padding: const EdgeInsets.symmetric(vertical: 2),
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

  String maskFirst6Digits(String number) {
    if (number.length < 6) return number; // Handle edge case
    return 'xxxxxx${number.substring(6)}';
  }
}
