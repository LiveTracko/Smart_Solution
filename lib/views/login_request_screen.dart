import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_solutions/constants/static_stored_data.dart';
import 'package:smart_solutions/controllers/data_entry_controller.dart';
import 'package:smart_solutions/controllers/login_request_controller.dart';
import 'package:smart_solutions/utils/currency_util.dart';
import 'package:smart_solutions/views/data_entry_form.dart';
import 'package:smart_solutions/views/login_request_form.dart';

class LoginRequestScreen extends StatelessWidget {
  LoginRequestScreen({super.key});
  final LoginRequestController controller = Get.put(LoginRequestController());
  final DataController dataEntryController = Get.put(DataController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            controller.isEdit.value = true;
            controller.isNew.value = true;
            Get.to(() => LoginRequestForm());
          }),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Login Requests',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.getLoginRequestList(),
        child: Obx(() {
          if (controller.loginRequestList.isEmpty) {
            return const Center(
              child: Text(
                'No Data',
                style: TextStyle(color: Colors.black),
              ),
            );
          }

          return Obx(() => controller.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  padding:
                      const EdgeInsets.all(10.0), // Add padding to the list
                  itemCount: controller.loginRequestList.length,
                  itemBuilder: (context, index) {
                    final request = controller.loginRequestList[index];

                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 5.0),
                      child: ExpansionTile(
                        tilePadding:
                            const EdgeInsets.symmetric(horizontal: 10.0),
                        childrenPadding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        expandedCrossAxisAlignment: CrossAxisAlignment.start,
                        initiallyExpanded: false,
                        title: Row(
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: const CircleAvatar(
                                  backgroundColor: AppColors.primaryColor,
                                  radius: 18,
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  )),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(request.customerName.toString()),
                                Text(
                                    softWrap: true,
                                    style: const TextStyle(fontSize: 11),
                                    request.bankName.toString()),
                              ],
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  color: (request.title ?? '').toLowerCase() ==
                                          'not doable'
                                      ? const Color.fromARGB(255, 235, 52, 39)
                                      : Colors.green,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                    request.title!.isNotEmpty
                                        ? request.title.toString()
                                        : 'No status',
                                    style:
                                        const TextStyle(color: Colors.white)),
                              ),
                              Text(
                                  CurrencyUtils.formatIndianCurrency(
                                      request.loanAmount),
                                  style: TextStyle(color: Colors.grey[600])),
                            ],
                          ),
                        ),
                        trailing: SizedBox(
                          width: 80.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                      onTap: () async {
                                        controller.currentId.value = request.id;
                                        controller.customerName.value =
                                            request.customerName;
                                        controller.contactNumber.value =
                                            request.contactNumber;
                                        controller.loanAmount.value =
                                            request.loanAmount;
                                        controller.loanStatus.value =
                                            ((request.loanStatus == null ||
                                                    request.loanStatus!.isEmpty)
                                                ? "NA"
                                                : request.loanStatus)!;
                                        controller.bankId.value =
                                            request.bankName ?? "";
                                        controller.commonRemark.value =
                                            request.commonRemark;
                                        controller.sourceId.value =
                                            request.sourcingTitle ?? "";

                                        controller.getRemarks();
                                        await Get.to(() => LoginRequestForm());

                                        controller.getLoginRequestList();
                                      },
                                      child: const Icon(Icons.edit)),
                                  StaticStoredData.roleName != 'telecaller' &&
                                          StaticStoredData.roleName !=
                                              'teamleader'
                                      ? GestureDetector(
                                          onTap: () async {
                                            // dataEntryController.customerName
                                            //     .value = request.customerName;

                                            dataEntryController.contactNumber
                                                .value = request.contactNumber;

                                            dataEntryController.loanAmount
                                                .value = request.loanAmount;

                                            dataEntryController.Id.value =
                                                request.id;

                                            dataEntryController
                                                    .selectedSource.value =
                                                request.sourcing.toString();

                                            dataEntryController
                                                .selectTelecallerName
                                                .value = request.telecallerId;

                                            await Get.to(DataEntryForm(
                                                id: '',
                                                tellecallerId:
                                                    request.telecallerId,
                                                dsaId: '',
                                                bankerId: ''));
                                          },
                                          child: Icon(Icons.login,
                                              color: Colors.grey[700]))
                                      : const SizedBox.shrink()
                                ],
                              ),
                              Icon(
                                Icons.expand_more,
                                color: Colors.grey[700],
                              ),
                            ],
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDoubleRow(
                                    iconLeft: Icons.call,
                                    valueLeft: maskFirst6Digits(
                                        request.contactNumber.toString()),
                                    iconRight: null,
                                    valueRight: DateFormat('dd-MM-yyyy').format(
                                        DateTime.parse(request.loginRequestDate
                                            .toString()))),

                                // _buildSingleRow(
                                //     Icons.comment,
                                //     request.commonRemark.isNotEmpty
                                //         ? request.commonRemark
                                //         : ' No common Remark Available'
                                //         ),

                                Obx(
                                  () => _buildSingleRow(
                                      Icons.feedback,
                                      controller.remarksList.isNotEmpty
                                          //  request.remark.isNotEmpty
                                          ? controller.remarksList.first
                                          : 'No remark'),
                                )

                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     Text(
                                //       'Contact: ${request.contactNumber}',
                                //       style: TextStyle(color: Colors.grey[600]),
                                //     ),
                                //     const SizedBox(width: 4),
                                //     Text(
                                //       'Loan Status: ${request.title}',
                                //       style: TextStyle(color: Colors.grey[600]),
                                //     ),
                                //   ],
                                // )

                                // ElevatedButton.icon(
                                //   onPressed: () async {
                                // controller.currentId.value = request.id;
                                // controller.customerName.value =
                                //     request.customerName;
                                // controller.contactNumber.value =
                                //     request.contactNumber;
                                // controller.loanAmount.value =
                                //     request.loanAmount.replaceAll(',', '');
                                // controller.loanStatus.value =
                                //     ((request.loanStatus == null ||
                                //             request.loanStatus!.isEmpty)
                                //         ? "NA"
                                //         : request.loanStatus)!;
                                // controller.bankId.value =
                                //     request.bankName ?? "";
                                // controller.commonRemark.value =
                                //     request.commonRemark;
                                // controller.sourceId.value =
                                //     request.sourcingTitle ?? "";

                                // controller.getRemarks();
                                // var result =
                                //     await Get.to(() => LoginRequestForm());

                                // controller.getLoginRequestList();
                                // },
                                // icon: const Icon(Icons.edit),
                                // label: const Text('Edit Request'),
                                // style: ElevatedButton.styleFrom(
                                //   backgroundColor: Colors.blue.shade600,
                                // ),
                                //  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ));
        }),
      ),
    );
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
          Expanded(
            child: Row(
              children: [
                Icon(iconLeft, size: 14, color: Colors.grey[700]),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    valueLeft,
                    style: const TextStyle(fontSize: 12, color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(iconRight, size: 14, color: Colors.grey[700]),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    valueRight,
                    style: TextStyle(
                      fontSize: 12,
                      color: textColorRight ?? Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleRow(IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey[700]),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12, color: Colors.black),
              maxLines: 10,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
