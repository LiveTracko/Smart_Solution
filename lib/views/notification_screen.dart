import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_solutions/controllers/notification_controller.dart';
import 'package:smart_solutions/theme/app_theme.dart';
import 'package:smart_solutions/widget/common_scaffold.dart';
import 'package:smart_solutions/widget/loading_page.dart';
import 'package:smart_solutions/widget/no_data_available.dart';

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
              : notificationController.notificationData.isEmpty
                  ? const NoDataAvailable()
                  : ListView.builder(
                      itemCount: notificationController.notificationData.length,
                      itemBuilder: (context, index) {
                        DateTime parsedDate = DateTime.parse(
                            notificationController.notificationData[index]
                                ['created']);
                        String date = DateFormat('dd MMM yyyy hh:mm:ss a')
                            .format(parsedDate);

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

  // showNotificationData(
  //     String date, String fileStatus, String status, String msg) {
  //   return Card(
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //     elevation: 4,
  //     margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //     child: Padding(
  //       padding: const EdgeInsets.all(16),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text(
  //                 date,
  //                 style: TextStyle(
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 16.sp,
  //                   color: Colors.black87,
  //                 ),
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 6),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text(
  //                 fileStatus, // Date
  //                 style: TextStyle(
  //                   color: AppColors.secondayColor,
  //                   fontSize: 14.sp,
  //                 ),
  //               ),
  //               const SizedBox(height: 8),
  //               Text(
  //                 status,
  //                 style: TextStyle(
  //                   color: AppColors.secondayColor,
  //                   fontSize: 14.sp,
  //                 ),
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 6),
  //           Text(
  //             msg,
  //             style: TextStyle(
  //               color: AppColors.secondayColor,
  //               fontSize: 14.sp, // Responsive font size
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget showNotificationData(
      String date, String fileStatus, String status, String msg) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 6,
      shadowColor: Colors.black26,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TOP STRIP
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryColor.withOpacity(0.9),
                  AppColors.primaryColor.withOpacity(0.6),
                ],
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.notifications, color: Colors.white, size: 20),
                Text(
                  date,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // MAIN CONTENT
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.folder,
                            color: AppColors.primaryColor, size: 20),
                        const SizedBox(width: 6),
                        SizedBox(
                          child: Text(
                            fileStatus,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.check_circle,
                            color: Colors.green.shade600, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          status,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  msg,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
