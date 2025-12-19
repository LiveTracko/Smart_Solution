import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/views/otp_view.dart';
import 'package:smart_solutions/widget/common_form_field.dart';
import 'package:smart_solutions/widget/text_style.dart';

class ForgetView extends StatefulWidget {
  const ForgetView({super.key});

  @override
  ForgetViewState createState() => ForgetViewState();
}

class ForgetViewState extends State<ForgetView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        resizeToAvoidBottomInset: true,

        /// 🔽 BUTTON FIXED AT BOTTOM
        bottomNavigationBar: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
          child: SizedBox(
            height: 45.h,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Get.to(
                    () => const OtpView(),
                    transition: Transition.rightToLeft,
                    duration: const Duration(milliseconds: 300),
                  );
                }
              },
              child: const Text("Verify"),
            ),
          ),
        ),

        body: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: 100.h,
            top: 32.h,
            left: 16.w,
            right: 16.w,
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
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    "Forgot Password",
                    style: AppTextStyle.headerTitle1.copyWith(fontSize: 24.sp),
                  ),
                ),

                SizedBox(height: 8.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    "Enter your registered email address or mobile number to receive an OTP and reset your password",
                    style: AppTextStyle.normalHeadingTxt.copyWith(fontSize: 14.sp),
                  ),
                ),

                SizedBox(height: 24.h),

                CommonTextField(
                  label: "Enter Email Or Mobile No.",
                  controller: emailController,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return "This field is required";
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
