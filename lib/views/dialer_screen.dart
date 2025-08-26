import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/components/widgets/DailerScreenWidget/KeypadRowWidget.dart';
import 'package:smart_solutions/controllers/dailer_controller.dart';
import 'package:smart_solutions/controllers/follow_form.dart';
import 'package:smart_solutions/views/followBackForm.dart';
import 'package:smart_solutions/widget/common_scaffold.dart';

class DialerScreen extends StatefulWidget {
  DialerScreen({Key? key}) : super(key: key);

  @override
  State<DialerScreen> createState() => _DialerScreenState();
}

class _DialerScreenState extends State<DialerScreen> {
  // final DialerController dialerController = Get.put(DialerController());

  final DialerController dialerController = Get.find<DialerController>();
  final FollowBackFormController _formController =
      Get.put(FollowBackFormController());

  int callsToBeHeld = 5;

  @override
  void dispose() {
    dialerController.setPhoneNumberOnce('');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      actions: [
        IconButton(
          icon: SvgPicture.asset(
            'assets/images/plus_icon.svg',
            width: 20,
            height: 20,
          ),
          onPressed: () {
            Get.to(() => FollowBackForm(
                  mobileNumber: '',
                ));
            // handle click
          },
        )
      ],
      title: 'Dialler',
      showBack: false,
      //   appBar: const CurvedAppBar(title: 'title'),

      //  AppBar(
      //   automaticallyImplyLeading: false,
      //   centerTitle: true,
      //   title: const Text(
      //     'Dialer',
      //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      //   ),
      //   actions: [
      //     IconButton(
      //         onPressed: () {
      //           dialerController.customerLoan.value = '';
      //           dialerController.customerName.value = '';
      //           dialerController.datatype.value = '';
      //           Get.to(() => FollowBackForm(
      //                 mobileNumber: '',
      //               ));
      //         },
      //         icon: const Icon(Icons.add_rounded))
      //   ],
      // ),
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Obx(() {
                bool isActive = dialerController.isManual.value;
                return Align(
                  alignment: Alignment.topRight,
                  child: Row(
                    mainAxisSize: MainAxisSize
                        .min, // Ensures the row only takes the necessary width
                    children: [
                      Text(
                        isActive
                            ? "Manual Mode"
                            : "Auto Mode", // Short text to fit the compact design
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize:
                              14.h, // Maintain a small but readable font size
                        ),
                      ),
                      const SizedBox(
                          width: 8), // Small gap between text and switch
                      Transform.scale(
                        scale: 0.8, // Ensuring the switch remains compact
                        child: Switch(
                          activeColor: AppColors.greenColor,
                          inactiveTrackColor: Colors.grey.shade100,
                          value: isActive,
                          onChanged: dialerController.isCallOngoing.value
                              ? null
                              : (value) async {
                                  if (value) {
                                    dialerController.phoneNumber.value = '';
                                    _removeNumber();
                                  }
                                  dialerController.isManual.value = value;
                                },
                        ),
                      ),
                    ],
                  ),
                );
              }),

