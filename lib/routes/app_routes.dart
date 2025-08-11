import 'package:get/get.dart';
import 'package:smart_solutions/views/dashboard_screen.dart';
import 'package:smart_solutions/views/navigationbar.dart';
import 'package:smart_solutions/views/splash_screen.dart';
import '../views/login_screen.dart';

class AppRoutes {
  static const String splashScreen = '/splashScreen';
  static const String navigationscreen = '/navscreen';
  static const String login = '/login';
  static const String home = '/home';

  static List<GetPage> pages = [
    GetPage(name: splashScreen, page: () => const SplashScreen()),
    GetPage(
      name: navigationscreen,
      page: () {
        final args = Get.arguments as Map<String, dynamic>? ?? {};
        final int pageIndex = args['pageIndex'] ?? 0;
        final String phone = args['phone']?.toString() ?? '';

        return MainScreen(
          pageIndex: pageIndex,
        );
      },
    ),
    GetPage(name: login, page: () => const LoginView()),
    GetPage(name: home, page: () => DashboardScreen()),
  ];
}
