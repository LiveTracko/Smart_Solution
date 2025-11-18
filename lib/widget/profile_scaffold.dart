import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_solutions/controllers/dashboard_controller.dart';
import 'package:smart_solutions/controllers/profile_controller.dart';
import 'package:smart_solutions/views/drawer.dart';
import 'package:smart_solutions/widget/profile_appbar.dart';

class ProfileScaffold extends StatefulWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final bool showBack;
  final bool isDrawer;
  final double height;
  final double bodyPadding;

  ProfileScaffold({
    super.key,
    required this.title,
    required this.body,
    this.isDrawer = false,
    this.actions,
    this.showBack = true,
    this.height = 30,
    this.bodyPadding = 100,
  });

  @override
  State<ProfileScaffold> createState() => _ProfileScaffoldState();
}

class _ProfileScaffoldState extends State<ProfileScaffold> {
  String _userName = "";
  String _role = '';
  final DashboardController controller = Get.put(DashboardController());

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final ProfileController _profileController = Get.find<ProfileController>();

  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? "name";
      _role = prefs.getString('roleName') ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      drawer: widget.isDrawer ? const CustomDrawer() : null,
      key: _scaffoldKey,
      body: Stack(
        children: [
          ProfileCurvedAppBar(
            name: _userName.toString(),
            role: _role,
            imagePath: _profileController.profileImageUrl.toString(),
            showBack: widget.showBack,
          ),
          Padding(
            padding: EdgeInsets.only(top: widget.bodyPadding.h),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: widget.body,
            ),
          ),
        ],
      ),
    );
  }
}
