import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/services/firbase_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_solutions/theme/app_theme.dart';
import '../components/button_component.dart';
import '../controllers/login_controllers.dart';

class ForgetView extends StatefulWidget {
  const ForgetView({super.key});

  @override
  ForgetViewState createState() => ForgetViewState();
}

class ForgetViewState extends State<ForgetView> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  bool _isObscured = true; // State for password visibility

  String? _selectedLoanType; // 'secure' or 'unsecure'
  String? token;

  @override
  void initState() {
    getDeviceToken();
    super.initState();
  }

  getDeviceToken() async {
    await FireBaseNotificatinService().getDeviceToken();
    token = FireBaseNotificatinService.token;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const Color selectedColor = Color(0xFF356EFF);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(minHeight: size.height, maxWidth: size.width),
          child: IntrinsicHeight(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/login_background.png',
                    fit: BoxFit.cover,
                  ),
                ),
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

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child: Form(
                            key: _formKey,
                            child: Column(children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15.w),
                                child: Text(
                                  "Change Password",
                                  style: TextStyle(
                                    fontSize: 21.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Image.asset('assets/images/forgot_password.png'),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const CircleAvatar(
                                      radius: 25,
                                      // ignore: sort_child_properties_last
                                      child: Text(
                                        'A',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: AppColors.primaryColor,
                                    ),
                                    SizedBox(
                                      width: 25.w,
                                    ),
                                    Text(
                                      "Ashwini Mishra",
                                      style: TextStyle(
                                          fontSize: 20.sp,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 25.h),

                              // Password TextField
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(color: Colors.black),
                                  // controller: controller.passwordController,
                                  maxLength: 6,
                                  decoration: InputDecoration(
                                    hintText: 'Enter New Password',
                                    labelStyle:
                                        const TextStyle(color: Colors.black),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.r)),
                                    ),
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SvgPicture.asset(
                                        'assets/images/password.svg',
                                        height: 20,
                                        width: 20,
                                      ),
                                    ),
                                    prefixIconConstraints: const BoxConstraints(
                                      minWidth: 32,
                                      minHeight: 32,
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
                              SizedBox(height: 20.h),
                              // controller.isLoading.value
                              //     ? const CircularProgressIndicator()
                              //     :
                              ButtonComponent(
                                text: 'Submit',
                                color: const Color(0xFF356EFF),
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
                                    // controller.login(token!);
                                    // controller.usernameController.clear();
                                    // controller.passwordController.clear();
                                  }
                                },
                              )
                            ]))),
                  ],
                )
                //           Positioned(
                //             top: size.height * 0.45, // Start the scrollable area below the logo
                //             left: 0,
                //             right: 0,
                //             bottom: 0,
                //             child: SingleChildScrollView(
                //               child: Padding(
                //                 padding: EdgeInsets.only(
                //                     bottom: MediaQuery.of(context).viewInsets.bottom),
                //                 child: Form(
                //                   key: _formKey,
                //                   child: Column(
                //                     children: [
                //                       Padding(
                //                         padding: EdgeInsets.symmetric(horizontal: 15.w),
                //                         child: Text(
                //                           "Welcome Back",
                //                           style: TextStyle(
                //                             fontSize: 21.sp,
                //                             fontWeight: FontWeight.bold,
                //                             color: Colors.black,
                //                           ),
                //                           textAlign: TextAlign.center,
                //                         ),
                //                       ),
                //                       Text(
                //                         "Login to your account",
                //                         style: TextStyle(
                //                           fontSize: 12.sp,
                //                           color: Colors.black,
                //                         ),
                //                         textAlign: TextAlign.center,
                //                       ),
                //                       SizedBox(height: 15.h),

                //                       // Loan type selection containers in a Row BELOW welcome text
                //                       Padding(
                //                         padding: EdgeInsets.symmetric(horizontal: 15.w),
                //                         child: Row(
                //                           children: [
                //                             // Unsecure loan
                //                             Expanded(
                //                               child: GestureDetector(
                //                                 onTap: () {
                //                                   setState(() {
                //                                     _selectedLoanType = 'unsecure';
                //                                     controller.secureType.value = 0;
                //                                   });
                //                                 },
                //                                 child: Container(
                //                                   height: 50.h,
                //                                   decoration: BoxDecoration(
                //                                     color: _selectedLoanType == 'unsecure'
                //                                         ? selectedColor // solid blue background
                //                                         : Colors.transparent,
                //                                     borderRadius: BorderRadius.circular(12.r),
                //                                     border: Border.all(
                //                                       color: _selectedLoanType == 'unsecure'
                //                                           ? selectedColor
                //                                           : Colors.blue,
                //                                       width: 1, // reduced border width
                //                                     ),
                //                                   ),
                //                                   child: Row(
                //                                     mainAxisAlignment: MainAxisAlignment.start,
                //                                     children: [
                //                                       SizedBox(width: 8.w),
                //                                       Image.asset(
                //                                         'assets/images/login_homeloan_secure.png',
                //                                         height: 20.h,
                //                                         width: 20.w,
                //                                       ),
                //                                       SizedBox(width: 8.w),
                //                                       Text(
                //                                         "Personal Loan\nUnsecure",
                //                                         style: TextStyle(
                //                                           color: _selectedLoanType == 'unsecure'
                //                                               ? Colors.white
                //                                               : Colors.black54,
                //                                           fontSize: 14.sp,
                //                                         ),
                //                                       ),
                //                                     ],
                //                                   ),
                //                                 ),
                //                               ),
                //                             ),
                //                             SizedBox(width: 15.w),
                //                             // Secure loan
                //                             Expanded(
                //                               child: GestureDetector(
                //                                 onTap: () {
                //                                   setState(() {
                //                                     _selectedLoanType = 'secure';
                //                                     controller.secureType.value = 1;
                //                                   });
                //                                 },
                //                                 child: Container(
                //                                   height: 50.h,
                //                                   decoration: BoxDecoration(
                //                                     color: _selectedLoanType == 'secure'
                //                                         ? selectedColor
                //                                         : Colors.transparent,
                //                                     borderRadius: BorderRadius.circular(12.r),
                //                                     border: Border.all(
                //                                       color: _selectedLoanType == 'secure'
                //                                           ? selectedColor
                //                                           : Colors.blue,
                //                                       width: 1,
                //                                     ),
                //                                   ),
                //                                   child: Padding(
                //                                     padding:
                //                                         EdgeInsets.symmetric(horizontal: 8.w),
                //                                     child: Row(
                //                                       mainAxisAlignment:
                //                                           MainAxisAlignment.start,
                //                                       children: [
                //                                         Image.asset(
                //                                           'assets/images/login_personalloan_unsecure.png',
                //                                           height: 20.h,
                //                                           width: 20.w,
                //                                           color: _selectedLoanType == 'secure'
                //                                               ? Colors.white
                //                                               : Colors.black54,
                //                                         ),
                //                                         SizedBox(width: 8.w),
                //                                         Text(
                //                                           "Home Loan\nSecure",
                //                                           style: TextStyle(
                //                                             fontSize: 14.sp,
                //                                             color: _selectedLoanType == 'secure'
                //                                                 ? Colors.white
                //                                                 : Colors.black54,
                //                                           ),
                //                                         ),
                //                                       ],
                //                                     ),
                //                                   ),
                //                                 ),
                //                               ),
                //                             ),
                //                           ],
                //                         ),
                //                       ),

                //                       SizedBox(height: 20.h),

                //                       // Username TextField
                //                       Padding(
                //                         padding: EdgeInsets.symmetric(horizontal: 15.w),
                //                         child: TextFormField(
                //                           style: const TextStyle(color: AppColors.primaryColor),
                //                           controller: controller.usernameController,
                //                           decoration: InputDecoration(
                //                             labelText: 'Username',
                //                             labelStyle: const TextStyle(color: Colors.black),
                //                             border: OutlineInputBorder(
                //                               borderRadius:
                //                                   BorderRadius.all(Radius.circular(16.r)),
                //                             ),
                //                             prefixIcon: const Icon(
                //                               Icons.person,
                //                               color: Colors.black,
                //                             ),
                //                           ),
                //                           validator: (value) {
                //                             if (value == null || value.isEmpty) {
                //                               return 'Please enter your username';
                //                             }
                //                             return null;
                //                           },
                //                         ),
                //                       ),
                //                       SizedBox(height: 20.h),

                //                       // Password TextField
                //                       Padding(
                //                         padding: EdgeInsets.symmetric(horizontal: 15.w),
                //                         child: TextFormField(
                //                           keyboardType: TextInputType.number,
                //                           style: const TextStyle(color: Colors.black),
                //                           controller: controller.passwordController,
                //                           decoration: InputDecoration(
                //                             labelText: 'Password',
                //                             labelStyle: const TextStyle(color: Colors.black),
                //                             border: OutlineInputBorder(
                //                               borderRadius:
                //                                   BorderRadius.all(Radius.circular(16.r)),
                //                             ),
                //                             prefixIcon: const Icon(
                //                               Icons.lock,
                //                               color: Colors.black,
                //                             ),
                //                             suffixIcon: IconButton(
                //                               icon: Icon(
                //                                 _isObscured
                //                                     ? Icons.visibility
                //                                     : Icons.visibility_off,
                //                                 color: Colors.black,
                //                               ),
                //                               onPressed: () {
                //                                 setState(() {
                //                                   _isObscured = !_isObscured;
                //                                 });
                //                               },
                //                             ),
                //                           ),
                //                           obscureText: _isObscured,
                //                           validator: (value) {
                //                             if (value == null || value.isEmpty) {
                //                               return 'Please enter your password';
                //                             } else if (value.length < 6) {
                //                               return 'Password must be at least 6 characters long';
                //                             }
                //                             return null;
                //                           },
                //                         ),
                //                       ),

                // // Forgot Password text (no extra top padding)
                //                       Padding(
                //                         padding: EdgeInsets.only(
                //                           right: 15.w,
                //                         ),
                //                         child: Align(
                //                           alignment: Alignment.centerRight,
                //                           child: TextButton(
                //                             onPressed: () {
                //                               Get.snackbar(
                //                                 'Forgot Password',
                //                                 'Reset link sent to your email',
                //                                 snackPosition: SnackPosition.BOTTOM,
                //                               );
                //                             },
                //                             child: Text(
                //                               'Forgot Password',
                //                               style: TextStyle(
                //                                 color: Theme.of(context).primaryColor,
                //                                 fontWeight: FontWeight.w500,
                //                                 fontSize: 14.sp,
                //                                 decoration: TextDecoration.underline,
                //                                 decorationColor: Theme.of(context).primaryColor,
                //                                 decorationThickness: 1.5,
                //                               ),
                //                             ),
                //                           ),
                //                         ),
                //                       ),

                //                       SizedBox(height: 15.h),

                //                       // Login button or loading indicator
                //                       Obx(() {
                //                         return controller.isLoading.value
                //                             ? const CircularProgressIndicator()
                //                             : ButtonComponent(
                //                                 text: 'Log in',
                //                                 color: const Color(0xFF356EFF),
                //                                 onPressed: () async {
                //                                   if (_formKey.currentState!.validate()) {
                //                                     if (_selectedLoanType == null) {
                //                                       Get.snackbar(
                //                                         "Error",
                //                                         "Please select loan type",
                //                                         snackPosition: SnackPosition.BOTTOM,
                //                                       );
                //                                       return;
                //                                     }
                //                                     controller.login();
                //                                     controller.usernameController.clear();
                //                                     controller.passwordController.clear();
                //                                   }
                //                                 },
                //                               );
                //                       }),

                //                       SizedBox(height: 16.h),
                //                     ],
                //                   ),
                //                 ),
                //               ),
                //             ),
                //           ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
