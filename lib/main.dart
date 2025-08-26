import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import ScreenUtil
import 'package:get/get.dart';
import 'package:smart_solutions/components/commons.dart';
import 'package:smart_solutions/controllers/internet_checker.dart';
import 'package:smart_solutions/services/firbase_notifications.dart';
import 'package:smart_solutions/services/local_notification_service.dart';
import 'core/app_bindings.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Create and keep controller alive for whole app
  Get.put(ConnectivityController()); // Global instance

  await FireBaseNotificatinService.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await LocalNotificationService.initLocalNotification();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage v) async {
  await Firebase.initializeApp();

  customLog("this is background body ${v.notification?.body}");
  // String img = '';
  // if ((v.notification?.android?.imageUrl != null &&
  //         (v.notification?.android?.imageUrl ?? '').isNotEmpty) ||
  //     v.notification?.apple?.imageUrl != null &&
  //         (v.notification?.android?.imageUrl ?? '').isNotEmpty ||
  //     (v.data['imageUrl'] != null && v.data['imageUrl'].isNotEmpty)) {
  //   img = await FireBaseNotificatinService.downloadAndSaveFile(
  //           (v.notification?.android?.imageUrl) ??
  //               v.notification?.apple?.imageUrl ??
  //               v.data['imageUrl'] ??
  //               '') ??
  //       '';
  // }
  // BigPictureStyleInformation? bigPictureStyle;
  // bigPictureStyle = await FireBaseNotificatinService.getPicture(v: v);
  // LocalNotificationService.showNotification(
  //     info: bigPictureStyle,
  //     filePath: img,

  //     ///to show image on foreground
  //     title: v.data['title'] ?? v.notification?.title ?? '',
  //     body: v.data['body'] ?? v.notification?.body ?? '');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return GetMaterialApp(
          initialBinding: AppBinding(),
          initialRoute: AppRoutes.splashScreen,
          getPages: AppRoutes.pages,
          debugShowCheckedModeBanner: false,
          title: 'Smart Solutions',
          theme: AppTheme.lightTheme,
        );
      },
    );
  }
}
