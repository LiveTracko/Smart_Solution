import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_solutions/controllers/notification_controller.dart';
import 'package:smart_solutions/theme/app_theme.dart';
import 'package:smart_solutions/widget/common_scaffold.dart';
import 'package:smart_solutions/widget/loading_page.dart';

class NotificationSCreen extends StatefulWidget {
  const NotificationSCreen({super.key});

  @override
  State<NotificationSCreen> createState() => _NotificationSCreenState();
}

class _NotificationSCreenState extends State<NotificationSCreen> {
  final NotificationController notificationController =
      Get.put(NotificationController());
  @override
  void initState() {
    notificationController.getNotificationList();
    notificationController.updateNotificatioData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
        title: 'Notifications',
        showBack: true,
        // backgroundColor: Colors.grey[50],
        // appBar: AppBar(
        //   automaticallyImplyLeading: true,
        //   centerTitle: true,
        //   title: const Text(
        //     'Notifications',
        //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        //   ),
        // ),
        body: Obx(
          () => notificationController.isLoading.value
              ? const Center(child: LoadingPage())
              : ListView.builder(
                  itemCount: notificationController.notificationData.length,
                  itemBuilder: (context, index) {
                    DateTime parsedDate = DateTime.parse(notificationController
                        .notificationData[index]['created']);
                    String date =
                        DateFormat('dd MMM yyyy hh:mm:ss a').format(parsedDate);
                    return showNotificationData(
                        date,
                        notificationController.notificationData[index]
                                ['title'] ??
                            '',
                        notificationController.notificationData[index]
                                ['status'] ??
                            '',
                        notificationController.notificationData[index]
                                ['message'] ??
                            '');
                  },
                ),
        ));
  }

  showNotificationData(
      String date, String fileStatus, String status, String msg) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  fileStatus, // Date
                  style: TextStyle(
                    color: AppColors.secondayColor,
                    fontSize: 14.sp,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  status,
                  style: TextStyle(
                    color: AppColors.secondayColor,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              msg,
              style: TextStyle(
                color: AppColors.secondayColor,
                fontSize: 14.sp, // Responsive font size
              ),
            ),
          ],
        ),
      ),
    );
  }
}
