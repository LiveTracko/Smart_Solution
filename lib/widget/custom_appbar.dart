import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_solutions/views/login_request_form.dart';

class CurvedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool? showBack;
  final double height;

  const CurvedAppBar({
    Key? key,
    required this.title,
    this.showBack = true,
    this.actions,
    this.leading,
    this.height = 30,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(0xFF356eff),
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
                  SizedBox(width: 48.w),
              ],
            ),
          ),
        ));
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + height.h);
}
