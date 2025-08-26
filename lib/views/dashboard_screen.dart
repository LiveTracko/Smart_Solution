import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_solutions/constants/static_stored_data.dart';
import 'package:smart_solutions/controllers/dashboard_controller.dart';
import 'package:smart_solutions/controllers/follow_form.dart';
import 'package:smart_solutions/controllers/notification_controller.dart';
import 'package:smart_solutions/models/dashBoardToday_model.dart';
import 'package:smart_solutions/theme/app_theme.dart';
import 'package:smart_solutions/views/notification_screen.dart';
import 'package:smart_solutions/widget/common_scaffold.dart';
import 'package:smart_solutions/widget/loading_page.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../models/getGroupStatus.dart';
import '../models/FollowUpSubmittedList.dart' as followuplist;

class DashboardScreen extends StatefulWidget {
  DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final DashboardController controller = Get.put(DashboardController());
  final FollowBackFormController followBackFormController =
      Get.put(FollowBackFormController());

  @override
  void initState() {
    controller.onInit();
    if (StaticStoredData.roleName == 'telecaller') {
      followBackFormController.fetchFollowBackList();
      loadFollowData();
    }
    super.initState();
  }

  Future<void> loadFollowData() async {
    await getMonthlyFollowList();
    await getDailyFollowList();
  }

  DateTime today = DateTime.now();

  List todayUsers = [];

  Future<List<followuplist.Data>> getMonthlyFollowList() async {
    await followBackFormController.getDailyMonthlyCallbackData('0');
    return followBackFormController.callbackData;
  }

  Future<List<followuplist.Data>> getDailyFollowList() async {
    await followBackFormController.getDailyMonthlyCallbackData('1');
    return followBackFormController.dailycallbackData;
  }

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.put(DashboardController());
    final NotificationController notificationController =
        Get.put(NotificationController());

