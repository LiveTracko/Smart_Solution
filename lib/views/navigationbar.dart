import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_solutions/constants/static_stored_data.dart';
import 'package:smart_solutions/core/app_bindings.dart';
import 'package:smart_solutions/services/api_service.dart';
import 'package:smart_solutions/views/active_files.dart';
import 'package:smart_solutions/views/dialer_screen.dart';
import 'package:smart_solutions/views/followBackList.dart';
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
  late int _previousIndex;

  @override
  void initState() {
    super.initState();
    _previousIndex = widget.pageIndex;
    _controller = PersistentTabController(initialIndex: widget.pageIndex);
  }

  Future<bool> _ensureLoggedIn() async {
    if (await ApiService().checkUserStillLoggedIn()) return true;

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.off(() => const LoginView(), binding: AppBinding());
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final tabs = _buildTabs();

    return Scaffold(
      body: PersistentTabView(
        tabs: tabs,
        controller: _controller,
        navBarBuilder: (navBarConfig) => Style13BottomNavBar(
          navBarConfig: navBarConfig,
          height: 60,
          navBarDecoration: const NavBarDecoration(
            padding: EdgeInsets.zero,
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          ),
        ),
        backgroundColor: Colors.red,
        onTabChanged: _onTabChanged,
        keepNavigatorHistory: true,
        stateManagement: false,
        handleAndroidBackButtonPress: true,
        avoidBottomPadding: false,
      ),
    );
  }

  List<PersistentTabConfig> _buildTabs() {
    final isTelecaller = StaticStoredData.roleName == 'telecaller';

    if (isTelecaller) {
      return [
        // Dashboard
        PersistentTabConfig(
          screen: const DashboardScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.dashboard_outlined, size: 24),
            title: "Dashboard",
            //  activeColorPrimary: AppColors.primaryColor,
            //  inactiveColorPrimary: Colors.grey.shade600,
            textStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // Leads
        PersistentTabConfig(
          screen: ActiveFiles(
            title: 'Leads',
            status: -1,
            isShowBack: false,
            isDrawer: true,
          ),
          item: ItemConfig(
            icon: const Icon(Icons.assignment_ind_outlined, size: 24),
            title: "Leads",
            //  activeColorPrimary: AppColors.primaryColor,
            //  inactiveColorPrimary: Colors.grey.shade600,
            textStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // DIALER (Center tab with different styling)
        PersistentTabConfig(
          screen: const DialerScreen(),
          item: ItemConfig(
            icon: SvgPicture.asset('assets/images/fab.svg'),

            title: "DIALER",
            // activeColorPrimary: AppColors.primaryColor,
            // inactiveColorPrimary: AppColors.primaryColor,
            textStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Call Log
        PersistentTabConfig(
          screen: FollowBackListScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.schedule_outlined, size: 24),
            title: "Call Log",
            //  activeColorPrimary: AppColors.primaryColor,
            //  inactiveColorPrimary: Colors.grey.shade600,
            textStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // HRM
        PersistentTabConfig(
          screen: LoginRequestScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.co_present_outlined, size: 24),
            title: "HRM",
            //  activeColorPrimary: AppColors.primaryColor,
            //  inactiveColorPrimary: Colors.grey.shade600,
            textStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ];
    } else {
      // Non-telecaller version
      return [
        PersistentTabConfig(
          screen: const DashboardScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.dashboard_outlined, size: 24),
            title: "Dashboard",
            //  activeColorPrimary: AppColors.primaryColor,
            //  inactiveColorPrimary: Colors.grey.shade600,
          ),
        ),
        PersistentTabConfig(
          screen: ActiveFiles(
            title: 'Leads',
            status: -1,
            isShowBack: false,
            isDrawer: true,
          ),
          item: ItemConfig(
            icon: const Icon(Icons.assignment_ind_outlined, size: 24),
            title: "Leads",
            //  activeColorPrimary: AppColors.primaryColor,
            //  inactiveColorPrimary: Colors.grey.shade600,
          ),
        ),
        PersistentTabConfig(
          screen: const ListingScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.list_alt_outlined, size: 24),
            title: "Listing",
            //  activeColorPrimary: AppColors.primaryColor,
            //  inactiveColorPrimary: Colors.grey.shade600,
          ),
        ),
        PersistentTabConfig(
          screen: LoginRequestScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.co_present_outlined, size: 24),
            title: "HRM",
            //  activeColorPrimary: AppColors.primaryColor,
            //  inactiveColorPrimary: Colors.grey.shade600,
          ),
        ),
      ];
    }
  }

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:smart_solutions/constants/static_stored_data.dart';
// import 'package:smart_solutions/core/app_bindings.dart';
// import 'package:smart_solutions/services/api_service.dart';
// import 'package:smart_solutions/views/active_files.dart';
// import 'package:smart_solutions/views/dialer_screen.dart';
// import 'package:smart_solutions/views/followBackList.dart';
// import 'package:smart_solutions/views/listing_screen.dart';
// import 'package:smart_solutions/views/login_request_screen.dart';
// import 'package:smart_solutions/views/login_screen.dart';
// import '../theme/app_theme.dart';
// import 'dashboard_screen.dart';

