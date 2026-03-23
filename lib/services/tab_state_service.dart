import 'package:get/get.dart';

enum MainTab { dashboard, leads, dialer, callLog, listing, request }

class MainTabService extends GetxService {
  var currentTab = MainTab.dashboard.obs;

  final Map<MainTab, DateTime> _lastRefresh = {};

  bool shouldRefresh(MainTab tab, {int seconds = 3}) {
    final last = _lastRefresh[tab];
    if (last == null) return true;

    return DateTime.now().difference(last).inSeconds > seconds;
  }

  void markRefreshed(MainTab tab) {
    _lastRefresh[tab] = DateTime.now();
  }
}
