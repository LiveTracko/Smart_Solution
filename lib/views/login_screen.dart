import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/controllers/login_controllers.dart';
import 'package:smart_solutions/services/firbase_notifications.dart';
import 'package:smart_solutions/theme/app_theme.dart';
import 'package:smart_solutions/views/forget_password.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginViewModel controller = Get.find<LoginViewModel>();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

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
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() {
                final msg = controller.loginError.value;

                if (msg != null) {
                  Future.microtask(() {
                    print('object');
                    Get.snackbar(
                      "Login Failed",
                      msg,
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.red.shade600,
                      colorText: Colors.white,
                      margin: const EdgeInsets.all(12),
                      duration: const Duration(seconds: 3),
                    );

                    controller.loginError.value = null;
                  });
                }

                return const SizedBox();
              }),

              const SizedBox(height: 50),

              Center(
                child: Image.asset(
                  'assets/images/app_logo.png',
                  // 'assets/images/app_logo_with_name.png',
                  fit: BoxFit.contain,
                  height: 80,
                ),
              ),
              const SizedBox(height: 15),

              /// WELCOME TEXT
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome Back 👋",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Login to continue",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              /// LOAN SELECTOR
              LoanTypeSelector(),

              const SizedBox(height: 20),

              /// FORM CARD
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                      spreadRadius: 0,
                      color: Colors.black.withOpacity(.08),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Mobile Number",
                              style: TextStyle(fontWeight: FontWeight.w600))),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: controller.usernameController,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        decoration: InputDecoration(
                            suffixIcon: const SizedBox(width: 0),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 10.h),
                            hintText: "Enter Mobile Number",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12))),
                        validator: (value) {
                          if (value!.isEmpty) return "Enter number";
                          if (value.length != 10) {
                            return "Enter valid 10 digit number";
                          }
                          return null;
                        },
                      ),
                      const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Password",
                              style: TextStyle(fontWeight: FontWeight.w600))),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: controller.passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 10.h,
                          ),
                          hintText: "Enter Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter Password";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 22),

                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: Obx(() {
                          return ElevatedButton(
                            onPressed: controller.isLoading.value
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      controller.login(token!);
                                    }
                                  },
                            child: controller.isLoading.value
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text("Login"),
                          );
                        }),
                      )

                      // SizedBox(
                      //   width: double.infinity,
                      //   height: 48,
                      //   child: ElevatedButton(
                      //     style: ElevatedButton.styleFrom(
                      //       shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(12)),
                      //     ),
                      //     onPressed: () {
                      //       if (_formKey.currentState!.validate()) {
                      //         controller.login(token!);
                      //       }
                      //     },
                      //     child:const Text(
                      //       "Login",
                      //       style: TextStyle(
                      //           fontSize: 18, fontWeight: FontWeight.w600),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 15),

              TextButton(
                  onPressed: () {
                    Get.to(() => const ForgetView());
                  },
                  child: const Text("Forgot Password?",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.blue,
                          fontWeight: FontWeight.w600))),

              const SizedBox(height: 20),
            ],
          ),
        )

            // Stack(
            //   children: [
            //     Image.asset(
            //       'assets/images/login_image_1.png',
            //       width: double.infinity,
            //       height: MediaQuery.of(context).size.height,
            //       fit: BoxFit.contain,
            //     ),

            //     // White Login Card - FIXED POSITION
            //     Positioned(
            //       bottom: -20,
            //       left: 0,
            //       right: 0,
            //       child: Container(
            //         width: double.infinity,
            //         padding:
            //             const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            //         decoration: const BoxDecoration(
            //           color: Colors.white,
            //           boxShadow: [
            //             BoxShadow(
            //               color: Colors.black12,
            //               blurRadius: 10,
            //               offset: Offset(0, -5),
            //             ),
            //           ],
            //         ),
            //         child:

            //         //  Column(
            //         //   crossAxisAlignment: CrossAxisAlignment.start,
            //         //   children: [
            //         //     Row(
            //         //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         //       children: [
            //         //         const Column(
            //         //           crossAxisAlignment: CrossAxisAlignment.start,
            //         //           children: [
            //         //             SizedBox(height: 10),
            //         //             Text("Welcome Back!",
            //         //                 style: AppTextStyle.headerTitle),
            //         //             SizedBox(height: 2),
            //         //             Row(
            //         //               mainAxisAlignment:
            //         //                   MainAxisAlignment.spaceBetween,
            //         //               children: [
            //         //                 Text(
            //         //                   "Login To Your Account",
            //         //                   style: AppTextStyle.body,
            //         //                 ),
            //         //               ],
            //         //             )
            //         //           ],
            //         //         ),
            //         //         Image.asset(
            //         //           'assets/images/app_logo_with_name.png',
            //         //           height: 150,
            //         //         )
            //         //         // SvgPicture.asset(
            //         //         //   'assets/images/app_logo_with_name.svg',
            //         //         //   height: 30,
            //         //         // )
            //         //       ],
            //         //     ),

            //         //     const SizedBox(height: 10),

            //         //     LoanTypeSelector(),

            //         //     // Loan Type Selection
            //         //     const SizedBox(height: 10),

            //         //     Form(
            //         //       key: _formKey,
            //         //       child: Column(
            //         //         crossAxisAlignment: CrossAxisAlignment.start,
            //         //         children: [
            //         //           const Text("Mobile Number"),
            //         //           kVerticalSpace(5),
            //         //           TextFormField(
            //         //             controller: controller.usernameController,
            //         //             style: AppTextStyle.hintText,
            //         //             maxLength: 10,
            //         //             keyboardType: TextInputType.phone,
            //         //             decoration: InputDecoration(
            //         //                 contentPadding: const EdgeInsets.symmetric(
            //         //                     horizontal: 16, vertical: 12),
            //         //                 hintText: "Enter Mobile Number",
            //         //                 isDense: true,
            //         //                 border: OutlineInputBorder(
            //         //                     borderRadius: BorderRadius.circular(10))),
            //         //             validator: (value) {
            //         //               if (value == null || value.isEmpty) {
            //         //                 return 'Please enter username';
            //         //               }
            //         //               if (value.length < 3) {
            //         //                 return 'Username must be at least 3 characters';
            //         //               }
            //         //               return null;
            //         //             },
            //         //           ),
            //         //           const SizedBox(height: 10),
            //         //           const Text("Password"),
            //         //           kVerticalSpace(5),
            //         //           TextFormField(
            //         //             obscureText: true,
            //         //             controller: controller.passwordController,
            //         //             style: AppTextStyle.hintText,
            //         //             decoration: InputDecoration(
            //         //               hintText: "Enter password",
            //         //               isDense: true,
            //         //               suffixIcon: const Icon(
            //         //                 Icons.visibility_off,
            //         //                 size: 20,
            //         //               ),
            //         //               contentPadding: const EdgeInsets.symmetric(
            //         //                   horizontal: 16, vertical: 12),
            //         //               border: OutlineInputBorder(
            //         //                   borderRadius: BorderRadius.circular(10)),
            //         //             ),
            //         //             validator: (value) {
            //         //               if (value == null || value.isEmpty) {
            //         //                 return 'Please enter password';
            //         //               }
            //         //               if (value.length < 6) {
            //         //                 return 'Password must be at least 6 characters';
            //         //               }
            //         //               return null;
            //         //             },
            //         //           ),
            //         //           const SizedBox(height: 15),
            //         //           SizedBox(
            //         //             width: double.infinity,
            //         //             height: 40,
            //         //             child: ElevatedButton(
            //         //               style: ElevatedButton.styleFrom(
            //         //                 backgroundColor: const Color(0xFF0F5DFF),
            //         //                 shape: RoundedRectangleBorder(
            //         //                     borderRadius: BorderRadius.circular(10)),
            //         //               ),
            //         //               onPressed: () {
            //         //                 if (_formKey.currentState!.validate()) {
            //         //                   controller.login(token!);
            //         //                   controller.usernameController.clear();
            //         //                   controller.passwordController.clear();
            //         //                 }
            //         //               },
            //         //               child: const Text("Login",
            //         //                   style: TextStyle(
            //         //                       color: Colors.white, fontSize: 16)),
            //         //             ),
            //         //           ),
            //         //         ],
            //         //       ),
            //         //     ),

            //         //     Center(
            //         //       child: TextButton(
            //         //         onPressed: () {},
            //         //         child: const Text(
            //         //           "Forgot Password?",
            //         //           style: TextStyle(color: Colors.blue),
            //         //         ),
            //         //       ),
            //         //     )
            //         //   ],
            //         // ),

            //       ),
            //     )

            ),
      ),
    );
  }
}

// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:smart_solutions/services/firbase_notifications.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:smart_solutions/theme/app_theme.dart';
// import 'package:smart_solutions/views/forget_password.dart';
// import '../components/button_component.dart';
// import '../controllers/login_controllers.dart';

// class LoginView extends StatefulWidget {
//   const LoginView({super.key});

//   @override
//   LoginViewState createState() => LoginViewState();
// }

// class LoginViewState extends State<LoginView> {
//   final LoginViewModel controller = Get.find();

//   final _formKey = GlobalKey<FormState>(); // Form key for validation
//   bool _isObscured = true; // State for password visibility

//   String? _selectedLoanType = 'unsecure'; // 'secure' or 'unsecure'
//   String? token;

//   @override
//   void initState() {
//     getDeviceToken();
//     super.initState();
//   }

//   getDeviceToken() async {
//     await FireBaseNotificatinService().getDeviceToken();
//     token = FireBaseNotificatinService.token;
//   }

//   @override
//   void dispose() {
//     controller.usernameController.dispose();
//     controller.passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     const Color selectedColor = Color(0xFF356EFF);

//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       body: Stack(
//         alignment: Alignment.bottomCenter,
//         children: [
//           Positioned.fill(
//             child: Image.asset(
//               'assets/images/login_background.png',
//               fit: BoxFit.cover,
//             ),
//           ),
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             child: SvgPicture.asset(
//               'assets/images/login_grey.svg',
//               width: size.width,
//               fit: BoxFit.cover,
//             ),
//           ),

//           // Second SVG at top overlapping (blue)
//           Positioned(
//             top: size.height * 0.0,
//             left: 0,
//             right: 0,
//             child: SvgPicture.asset(
//               'assets/images/login_blue.svg',
//               width: size.width,
//               fit: BoxFit.cover,
//             ),
//           ),

//           Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               mainAxisSize: MainAxisSize.max,
//               children: [
//                 SizedBox(height: 130.h),
//                 Image.asset('assets/images/app_logo.png',
//                     height: 100, width: 100),
//                 SizedBox(height: 30.h),
//                 Expanded(
//                   child: SingleChildScrollView(
//                     child: Form(
//                       key: _formKey,
//                       child: Column(
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 15.w),
//                             child: Text(
//                               "Welcome Back",
//                               style: TextStyle(
//                                 fontSize: 21.sp,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black,
//                               ),
//                               textAlign: TextAlign.center,
//                             ),
//                           ),
//                           Text(
//                             "Login to your account",
//                             style: TextStyle(
//                               fontSize: 12.sp,
//                               color: Colors.black,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                           SizedBox(height: 25.h),

