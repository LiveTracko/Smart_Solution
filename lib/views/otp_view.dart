import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:smart_solutions/theme/app_theme.dart';
import 'package:smart_solutions/views/reset_password.dart';
import 'package:smart_solutions/widget/text_style.dart';

import '../controllers/forget_password_controller.dart';

class OtpView extends StatefulWidget {
  final String mobileNo;
  const OtpView({super.key, required this.mobileNo});

  @override
  State<OtpView> createState() => _OtpViewState();
}

ForgetPasswordController _forgetPasswordController =
    Get.find<ForgetPasswordController>();

class _OtpViewState extends State<OtpView> {
  String enteredOtp = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,

        // 🔹 BUTTON FIXED AT BOTTOM
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
            left: 16.w,
            right: 16.w,
            bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? 16.h : 24.h,
          ),
          child: SizedBox(
            height: 45.h,
            child: ElevatedButton(
              onPressed: () async {
                final bool isValid = await _forgetPasswordController.verifyOtp(
                    widget.mobileNo, enteredOtp);

                if (isValid) {
                  Get.to(
                    () => ChangePasswordScreen(mobileNo: widget.mobileNo),
                    transition: Transition.rightToLeft,
                    duration: const Duration(milliseconds: 300),
                  );
                } else {
                  Get.snackbar(
                    "Invalid OTP",
                    "Please enter the correct 4 digit OTP",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }

                // if (enteredOtp.length == 4) {
                //   // 🔐 Call verify OTP API here
                //   Get.to(
                //     () => const ChangePasswordScreen(),
                //     transition: Transition.rightToLeft,
                //   );
                // } else {
                //   Get.snackbar(
                //     "Invalid OTP",
                //     "Please enter 4 digit OTP",
                //     snackPosition: SnackPosition.BOTTOM,
                //   );
                // }
              },
              child: _forgetPasswordController.isverifyingotp.value
                  ? const CircularProgressIndicator(
                      color: AppColors.appBarTextColor,
                    )
                  : const Text("Verify"),
            ),
          ),
        ),

        // 🔹 SCROLLABLE BODY
        body: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 16.w,
            right: 16.w,
            top: 24.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20.h),

              // IMAGE
              Align(
                alignment: Alignment.topCenter,
                child: SvgPicture.asset(
                  "assets/images/forgot_password.svg",
                  height: 220.h,
                  width: 220.w,
                ),
              ),

              SizedBox(height: 24.h),

              Text(
                "Verify Code",
                style: AppTextStyle.headerTitle1.copyWith(fontSize: 24.sp),
              ),

              SizedBox(height: 8.h),

              Text(
                "Enter the OTP we sent to your email or phone.",
                style: AppTextStyle.normalHeadingTxt.copyWith(fontSize: 14.sp),
              ),

              SizedBox(height: 32.h),

              // ENTER OTP TEXT
              Text(
                "Enter OTP",
                style: AppTextStyle.textfieldabove.copyWith(fontSize: 16.sp),
              ),

              SizedBox(height: 12.h),

              // OTP PIN
              Pinput(
                length: 4,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    enteredOtp = value;
                  });
                },
                defaultPinTheme: PinTheme(
                  width: 60.w,
                  height: 60.h,
                  textStyle: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                ),
                focusedPinTheme: PinTheme(
                  width: 60.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: Colors.green.shade200,
                      width: 2.w,
                    ),
                  ),
                ),
                submittedPinTheme: PinTheme(
                  width: 60.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.blue, width: 2.w),
                  ),
                ),
              ),

              SizedBox(height: 120.h),
            ],
          ),
        ),
      ),
    );
  }
}
