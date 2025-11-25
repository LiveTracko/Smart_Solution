import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_solutions/constants/static_stored_data.dart';
import 'package:smart_solutions/core/app_bindings.dart';
import 'package:smart_solutions/services/api_service.dart';
import 'package:smart_solutions/theme/app_theme.dart';
import 'package:smart_solutions/views/active_files.dart';
import 'package:smart_solutions/views/call_log.dart';
import 'package:smart_solutions/views/dialer_screen.dart';
import 'package:smart_solutions/views/listing_screen.dart';
import 'package:smart_solutions/views/login_request_screen.dart';
import 'package:smart_solutions/views/login_screen.dart';
import 'dashboard_screen.dart';

class MainScreen extends StatefulWidget {
  final int pageIndex;

  const MainScreen({
    Key? key,
    this.pageIndex = 0,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final PersistentTabController _controller;
  late final List<PersistentTabConfig> tabs;
  late int _previousIndex;
  bool _isCheckingAuth = false;

  @override
  void initState() {
    super.initState();
    _previousIndex = widget.pageIndex;
    _controller = PersistentTabController(initialIndex: widget.pageIndex);
    tabs = _buildTabs();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<bool> _ensureLoggedIn() async {
    if (_isCheckingAuth) return false;

    _isCheckingAuth = true;
    try {
      final isLoggedIn = await ApiService().checkUserStillLoggedIn();
      if (!isLoggedIn) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        if (mounted) {
          Get.off(() => LoginView(), binding: AppBinding());
        }
        return false;
      }
      return true;
    } finally {
      _isCheckingAuth = false;
    }
  }

  List<PersistentTabConfig> _buildTabs() {
    final isTelecaller = StaticStoredData.roleName == 'telecaller';

    if (isTelecaller) {
      return [
        PersistentTabConfig(
          screen: const DashboardScreen(),
          item: ItemConfig(
            icon: SvgPicture.asset(
              'assets/images/dashboard.svg',
              colorFilter: const ColorFilter.mode(
                CupertinoColors.activeBlue,
                BlendMode.srcIn,
              ),
            ),
            inactiveIcon: SvgPicture.asset(
              'assets/images/dashboard.svg',
              colorFilter: ColorFilter.mode(
                Colors.grey.shade600,
                BlendMode.srcIn,
              ),
            ),
            title: "Dashboard",
            activeForegroundColor: AppColors.primaryColor,
            inactiveForegroundColor: Colors.grey.shade600,
            textStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        PersistentTabConfig(
          screen: ActiveFiles(
            key: const ValueKey('leads_screen'),
            title: 'Leads',
            status: -1,
            isShowBack: false,
            isDrawer: true,
          ),
          item: ItemConfig(
            icon: SvgPicture.asset(
              'assets/images/leads.svg',
              colorFilter: const ColorFilter.mode(
                CupertinoColors.activeBlue,
                BlendMode.srcIn,
              ),
            ),
            inactiveIcon: SvgPicture.asset(
              'assets/images/leads.svg',
              colorFilter: ColorFilter.mode(
                Colors.grey.shade600,
                BlendMode.srcIn,
              ),
            ),
            title: "Leads",
            activeForegroundColor: AppColors.primaryColor,
            inactiveForegroundColor: Colors.grey.shade600,
            textStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        PersistentTabConfig(
          screen: const DialerScreen(key: ValueKey('dialer_screen')),
          item: ItemConfig(
            icon: SvgPicture.asset(
              'assets/images/fab.svg',
              fit: BoxFit.contain,
            ),
            iconSize: 50,
            title: "DIALER",
            textStyle:
                const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            activeColorSecondary: Colors.transparent,
            inactiveBackgroundColor: Colors.transparent,
          ),
        ),
        PersistentTabConfig(
          screen: const CallLogPage(
            key: ValueKey('call_log_screen'),
            title: 'Call Log',
          ),
          // FollowBackListScreen(key: const ValueKey('call_log_screen')),
          item: ItemConfig(
            icon: SvgPicture.asset(
              'assets/images/clock_fast_forward.svg',
              colorFilter: const ColorFilter.mode(
                CupertinoColors.activeBlue,
                BlendMode.srcIn,
              ),
            ),
            inactiveIcon: SvgPicture.asset(
              'assets/images/clock_fast_forward.svg',
              colorFilter: ColorFilter.mode(
                Colors.grey.shade600,
                BlendMode.srcIn,
              ),
            ),
            title: "Call Log",
            activeForegroundColor: AppColors.primaryColor,
            inactiveForegroundColor: Colors.grey.shade600,
            textStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        PersistentTabConfig(
          screen: LoginRequestScreen(
            key: const ValueKey('hrm_screen'),
            title: 'Login Request',

            isShowBack: false,
            isDrawer: true,
            //key: const ValueKey('hrm_screen')
          ),
          item: ItemConfig(
            icon: SvgPicture.asset(
              'assets/images/user_plus_grey.svg',
              colorFilter: const ColorFilter.mode(
                CupertinoColors.activeBlue,
                BlendMode.srcIn,
              ),
            ),
            inactiveIcon: SvgPicture.asset(
              'assets/images/user_plus_grey.svg',
              colorFilter: ColorFilter.mode(
                Colors.grey.shade600,
                BlendMode.srcIn,
              ),
            ),
            // icon: const Icon(Icons.co_present_outlined, size: 24),
            // inactiveIcon: const Icon(Icons.co_present_outlined, size: 24),
            title: "Request ",
            activeForegroundColor: AppColors.primaryColor,
            inactiveForegroundColor: Colors.grey.shade600,
            textStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // PersistentTabConfig(
        //   screen: LoginRequestScreen(
        //     key: const ValueKey('hrm_screen'),
        //     title: 'Login Request',

        //     isShowBack: false,
        //     isDrawer: true,
        //     //key: const ValueKey('hrm_screen')
        //   ),
        //   item: ItemConfig(
        //     icon: SvgPicture.asset(
        //       'assets/images/fingerprint.svg',
        //       colorFilter: const ColorFilter.mode(
        //         CupertinoColors.activeBlue,
        //         BlendMode.srcIn,
        //       ),
        //     ),
        //     inactiveIcon: SvgPicture.asset(
        //       'assets/images/fingerprint.svg',
        //       colorFilter: ColorFilter.mode(
        //         Colors.grey.shade600,
        //         BlendMode.srcIn,
        //       ),
        //     ),
        //     title: "Login Request",
        //     activeForegroundColor: AppColors.primaryColor,
        //     inactiveForegroundColor: Colors.grey.shade600,
        //     textStyle: const TextStyle(
        //       fontSize: 12,
        //       fontWeight: FontWeight.w500,
        //     ),
        //   ),
        // ),
      ];
    } else {
      return [
        PersistentTabConfig(
          screen: const DashboardScreen(key: ValueKey('dashboard_screen')),
          item: ItemConfig(
            icon: const Icon(Icons.dashboard_outlined, size: 24),
            inactiveIcon: const Icon(Icons.dashboard_outlined, size: 24),
            title: "Dashboard",
            activeForegroundColor: AppColors.primaryColor,
            inactiveForegroundColor: Colors.grey.shade600,
            textStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        PersistentTabConfig(
          screen: ActiveFiles(
            key: const ValueKey('leads_screen'),
            title: 'Leads',
            status: -1,
            isShowBack: false,
            isDrawer: true,
          ),
          item: ItemConfig(
            icon: const Icon(Icons.assignment_ind_outlined, size: 24),
            inactiveIcon: const Icon(Icons.assignment_ind_outlined, size: 24),
            title: "Leads",
            activeForegroundColor: AppColors.primaryColor,
            inactiveForegroundColor: Colors.grey.shade600,
            textStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        PersistentTabConfig(
          screen: const ListingScreen(key: ValueKey('listing_screen')),
          item: ItemConfig(
            icon: const Icon(Icons.list_alt_outlined, size: 24),
            inactiveIcon: const Icon(Icons.list_alt_outlined, size: 24),
            title: "Listing",
            activeForegroundColor: AppColors.primaryColor,
            inactiveForegroundColor: Colors.grey.shade600,
            textStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        PersistentTabConfig(
          screen: LoginRequestScreen(
            key: const ValueKey('hrm_screen'),
            title: 'Request',

            isShowBack: false,
            isDrawer: true,
            //key: const ValueKey('hrm_screen')
          ),
          item: ItemConfig(
            icon: const Icon(Icons.co_present_outlined, size: 24),
            inactiveIcon: const Icon(Icons.co_present_outlined, size: 24),
            title: "Request ",
            activeForegroundColor: AppColors.primaryColor,
            inactiveForegroundColor: Colors.grey.shade600,
            textStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: PersistentTabView(
          tabs: tabs,
          controller: _controller,
          navBarBuilder: (navBarConfig) => Style15BottomNavBar(
            navBarConfig: navBarConfig,
            height: 70,
            navBarDecoration: const NavBarDecoration(
              padding: EdgeInsets.zero,
              color: Colors.white12,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
          ),
          backgroundColor: Colors.white,
          onTabChanged: _onTabChanged,
          keepNavigatorHistory: false,
          stateManagement: true, // ⚠️ Changed to true for better state handling
          navBarOverlap: const NavBarOverlap.custom(),

          handleAndroidBackButtonPress: true,
          avoidBottomPadding: false,
          //     confineInSafeArea: true, // ⚠️ ADD THIS for safety
          screenTransitionAnimation: const ScreenTransitionAnimation(
            //     animateTabTransition: true,
            curve: Curves.ease,
            duration: Duration(milliseconds: 200),
          ),
        ),
      ),
    );
  }

  void _onTabChanged(int newIndex) async {
    if (newIndex == _previousIndex) return;

    final ok = await _ensureLoggedIn();
    if (!ok) {
      // Jump back to the previous tab if not authenticated
      Future.microtask(() {
        if (mounted && _controller.index != _previousIndex) {
          _controller.jumpToTab(_previousIndex);
        }
      });
      return;
    }
    _previousIndex = newIndex;
  }
}
