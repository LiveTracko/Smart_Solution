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

  CommonScaffold({
    super.key,
    required this.title,
    required this.body,
    this.isDrawer = false,
    this.actions,
    this.showBack = true,
    this.height = 30,
    this.bodyPadding = 100,
  });

  final DashboardController controller = Get.put(DashboardController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  icon: SvgPicture.asset('assets/images/menu.svg')
                  // const Icon(
                  //   Icons.menu,
                  //   color: Colors.white,
                  // )
                  )
              : null),
      key: _scaffoldKey,
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.backgroundColor,
        ),
        child: SafeArea(child: body),
      ),
    );
  }
}
