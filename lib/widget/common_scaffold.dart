import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/controllers/dashboard_controller.dart';
import 'package:smart_solutions/theme/app_theme.dart';
import 'package:smart_solutions/views/drawer.dart';
import 'package:smart_solutions/widget/custom_appbar.dart';

class CommonScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final bool showBack;
  final bool isDrawer;
  final double height;
  final double bodyPadding;

  
  final Widget? bottomNavigationBar;

  CommonScaffold({
    super.key,
    required this.title,
    required this.body,
    this.isDrawer = false,
    this.actions,
    this.showBack = true,
    this.height = 15,
    this.bodyPadding = 80,

    
    this.bottomNavigationBar,
  });

  final DashboardController controller = Get.put(DashboardController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.backgroundColor,
      resizeToAvoidBottomInset: true,

      drawerEnableOpenDragGesture: false,
      drawer: isDrawer ? const CustomDrawer() : null,

      appBar: CurvedAppBar(
        title: title,
        actions: actions,
        showBack: showBack,
        height: height,
        leading: isDrawer
            ? IconButton(
                onPressed: () async {
                  controller.toggleDrawer();
                  controller.isDrawerOpen.value
                      ? _scaffoldKey.currentState!.openDrawer()
                      : _scaffoldKey.currentState!.closeDrawer();
                },
                icon: SvgPicture.asset('assets/images/menu.svg'),
              )
            : null,
      ),

      body: SafeArea(child: body),

      
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
