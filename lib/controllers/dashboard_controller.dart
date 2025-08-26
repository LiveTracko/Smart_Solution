import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_solutions/components/commons.dart';
import 'package:smart_solutions/constants/api_urls.dart';
import 'package:smart_solutions/constants/static_stored_data.dart';
import 'package:smart_solutions/models/call_time_model.dart';
import 'package:smart_solutions/models/dashBoardToday_model.dart';
import 'package:smart_solutions/models/getGroupStatus.dart';
import 'package:smart_solutions/services/api_service.dart';
import '../components/dashboardgrid.dart';
import '../constants/services.dart';

class DashboardController extends GetxController {
  var dateRangeList = <DateTime?>[].obs;
  final ApiService _apiService = ApiService();
  GetCallTimeModel callTimeModel = GetCallTimeModel();
  var isLoading = true.obs;
  RxString totalValActive = "0".obs;
  RxString totalNoValActive = "0".obs;
  RxString totalPicked = "0".obs;
  RxString totalNotPicked = "0".obs;
  RxString totalDuration = "0".obs;
  RxString dateRange = ''.obs;
  RxString formattedDate = ''.obs;
  formateDate() {
    if (dateRangeList.length > 1 && dateRangeList.isNotEmpty) {
      String firstDate = '';
      String secondDate = '';
      firstDate =
          DateFormat('d MMM yy').format(dateRangeList.first ?? DateTime.now());
      secondDate =
          DateFormat('d MMM yy').format(dateRangeList.last ?? DateTime.now());
      formattedDate.value = "$firstDate - $secondDate";
    } else {
      String firstDate = '';
      firstDate =
          DateFormat('d MMM yy').format(dateRangeList.first ?? DateTime.now());
      formattedDate.value = firstDate;
    }
  }

  var isDrawerOpen = false.obs;
  List<StatusGroupModel> activeList = [];
  List<StatusGroupModel> inActiveList = [];
  List<TotalContact> totalContact = [];
  List<TotalNoContact> totalNoContact = [];
  List<TotalAttemptContact> totalAttempt = [];
  RxList<CallGraphModel> finalActiveCallList = <CallGraphModel>[].obs;
  RxList<CallGraphModel> finalActiveNoCallList = <CallGraphModel>[].obs;
  RxList<CallGraphModel> finalTotalAttemptCallList = <CallGraphModel>[].obs;

  // Store today's and monthly data sepa rately
  var todayData = DashboardTodayModel().obs;
  var monthlyData = DashboardMonthlyModel().obs;
  Map<String, dynamic> timeMap = {
    "10 AM": null,
    "11 AM": null,
    "12 PM": null,
    "1 PM": null,
    "2 PM": null,
    "3 PM": null,
    "4 PM": null,
    "5 PM": null,
    "6 PM": null,
    "7 PM": null
  };
  Map<String, dynamic> timeMapInactive = {
    "10 AM": null,
    "11 AM": null,
    "12 PM": null,
    "1 PM": null,
    "2 PM": null,
    "3 PM": null,
    "4 PM": null,
    "5 PM": null,
    "6 PM": null,
    "7 PM": null
  };
  Map<String, dynamic> activeCallMap = {};
  Map<String, dynamic> activeNoCallMap = {};
  Map<String, dynamic> activeAttemptMap = {};

  // List<SalesData> data = [
  //   SalesData(month: 'jan', data: 300),
  //   SalesData(month: 'Feb', data: 400),
  //   SalesData(month: 'Mar', data: 100),
  //   SalesData(month: 'Apr', data: 600),
  //   SalesData(month: 'May', data: 200),
  //   SalesData(month: 'Jun', data: 300),
  //   SalesData(month: 'Jul', data: 400),
  //   SalesData(month: 'Aug', data: 100),
  //   SalesData(month: 'Sep', data: 700),
  //   SalesData(month: 'Oct', data: 200),
  //   SalesData(month: 'Nov', data: 1000),
  //   SalesData(month: 'Dec', data: 200),
  // ];

  List<Color> tileColors = const [
    Color(0xFFE3F2FD),
    Color(0xFFE1F5FE),
    Color(0xFFFFF8E1),
    Color(0xFFFCE4EC)
  ];

  Color getTileColor(int index) {
    try {
      return tileColors[index % tileColors.length];
    } catch (e) {
      customLog('error while parsing color');
      return tileColors[0];
    }
  }

