import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/controllers/dashboard_controller.dart';
import 'package:smart_solutions/views/drawer.dart';
import 'package:smart_solutions/widget/custom_appbar.dart';

class CommonScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final bool showBack;
  final bool isDrawer;

  CommonScaffold({
    super.key,
    required this.title,
    required this.body,
    this.isDrawer = false,
    this.actions,
    this.showBack = true,
  });

  final DashboardController controller = Get.put(DashboardController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      drawer: isDrawer ? const CustomDrawer() : null,
      key: _scaffoldKey,
      body: Stack(
        children: [
          CurvedAppBar(
              title: title,
              actions: actions,
              showBack: showBack,
              leading: isDrawer
                  ? IconButton(
                      onPressed: () async {
                        controller.toggleDrawer();
                        controller.isDrawerOpen.value
                            ? _scaffoldKey.currentState!.openDrawer()
                            : _scaffoldKey.currentState!.closeDrawer();

                        // if (controller.isDrawerOpen.value) {
                        //   logOutput("opening drawer");
                        //   _scaffoldKey.currentState!.openDrawer();
                        // } else {
                        //   _scaffoldKey.currentState!.closeDrawer();

                        //   logOutput('closing drawer');
                        //   Get.back();
                        // }
                      },
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.white,
                      ))
                  : null),
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: body,
            ),
          ),
        ],
      ),
    );
  }
}
