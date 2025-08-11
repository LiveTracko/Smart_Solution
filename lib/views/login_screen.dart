import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_solutions/theme/app_theme.dart';
import '../components/button_component.dart';
import '../controllers/login_controllers.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  final LoginViewModel controller = Get.find();

  final _formKey = GlobalKey<FormState>(); // Form key for validation
  bool _isObscured = true; // State for password visibility

  String? _selectedLoanType; // 'secure' or 'unsecure'

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background image covering entire screen
          Positioned.fill(
            child: Image.asset(
              'assets/images/login_background.png', // your background image path
              fit: BoxFit.cover,
            ),
          ),

          // First SVG at top (grey)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SvgPicture.asset(
              'assets/images/login_grey.svg',
              width: size.width,
              fit: BoxFit.cover,
            ),
          ),

          // Second SVG at top overlapping (blue)
          Positioned(
            top: size.height * 0.0,
            left: 0,
            right: 0,
            child: SvgPicture.asset(
              'assets/images/login_blue.svg',
              width: size.width,
              fit: BoxFit.cover,
            ),
          ),

          // Scrollable login form content
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                      height: size.height * 0.2), // Space so form is below SVGs
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 10.h), // Moved logo slightly up
                        Image.asset(
                          "assets/images/logo.png",
                          height: 250.h,
                          width: 250.w,
                        ),
                        SizedBox(height: 10.h), // Space after logo

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: Text(
                            "Welcome back \nlogin to your account",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        SizedBox(height: 15.h),

                        // Loan type selection containers in a Row BELOW welcome text
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedLoanType = 'secure';
                                        controller.secureType.value = 1;
                                      });
                                    },
                                    child: Container(
                                      height: 50.h,
                                      decoration: BoxDecoration(
                                        color: _selectedLoanType == 'secure'
                                            ? Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.2)
                                            : Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                        border: Border.all(
                                          color: _selectedLoanType == 'secure'
                                              ? Theme.of(context).primaryColor
                                              : Colors.grey,
                                          width: 2,
                                        ),
                                      ),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/images/login_homeloan_secure.png',
                                              height: 24.h,
                                              width: 24.w,
                                            ),
                                            SizedBox(width: 8.w),
                                            Text(
                                              "Home Loan\n   Secure",
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                color:
                                                    _selectedLoanType ==
                                                            'secure'
                                                        ? Theme.of(context)
                                                            .primaryColor
                                                        : Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15.w),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedLoanType = 'unsecure';
                                        controller.secureType.value = 0;
                                      });
                                    },
                                    child: Container(
                                      height: 50.h,
                                      decoration: BoxDecoration(
                                        color: _selectedLoanType == 'unsecure'
                                            ? Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.2)
                                            : Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                        border: Border.all(
                                          color: _selectedLoanType == 'unsecure'
                                              ? Theme.of(context).primaryColor
                                              : Colors.grey,
                                          width: 2,
                                        ),
                                      ),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/images/login_personalloan_unsecure.png',
                                              height: 24.h,
                                              width: 24.w,
                                            ),
                                            SizedBox(width: 8.w),
                                            Text(
                                              "Personal Loan\n    Unsecure",
                                              style: TextStyle(
                                                color: _selectedLoanType ==
                                                        'unsecure'
                                                    ? Theme.of(context)
                                                        .primaryColor
                                                    : Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),

                        SizedBox(height: 20.h),

                        // Username TextField
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: TextFormField(
                            style:
                                const TextStyle(color: AppColors.primaryColor),
                            controller: controller.usernameController,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              labelStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16.r)),
                              ),
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.black54,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your username';
                              }
                              return null;
                            },
                          ),
                        ),

                        SizedBox(height: 10.h),

                        // Password TextField
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: 10.h, left: 15.w, right: 15.w, top: 15.h),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.black),
                            controller: controller.passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16.r)),
                              ),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.black54,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscured
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscured = !_isObscured;
                                  });
                                },
                              ),
                            ),
                            obscureText: _isObscured,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              } else if (value.length < 6) {
                                return 'Password must be at least 6 characters long';
                              }
                              return null;
                            },
                          ),
                        ),

                        // Forgot Password text
                        Padding(
                          padding: EdgeInsets.only(
                              right: 15.w, top: 4.h, bottom: 8.h),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                // Your forgot password logic here
                                Get.snackbar(
                                  'Forgot Password',
                                  'Reset link sent to your email',
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              },
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 24.h),

                        // Login button or loading indicator
                        Obx(() {
                          return controller.isLoading.value
                              ? const CircularProgressIndicator()
                              : ButtonComponent(
                                  text: 'Login',
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      if (_selectedLoanType == null) {
                                        Get.snackbar(
                                          "Error",
                                          "Please select loan type",
                                          snackPosition: SnackPosition.BOTTOM,
                                        );
                                        return;
                                      }
                                      controller.login();
                                      controller.usernameController.clear();
                                      controller.passwordController.clear();
                                    }
                                  },
                                );
                        }),
                        SizedBox(height: 16.h),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