//                           // Loan type selection containers in a Row BELOW welcome text
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 10.w),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 // Unsecure loan
//                                 Expanded(
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       setState(() {
//                                         _selectedLoanType = 'unsecure';
//                                         controller.secureType.value = 0;
//                                       });
//                                     },
//                                     child: Container(
//                                       height: 50.h,
//                                       width: 40.w,
//                                       decoration: BoxDecoration(
//                                         color: _selectedLoanType == 'unsecure'
//                                             ? selectedColor // solid blue background
//                                             : Colors.transparent,
//                                         borderRadius:
//                                             BorderRadius.circular(12.r),
//                                         border: Border.all(
//                                           color: _selectedLoanType == 'unsecure'
//                                               ? selectedColor
//                                               : Colors.blue,
//                                           width: 1, // reduced border width
//                                         ),
//                                       ),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         children: [
//                                           SizedBox(width: 5.w),
//                                           Image.asset(
//                                             'assets/images/login_personalloan_unsecure.png',
//                                             height: 30.h,
//                                             width: 30.w,
//                                           ),
//                                           SizedBox(width: 5.w),
//                                           Expanded(
//                                             child: Text(
//                                               "Personal Loan\nUnsecure",
//                                               textAlign: TextAlign.center,
//                                               style: TextStyle(
//                                                 color: _selectedLoanType ==
//                                                         'unsecure'
//                                                     ? Colors.white
//                                                     : Colors.black54,
//                                                 fontSize: 14.sp,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(width: 15.w),
//                                 // Secure loan
//                                 Expanded(
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       setState(() {
//                                         _selectedLoanType = 'secure';
//                                         controller.secureType.value = 1;
//                                       });
//                                     },
//                                     child: Container(
//                                       height: 50.h,
//                                       decoration: BoxDecoration(
//                                         color: _selectedLoanType == 'secure'
//                                             ? selectedColor
//                                             : Colors.transparent,
//                                         borderRadius:
//                                             BorderRadius.circular(12.r),
//                                         border: Border.all(
//                                           color: _selectedLoanType == 'secure'
//                                               ? selectedColor
//                                               : Colors.blue,
//                                           width: 1,
//                                         ),
//                                       ),
//                                       child: Padding(
//                                         padding: EdgeInsets.symmetric(
//                                             horizontal: 8.w),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           children: [
//                                             Image.asset(
//                                               'assets/images/login_homeloan_secure.png',
//                                               height: 30.h,
//                                               width: 30.w,
//                                               color:
//                                                   _selectedLoanType == 'secure'
//                                                       ? Colors.white
//                                                       : null,
//                                             ),
//                                             SizedBox(width: 8.w),
//                                             Expanded(
//                                               child: Text(
//                                                 "Home Loan\nSecure",
//                                                 textAlign: TextAlign.center,
//                                                 style: TextStyle(
//                                                   fontSize: 14.sp,
//                                                   color: _selectedLoanType ==
//                                                           'secure'
//                                                       ? Colors.white
//                                                       : Colors.black54,
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),

//                           SizedBox(height: 20.h),

//                           // Username TextField
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 8.w),
//                             child: TextFormField(
//                               keyboardType: TextInputType.text,
//                               style: const TextStyle(
//                                   color: AppColors.primaryColor),
//                               controller: controller.usernameController,
//                               decoration: InputDecoration(
//                                   labelText: 'Username',
//                                   labelStyle:
//                                       const TextStyle(color: Colors.black),
//                                   border: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(10.r)),
//                                   ),
//                                   prefixIcon: Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: SvgPicture.asset(
//                                       'assets/images/username.svg',
//                                       height: 20,
//                                       width: 20,
//                                     ),
//                                   ),
//                                   prefixIconConstraints: const BoxConstraints(
//                                     minWidth: 32,
//                                     minHeight: 32,
//                                   )),
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter your username';
//                                 }
//                                 return null;
//                               },
//                             ),
//                           ),
//                           SizedBox(height: 20.h),

//                           // Password TextField
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 8.w),
//                             child: TextFormField(
//                               keyboardType: TextInputType.text,
//                               style: const TextStyle(color: Colors.black),
//                               controller: controller.passwordController,
//                               decoration: InputDecoration(
//                                 labelText: 'Password',
//                                 labelStyle:
//                                     const TextStyle(color: Colors.black),
//                                 border: OutlineInputBorder(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(10.r)),
//                                 ),
//                                 prefixIcon: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: SvgPicture.asset(
//                                     'assets/images/password.svg',
//                                     height: 20,
//                                     width: 20,
//                                   ),
//                                 ),
//                                 prefixIconConstraints: const BoxConstraints(
//                                   minWidth: 32,
//                                   minHeight: 32,
//                                 ),
//                                 suffixIcon: IconButton(
//                                   icon: Icon(
//                                     _isObscured
//                                         ? Icons.visibility
//                                         : Icons.visibility_off,
//                                     color: Colors.black,
//                                   ),
//                                   onPressed: () {
//                                     setState(() {
//                                       _isObscured = !_isObscured;
//                                     });
//                                   },
//                                 ),
//                               ),
//                               obscureText: _isObscured,
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter your password';
//                                 } else if (value.length < 6) {
//                                   return 'Password must be at least 6 characters long';
//                                 }
//                                 return null;
//                               },
//                             ),
//                           ),

//                           // Forgot Password text (no extra top padding)
//                           Padding(
//                             padding: EdgeInsets.only(
//                               right: 15.w,
//                             ),
//                             child: Align(
//                               alignment: Alignment.centerRight,
//                               child: TextButton(
//                                   onPressed: () {
//                                     Get.snackbar(
//                                       'Forgot Password',
//                                       'Reset link sent to your email',
//                                       snackPosition: SnackPosition.BOTTOM,
//                                     );
//                                   },
//                                   child: RichText(
//                                     text: TextSpan(
//                                       recognizer: TapGestureRecognizer()
//                                         ..onTap = () {
//                                           Get.to(() => const ForgetView());
//                                         },
//                                       text: 'Forgot Password',
//                                       style: TextStyle(
//                                         color: Theme.of(context).primaryColor,
//                                         fontWeight: FontWeight.w500,
//                                         fontSize: 14.sp,
//                                         decoration: TextDecoration.underline,
//                                         decorationColor:
//                                             Theme.of(context).primaryColor,
//                                         decorationThickness: 1.5,
//                                       ),
//                                       children: const [
//                                         WidgetSpan(
//                                           child: SizedBox(
//                                               height:
//                                                   4), // pushes underline visually lower
//                                         ),
//                                       ],
//                                     ),
//                                   )),
//                             ),
//                           ),

//                           SizedBox(height: 10.h),

//                           // Login button or loading indicator
//                           Obx(() {
//                             return controller.isLoading.value
//                                 ? Padding(
//                                     padding: const EdgeInsets.all(25),
//                                     child: Container(
//                                       color: const Color(0xFF356EFF),
//                                       height: 50,
//                                       child: const Center(
//                                         child: CircularProgressIndicator(
//                                           color: Colors
//                                               .white, // or AppColors.backgroundColor
//                                         ),
//                                       ),
//                                     ),
//                                   )
//                                 : ButtonComponent(
//                                     text: 'Log in',
//                                     color: const Color(0xFF356EFF),
//                                     onPressed: () async {
//                                       if (_formKey.currentState!.validate()) {
//                                         if (_selectedLoanType == null) {
//                                           Get.snackbar(
//                                             "Error",
//                                             "Please select loan type",
//                                             snackPosition: SnackPosition.BOTTOM,
//                                           );
//                                           return;
//                                         }
//                                         controller.login(token!);
//                                         controller.usernameController.clear();
//                                         controller.passwordController.clear();
//                                       }
//                                     },
//                                   );
//                           }),

//                           SizedBox(height: 16.h),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )
//           //           Positioned(
//           //             top: size.height * 0.45, // Start the scrollable area below the logo
//           //             left: 0,
//           //             right: 0,
//           //             bottom: 0,
//           //             child: SingleChildScrollView(
//           //               child: Padding(
//           //                 padding: EdgeInsets.only(
//           //                     bottom: MediaQuery.of(context).viewInsets.bottom),
//           //                 child: Form(
//           //                   key: _formKey,
//           //                   child: Column(
//           //                     children: [
//           //                       Padding(
//           //                         padding: EdgeInsets.symmetric(horizontal: 15.w),
//           //                         child: Text(
//           //                           "Welcome Back",
//           //                           style: TextStyle(
//           //                             fontSize: 21.sp,
//           //                             fontWeight: FontWeight.bold,
//           //                             color: Colors.black,
//           //                           ),
//           //                           textAlign: TextAlign.center,
//           //                         ),
//           //                       ),
//           //                       Text(
//           //                         "Login to your account",
//           //                         style: TextStyle(
//           //                           fontSize: 12.sp,
//           //                           color: Colors.black,
//           //                         ),
//           //                         textAlign: TextAlign.center,
//           //                       ),
//           //                       SizedBox(height: 15.h),

//           //                       // Loan type selection containers in a Row BELOW welcome text
//           //                       Padding(
//           //                         padding: EdgeInsets.symmetric(horizontal: 15.w),
//           //                         child: Row(
//           //                           children: [
//           //                             // Unsecure loan
//           //                             Expanded(
//           //                               child: GestureDetector(
//           //                                 onTap: () {
//           //                                   setState(() {
//           //                                     _selectedLoanType = 'unsecure';
//           //                                     controller.secureType.value = 0;
//           //                                   });
//           //                                 },
//           //                                 child: Container(
//           //                                   height: 50.h,
//           //                                   decoration: BoxDecoration(
//           //                                     color: _selectedLoanType == 'unsecure'
//           //                                         ? selectedColor // solid blue background
//           //                                         : Colors.transparent,
//           //                                     borderRadius: BorderRadius.circular(12.r),
//           //                                     border: Border.all(
//           //                                       color: _selectedLoanType == 'unsecure'
//           //                                           ? selectedColor
//           //                                           : Colors.blue,
//           //                                       width: 1, // reduced border width
//           //                                     ),
//           //                                   ),
//           //                                   child: Row(
//           //                                     mainAxisAlignment: MainAxisAlignment.start,
//           //                                     children: [
//           //                                       SizedBox(width: 8.w),
//           //                                       Image.asset(
//           //                                         'assets/images/login_homeloan_secure.png',
//           //                                         height: 20.h,
//           //                                         width: 20.w,
//           //                                       ),
//           //                                       SizedBox(width: 8.w),
//           //                                       Text(
//           //                                         "Personal Loan\nUnsecure",
//           //                                         style: TextStyle(
//           //                                           color: _selectedLoanType == 'unsecure'
//           //                                               ? Colors.white
//           //                                               : Colors.black54,
//           //                                           fontSize: 14.sp,
//           //                                         ),
//           //                                       ),
//           //                                     ],
//           //                                   ),
//           //                                 ),
//           //                               ),
//           //                             ),
//           //                             SizedBox(width: 15.w),
//           //                             // Secure loan
//           //                             Expanded(
//           //                               child: GestureDetector(
//           //                                 onTap: () {
//           //                                   setState(() {
//           //                                     _selectedLoanType = 'secure';
//           //                                     controller.secureType.value = 1;
//           //                                   });
//           //                                 },
//           //                                 child: Container(
//           //                                   height: 50.h,
//           //                                   decoration: BoxDecoration(
//           //                                     color: _selectedLoanType == 'secure'
//           //                                         ? selectedColor
//           //                                         : Colors.transparent,
//           //                                     borderRadius: BorderRadius.circular(12.r),
//           //                                     border: Border.all(
//           //                                       color: _selectedLoanType == 'secure'
//           //                                           ? selectedColor
//           //                                           : Colors.blue,
//           //                                       width: 1,
//           //                                     ),
//           //                                   ),
//           //                                   child: Padding(
//           //                                     padding:
//           //                                         EdgeInsets.symmetric(horizontal: 8.w),
//           //                                     child: Row(
//           //                                       mainAxisAlignment:
//           //                                           MainAxisAlignment.start,
//           //                                       children: [
//           //                                         Image.asset(
//           //                                           'assets/images/login_personalloan_unsecure.png',
//           //                                           height: 20.h,
//           //                                           width: 20.w,
//           //                                           color: _selectedLoanType == 'secure'
//           //                                               ? Colors.white
//           //                                               : Colors.black54,
//           //                                         ),
//           //                                         SizedBox(width: 8.w),
//           //                                         Text(
//           //                                           "Home Loan\nSecure",
//           //                                           style: TextStyle(
//           //                                             fontSize: 14.sp,
//           //                                             color: _selectedLoanType == 'secure'
//           //                                                 ? Colors.white
//           //                                                 : Colors.black54,
//           //                                           ),
//           //                                         ),
//           //                                       ],
//           //                                     ),
//           //                                   ),
//           //                                 ),
//           //                               ),
//           //                             ),
//           //                           ],
//           //                         ),
//           //                       ),

//           //                       SizedBox(height: 20.h),

//           //                       // Username TextField
//           //                       Padding(
//           //                         padding: EdgeInsets.symmetric(horizontal: 15.w),
//           //                         child: TextFormField(
//           //                           style: const TextStyle(color: AppColors.primaryColor),
//           //                           controller: controller.usernameController,
//           //                           decoration: InputDecoration(
//           //                             labelText: 'Username',
//           //                             labelStyle: const TextStyle(color: Colors.black),
//           //                             border: OutlineInputBorder(
//           //                               borderRadius:
//           //                                   BorderRadius.all(Radius.circular(16.r)),
//           //                             ),
//           //                             prefixIcon: const Icon(
//           //                               Icons.person,
//           //                               color: Colors.black,
//           //                             ),
//           //                           ),
//           //                           validator: (value) {
//           //                             if (value == null || value.isEmpty) {
//           //                               return 'Please enter your username';
//           //                             }
//           //                             return null;
//           //                           },
//           //                         ),
//           //                       ),
//           //                       SizedBox(height: 20.h),

//           //                       // Password TextField
//           //                       Padding(
//           //                         padding: EdgeInsets.symmetric(horizontal: 15.w),
//           //                         child: TextFormField(
//           //                           keyboardType: TextInputType.number,
//           //                           style: const TextStyle(color: Colors.black),
//           //                           controller: controller.passwordController,
//           //                           decoration: InputDecoration(
//           //                             labelText: 'Password',
//           //                             labelStyle: const TextStyle(color: Colors.black),
//           //                             border: OutlineInputBorder(
//           //                               borderRadius:
//           //                                   BorderRadius.all(Radius.circular(16.r)),
//           //                             ),
//           //                             prefixIcon: const Icon(
//           //                               Icons.lock,
//           //                               color: Colors.black,
//           //                             ),
//           //                             suffixIcon: IconButton(
//           //                               icon: Icon(
//           //                                 _isObscured
//           //                                     ? Icons.visibility
//           //                                     : Icons.visibility_off,
//           //                                 color: Colors.black,
//           //                               ),
//           //                               onPressed: () {
//           //                                 setState(() {
//           //                                   _isObscured = !_isObscured;
//           //                                 });
//           //                               },
//           //                             ),
//           //                           ),
//           //                           obscureText: _isObscured,
//           //                           validator: (value) {
//           //                             if (value == null || value.isEmpty) {
//           //                               return 'Please enter your password';
//           //                             } else if (value.length < 6) {
//           //                               return 'Password must be at least 6 characters long';
//           //                             }
//           //                             return null;
//           //                           },
//           //                         ),
//           //                       ),

//           // // Forgot Password text (no extra top padding)
//           //                       Padding(
//           //                         padding: EdgeInsets.only(
//           //                           right: 15.w,
//           //                         ),
//           //                         child: Align(
//           //                           alignment: Alignment.centerRight,
//           //                           child: TextButton(
//           //                             onPressed: () {
//           //                               Get.snackbar(
//           //                                 'Forgot Password',
//           //                                 'Reset link sent to your email',
//           //                                 snackPosition: SnackPosition.BOTTOM,
//           //                               );
//           //                             },
//           //                             child: Text(
//           //                               'Forgot Password',
//           //                               style: TextStyle(
//           //                                 color: Theme.of(context).primaryColor,
//           //                                 fontWeight: FontWeight.w500,
//           //                                 fontSize: 14.sp,
//           //                                 decoration: TextDecoration.underline,
//           //                                 decorationColor: Theme.of(context).primaryColor,
//           //                                 decorationThickness: 1.5,
//           //                               ),
//           //                             ),
//           //                           ),
//           //                         ),
//           //                       ),

//           //                       SizedBox(height: 15.h),

//           //                       // Login button or loading indicator
//           //                       Obx(() {
//           //                         return controller.isLoading.value
//           //                             ? const CircularProgressIndicator()
//           //                             : ButtonComponent(
//           //                                 text: 'Log in',
//           //                                 color: const Color(0xFF356EFF),
//           //                                 onPressed: () async {
//           //                                   if (_formKey.currentState!.validate()) {
//           //                                     if (_selectedLoanType == null) {
//           //                                       Get.snackbar(
//           //                                         "Error",
//           //                                         "Please select loan type",
//           //                                         snackPosition: SnackPosition.BOTTOM,
//           //                                       );
//           //                                       return;
//           //                                     }
//           //                                     controller.login();
//           //                                     controller.usernameController.clear();
//           //                                     controller.passwordController.clear();
//           //                                   }
//           //                                 },
//           //                               );
//           //                       }),

//           //                       SizedBox(height: 16.h),
//           //                     ],
//           //                   ),
//           //                 ),
//           //               ),
//           //             ),
//           //           ),
//         ],
//       ),
//     );
//   }
// }

// Your LoanTypeSelector Widget (keep this as is)

class LoanTypeSelector extends StatelessWidget {
  LoanTypeSelector({super.key});

  final LoginViewModel controller = Get.find<LoginViewModel>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            offset: const Offset(0, 3),
            spreadRadius: 0,
            color: Colors.black.withOpacity(.08),
          ),
        ],
      ),
      child: Row(
        children: [
          // PERSONAL LOAN
          Expanded(
            child: InkWell(
              onTap: () => controller.secureType.value = 0,
              child: Obx(() {
                final isSelected = controller.secureType.value == 0;

                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.grey,
                    ),
                    color: isSelected
                        ? Colors.blue.withOpacity(.12)
                        : Colors.white,
                  ),
                  child: Center(
                    child: Text(
                      "Unsecure",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.blue : Colors.black,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(width: 10),

          // HOME LOAN
          Expanded(
            child: InkWell(
              onTap: () => controller.secureType.value = 1,
              child: Obx(() {
                final isSelected = controller.secureType.value == 1;

                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.grey,
                    ),
                    color: isSelected
                        ? Colors.blue.withOpacity(.12)
                        : Colors.white,
                  ),
                  child: Center(
                    child: Text(
                      "Secure",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.blue : Colors.black,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
