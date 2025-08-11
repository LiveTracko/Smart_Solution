import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_solutions/components/commons.dart';
import 'package:smart_solutions/controllers/login_controllers.dart';
import 'package:smart_solutions/services/api_service.dart';
import 'package:smart_solutions/services/local_notification_service.dart';
import 'package:http/http.dart' as http;

class FireBaseNotificatinService {
  final ApiService _apiService = ApiService(); // ApiService instance
  static final FireBaseNotificatinService notificationService =
      FireBaseNotificatinService._init();
  factory FireBaseNotificatinService() => notificationService;
  FireBaseNotificatinService._init();
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static String token = '';
  final LoginViewModel controller = Get.find();
  static String? imagePath;
  final LoginViewModel loginController = Get.put(LoginViewModel());
  @pragma('vm:entry-point')
  static initializeApp() async {
    try {
      await Firebase.initializeApp();
      await LocalNotificationService.initLocalNotification();
      bool? permission = await Permission.notification.isDenied.then((value) {
        if (value) {
          Permission.notification.request();
        }
        return null;
      });
      customLog('persmission for notification $permission');
      NotificationSettings request =
          await notificationService.firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      customLog('firebase request ${request.authorizationStatus}');
      await notificationService.getDeviceToken();
      FirebaseMessaging.onMessage.listen((v) async {
        customLog("this is foreground body ${v.notification?.body}");

        BigPictureStyleInformation? bigPictureStyle;
        if (v.notification?.android?.imageUrl != null ||
            v.notification?.apple?.imageUrl != null ||
            v.data['imageUrl'] != null) {
          bigPictureStyle = await getPicture(v: v);
        }
        return LocalNotificationService.showNotification(
            info: bigPictureStyle,
            filePath: imagePath,

            ///to show image on foreground
            title: v.data['title'] ?? v.notification?.title ?? '',
            body: v.data['body'] ?? v.notification?.body ?? '');
      });
    } catch (e) {
      customLog('error white initialing $e');
    }
  }

  Future<String> getDeviceToken() async {
  try {
    token = await firebaseMessaging.getToken() ?? '';
    customLog('DeviceToken $token ', name: "getDeviceToken");
    return token;
  } catch (e) {
    customLog('error while getting token $e');
    return '';
  }
}

  // getDeviceToken() async {
  //   try {
  //     token = await firebaseMessaging.getToken() ?? '';
  //     // (Platform.isAndroid
  //     //     ? await firebaseMessaging.getToken() ?? 'hh'
  //     //     : Platform.isIOS
  //     //         ? await firebaseMessaging.getAPNSToken()
  //     //         : await firebaseMessaging.getToken() ?? '') ??
  //     // '';
  //     //   loginController.login(token);
  //     customLog('DeviceToken $token ', name: "getDeviceToken");
  //   } catch (e) {
  //     customLog('error white getting token $e');
  //   }
  // }

  static Future<BigPictureStyleInformation?> getPicture(
      {RemoteMessage? v}) async {
    String? bigPicturePath;
    BigPictureStyleInformation? bigPictureStyle;
    try {
      String? imageUrl = v?.notification?.android?.imageUrl ??
          v?.notification?.apple?.imageUrl ??
          v?.data['imageUrl'];
      if (imageUrl != null && (imageUrl).isNotEmpty) {
        bigPicturePath = await downloadAndSaveFile(imageUrl);
      }
      if (bigPicturePath != null) {
        bigPictureStyle = BigPictureStyleInformation(
          FilePathAndroidBitmap(bigPicturePath),
          contentTitle: v?.notification?.title ?? '',
          summaryText: v?.notification?.body ?? '',
        );
      }
    } catch (e) {
      customLog('error While downloading and setting image $e');
    }
    return bigPictureStyle;
  }

  static Future<String?> downloadAndSaveFile(
    String url,
  ) async {
    try {
      var response = await http.get(Uri.parse(url));
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/notification_image.jpg';
      imagePath = filePath;
      File file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      return filePath;
    } catch (e) {
      customLog('error While downloading $e');
      return null;
    }
  }

  // void login(String username, String password, String datatype) async {
  //   FirebaseMessaging messaging = FirebaseMessaging.instance;
  //   String? fcmToken = await messaging.getToken();

  //   Map<String, dynamic> loginData = {
  //     'username': username.trim(),
  //     'password': password.trim(),
  //     'data_type': datatype,
  //     'fcm_token': fcmToken ?? '', // ✅ Add FCM token here
  //   };

  //   try {
  //     final response = await _apiService.postRequest(
  //       APIUrls.loginUrl,
  //       loginData,
  //       type: 'login',
  //     );

  //     print(response.body);
  //   } catch (e) {
  //     // logOutput('$e');
  //     Get.snackbar('Error', 'fetting error in fcm token.');
  //   } finally {
  //     // isLoading.value = false;
  //   }
  // }
}
