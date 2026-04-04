import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_solutions/controllers/forget_password_controller.dart';

import 'package:smart_solutions/controllers/reset_password_controller.dart';
import 'package:smart_solutions/routes/app_routes.dart';
import 'package:smart_solutions/widget/common_form_field.dart';
import 'package:smart_solutions/widget/text_style.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String mobileNo;
  const ChangePasswordScreen({super.key, required this.mobileNo});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final ResetPasswordController controller = Get.put(ResetPasswordController());

  final _formKey = GlobalKey<FormState>();

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String userName = "User Name";
  final ForgetPasswordController _forgetPasswordController =
      Get.find<ForgetPasswordController>();

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? "Rinka Chaurasiya";
    });
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final bool isReset = await _forgetPasswordController.resetPassword(
          widget.mobileNo, newPasswordController.text);

      if (isReset) {
        Get.offAllNamed(AppRoutes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,

        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
            left: 16.w,
            right: 16.w,
            bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? 16.h : 24.h,
          ),
          child: SizedBox(
            height: 48.h,
            child: ElevatedButton(
              onPressed: _submit,
              child: _forgetPasswordController.isresetting.value
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text(
                      "Change Password",
                      style: TextStyle(fontSize: 16),
                    ),
            ),
          ),
        ),

        /// 🔹 BODY
        body: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 16.w,
            right: 16.w,
            top: 40.h, // moves whole layout down
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// 👤 PROFILE ROW
                Row(
                  children: [
                    Container(
                      height: 48.w,
                      width: 48.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade200,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      userName,
                      style: AppTextStyle.body.copyWith(fontSize: 16.sp),
                    ),
                  ],
                ),

                SizedBox(height: 24.h),

                /// SVG IMAGE
                Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/reset.png',
                      height: 200.h,
                    )
                    // child: SvgPicture.asset(
                    //   "assets/images/reset_password.svg",
                    //   height: 150.h,
                    // ),
                    ),

                SizedBox(height: 15.h),

                Text(
                  "Reset Password",
                  style: AppTextStyle.headerTitle1.copyWith(fontSize: 22.sp),
                ),

                SizedBox(height: 8.h),

                Text(
                  "Create a new password in order to log in to your Account.",
                  style:
                      AppTextStyle.normalHeadingTxt.copyWith(fontSize: 14.sp),
                ),

                SizedBox(height: 32.h),

                /// NEW PASSWORD
                CommonTextField(
                  label: "Enter New Password",
                  controller: newPasswordController,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return "Password is required";
                    }
                    if (v.length < 6) {
                      return "Minimum 6 characters required";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 10.h),

                /// CONFIRM PASSWORD
                CommonTextField(
                  label: "Confirm New Password",
                  controller: confirmPasswordController,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return "Confirm password is required";
                    }
                    if (v != newPasswordController.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 120.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
