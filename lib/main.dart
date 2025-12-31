import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import ScreenUtil
import 'package:get/get.dart';
import 'package:smart_solutions/components/commons.dart';
import 'package:smart_solutions/controllers/internet_checker.dart';
import 'package:smart_solutions/controllers/theme_controller.dart'; // <-- import ThemeController
import 'package:smart_solutions/services/firbase_notifications.dart';
import 'package:smart_solutions/services/local_notification_service.dart';
 import 'core/app_bindings.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🌐 Global controllers (alive for whole app)
  Get.put(ConnectivityController(), permanent: true);
  Get.put(ThemeController(), permanent: true); // 🎨 Theme controller

  // 🔔 Firebase & notifications
  await FireBaseNotificatinService.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await LocalNotificationService.initLocalNotification();

  // 🔒 Force portrait mode
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
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔥 Get theme controller
    final ThemeController themeController = Get.find<ThemeController>();

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        // 🔁 Obx listens to theme changes
        return Obx(() => GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Smart Solutions',

              // 🚦 Routing
              initialBinding: AppBinding(),
              initialRoute: AppRoutes.splashScreen,
              getPages: AppRoutes.pages,

              // 🎨 Dynamic theme
              theme: ThemeData(
                fontFamily: 'Poppins',
                primaryColor: themeController.primaryColor.value,
                scaffoldBackgroundColor: Colors.white,
                cardColor: Colors.white,
                appBarTheme: AppBarTheme(
                  backgroundColor: themeController.primaryColor.value,
                  foregroundColor: Colors.white,
                  elevation: 0,
                ),
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeController.primaryColor.value,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(
                        vertical: 5, horizontal: 20),
                  ),
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                      textStyle: const TextStyle(color: Colors.white)),
                ),
                colorScheme: ColorScheme.fromSeed(
                    seedColor: themeController.primaryColor.value,
                    brightness: Brightness.light),
              ),
            ));
      },
    );
  }
}