// // ignore: must_be_immutable
// class MainScreen extends StatefulWidget {
//   int pageIndex;

//   MainScreen({
//     Key? key,
//     this.pageIndex = 0,
//   }) : super(key: key);

//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   late final PageController _pageController;
//   late int _selectedIndex;
//   String? roleName = '';

//   @override
//   void initState() {
//     super.initState();
//     _selectedIndex = widget.pageIndex;
//     _pageController = PageController(initialPage: _selectedIndex);
//   }

//   final pages = [
//     const DashboardScreen(),
//     ActiveFiles(
//       title: 'Leads',
//       status: -1,
//       isShowBack: false,
//       isDrawer: true,
//     ),
//     // DataEntryViewScreen(),
//     if (StaticStoredData.roleName == 'telecaller') DialerScreen(),
//     if (StaticStoredData.roleName == 'telecaller')
//       //  LoginRequestScreen()
//       FollowBackListScreen()
//     else
//       const ListingScreen(),
//     // ProfilePage()
//     LoginRequestScreen(),
//   ];
//   // final List<Widget> _screens = [
//   //   DashboardScreen(),
//   //   DataEntryViewScreen(),
//   //   StaticStoredData.roleName == 'telecaller'
//   //       ? DialerScreen()
//   //       : const ReportPage(),
//   //   StaticStoredData.roleName == 'telecaller'
//   //       ? FollowBackListScreen()
//   //       : const ListingScreen(),
//   //   LoginRequestScreen()
//   // ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PageView.builder(
//         controller: _pageController,
//         itemCount: pages.length,
//         itemBuilder: (context, index) => pages[index],

//         onPageChanged: (index) async {
//           if (await ApiService().checkUserStillLoggedIn()) {
//             if (index >= 0 && index < 5) {
//               setState(() {
//                 _selectedIndex = index;
//               });
//             }
//           } else {
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.clear();
//             Get.off(() => const LoginView(), binding: AppBinding());
//           }
//         },
//       ),
//       //_screens[_selectedIndex],
//       bottomNavigationBar: NavigationBar(
//         indicatorColor: AppColors.backgroundColor,
//         backgroundColor: AppColors.backgroundColor,

//         selectedIndex: _selectedIndex,
//         onDestinationSelected: (int index) async {
//           if (index >= 0 && index < 5) {
//             if (await ApiService().checkUserStillLoggedIn()) {
//               _pageController.animateToPage(
//                 index,
//                 duration: const Duration(milliseconds: 200),
//                 curve: Curves.easeInOut,
//               );
//             }
//           } else {
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.clear();
//             Get.off(const LoginView(), binding: AppBinding());
//           }
//         },
//         destinations: [
//           const NavigationDestination(
//             icon: Icon(
//               Icons.dashboard_outlined,
//               color: AppColors.secondayColor,
//             ),
//             selectedIcon: Icon(
//               Icons.dashboard,
//               color: AppColors.primaryColor,
//             ),
//             label: 'Dashboard',
//           ),
//           const NavigationDestination(
//             icon: Icon(
//               Icons.assignment_ind,
//               color: AppColors.secondayColor,
//             ),
//             selectedIcon: Icon(
//               Icons.assignment_ind,
//               color: AppColors.primaryColor,
//             ),
//             label: 'Leads',
//           ),
//           if (StaticStoredData.roleName == 'telecaller')
//             const NavigationDestination(
//                 icon: Icon(Icons.dialpad_outlined,
//                     color: AppColors.secondayColor),
//                 selectedIcon:
//                     Icon(Icons.dialpad, color: AppColors.primaryColor),
//                 label: 'Dialer'),
//           NavigationDestination(
//             icon: Icon(
//                 StaticStoredData.roleName == 'telecaller'
//                     ? Icons.schedule
//                     : Icons.list_alt,
//                 color: AppColors.secondayColor),
//             selectedIcon: Icon(
//                 StaticStoredData.roleName == 'telecaller'
//                     ? Icons.schedule
//                     : Icons.list_alt,
//                 color: AppColors.primaryColor),
//             label: StaticStoredData.roleName == 'telecaller'
//                 ? 'Call Log'
//                 : 'Listing',
//           ),
//           const NavigationDestination(
//             icon: Icon(
//               Icons.co_present_rounded,
//               color: AppColors.secondayColor,
//             ),
//             selectedIcon: Icon(
//               Icons.co_present_rounded,
//               color: AppColors.primaryColor,
//             ),
//             label: 'Request',
//           ),
//         ],
//       ),
//     );
//   }
// }

  void _onTabChanged(int newIndex) async {
    final ok = await _ensureLoggedIn();
    if (!ok) {
      _controller.jumpToTab(_previousIndex);
      return;
    }
    _previousIndex = newIndex;
  }
}
