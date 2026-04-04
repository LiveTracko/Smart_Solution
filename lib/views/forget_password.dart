import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/theme/app_theme.dart';
import 'package:smart_solutions/views/otp_view.dart';
import 'package:smart_solutions/widget/common_form_field.dart';
import 'package:smart_solutions/widget/text_style.dart';

import '../controllers/forget_password_controller.dart';

class ForgetView extends StatefulWidget {
  const ForgetView({super.key});

  @override
  ForgetViewState createState() => ForgetViewState();
}

class ForgetViewState extends State<ForgetView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  ForgetPasswordController forgetPasswordController =
      Get.put(ForgetPasswordController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
          child: SizedBox(
            height: 45.h,
            child: Obx(
              () => ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final data = await forgetPasswordController
                        .verifyMobileNo(emailController.text);

                    if (data == true) {
                      Get.to(
                        () => OtpView(mobileNo: emailController.text),
                        transition: Transition.rightToLeft,
                        duration: const Duration(milliseconds: 300),
                      );
                    }
                  }
                },
                child: forgetPasswordController.isverifying.value
                    ? const CircularProgressIndicator(
                        color: AppColors.appBarTextColor,
                      )
                    : const Text("Verify"),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: 100.h,
            top: 32.h,
            left: 5.w,
            right: 5.w,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20.h),
                Align(
                  alignment: Alignment.topCenter,
                  child: SvgPicture.asset(
                    "assets/images/forgot_password.svg",
                    height: 220.h,
                    width: 220.w,
                  ),
                ),
                SizedBox(height: 24.h),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Text(
                    "Forgot Password",
                    style: AppTextStyle.headerTitle1.copyWith(fontSize: 24.sp),
                  ),
                ),
                SizedBox(height: 8.h),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Text(
                    "Enter your registered email address or mobile number to receive an OTP and reset your password",
                    style: AppTextStyle.normalHeadingTxt
                        .copyWith(fontSize: 12.5.sp),
                  ),
                ),
                SizedBox(height: 24.h),
                CommonTextField(
                  label: "Enter Mobile No.",
                  controller: emailController,
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return "This field is required";
                    }
                    final value = v.trim();
                    if (RegExp(r'^\d+$').hasMatch(value)) {
                      if (value.length != 10) {
                        return "Mobile Number must be 10 digits";
                      }
                      return null;
                    }
                    final emailRegex =
                        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!emailRegex.hasMatch(value)) {
                      return "Enter a valid email or 10 digit mobile number";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
