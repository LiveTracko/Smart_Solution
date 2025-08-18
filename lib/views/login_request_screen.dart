import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_solutions/constants/static_stored_data.dart';
import 'package:smart_solutions/controllers/data_entry_controller.dart';
import 'package:smart_solutions/controllers/login_request_controller.dart';
import 'package:smart_solutions/utils/currency_util.dart';
import 'package:smart_solutions/utils/customAppbar.dart';
import 'package:smart_solutions/views/data_entry_form.dart';
import 'package:smart_solutions/views/login_request_form.dart';

class LoginRequestScreen extends StatelessWidget {
  LoginRequestScreen({super.key});
  final LoginRequestController controller = Get.put(LoginRequestController());
  final DataController dataEntryController = Get.put(DataController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Stack(
          children: [
            SizedBox(
                height: 120,
                child: CurvedAppBar(
                  title: 'Login Requests',
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 12,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          controller.isEdit.value = true;
                          controller.isNew.value = true;
                          Get.to(() => LoginRequestForm());
                        },
                        child: SvgPicture.asset(
                          'assets/images/login_request_add_circle.svg',
                          height: 25,
                          width: 25,
                        ),
                      ),
                    ),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: RefreshIndicator(
                onRefresh: () => controller.getLoginRequestList(),
                child: (controller.loginRequestList.isEmpty)
                    ? const Center(
                        child: Text(
                          'No Data',
                          style: TextStyle(color: Colors.black),
                        ),
                      )
                    : controller.isLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(35),
                                topRight: Radius.circular(35),
                              ),
                            ),
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10, bottom: 10, top: 15),
                            child: ListView.builder(
                              itemCount: controller.loginRequestList.length,
                              itemBuilder: (context, index) {
                                final request =
                                    controller.loginRequestList[index];

                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                          color: Colors.blue,
                                          width: 4,
                                        ),
                                      ),
                                    ),
                                    child: Card(
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(1),
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child: ExpansionTile(
                                        shape: const Border(),
                                        collapsedShape: const Border(),
                                        tilePadding: EdgeInsets.zero,
                                        childrenPadding: EdgeInsets.zero,
                                        trailing: const SizedBox.shrink(),
                                        expandedCrossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        initiallyExpanded: false,
                                        backgroundColor: Colors.transparent,
                                        collapsedBackgroundColor: Colors.white,
                                        title: Row(
                                          children: [
                                            SvgPicture.asset(
                                              'assets/images/login_request_icon.svg',
                                              width: 35,
                                              height: 35,
                                            ),
                                            const SizedBox(width: 8),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.72,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        request.customerName
                                                            .toString(),
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        request.bankName
                                                            .toString(),
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      SvgPicture.asset(
                                                        'assets/images/login_request_pencil.svg',
                                                        width: 15.w,
                                                        height: 17.h,
                                                        color: AppColors
                                                            .primaryColor,
                                                      ),
                                                      SizedBox(
                                                        width: 10.w,
                                                      ),
                                                      Icon(Icons.login,
                                                          size: 20.w,
                                                          color:
                                                              Colors.grey[700]),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                decoration: BoxDecoration(
                                                  color: (request.title ?? '')
                                                              .toLowerCase() ==
                                                          'not doable'
                                                      ? Colors.red.shade50
                                                      : Colors.green.shade50,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Text(
                                                  request.title!.isNotEmpty
                                                      ? request.title.toString()
                                                      : 'No status',
                                                  style: TextStyle(
                                                    color: (request.title ?? '')
                                                                .toLowerCase() ==
                                                            'not doable'
                                                        ? const Color.fromARGB(
                                                            255, 235, 15, 15)
                                                        : Colors.green,
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    CurrencyUtils
                                                        .formatIndianCurrency(
                                                            request.loanAmount),
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                  SvgPicture.asset(
                                                    "assets/images/login_request_dropdown.svg",
                                                    height: 20.h,
                                                    width: 20.w,
                                                    color: Colors.grey[700],
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        // trailing: SizedBox(
                                        //   width: 100.w,
                                        //   child: Column(
                                        //     crossAxisAlignment:
                                        //         CrossAxisAlignment.start,
                                        //     mainAxisAlignment:
                                        //         MainAxisAlignment.spaceBetween,
                                        //     children: [
                                        //       Row(
                                        //         mainAxisAlignment:
                                        //             MainAxisAlignment
                                        //                 .spaceAround,
                                        //         children: [
                                        //           GestureDetector(
                                        //             onTap: () async {
                                        //               controller.currentId
                                        //                   .value = request.id;
                                        //               controller.customerName
                                        //                       .value =
                                        //                   request.customerName;
                                        //               controller.contactNumber
                                        //                       .value =
                                        //                   request.contactNumber;
                                        //               controller.loanAmount
                                        //                       .value =
                                        //                   request.loanAmount;
                                        //               controller.loanStatus
                                        //                       .value =
                                        //                   ((request.loanStatus ==
                                        //                               null ||
                                        //                           request
                                        //                               .loanStatus!
                                        //                               .isEmpty)
                                        //                       ? "NA"
                                        //                       : request
                                        //                           .loanStatus)!;
                                        //               controller.bankId.value =
                                        //                   request.bankName ??
                                        //                       "";
                                        //               controller.commonRemark
                                        //                       .value =
                                        //                   request.commonRemark;
                                        //               controller.sourceId
                                        //                   .value = request
                                        //                       .sourcingTitle ??
                                        //                   "";

                                        //               controller.getRemarks();
                                        //               await Get.to(() =>
                                        //                   LoginRequestForm());

                                        //               controller
                                        //                   .getLoginRequestList();
                                        //             },
                                        //             child: Column(
                                        //               mainAxisAlignment:
                                        //                   MainAxisAlignment
                                        //                       .spaceBetween,
                                        //               children: [
                                        //                 SvgPicture.asset(
                                        //                   'assets/images/login_request_pencil.svg',
                                        //                   width: 15.w,
                                        //                   height: 17.h,
                                        //                   color: AppColors
                                        //                       .primaryColor,
                                        //                 ),
                                        //                 Text(
                                        //                   CurrencyUtils
                                        //                       .formatIndianCurrency(
                                        //                           request
                                        //                               .loanAmount),
                                        //                   style: const TextStyle(
                                        //                       color:
                                        //                           Colors.black,
                                        //                       fontSize: 12,
                                        //                       fontWeight:
                                        //                           FontWeight
                                        //                               .normal),
                                        //                 ),
                                        //               ],
                                        //             ),
                                        //           ),
                                        //           StaticStoredData.roleName !=
                                        //                       'telecaller' &&
                                        //                   StaticStoredData
                                        //                           .roleName !=
                                        //                       'teamleader'
                                        //               ? GestureDetector(
                                        //                   onTap: () async {
                                        //                     dataEntryController
                                        //                             .contactNumber
                                        //                             .value =
                                        //                         request
                                        //                             .contactNumber;
                                        //                     dataEntryController
                                        //                             .loanAmount
                                        //                             .value =
                                        //                         request
                                        //                             .loanAmount;
                                        //                     dataEntryController
                                        //                             .Id.value =
                                        //                         request.id;
                                        //                     dataEntryController
                                        //                             .selectedSource
                                        //                             .value =
                                        //                         request.sourcing
                                        //                             .toString();
                                        //                     dataEntryController
                                        //                             .selectTelecallerName
                                        //                             .value =
                                        //                         request
                                        //                             .telecallerId;

                                        //                     await Get.to(() =>
                                        //                         DataEntryForm(
                                        //                           id: '',
                                        //                           tellecallerId:
                                        //                               request
                                        //                                   .telecallerId,
                                        //                           dsaId: '',
                                        //                           bankerId: '',
                                        //                         ));
                                        //                   },
                                        //                   child: Column(
                                        //                     children: [
                                        //                       Icon(Icons.login,
                                        //                           size: 20.w,
                                        //                           color: Colors
                                        //                                   .grey[
                                        //                               700]),
                                        //                       SvgPicture.asset(
                                        //                         "assets/images/login_request_dropdown.svg",
                                        //                         height: 20.h,
                                        //                         width: 20.w,
                                        //                         color: Colors
                                        //                             .grey[700],
                                        //                       )
                                        //                     ],
                                        //                   ),
                                        //                 )
                                        //               : const SizedBox.shrink()
                                        //         ],
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0,
                                                vertical: 8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                _buildDoubleRow(
                                                  iconLeft: Icons.call,
                                                  valueLeft: maskFirst6Digits(
                                                      request.contactNumber
                                                          .toString()),
                                                  iconRight:
                                                      Icons.calendar_month,
                                                  valueRight: DateFormat(
                                                          'dd-MM-yyyy')
                                                      .format(DateTime.parse(
                                                          request
                                                              .loginRequestDate
                                                              .toString())),
                                                ),
                                                Obx(
                                                  () => _buildSingleRow(
                                                    Icons.feedback,
                                                    controller.remarksList
                                                            .isNotEmpty
                                                        ? controller
                                                            .remarksList.first
                                                        : 'No remark',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String maskFirst6Digits(String number) {
  if (number.length < 6) return number; // Handle edge case
  return 'xxxxxx${number.substring(6)}';
}

Widget _buildDoubleRow({
  required IconData iconLeft,
  required String valueLeft,
  IconData? iconRight,
  required String valueRight,
  Color? textColorRight,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      children: [
        // Left section
        Expanded(
          child: Row(
            children: [
              Icon(iconLeft, size: 18, color: Colors.grey[700]),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  valueLeft,
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),

        // Right section
        Row(
          mainAxisSize: MainAxisSize.min, // keeps it compact
          children: [
            if (iconRight != null)
              Icon(iconRight, size: 18, color: Colors.grey[700]),
            const SizedBox(width: 4),
            Text(
              valueRight,
              style: TextStyle(
                fontSize: 12,
                color: textColorRight ?? Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildSingleRow(IconData icon, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start, // Align top
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2), // slight vertical alignment
          child: Icon(icon, size: 18, color: Colors.grey[700]),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, color: Colors.black),
            maxLines: 10,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}
