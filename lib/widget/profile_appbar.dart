import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_solutions/views/login_request_form.dart';

class ProfileCurvedAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String name;
  final String role;
  final String imagePath;
  final bool showBack;
  final VoidCallback? onBack;

  const ProfileCurvedAppBar({
    Key? key,
    required this.name,
    required this.role,
    required this.imagePath,
    this.showBack = true,
    this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
        child: Container(
            height: preferredSize.height,
            decoration: const BoxDecoration(color: AppColors.primaryColor),
            child: SafeArea(
              bottom: false,
              child: SizedBox(
                height: preferredSize.height,
                child: Transform.translate(
                  offset: Offset(0, -10.h), //
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                    child: Row(
                      children: [
                        if (showBack)
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back,
                                  color: Colors.white),
                              onPressed: onBack ??
                                  () => Navigator.of(context).maybePop(),
                            ),
                          ),
                        if (!showBack) SizedBox(width: 8.w),

                        // Avatar
                        Container(
                          width: 100.w,
                          height: 100.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: (imagePath.isNotEmpty
                                  ? NetworkImage(imagePath)
                                  : const AssetImage(
                                          "assets/images/app_login.png")
                                      as ImageProvider),
                            ),
                          ),
                        ),

                        SizedBox(width: 20.w),

                        // Name + Role
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                role,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )));
  }

  @override
  Size get preferredSize => Size.fromHeight(200.h);
}