  @override
  void onInit() async {
    isDrawerOpen.value = false;

    Future.microtask(() async {
      fetchDashboardData(true); // Fetch monthly data
      fetchDashboardData(false); // Fetch today’s data
      await getActiveData(status: 1);
      await getActiveData(status: 2);
      getTimeGraph();
    });

    super.onInit();
  }

  Future<void> fetchDashboardData(bool isMonthly) async {
    try {
      //   isLoading(true);
      DateTime now = DateTime.now();
      DateTime startDate = DateTime(now.year, now.month, 1);

      String dateRange = isMonthly
          ? '${DateFormat('dd-MM-yyyy').format(startDate)},${DateFormat('dd-MM-yyyy').format(now)}'
          : '${DateFormat('dd-MM-yyyy').format(now)},${DateFormat('dd-MM-yyyy').format(now)}';

      final requestData = {
        'telecaller_id': StaticStoredData.userId,
        'daterange': dateRange,
      };

      final response =
          await _apiService.postRequest(APIUrls.todaysDashboard, requestData);

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);

        if (isMonthly) {
          monthlyData.value = DashboardMonthlyModel.fromJson(decodedResponse);
        } else {
          todayData.value = DashboardTodayModel.fromJson(decodedResponse);
          //      totalDuration.value = todayData
        }
      } else if (response.statusCode == 204) {
        Get.snackbar(
          'Opps',
          'No Data Found',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
          duration: const Duration(seconds: 3),
        );
      } else {
        throw Exception('Server returned ${response.statusCode}');
      }
    } catch (e) {
      // Get.snackbar(
      //   'Error',
      //   'Failed to load dashboard data',
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.red[100],
      //   colorText: Colors.red[900],
      //   duration: const Duration(seconds: 3),
      // );
      logOutput('Error fetching dashboard data: $e');
    } finally {
      //  isLoading(false);
    }
  }

  void toggleDrawer() {
    isDrawerOpen.value = !isDrawerOpen.value;
  }

  getActiveData({required int status}) async {
    isLoading(true);
    try {
      final requestData = {
        "status": "$status",
        "telecaller_id": StaticStoredData.userId
      };
      final response =
          await _apiService.postRequest(APIUrls.getUserGroup, requestData);
      final decodedResponse = json.decode(response.body);
      GetStatusGroupModel model = GetStatusGroupModel.fromJson(decodedResponse);
      customLog('this is status ${StaticStoredData.userId}');
      customLog('this is data ${model.data?.length}');
      if (status == 1) {
        activeList.clear();
        for (var i in model.data ?? <StatusGroupModel>[]) {
          if (i.totalLoanAmount != 0 &&
              i.totalLoanAmount != '0' &&
              i.totalLoanAmount != null) {
            activeList.add(i);
          }
        }
        // activeList = model.data ?? [];
        getTotalPriceCount(activeList, 1);
        customLog('this is data lis len ${activeList.length}');
      } else {
        inActiveList.clear();
        for (var i in model.data ?? <StatusGroupModel>[]) {
          if (i.totalLoanAmount != 0 &&
              i.totalLoanAmount != '0' &&
              i.totalLoanAmount != null) {
            inActiveList.add(i);
          }
        }
        // inActiveList = model.data ?? [];
        getTotalPriceCount(inActiveList, 2);
        customLog('this is data lis len ${inActiveList.length}');
      }
    } catch (e) {
      customLog("error while parsing data $e", name: "getActiveData");
      Get.snackbar(
        'Error',
        'Failed to load data',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: const Duration(seconds: 3),
      );
    }
    isLoading(false);
  }

  String priceFormatter(dynamic price) {
    String val = '';
    // if (price == "null") return '0';
    try {
      final formatter = NumberFormat.decimalPattern('en_IN');
      dynamic pr;
      // int? pr = int.tryParse(price);
      if (price.contains('.')) {
        pr = int.tryParse("$price");
      } else {
        pr = double.tryParse("$price");
      }
      if (pr != 0 || price != '0' || pr != '0.0' || pr != 0.0) {
        val = formatter.format(pr);
      } else if (pr == null || pr == 'null') {
        // double? p = double.tryParse(price);
        // val = formatter.format(p);
      } else {
        val = price;
      }
    } catch (e) {
      customLog("unable to format price $e", name: "priceFormatter ");
      val = price;
    }
    return val;
  }

  getTotalPriceCount(List<StatusGroupModel> list, int status) {
    if (status == 1) {
      totalValActive.value = '0';
    } else {
      totalNoValActive.value = '0';
    }
    int totalI = status == 1
        ? int.tryParse(totalValActive.value) ?? 0
        : int.tryParse(totalNoValActive.value) ?? 0;
    double totalD = status == 1
        ? double.tryParse(totalValActive.value) ?? 0
        : double.tryParse(totalNoValActive.value) ?? 0;
    for (var i in list) {
      try {
        int? val = int.tryParse("${i.totalLoanAmount}");
        // double? vals = double.tryParse("${i.totalLoanAmount}");
        if (val != null) {
          totalI += val;
        } else {
          // totalValActive.value = '0.0';
        }
      } catch (e) {
        customLog("unable to add prices $e", name: "getTotalPriceCount");
      }
    }
    status == 1
        ? totalValActive.value = totalI != 0
            ? "$totalI"
            : totalD != 0
                ? "$totalD"
                : "0.0"
        : totalNoValActive.value = totalI != 0
            ? "$totalI"
            : totalD != 0
                ? "$totalD"
                : "0.0";
  }

  getTimeGraph() async {
    timeMap = dateRangeList.length > 1 && dateRange.isNotEmpty
        ? {}
        : {
            "10 AM": null,
            "11 AM": null,
            "12 PM": null,
            "1 PM": null,
            "2 PM": null,
            "3 PM": null,
            "4 PM": null,
            "5 PM": null,
            "6 PM": null,
            "7 PM": null
          };
    isLoading(true);
    try {
      final requestData = {
        "telecaller_id": StaticStoredData.userId,
        "daterange": dateRange.value
      };
      totalContact.clear();
      totalNoContact.clear();
      totalAttempt.clear();
      final response =
          await _apiService.postRequest(APIUrls.getTimeGraphData, requestData);
      final decodedResponse = json.decode(response.body);
      callTimeModel = GetCallTimeModel.fromJson(decodedResponse);
      totalContact =
          callTimeModel.callTimeModel?.totalContact ?? <TotalContact>[];
      totalNoContact =
          callTimeModel.callTimeModel?.totalNocontact ?? <TotalNoContact>[];
      totalAttempt = callTimeModel.callTimeModel?.totalAttemptContact ??
          <TotalAttemptContact>[];
      totalDuration.value =
          callTimeModel.callTimeModel!.totalDuration.toString();
      try {
        activeCallMap.clear();
        activeNoCallMap.clear();
        activeAttemptMap.clear();
        finalActiveNoCallList.clear();
        finalActiveCallList.clear();
        finalTotalAttemptCallList.clear();
        activeCallMap = dateRangeList.length > 1 && dateRange.isNotEmpty
            ? {}
            : {
                "10 AM": null,
                "11 AM": null,
                "12 PM": null,
                "1 PM": null,
                "2 PM": null,
                "3 PM": null,
                "4 PM": null,
                "5 PM": null,
                "6 PM": null,
                "7 PM": null
              };
        activeNoCallMap = dateRangeList.length > 1 && dateRange.isNotEmpty
            ? {}
            : {
                "10 AM": null,
                "11 AM": null,
                "12 PM": null,
                "1 PM": null,
                "2 PM": null,
                "3 PM": null,
                "4 PM": null,
                "5 PM": null,
                "6 PM": null,
                "7 PM": null
              };
        activeAttemptMap = dateRangeList.length > 1 && dateRange.isNotEmpty
            ? {}
            : {
                "10 AM": null,
                "11 AM": null,
                "12 PM": null,
                "1 PM": null,
                "2 PM": null,
                "3 PM": null,
                "4 PM": null,
                "5 PM": null,
                "6 PM": null,
                "7 PM": null
              };
        //2025-06-09 10:55:07
        final timeFormat = DateFormat('yyyy-mm-dd hh:mm:ss');

        ///totalcontacted
        totalContact.sort((TotalContact a, TotalContact b) {
          DateTime dateA = timeFormat.parse(a.created ?? '');
          DateTime dateB = timeFormat.parse(b.created ?? '');
          return dateA.compareTo(dateB);
        });

        for (var i in totalContact) {
          // int vals = 1; //int.tryParse(i.callStatus ?? '0') ?? 0;
          if (dateRangeList.length > 1 && dateRange.isNotEmpty) {
            DateTime dateTime =
                DateTime.parse(i.created ?? "${DateTime.now()}");
            String formattedTime = DateFormat('d MMM yy').format(dateTime);
            i.created = formattedTime;
          } else {
            DateTime dateTime =
                DateTime.parse(i.created ?? "${DateTime.now()}");
            String formattedTime = DateFormat('h a').format(dateTime);
            i.created = formattedTime;
          }
          int val = activeCallMap[i.created] ?? -0;
          activeCallMap[i.created ?? ''] = val + 1;
        }
        totalPicked.value = "${totalContact.length}";
        activeCallMap.forEach((k, v) {
          finalActiveCallList.add(CallGraphModel(time: k, data: v));
        });
        ////totalnocaonta
        customLog('totalcontact ${totalContact.length}');
        totalNoContact.sort((TotalNoContact a, TotalNoContact b) {
          DateTime dateA = timeFormat.parse(a.created ?? '');
          DateTime dateB = timeFormat.parse(b.created ?? '');
          return dateA.compareTo(dateB);
        });
        for (var i in totalNoContact) {
          if (dateRangeList.length > 1 && dateRange.isNotEmpty) {
            DateTime dateTime =
                DateTime.parse(i.created ?? "${DateTime.now()}");
            String formattedTime = DateFormat('d MMM yy').format(dateTime);
            i.created = formattedTime;
          } else {
            DateTime dateTime =
                DateTime.parse(i.created ?? "${DateTime.now()}");
            String formattedTime = DateFormat('h a').format(dateTime);
            i.created = formattedTime;
          }
          // int vals = 1; // int.tryParse(i.callStatus ?? '0') ?? 0;
          int val = activeNoCallMap[i.created] ?? 0;
          activeNoCallMap[i.created ?? ''] = val + 1;
          // totalInactiveVal += val;
          // totalInactiveVal.value = "$totalVal";
        }

        totalNotPicked.value = "${totalNoContact.length}";
        customLog('totalcontact ${totalNoContact.length}');

        activeNoCallMap.forEach((k, v) {
          finalActiveNoCallList.add(CallGraphModel(time: k, data: v));
        });
        //
        totalAttempt.sort((TotalAttemptContact a, TotalAttemptContact b) {
          DateTime dateA = timeFormat.parse(a.created ?? '');
          DateTime dateB = timeFormat.parse(b.created ?? '');
          return dateA.compareTo(dateB);
        });
        customLog('this is list len ${totalAttempt.length}');

        for (var i in totalAttempt) {
          customLog("${i.callStatus} tjs is i");
          if (dateRangeList.length > 1 && dateRange.isNotEmpty) {
            DateTime dateTime =
                DateTime.parse(i.created ?? "${DateTime.now()}");
            String formattedTime = DateFormat('d MMM yy').format(dateTime);
            i.created = formattedTime;
          } else {
            DateTime dateTime =
                DateTime.parse(i.created ?? "${DateTime.now()}");
            String formattedTime = DateFormat('h a').format(dateTime);
            i.created = formattedTime;
          }
          int val = activeAttemptMap[i.created] ?? 0;
          activeAttemptMap[i.created ?? ''] = val + 1;
        }
        activeAttemptMap.forEach((k, v) {
          finalTotalAttemptCallList.add(CallGraphModel(time: k, data: v));
        });
      } catch (e) {
        totalNoContact =
            callTimeModel.callTimeModel?.totalNocontact ?? <TotalNoContact>[];
        totalContact =
            callTimeModel.callTimeModel?.totalContact ?? <TotalContact>[];
        totalAttempt = callTimeModel.callTimeModel?.totalAttemptContact ??
            <TotalAttemptContact>[];
        customLog("error while sorting data $e", name: "getTimeGraph");
      }
      customLog(
          'this is Response ${callTimeModel.callTimeModel?.totalAttempt}');
    } catch (e) {
      customLog("error while parsing data $e", name: "getTimeGraph");
    }
    isLoading(false);
  }

  Widget buildChunkedGrid(List<StatusGroupModel> items, int itemsPerRow) {
    List<Widget> rows = [];

    for (int i = 0; i < items.length; i += itemsPerRow) {
      final rowItems = items.sublist(
        i,
        i + itemsPerRow > items.length ? items.length : i + itemsPerRow,
      );

      rows.add(SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: rowItems.asMap().entries.map((entry) {
            int idx = i + entry.key;
            return Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: DashboardCardNew(
                fileCount: entry.value.filecount ?? '0',
                icon: Icons.file_copy_sharp,
                title: entry.value.StatusGroupModelName ?? '',
                count: "${entry.value.totalLoanAmount ?? '0'}",
                backgroundColor: rows.length % 2 == 0
                    ? getTileColor(idx)
                    : getTileColor(idx + 1),
              ),
            );
          }).toList(),
        ),
      ));
    }
    return Column(
      children: List.generate(
          rows.length,
          (ind) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: rows[ind],
              )),
    );
  }
}

class CallGraphModel {
  int? data;
  String? time;
  CallGraphModel({this.data, this.time});
}
