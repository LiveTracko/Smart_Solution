import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_solutions/controllers/dailer_controller.dart';
import 'package:smart_solutions/views/notification_screen.dart';
import 'package:smart_solutions/widget/common_rows_card.dart';
import 'package:smart_solutions/widget/common_scaffold.dart';
import 'package:smart_solutions/widget/common_title_card.dart';
import 'package:smart_solutions/widget/header_title.dart';
import 'package:smart_solutions/widget/loading_page.dart';
import 'package:smart_solutions/widget/text_style.dart';

class CallBackData extends StatelessWidget {
  final String title;
  final String headerTitle;
  final dynamic controller;
  final List<dynamic> Function() getDataList;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  CallBackData({
    super.key,
    required this.title,
    required this.headerTitle,
    required this.controller,
    required this.getDataList,
  });

  final DialerController _dialerController = Get.find<DialerController>();

  final CommonRows _commonRows = CommonRows();

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: title,
      isDrawer: false,
      showBack: true,
      actions: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: IconButton(
            onPressed: () => Get.to(() => const NotificationSCreen()),
            icon: SvgPicture.asset('assets/images/notification.svg'),
          ),
        ),
      ],
      key: _scaffoldKey,
      body: Column(children: [
        SizedBox(
          width: double.infinity,
          child:
              HeaderTitle(title: headerTitle, style: AppTextStyle.headerTitle),
        ),
        Expanded(child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: LoadingPage());
          }
          final dataList = getDataList(); // ✅ Use the provided function
          if (dataList.isEmpty) {
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
          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              var data = dataList[index];
              debugPrint(
                  'FOLLOW UP FINAL => ${formatDateTime(data.followupDate)}');

              return CommonTitleCard(
                leading: Obx(
                  () => SvgPicture.asset(
                    'assets/images/phone_call.svg',
                    color: themeController.primaryColor.value,
                  ),
                ),
                followupdate: formatDateTime(data.followupDate),
                onLeadingTap: () {
                  if (!_dialerController.isCallOngoing.value) {
                    _dialerController.makePhoneCall(
                        data.contactNumber.toString(),
                        followUpId: data.id ?? '');
                  }

                  controller.mobile.value = data.contactNumber ?? "";
                  controller.bankName.value = data.bankName ?? "";
                  controller.customerName.value = data.customerName ?? "";
                  _dialerController.customerName.value =
                      data.customerName ?? '';

                  _dialerController.datatype.value = '';
                  controller.remark.value = data.remark ?? '';
                  _dialerController.followup_id.value = data.id ?? '';
                  _dialerController.excel_id.value = '';
                },
                title: data.customerName.toString(),
                subtitle: formatDateTime(data.entryDate),
                amount: maskFirst6Digits(data.contactNumber.toString()),
                children: [
                  _commonRows.buildSingleRow(
                      'assets/images/message_dots_circle.svg',
                      data.remark ?? 'NA'),
                ],
              );
            },
          );
        }))
      ]),
    );
  }

  String maskFirst6Digits(String number) {
    if (number.length < 6) return number;
    return 'xxxxxx${number.substring(6)}';
  }

  String formatDateTime(dynamic date) {
    if (date == null) return '--';

    try {
      if (date is DateTime) {
        return DateFormat('dd/MM/yyyy').format(date);
      }

      String dateString = date.toString().trim();

      // 🔑 Normalize yyyy-M-d → yyyy-MM-dd
      final parts = dateString.split('-');
      if (parts.length == 3) {
        final year = parts[0];
        final month = parts[1].padLeft(2, '0');
        final day = parts[2].padLeft(2, '0');
        dateString = '$year-$month-$day';
      }

      final dt = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(dt);
    } catch (e) {
      debugPrint('DATE FORMAT ERROR => $date');
      return '--';
    }
  }
}