    return CommonScaffold(
      title: "Dashboard",
      isDrawer: true,
      showBack: false,
      actions: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: IconButton(
            onPressed: () async {
              Get.to(() => const NotificationSCreen());
              //     controller.onInit();
              //    refreshDashboard();
              // await controller
              //     .fetchDashboardData(true); // Refresh monthly data
              // await controller.fetchDashboardData(false);
            },
            icon: Obx(
              () => Stack(
                children: [
                  const Icon(
                    Icons.notifications,
                    color: AppColors.appBarTextColor,
                  ),
                  notificationController.unreadCount.value != 0
                      ? Positioned(
                          right: 0,
                          top: 0,
                          bottom: 5,
                          child: Container(
                            padding: const EdgeInsets.all(0),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 15,
                              minHeight: 12,
                            ),
                            child: Text(
                              notificationController.unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ))
                      : const SizedBox(),
                ],
              ),
            ),
            // const Icon(Icons.refresh_rounded),
          ),
        ),
      ],

      //   backgroundColor: Colors.grey[50],
      key: _scaffoldKey,
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   backgroundColor: AppColors.primaryColor,
      //   centerTitle: true,
      //   title: const Text(
      //     "Dashboard",
      //     style: TextStyle(color: Colors.white),
      //   ),
      //   leading: IconButton(
      //       onPressed: () async {
      //         controller.toggleDrawer();
      //         controller.isDrawerOpen.value
      //             ? _scaffoldKey.currentState!.openDrawer()
      //             : _scaffoldKey.currentState!.closeDrawer();

      //         // if (controller.isDrawerOpen.value) {
      //         //   logOutput("opening drawer");
      //         //   _scaffoldKey.currentState!.openDrawer();
      //         // } else {
      //         //   _scaffoldKey.currentState!.closeDrawer();

      //         //   logOutput('closing drawer');
      //         //   Get.back();
      //         // }
      //       },
      //       icon: const Icon(
      //         Icons.menu,
      //         color: Colors.white,
      //       )),
      //   actions: [
      //     Padding(
      //       padding: const EdgeInsets.all(10.0),
      //       child: IconButton(
      //         onPressed: () async {
      //           Get.to(() => const NotificationSCreen());
      //           //     controller.onInit();
      //           //    refreshDashboard();
      //           // await controller
      //           //     .fetchDashboardData(true); // Refresh monthly data
      //           // await controller.fetchDashboardData(false);
      //         },
      //         icon: Obx(
      //           () => Stack(
      //             children: [
      //               const Icon(Icons.notifications),
      //               notificationController.unreadCount.value != 0
      //                   ? Positioned(
      //                       right: 0,
      //                       top: 0,
      //                       bottom: 5,
      //                       child: Container(
      //                         padding: const EdgeInsets.all(0),
      //                         decoration: BoxDecoration(
      //                           color: Colors.red,
      //                           borderRadius: BorderRadius.circular(10),
      //                         ),
      //                         constraints: const BoxConstraints(
      //                           minWidth: 15,
      //                           minHeight: 12,
      //                         ),
      //                         child: Text(
      //                           notificationController.unreadCount.toString(),
      //                           style: const TextStyle(
      //                             color: Colors.white,
      //                             fontSize: 10,
      //                           ),
      //                           textAlign: TextAlign.center,
      //                         ),
      //                       ))
      //                   : const SizedBox(),
      //             ],
      //           ),
      //         ),
      //         // const Icon(Icons.refresh_rounded),
      //       ),
      //     ),
      //   ],
      // ),
      // drawerEnableOpenDragGesture: false,
      // drawer: const CustomDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.onInit();
          await controller.fetchDashboardData(true); // Refresh monthly data
          await controller.fetchDashboardData(false); // Refresh today's data
        },
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: LoadingPage());
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Attempted",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            "${controller.callTimeModel.callTimeModel?.totalAttempt ?? '0'}",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Connected",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            controller.totalPicked.value,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Not Connected",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            controller.totalNotPicked.value,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 5.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Duration",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            controller.totalDuration.value,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              var results = await showCalendarDatePicker2Dialog(
                                context: context,
                                config:
                                    CalendarDatePicker2WithActionButtonsConfig(
                                  calendarType: CalendarDatePicker2Type.range,
                                ),
                                dialogSize: const Size(325, 400),
                                value: controller.dateRangeList,
                                borderRadius: BorderRadius.circular(15),
                              );

                              if (results != null) {
                                if (results.first == results.last) {
                                  controller.dateRangeList.clear();
                                  controller.dateRangeList.add(results.first);
                                } else {
                                  controller.dateRangeList.value = results;
                                }
                                controller.formateDate();

                                if (controller.dateRangeList.length != 1) {
                                  DateTime? date =
                                      controller.dateRangeList.first;
                                  DateTime? lDate =
                                      controller.dateRangeList.last;
                                  // if(date!=null){
                                  controller.dateRange.value =
                                      "${date?.day}-${date?.month}-${lDate?.year},${lDate?.day}-${lDate?.month}-${date?.year}";
                                  print(controller.dateRange.value);
                                } else {
                                  DateTime? date =
                                      controller.dateRangeList.first;
                                  if (date != null) {
                                    controller.dateRange.value =
                                        "${date.day}-${date.month}-${date.year},${date.day}-${date.month}-${date.year}";
                                    print(controller.dateRange.value);
                                  }
                                }
                                controller.getTimeGraph();
                              }
                              // controller.fetchFollowBackList();
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
                              child: const Row(
                                children: [
                                  Text(
                                    'Select Date',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  // SizedBox(
                                  //   width: 10,
                                  // ),
                                  // Icon(
                                  //   Icons.filter_alt,
                                  //   color: Colors.white,
                                  // )
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
                          if (controller.dateRangeList.isNotEmpty) ...[
                            const Spacer(),
                            Text(
                              controller.formattedDate.value,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                controller.dateRangeList.clear();
                                controller.totalContact.clear();
                                controller.totalNoContact.clear();
                                controller.totalAttempt.clear();
                                controller.activeCallMap.clear();
                                controller.activeNoCallMap.clear();
                                controller.activeAttemptMap.clear();
                                controller.finalActiveNoCallList.clear();
                                controller.finalActiveCallList.clear();
                                controller.finalTotalAttemptCallList.clear();
                                DateTime now = DateTime.now();
                                controller.dateRange.value =
                                    "${now.day}-${now.month}-${now.year},${now.day}-${now.month}-${now.year}";
                                controller.getTimeGraph();
                              },
                              child: Container(
                                padding: EdgeInsets.all(5.0.w),
                                decoration: BoxDecoration(
                                  color: AppColors.grid1.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Icon(
                                  Icons.close,
                                  size: 20.sp,
                                ),
                              ),
                            ),
                          ]
                        ],
                      ),

                      SizedBox(
                        height: 300,
                        child: SfCartesianChart(
                          primaryXAxis: const CategoryAxis(),
                          tooltipBehavior: TooltipBehavior(enable: true),
                          legend: const Legend(isVisible: true),
                          series: <CartesianSeries<CallGraphModel, String>>[
                            LineSeries<CallGraphModel, String>(
                              color: AppColors.primaryColor,
                              dataSource: controller.finalTotalAttemptCallList,
                              xValueMapper: (CallGraphModel data, _) =>
                                  data.time,
                              yValueMapper: (CallGraphModel data, _) =>
                                  data.data ?? 0,
                              name: 'Attempted',
                              dataLabelSettings:
                                  const DataLabelSettings(isVisible: true),
                            ),
                            LineSeries<CallGraphModel, String>(
                              color: Colors.green,
                              dataSource: controller.finalActiveCallList,
                              xValueMapper: (CallGraphModel data, _) =>
                                  data.time,
                              yValueMapper: (CallGraphModel data, _) =>
                                  data.data ?? 0,
                              name: 'Connected',
                              dataLabelSettings:
                                  const DataLabelSettings(isVisible: true),
                            ),
                            LineSeries<CallGraphModel, String>(
                              color: Colors.red,
                              dataSource: controller.finalActiveNoCallList,
                              xValueMapper: (CallGraphModel data, _) =>
                                  data.time,
                              yValueMapper: (CallGraphModel data, _) =>
                                  data.data ?? 0,
                              name: 'Not Connected',
                              dataLabelSettings:
                                  const DataLabelSettings(isVisible: true),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 34),

                      if (controller.activeList.isNotEmpty) ...[
                        DashboardSection(
                          graphLabel: 'Active cases',
                          amount: controller
                              .priceFormatter(controller.totalValActive.value),
                          title: "Active Cases",
                          data: controller.todayData.value.data,
                          controller: controller,
                          list: controller.activeList,
                        ),
                        const SizedBox(height: 34),
                      ],
                      // Monthly Section
                      if (controller.inActiveList.isNotEmpty) ...[
                        DashboardSection(
                          graphLabel: "Inactive Cases",
                          amount: controller.priceFormatter(
                              controller.totalNoValActive.value),
                          title: "Inactive Cases",
                          data: controller.monthlyData.value.data,
                          controller: controller,
                          list: controller.inActiveList,
                        ),
                        SizedBox(height: 10.h),
                      ],
                      SizedBox(
                        height: 6.h,
                      ),

                      const SizedBox(height: 15),
                      if (StaticStoredData.roleName == 'telecaller') ...[
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.black)),
                          child: const Text(
                            "Today Call back list",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        FutureBuilder<List<followuplist.Data>>(
                          future: getDailyFollowList(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return LoadingPage();
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text(
                                'Error: ${snapshot.error}',
                                style: const TextStyle(color: Colors.black),
                              ));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Center(
                                  child: Text(
                                'No follow-ups for today',
                                style: TextStyle(color: Colors.black),
                              ));
                            }

                            final todayUsers = snapshot.data!;

                            return ListView.builder(
                              itemCount: todayUsers.length,
                              shrinkWrap:
                                  true, // ✅ Important: wrap content height
                              physics:
                                  const NeverScrollableScrollPhysics(), // ✅ Prevent internal scrolling
                              itemBuilder: (context, index) {
                                final user = todayUsers[index];
                                return ListTile(
                                  contentPadding: const EdgeInsets.all(0),
                                  title: Text(
                                    user.customerName ?? 'No Name',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  subtitle: Text(maskFirst6Digits(
                                      user.contactNumber ?? '')),
                                  leading: IconButton(
                                    onPressed: () {
                                      // your logic...
                                    },
                                    icon: const Icon(Icons.call),
                                  ),
                                  trailing: Text(
                                    DateFormat('dd-MM-yy hh:mm:ss a').format(
                                        DateTime.parse(
                                            user.entryDate.toString())),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.black)),
                          child: const Text(
                            "Monthly Call back list",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        FutureBuilder<List<followuplist.Data>>(
                          future: getMonthlyFollowList(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Center(
                                  child: Text('No follow-ups for today'));
                            }

                            final todayUsers = snapshot.data!;

                            return ListView.builder(
                              itemCount: todayUsers.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final user = todayUsers[index];
                                return ListTile(
                                  contentPadding: const EdgeInsets.all(0),
                                  title: Text(
                                    user.customerName ?? 'No Name',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  subtitle: Text(maskFirst6Digits(
                                      user.contactNumber ?? '')),
                                  leading: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.call),
                                  ),
                                  trailing: Text(
                                    DateFormat('dd-MM-yy hh:mm:ss a').format(
                                        DateTime.parse(
                                            user.entryDate.toString())),
                                  ),
                                );
                              },
                            );
                          },
                        )
                      ],
                    ]),
              ),
            );
          }
        }),
      ),
    );
  }

  String maskFirst6Digits(String number) {
    if (number.length < 6) return number; // Handle edge case
    return 'xxxxxx${number.substring(6)}';
  }
}

