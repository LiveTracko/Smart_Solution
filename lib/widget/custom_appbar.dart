import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/controllers/theme_controller.dart';
import 'package:smart_solutions/theme/app_theme.dart';

class CurvedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool? showBack;
  final double height;

  CurvedAppBar({
    Key? key,
    required this.title,
    this.showBack = true,
    this.actions,
    this.leading,
    this.height = 30,
  }) : super(key: key);

  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        color: themeController.primaryColor.value,
        child: SafeArea(
          bottom: false,
          child: SizedBox(
            height: preferredSize.height,
            child: Row(
              children: [
                // Leading (menu/back)
                showBack == true
                    ? IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppColors.backgroundColor,
                        ),
                        onPressed: () => Navigator.of(context).maybePop(),
                      )
                    : (leading ?? SizedBox(width: 55.w)),

                // Title
                Expanded(
                  child: Center(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp, // responsive font size
                      ),
                    ),
                  ),
                ),

                // Actions
                if (actions != null && actions!.isNotEmpty)
                  Row(children: actions!)
                else
                  SizedBox(width: 50.w),
              ],
            ),
          ),
        ),
      );
    });
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + height.h);
}