              SizedBox(height: 5.h),
              Obx(
                () => dialerController.isCallOngoing.value
                    ? Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.grey.shade300),
                          child: Text(
                            dialerController.formatElapsedTime(
                                dialerController.elapsedTimeInSeconds.value),
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              Obx(() => Container(
                    alignment: AlignmentDirectional.topStart,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      dialerController.customerName.value,
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: AppColors.secondaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
              SizedBox(
                height: 3.h,
              ),
              Obx(() => Container(
                    alignment: AlignmentDirectional.topStart,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      dialerController
                          .formatCurrency(dialerController.customerLoan.value),
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: AppColors.secondaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
              Padding(
                padding: EdgeInsets.all(16.0.w),
                child: Obx(() {
                  return Column(
                    children: [
                      Center(
                        child: Text(
                          dialerController.phoneNumber.value.isEmpty
                              ? 'Enter number'
                              : dialerController.phoneNumber.value,
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: AppColors.secondaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Divider(
                        color: AppColors.secondaryColor,
                      )
                    ],
                  );

                  // Container(
                  //   height: 50.h,
                  //   padding: EdgeInsets.symmetric(horizontal: 16.w),
                  //   decoration: BoxDecoration(
                  //     color: AppColors.backgroundColor,
                  //     borderRadius: BorderRadius.circular(12.r),
                  //     border: Border.all(
                  //         color: AppColors.primaryColor.withOpacity(0.2)),
                  //   ),
                  //   child: Center(
                  //     child:
                  //         // TextField(
                  //         //   inputFormatters: [],
                  //         //   maxLength: 10,
                  //         //   readOnly: true,
                  //         //   controller: TextEditingController()
                  //         //     ..text = dialerController.phoneNumber.value,
                  //         //   onChanged: (value) {
                  //         //     // dialerController.phoneNumber.value = value;
                  //         //     if (value.length <= 10) {
                  //         //       dialerController.phoneNumber.value = value;
                  //         //     }
                  //         //   },
                  //         //   style: TextStyle(
                  //         //     fontSize: 20.sp,
                  //         //     color: AppColors.secondaryColor,
                  //         //     fontWeight: FontWeight.bold,
                  //         //   ),
                  //         //   decoration: InputDecoration(
                  //         //     counterText: '',
                  //         //     border: InputBorder.none,
                  //         //     hintText: 'Enter number',
                  //         //     hintStyle: TextStyle(
                  //         //       fontSize: 20.sp,
                  //         //       color: AppColors.secondaryColor,
                  //         //       fontWeight: FontWeight.bold,
                  //         //     ),
                  //         //   ),
                  //         // ),

                  //         Text(
                  //       dialerController.phoneNumber.value.isEmpty
                  //           ? 'Enter number'
                  //           : dialerController.phoneNumber.value,
                  //       style: TextStyle(
                  //         fontSize: 20.sp,
                  //         color: AppColors.secondaryColor,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //   ),
                  // );
                }),
              ),

              // Keypad
              Container(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Column(
                  children: [
                    KeypadRowWidget(
                      numbers: const ['1', '2', '3'],
                      subTexts: const ['', 'ABC', 'DEF'],
                      onDialButtonPressed: _addNumber,
                    ),
                    KeypadRowWidget(
                      numbers: const ['4', '5', '6'],
                      subTexts: const ['GHI', 'JKL', 'MNO'],
                      onDialButtonPressed: _addNumber,
                    ),
                    KeypadRowWidget(
                      numbers: const ['7', '8', '9'],
                      subTexts: const ['PQRS', 'TUV', 'WXYZ'],
                      onDialButtonPressed: _addNumber,
                    ),
                    KeypadRowWidget(
                      numbers: const ['*', '0', '#'],
                      subTexts: const [null, '+', null],
                      onDialButtonPressed: _addNumber,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              // Call and delete buttons
              Padding(
                padding: EdgeInsets.only(bottom: 0.h, left: 40.h, right: 50.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Obx(() => _buildCallButton(
                          SvgPicture.asset('assets/images/call_icon.svg'),
                          dialerController.phoneNumber.isNotEmpty &&
                                  !dialerController.isCallOngoing.value
                              ? () {
                                  // if (dialerController.dialNumber.isEmpty) {
                                  //   dialerController.fetchNextPhoneNumber();
                                  // } else {
                                  //   dialerController
                                  //       .makePhoneCall(dialerController.dialNumber.value);
                                  // }
                                  dialerController.makePhoneCall(
                                      dialerController.phoneNumber.value);
                                  _formController.mobile.value =
                                      dialerController.phoneNumber.value;
                                }
                              : null,
                        )),
                    SizedBox(width: 5.sp),
                    // Obx(() => Expanded(
                    //       child: ElevatedButton(
                    //         style: ElevatedButton.styleFrom(
                    //           backgroundColor:
                    //               dialerController.isCallOngoing.value
                    //                   ? AppColors.ongoindCallColor
                    //                   : AppColors.primaryColor,
                    //           foregroundColor: Colors.white,
                    //           padding: EdgeInsets.symmetric(vertical: 16.h),
                    //           shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(12.r),
                    //           ),
                    //         ),
                    //         onPressed: dialerController.isManual.value
                    //             ? null
                    //             : dialerController.isLoading.value
                    //                 ? null
                    //                 : () async {
                    //                     dialerController.isCallOngoing.value
                    //                         ? Get.defaultDialog(
                    //                             title: "End Call",
                    //                             titleStyle: const TextStyle(
                    //                                 color: Colors.black,
                    //                                 fontWeight: FontWeight.bold,
                    //                                 fontSize:
                    //                                     20), // Bold title for emphasis.
                    //                             middleText:
                    //                                 "Want to end the call? End the call from the caller screen.", // Updated guiding message.
                    //                             middleTextStyle: const TextStyle(
                    //                                 color: Colors.black,
                    //                                 fontSize:
                    //                                     16), // Clear and readable middle text.
                    //                             backgroundColor: Colors
                    //                                 .white, // Dialog background in white.
                    //                             textConfirm:
                    //                                 "OK", // Single button labeled 'OK'.
                    //                             confirmTextColor: Colors
                    //                                 .white, // Confirm button text in white.
                    //                             buttonColor: Colors
                    //                                 .blue, // 'OK' button in blue for neutrality.
                    //                             barrierDismissible:
                    //                                 false, // Prevent accidental dismiss by tapping outside.
                    //                             onConfirm: () {
                    //                               Get.back(); // Simply close the dialog.
                    //                             },
                    //                           )
                    //                         : await dialerController
                    //                             .fetchNextPhoneNumber();
                    //                   },
                    //         child: dialerController.isLoading.value
                    //             ? const Text('Loading...')
                    //             : Text(
                    //                 dialerController.isCallOngoing.value
                    //                     ? "End Call"
                    //                     : 'NEXT CALL',
                    //                 style: TextStyle(
                    //                     fontSize: 16.sp,
                    //                     fontWeight: FontWeight.bold),
                    //               ),
                    //       ),
                    //     )),

                    SizedBox(
                      width: 20.sp,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: _buildIconButton(
                        Icons.backspace_outlined,
                        AppColors.greyColor,
                        _removeNumber,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),

              Obx(() => dialerController.isManual.value
                  ? const SizedBox.shrink()
                  : Padding(
                      padding:
                          EdgeInsets.only(bottom: 0.h, left: 20.h, right: 20.h),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                dialerController.isCallOngoing.value
                                    ? AppColors.ongoindCallColor
                                    : AppColors.primaryColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          onPressed: dialerController.isManual.value
                              ? null
                              : dialerController.isLoading.value
                                  ? null
                                  : () async {
                                      dialerController.isCallOngoing.value
                                          ? Get.defaultDialog(
                                              title: "End Call",
                                              titleStyle: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      20), // Bold title for emphasis.
                                              middleText:
                                                  "Want to end the call? End the call from the caller screen.", // Updated guiding message.
                                              middleTextStyle: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize:
                                                      16), // Clear and readable middle text.
                                              backgroundColor: Colors
                                                  .white, // Dialog background in white.
                                              textConfirm:
                                                  "OK", // Single button labeled 'OK'.
                                              confirmTextColor: Colors
                                                  .white, // Confirm button text in white.
                                              buttonColor: Colors
                                                  .blue, // 'OK' button in blue for neutrality.
                                              barrierDismissible:
                                                  false, // Prevent accidental dismiss by tapping outside.
                                              onConfirm: () {
                                                Get.back(); // Simply close the dialog.
                                              },
                                            )
                                          : await dialerController
                                              .fetchNextPhoneNumber();
                                    },
                          child: dialerController.isLoading.value
                              ? const Text('Loading...')
                              : Text(
                                  dialerController.isCallOngoing.value
                                      ? "End Call"
                                      : 'NEXT CALL',
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                    ))
            ]),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, Color color, VoidCallback? onPressed) {
    return Container(
      width: 65.w,
      height: 65.h,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.secondaryColor),
        iconSize: 25.r,
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildCallButton(Widget icon, VoidCallback? onPressed) {
    return SizedBox(
      width: 80.w,
      height: 80.h,
      child: IconButton(
        icon: icon,
        // Icon(icon, color: AppColors.secondaryColor),
        iconSize: 25.r,
        onPressed: onPressed,
      ),
    );
  }

  void _addNumber(String number) {
    if (dialerController.isManual.value) {
      // setState(() {
      // dialerController.phoneNumber.value = '';
      dialerController.phoneNumber.value += number;
      //  });
    }
  }

  void _removeNumber() {
    if (dialerController.dialNumber.isNotEmpty) {
      setState(() {
        dialerController.dialNumber.value = dialerController.dialNumber.value
            .substring(0, dialerController.dialNumber.value.length - 1);
      });
    } else
      dialerController.customerLoan.value = '';
    dialerController.customerName.value = '';

    if (dialerController.phoneNumber.isNotEmpty) {
      dialerController.phoneNumber.value = dialerController.phoneNumber.value
          .substring(0, dialerController.phoneNumber.value.length - 1);
    }
  }

  Future<bool?> _showDeactivationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            "Confirm Deactivation",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
          ),
          content: Text(
            "Are you sure you want to deactivate manual dialing?",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Colors.black87,
                ),
          ),
          actions: <Widget>[
            // Row containing the buttons
            Row(
              children: [
                // Cancel Button - Takes up 50% of the row
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pop(false); // Return false if user cancels
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 10), // Reduced padding
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.w600,
                        fontSize: 14, // Reduced font size
                        overflow: TextOverflow
                            .ellipsis, // Prevent text from overflowing
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5.h,
                ),
                // Deactivate Button - Takes up 50% of the row
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pop(true); // Return true if user confirms
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 10), // Reduced padding
                    ),
                    child: const Text(
                      "Deactivate",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14, // Reduced font size
                        overflow: TextOverflow
                            .ellipsis, // Prevent text from overflowing
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
