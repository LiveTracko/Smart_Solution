import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_solutions/constants/static_stored_data.dart';
import 'package:smart_solutions/core/app_bindings.dart';
import 'package:smart_solutions/services/api_service.dart';
import 'package:smart_solutions/views/dailer_scree.dart';
import 'package:smart_solutions/views/followBackList.dart';
import 'package:smart_solutions/views/listing_screen.dart';
import 'package:smart_solutions/views/login_request_screen.dart';
import 'package:smart_solutions/views/login_screen.dart';
import 'package:smart_solutions/views/report_page.dart';
import '../theme/app_theme.dart';
import 'dashboard_screen.dart';
import 'data_entry_screen.dart' show DataEntryViewScreen;

class MainScreen extends StatefulWidget {
  int pageIndex;

  MainScreen({
    Key? key,
    this.pageIndex = 0,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final PageController _pageController;
  late int _selectedIndex;
  String? roleName = '';

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.pageIndex;
    _pageController = PageController(initialPage: _selectedIndex);
  }

  // final List<Widget> _screens = [
  //   DashboardScreen(),
  //   DataEntryViewScreen(),
  //   StaticStoredData.roleName == 'telecaller'
  //       ? DialerScreen()
  //       : const ReportPage(),
  //   StaticStoredData.roleName == 'telecaller'
  //       ? FollowBackListScreen()
  //       : const ListingScreen(),
  //   LoginRequestScreen()
  // ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: 5,
        itemBuilder: (context, index) {
          switch (index) {
            case 0:
              return const DashboardScreen();
            case 1:
              return DataEntryViewScreen();
            case 2:
              return StaticStoredData.roleName == 'telecaller'
                  ? const DialerScreen()
                  : const ReportPage();
            case 3:
              return StaticStoredData.roleName == 'telecaller'
                  ? FollowBackListScreen()
                  : const ListingScreen();
            case 4:
              return LoginRequestScreen();
            default:
              throw Exception(
                  'Invalid page index: $index'); // 🚫 strict restriction
            //      return const SizedBox.shrink();
          }
        },
        //  children: _screens,

        onPageChanged: (index) async {
          if (await ApiService().checkUserStillLoggedIn()) {
            if (index >= 0 && index < 5) {
              setState(() {
                _selectedIndex = index;
              });
            }
          } else {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.clear();
            Get.off(() => const LoginView(), binding: AppBinding());
          }
        },
      ),
      //_screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        indicatorColor: AppColors.backgroundColor,
        backgroundColor: AppColors.backgroundColor,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) async {
          if (index >= 0 && index < 5) {
            if (await ApiService().checkUserStillLoggedIn()) {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
              );
            }
          } else {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.clear();
            Get.off(const LoginView(), binding: AppBinding());
          }
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(
              Icons.dashboard_outlined,
              color: AppColors.secondayColor,
            ),
            selectedIcon: Icon(
              Icons.dashboard_outlined,
              color: AppColors.primaryColor,
            ),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: SvgPicture.asset(
              'assets/images/bottom_bar_leads.svg',
              width: 24,
              height: 24,
              color: AppColors.secondayColor, // unselected color
            ),
            selectedIcon: SvgPicture.asset(
              'assets/images/bottom_bar_leads.svg',
              width: 24,
              height: 24,
              color: AppColors.primaryColor, // selected color
            ),
            label: 'Leads',
          ),
          NavigationDestination(
            icon: Icon(
              StaticStoredData.roleName == 'telecaller'
                  ? Icons.dialpad_outlined
                  : Icons.assignment,
              color: AppColors.secondayColor,
            ),
            selectedIcon: Icon(
              StaticStoredData.roleName == 'telecaller'
                  ? Icons.dialpad
                  : Icons.assignment,
              color: AppColors.primaryColor,
            ),
            label:
                StaticStoredData.roleName == 'telecaller' ? 'Dialer' : 'Report',
          ),
          NavigationDestination(
            icon: const Icon(
              Icons.list_alt_outlined,
              color: AppColors.secondayColor,
            ),
            selectedIcon: const Icon(
              Icons.list_alt_outlined,
              color: AppColors.primaryColor,
            ),
            label:
                StaticStoredData.roleName == 'telecaller' ? 'List' : 'Listing',
          ),
          NavigationDestination(
            icon: SvgPicture.asset(
              'assets/images/bottom_bar_request.svg',
              width: 24,
              height: 24,
              color: AppColors.secondayColor, // unselected color
            ),
            selectedIcon: SvgPicture.asset(
              'assets/images/bottom_bar_request.svg', // use the same SVG here
              width: 24,
              height: 24,
              color: AppColors.primaryColor, // selected color
            ),
            label: 'Request',
          ),
        ],
      ),
    );
  }
}
