import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smart_solutions/components/commons.dart';
import 'package:smart_solutions/services/firbase_notifications.dart';

class LocalNotificationService {
  static final LocalNotificationService localNotificationService =
      LocalNotificationService._init();
  factory LocalNotificationService() => localNotificationService;
  LocalNotificationService._init();
  static FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();
  //create channel
  static AndroidNotificationChannel channel = const AndroidNotificationChannel(
      "smart_solution", "Notifications",
      importance: Importance.high);

  ///init ios android
  static Future initLocalNotification() async {
    await plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    DarwinInitializationSettings iosInitSetting =
        const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    final InitializationSettings settings = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitSetting);
    await plugin.initialize(
      settings,
    );
  }

  // BigPictureStyleInformation bigPictureStyleInformation;
  ///Notifications details
  NotificationDetails notificationDetails(
          {StyleInformation? styleInfo, String? filePath}) =>
      NotificationDetails(
        android: AndroidNotificationDetails(
          icon: '@mipmap/ic_launcher',
          playSound: true,
          "smart_solution",
          "Notifications",
          importance: Importance.high,
          priority: Priority.high,
          ticker: 'New Message',
          largeIcon: filePath == null ? null : FilePathAndroidBitmap(filePath),
          // styleInformation: styleInfo////uncomment if largeicon required
        ),
        iOS: const DarwinNotificationDetails(),
      );
  static int id = 0;
  static Future<void> showNotification(
      {required String title,
      required String body,
      String? filePath,
      StyleInformation? info}) async {
    try {
      await plugin.show(
          id++,
          title,
          body,
          localNotificationService.notificationDetails(
              styleInfo: info, filePath: filePath));
    } catch (e) {
      customLog('error while displaying notification',
          name: "showNotification");
    }
    FireBaseNotificatinService.imagePath = null;
  }
}