class DashboardSection extends StatefulWidget {
  final String? amount;
  final String title;
  final Data? data;
  final DashboardController controller;
  final List<StatusGroupModel> list;
  final String graphLabel;

  const DashboardSection(
      {Key? key,
      required this.amount,
      required this.graphLabel,
      required this.title,
      required this.data,
      required this.controller,
      required this.list})
      : super(key: key);

  @override
  State<DashboardSection> createState() => _DashboardSectionState();
}

class _DashboardSectionState extends State<DashboardSection> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              "${widget.amount}",
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        // controller.buildChunkedGrid(list, 4),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width - 32),
            child: DataTable(
              dataRowHeight: 30,
              horizontalMargin: 10,
              headingRowHeight: 35,
              clipBehavior: Clip.hardEdge,
              headingRowColor: WidgetStatePropertyAll(
                  AppColors.primaryColor.withOpacity(.7)),
              columnSpacing: 15.0,
              border: TableBorder.all(
                  color: Colors.black,
                  width: 0.5,
                  borderRadius: BorderRadius.circular(13)),
              columns: [
                DataColumn(
                    headingRowAlignment: MainAxisAlignment.center,
                    label: Text(
                      widget.graphLabel,
                      style: const TextStyle(color: Colors.white),
                    )),
                const DataColumn(
                    headingRowAlignment: MainAxisAlignment.center,
                    label: Text(
                      "Amount",
                      style: TextStyle(color: Colors.white),
                    )),
                const DataColumn(
                    headingRowAlignment: MainAxisAlignment.center,
                    label: Text(
                      "Files",
                      style: TextStyle(color: Colors.white),
                    ))
              ],
              rows: widget.list.asMap().entries.map((entry) {
                // val+=1;
                final index = entry.key;
                final row = entry.value;
                return DataRow(
                    color: WidgetStateProperty.resolveWith<Color?>(
                      (Set<WidgetState> states) {
                        // Alternate row color for even indexes
                        return index.isEven
                            ? Colors.white
                                .withOpacity(0.1) // Define your color here
                            : AppColors.primaryColor
                                .withOpacity(.3); // Default color for odd rows
                      },
                    ),
                    cells: [
                      DataCell(Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(
                                    index == widget.list.length - 1 ? 13 : 0))),
                        child: Text(
                          row.StatusGroupModelName ?? '',
                          style:
                              TextStyle(fontSize: 13.sp, color: Colors.black),
                        ),
                      )),
                      DataCell(Container(
                        alignment: Alignment.center,
                        child: Text(
                            widget.controller
                                .priceFormatter("${row.totalLoanAmount ?? ''}"),
                            style: TextStyle(
                                fontSize: 13.sp, color: Colors.black)),
                      )),
                      DataCell(Container(
                        alignment: Alignment.center,
                        child: Text(row.filecount ?? '',
                            style: TextStyle(
                                fontSize: 13.sp, color: Colors.black)),
                      ))
                    ]);
              }).toList(),
            ),
          ),
        ),
        // Row(
        //   children: [
        //    const Flexible(
        //       child: DashboardCardNew(
        //         icon: Icons.file_copy_sharp,
        //         title: "Document Sent",
        //         count: "Rs. 25,000 2 files",
        //         backgroundColor: const Color(0xFFE3F2FD),
        //       ),
        //     ),
        //     SizedBox(width: 12.w,),
        //    const Flexible(
        //       child: DashboardCardNew(
        //         icon: Icons.file_copy_sharp,
        //         title: "Login Process",
        //         count: "Rs. 30,000 4 files",
        //         backgroundColor: const Color(0xFFE3F2FD),
        //       ),
        //     ),
        //   ],
        // ),

        //    SingleChildScrollView(
        //      scrollDirection: Axis.horizontal,
        //      child: Row(
        //        children: [
        //          const DashboardCardNew(
        //            icon: Icons.file_copy_sharp,
        //            fileCount: "2",
        //            title: "Document Sent",
        //            count: "25,000",
        //            backgroundColor:  Color(0xFFE3F2FD),
        //          ),
        //          SizedBox(
        //            width: 12.w,
        //          ),
        //          const DashboardCardNew(
        //            icon: Icons.file_copy_sharp,
        //            title: "Login Process",
        //            count: "30,000",
        //            fileCount: '4',
        //            backgroundColor: const Color(0xFFE1F5FE),
        //          ),
        //          SizedBox(
        //            width: 12.w,
        //          ),
        //          const DashboardCardNew(
        //            fileCount: '2',
        //            icon: Icons.file_copy_sharp,
        //            title: "Query",
        //            count: "0",
        //            backgroundColor: const Color(0xFFFFF8E1),
        //          ),
        //          SizedBox(
        //            width: 12.w,
        //          ),
        //          const DashboardCardNew(
        //            fileCount: "3",
        //            icon: Icons.file_copy_sharp,
        //            title: "Login Done",
        //            count: "30,000",
        //            backgroundColor: const Color(0xFFFCE4EC),
        //          ),
        //        ],
        //      ),
        //    ),
        //    SizedBox(
        //      height: 12.h,
        //    ),
        //    SingleChildScrollView(
        //      scrollDirection: Axis.horizontal,
        //      child: Row(
        //        children: [
        //          const DashboardCardNew(
        //            icon: Icons.file_copy_sharp,
        //            fileCount: "2",
        //            title: "Verification Stage",
        //            count: "25,000",
        //            backgroundColor:  Color(0xFFE1F5FE),
        //          ),
        //          SizedBox(
        //            width: 12.w,
        //          ),
        //          const DashboardCardNew(
        //            icon: Icons.file_copy_sharp,
        //            title: "Relook",
        //            count: "30,000",
        //            fileCount: '4',
        //            backgroundColor:
        // Color(0xFFFFF8E1)
        //            ,
        //          ),
        //          SizedBox(
        //            width: 12.w,
        //          ),
        //          const DashboardCardNew(
        //            fileCount: '2',
        //            icon: Icons.file_copy_sharp,
        //            title: "Relook Done",
        //            count: "0",
        //            backgroundColor:
        //               Color(0xFFFCE4EC)
        //            ,
        //          ),
        //          SizedBox(
        //            width: 12.w,
        //          ),
        //          const DashboardCardNew(
        //            fileCount: "3",
        //            icon: Icons.file_copy_sharp,
        //            title: "Underwriting",
        //            count: "30,000",
        //            backgroundColor:
        //             Color(0xFFE3F2FD)
        //           ,
        //          ),
        //        ],
        //      ),
        //    ),
        //    SizedBox(
        //      height: 12.h,
        //    ),
        //    SingleChildScrollView(
        //      scrollDirection: Axis.horizontal,
        //      child: Row(
        //        children: [
        //          const DashboardCardNew(
        //            icon: Icons.file_copy_sharp,
        //            fileCount: "2",
        //            title: "Recommended",
        //            count: "25,000",
        //            backgroundColor: const Color(0xFFE3F2FD),
        //          ),
        //          SizedBox(
        //            width: 12.w,
        //          ),
        //          const DashboardCardNew(
        //            icon: Icons.file_copy_sharp,
        //            title: "Approved",
        //            count: "30,000",
        //            fileCount: '4',
        //            backgroundColor: const Color(0xFFE1F5FE),
        //          ),
        //          SizedBox(
        //            width: 12.w,
        //          ),
        //          const DashboardCardNew(
        //            fileCount: '2',
        //            icon: Icons.file_copy_sharp,
        //            title: "Distributed",
        //            count: "0",
        //            backgroundColor: const Color(0xFFFFF8E1),
        //          ),
        //        ],
        //      ),
        //    ),

        // GridView.count(
        //   physics: const NeverScrollableScrollPhysics(),
        //   shrinkWrap: true,
        //   crossAxisCount: 2,
        //   childAspectRatio: 1.3,
        //   crossAxisSpacing: 12.w,
        //   mainAxisSpacing: 12.h,
        //   children: const [
        //     DashboardCardNew(
        //       icon: Icons.file_copy_sharp,
        //       fileCount: "2",
        //       title: "Document Sent",
        //       count: "25,000",
        //       backgroundColor: const Color(0xFFE3F2FD),
        //     ),
        //     DashboardCardNew(
        //       icon: Icons.file_copy_sharp,
        //       title: "Login Process",
        //       count: "30,000",
        //       fileCount: '4',
        //       backgroundColor: const Color(0xFFE1F5FE),
        //     ),
        //     DashboardCardNew(
        //       fileCount: '2',
        //       icon: Icons.file_copy_sharp,
        //       title: "Query",
        //       count: "0",
        //       backgroundColor: const Color(0xFFFFF8E1),
        //     ),
        //     DashboardCardNew(
        //       fileCount: "3",
        //       icon: Icons.file_copy_sharp,
        //       title: "Login Done",
        //       count: "30,000",
        //       backgroundColor: const Color(0xFFFCE4EC),
        //     ),
        //     const DashboardCardNew(
        //       icon: Icons.file_copy_sharp,
        //       fileCount: "2",
        //       title: "Verification Stage",
        //       count: "25,000",
        //       backgroundColor: const Color(0xFFE3F2FD),
        //     ),
        //     const DashboardCardNew(
        //       icon: Icons.file_copy_sharp,
        //       title: "Relook",
        //       count: "30,000",
        //       fileCount: '4',
        //       backgroundColor: const Color(0xFFE1F5FE),
        //     ),
        //     const DashboardCardNew(
        //       fileCount: '2',
        //       icon: Icons.file_copy_sharp,
        //       title: "Relook Done",
        //       count: "0",
        //       backgroundColor: const Color(0xFFFFF8E1),
        //     ),
        //     const DashboardCardNew(
        //       fileCount: "3",
        //       icon: Icons.file_copy_sharp,
        //       title: "Underwriting",
        //       count: "30,000",
        //       backgroundColor: const Color(0xFFFCE4EC),
        //     ),
        //     const DashboardCardNew(
        //       icon: Icons.file_copy_sharp,
        //       fileCount: "2",
        //       title: "Recommended",
        //       count: "25,000",
        //       backgroundColor: const Color(0xFFE3F2FD),
        //     ),
        //     const DashboardCardNew(
        //       icon: Icons.file_copy_sharp,
        //       title: "Approved",
        //       count: "30,000",
        //       fileCount: '4',
        //       backgroundColor: const Color(0xFFE1F5FE),
        //     ),
        //     const DashboardCardNew(
        //       fileCount: '2',
        //       icon: Icons.file_copy_sharp,
        //       title: "Distributed",
        //       count: "0",
        //       backgroundColor: const Color(0xFFFFF8E1),
        //     ),
        //
        //     // DashboardCard(
        //     //   icon: Icons.person,
        //     //   title: "TOTAL ATTEMPT",
        //     //   count: (data?.totalAttempt ?? 0).toString(),
        //     //   backgroundColor: const Color(0xFFE3F2FD),
        //     // ),
        //     // DashboardCard(
        //     //   icon: Icons.headphones,
        //     //   title: "CONTACTED",
        //     //   count: (data?.totalContact ?? 0).toString(),
        //     //   backgroundColor: const Color(0xFFE1F5FE),
        //     // ),
        //     // DashboardCard(
        //     //   icon: Icons.mic_off,
        //     //   title: "NOT CONTACTED",
        //     //   count: (data?.totalNocontact ?? 0).toString(),
        //     //   backgroundColor: const Color(0xFFFFF8E1),
        //     // ),
        //     // DashboardCard(
        //     //   icon: Icons.calendar_month,
        //     //   title: "Disbursement".toUpperCase(),
        //     //   count: (data?.totalLead ?? 0).toString(),
        //     //   backgroundColor: const Color(0xFFFCE4EC),
        //     // ),
        //     //
        //   ],
        // ),
        //
      ],
    );
  }
}
