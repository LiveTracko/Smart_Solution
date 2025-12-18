import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:smart_solutions/controllers/dailer_controller.dart';
import 'package:smart_solutions/controllers/follow_form.dart';
import 'package:smart_solutions/controllers/login_request_controller.dart';
import 'package:smart_solutions/controllers/remark_status_controller.dart';
import 'package:smart_solutions/utils/currency_util.dart';
import 'package:smart_solutions/widget/common_scaffold.dart';
import 'package:smart_solutions/widget/loading_page.dart';
import 'package:smart_solutions/widget/text_style.dart';
import '../constants/services.dart';

// ignore: must_be_immutable
class FollowBackForm extends StatelessWidget {
  final bool isRefresh;
  FollowBackForm({Key? key, this.isRefresh = true}) : super(key: key);

  final FollowBackFormController _formController =
      Get.find<FollowBackFormController>();
  final RemarkStatusController _remarkController =
      Get.put(RemarkStatusController());
  final LoginRequestController _loginRequestController =
      Get.put(LoginRequestController());
  final _formKey = GlobalKey<FormState>();
  var selectedDate = DateTime.now().obs;

  // final DialerController _dialerController = Get.put(DialerController());
  final DialerController _dialerController = Get.find<DialerController>();
  int backPressCounter = 0;
  bool canPop = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      onPopInvoked: (didPop) {
        if (didPop) return;
        final NavigatorState navigator = Navigator.of(context);
        backPressCounter++;
        if (backPressCounter == 1) {
          Get.snackbar('Restricted', "Press back button once again to close",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.blue.shade100);
          canPop = true;
          Future.delayed(const Duration(seconds: 2), () {
            backPressCounter = 0; // Reset counter after 2 seconds

            canPop = false;
          });
        } else {
          // Get.back();
          _dialerController.salary.value = '';
          _formController.bankName.value = '';
          _formController.mobile.value = '';
          _dialerController.elapsedTimeInSeconds.value = 0;
          _dialerController.customerName.value = '';
          _dialerController.customerLoan.value = '';
          _dialerController.followup_id.value = '';
          navigator.pop();
        }

        logOutput("$canPop and $backPressCounter");
      },
      child: CommonScaffold(
        showBack: true,
        title: 'Follow Up Add',

        // appBar: AppBar(
        //   automaticallyImplyLeading: false,
        //   title: const Text('Follow Up Add'),
        //   backgroundColor: AppColors.primaryColor,
        // ),
        body: Container(
          color: AppColors.whiteColor,
          child: RefreshIndicator(
            onRefresh: () async {
              await _formController.loadData(isRefresh);
            },
            child: Obx(() {
              if (_formController.isBankAndStatusLoading.value) {
                return const Center(child: LoadingPage());
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        // _buildDatePicker(context, false),
                        // SizedBox(height: 16.h),
                        // loan amount field
                        SizedBox(height: 10.h),
                        _buildTextField(
                          label: 'Customer Name',
                          prefixIcon: SvgPicture.asset(
                            'assets/images/user.svg',
                            height: 24,
                            width: 24,
                          ),
                          controller: _dialerController.customerNameController,
                          onChanged: (value) =>
                              _dialerController.customerName.value = value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter customer name';
                            }
                            // else if (_dialerController
                            //     .customerName.value.isNotEmpty) {
                            //   _dialerController.customerName.value =
                            //       _formController.customerName.value;
                            //   // _formController.customerName.value =
                            //   //     _dialerController.customerName.value;
                            // }
                            return null;
                          },
                        ),

                        SizedBox(height: 16.h),

                        _buildMobileField(
                          label: 'Enter Mobile Number',
                          controller: _formController.customerNumberController,
                          inputType: TextInputType.number,
                          prefixIcon: SvgPicture.asset(
                            'assets/images/phone.svg',
                            height: 24,
                            width: 24,
                          ),
                          onChanged: (value) {
                            _formController.mobile.value =
                                value; // ✅ Proper update
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter mobile number';
                            } else if (value.length < 10) {
                              return 'Please enter a valid phone number';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 16.h),

                        // _buildTextField(
                        //     isRead: _dialerController.salary.value.isEmpty
                        //         ? false
                        //         : true,
                        //     inputType: TextInputType.number,
                        //     label: 'Salary',
                        //     prefixIcon: SvgPicture.asset(
                        //       'assets/images/rupees.svg',
                        //       height: 24,
                        //       width: 24,
                        //     ),
                        //     value: (_dialerController.salary.value.isEmpty ||
                        //             _dialerController.salary.value == "0")
                        //         ? ""
                        //         : CurrencyUtils.formatAmount(
                        //             _dialerController.salary.value),
                        //     onChanged: (value) =>
                        //         _dialerController.salary.value = value,
                        //     validator: null),

                        // SizedBox(height: 16.h),

                        // _buildTextField(
                        //     isRead: _dialerController.customerLoan.value.isEmpty
                        //         ? false
                        //         : true,
                        //     label: 'Loan Amount',
                        //     inputType: TextInputType.number,
                        //     prefixIcon: SvgPicture.asset(
                        //       'assets/images/rupees.svg',
                        //       height: 24,
                        //       width: 24,
                        //     ),
                        //     value: CurrencyUtils.formatIndianCurrency(
                        //         _dialerController.customerLoan.value),
                        //     onChanged: (value) =>
                        //         _dialerController.customerLoan.value = value,
                        //     validator: null),

                        Row(
                          children: [
                            // ------- Salary Field -------
                            Expanded(
                              child: _buildTextField(
                                isRead:
                                    _dialerController.salary.value.isNotEmpty,
                                inputType: TextInputType.number,
                                label: 'Salary',
                                prefixIcon: SvgPicture.asset(
                                  'assets/images/rupees.svg',
                                  height: 24,
                                  width: 24,
                                ),
                                value: (_dialerController
                                            .salary.value.isEmpty ||
                                        _dialerController.salary.value == "0")
                                    ? ""
                                    : CurrencyUtils.formatAmount(
                                        _dialerController.salary.value),
                                onChanged: (value) =>
                                    _dialerController.salary.value = value,
                                validator: null,
                              ),
                            ),

                            const SizedBox(width: 12), // space between fields

                            // ------- Loan Amount Field -------
                            Expanded(
                              child: _buildTextField(
                                isRead: _dialerController
                                    .customerLoan.value.isNotEmpty,
                                label: 'Loan Amount',
                                inputType: TextInputType.number,
                                prefixIcon: SvgPicture.asset(
                                  'assets/images/loan_amount.svg',
                                  height: 28,
                                  width: 28,
                                  color: AppColors.primaryColor,
                                ),
                                value: (_dialerController
                                            .customerLoan.value.isEmpty ||
                                        _dialerController.customerLoan.value ==
                                            "0")
                                    ? ""
                                    : CurrencyUtils.formatIndianCurrency(
                                        _dialerController.customerLoan.value),
                                onChanged: (value) => _dialerController
                                    .customerLoan.value = value,
                                validator: null,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),

                        // Bank Name Field
                        _buildAllBankNamesDropdown(),
                        SizedBox(height: 16.h),

                        _buildDataSourcingDropdown(),
                        // Data Type Field
                        // _buildTextField(
                        //     label: 'Data Type',
                        //     prefixIcon:
                        //         SvgPicture.asset('assets/images/data_type.svg'),
                        //     value: _dialerController.datatype.value.isEmpty
                        //         ? ""
                        //         : _dialerController.datatype.value,
                        //     onChanged: (value) =>
                        //         _formController.dataType.value = value,
                        //     validator: null),
                        SizedBox(height: 16.h),

                        // Contact Status Radio Buttons
                        _buildContactStatusRadio(_formController
                            .customerNumberController.text.isEmpty),
                        SizedBox(height: 16.h),

                        // Remark Status Dropdown
                        _buildRemarkStatusDropdown(),
                        SizedBox(height: 16.h),

                        Obx(() => _remarkController.isCallback.value
                            ? _buildDatePicker(context, true)
                            : const SizedBox.shrink()),

                        // Remark Field
                        _buildTextField(
                            label: 'Remark',
                            value: _formController.remark.value,
                            maxLines: 3,
                            onChanged: (value) =>
                                _formController.remark.value = value,
                            validator: null),
                        SizedBox(height: 16.h),

                        // Submit Button
                        Padding(
                          padding: EdgeInsetsGeometry.only(bottom: 20.h),
                          child: _buildSubmitButton(),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    String? value,
    TextEditingController? controller,
    bool? isRead,
    required ValueChanged<String> onChanged,
    required String? Function(String?)? validator,
    Widget? prefixIcon,
    TextInputType inputType = TextInputType.text,
    int maxLines = 1,
  }) {
    Widget? decoratedPrefixIcon;

    if (prefixIcon != null) {
      decoratedPrefixIcon = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 8.0),
            child: prefixIcon,
          ),
          const SizedBox(
            height: 50,
            width: 5,
            child: VerticalDivider(
                width: 1, thickness: 1, color: AppColors.primaryColor),
          ),
          const SizedBox(width: 5)
        ],
      );
    }

    return TextFormField(
      keyboardType: inputType,
      maxLines: maxLines,
      readOnly: false,
      controller: controller,
      initialValue:
          controller == null && (value!.isNotEmpty ?? false) ? value : null,
      decoration: InputDecoration(
        //    labelText: label,
        hintText: label,
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),

        hintStyle: AppTextStyle.hintText,
        prefixIcon: decoratedPrefixIcon,
        labelStyle: AppTextStyle.textStyle,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0.r),
          borderSide: const BorderSide(color: AppColors.primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0.r),
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        filled: true,
        fillColor: AppColors.whiteColor,
      ),
      style: const TextStyle(color: AppColors.primaryColor),
      onChanged: onChanged,
      validator: validator,
    );
  }

  Widget _buildMobileField({
    String? value,
    required String label,
    TextEditingController? controller,
    required ValueChanged<String> onChanged,
    required String? Function(String?)? validator,
    TextInputType inputType = TextInputType.text,
    Widget? prefixIcon,
    int maxLines = 1,
  }) {
    Widget? decoratedPrefixIcon;

    if (prefixIcon != null) {
      decoratedPrefixIcon = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 8.0),
            child: prefixIcon,
          ),
          const SizedBox(
            height: 50,
            width: 5,
            child: VerticalDivider(
              thickness: 1,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(width: 5)
        ],
      );
    }
    return TextFormField(
      initialValue:
          controller == null && (value!.isNotEmpty ?? false) ? value : null,
      keyboardType: inputType,
      controller: controller,
      maxLines: maxLines,
      maxLength: 10,
      readOnly: false,
      decoration: InputDecoration(
        counterText: '',
        hintText: label,
        hintStyle: AppTextStyle.hintText,
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        prefixIcon: decoratedPrefixIcon,
        prefixIconConstraints: const BoxConstraints(
          minWidth: 0,
          minHeight: 0,
        ), //,
        labelStyle: const TextStyle(color: AppColors.secondaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0.r),
          borderSide: const BorderSide(color: AppColors.primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0.r),
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        filled: true,
        fillColor: AppColors.whiteColor,
      ),
      style: const TextStyle(color: AppColors.primaryColor),
      onChanged: onChanged,
      validator: validator,
    );
  }

  // Widget _buildDatePicker(BuildContext context, bool chooseDate) {
  //   // This controller will store the selected date
  //   // final selectedDate = DateTime.now().obs;
  //   final selectedDate = DateTime.now().obs;

  //   selectedDate.value = _formController.followupDate.value;

  //   return InkWell(
  //     onTap: () async {
  //       if (chooseDate) {
  //         final DateTime? picked = await showDatePicker(
  //           context: context,
  //           initialDate: DateTime.now(),
  //           firstDate: DateTime.now(), // Prevent selecting past dates
  //           lastDate: DateTime(2100), // Set a far future date limit
  //         );

  //         if (picked != null) {
  //           selectedDate.value = picked; // Update selected date
  //           _formController.followupDate.value = picked;
  //         }
  //       }
  //     },
  //     child: Container(
  //       padding: EdgeInsets.all(16.w),
  //       decoration: BoxDecoration(
  //         border: Border.all(color: AppColors.primaryColor),
  //         borderRadius: BorderRadius.circular(20.0.r),
  //         color: AppColors.backgroundColor,,
  //       ),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           chooseDate
  //               ? Text(
  //                   '${'Follow Up Date'}: ${DateFormat('dd-MM-yyyy').format(selectedDate.value)}',
  //                   style: const TextStyle(color: AppColors.primaryColor),
  //                 )
  //               : Text(
  //                   '${'Date'}: ${DateFormat('dd-MM-yyyy').format(DateTime.now())}',
  //                   style: const TextStyle(color: AppColors.primaryColor),
  //                 ),
  //           const Icon(Icons.calendar_today, color: AppColors.primaryColor),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildDatePicker(BuildContext context, bool chooseDate) {
    // Initialize selectedDate as null
    final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

    return InkWell(
      onTap: () async {
        if (chooseDate) {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2100),
          );

          if (picked != null) {
            selectedDate.value = picked;
            _formController.followupDate.value = picked;
          }
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryColor),
          borderRadius: BorderRadius.circular(10.0.r),
          color: AppColors.backgroundColor,
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 16.h),
            SvgPicture.asset(
              'assets/images/calendar.svg',
              height: 24,
              width: 24,
            ),
            SizedBox(width: 12.w),
            const SizedBox(
              width: 5,
              height: 50,
              child: VerticalDivider(
                width: 1,

                // width: 1,
                thickness: 1,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(width: 8),
            chooseDate
                ? Obx(() => Text(
                      '${'Follow Up Date'}: ${selectedDate.value != null ? DateFormat('dd-MM-yyyy').format(selectedDate.value!) : '-'}',
                      style: const TextStyle(color: AppColors.primaryColor),
                    ))
                : Text(
                    '${'Date'}: ${DateFormat('dd-MM-yyyy').format(DateTime.now())}',
                    style: const TextStyle(color: AppColors.primaryColor),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactStatusRadio(bool isRestricted) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contacted Status',
          style: TextStyle(
            color: AppColors.primaryColor,
            fontSize: 16.sp,
          ),
        ),
        // Obx(() =>
        Row(
          children: [
            Radio<String>(
              value: 'Yes',
              groupValue: _formController.contacted.value,
              onChanged: (value) {
                isRestricted
                    ? {
                        _formController.contacted.value = value!,
                        _remarkController.fetchRemarkStatus('1')
                      }
                    : {};
                // _formController.contacted.value = value!;
                // _remarkController.fetchRemarkStatus('1');
              },
              activeColor: AppColors.primaryColor,
            ),
            const Text(
              'Yes',
              style: TextStyle(
                color: AppColors.secondaryColor,
              ),
            ),
            SizedBox(width: 20.w),
            Radio<String>(
              value: 'No',
              groupValue: _formController.contacted.value,
              onChanged: (value) {
                isRestricted
                    ? {
                        _formController.contacted.value = value!,
                        _remarkController.fetchRemarkStatus('2')
                      }
                    : {};
                // _formController.contacted.value = value!;
                // _remarkController.fetchRemarkStatus('2');
              },
              activeColor: AppColors.primaryColor,
            ),
            const Text(
              'No',
              style: TextStyle(
                color: AppColors.secondaryColor,
              ),
            ),
          ],
          // )),
        )
      ],
    );
  }

  Widget _buildRemarkStatusDropdown() {
    return Obx(
      () =>
          // _remarkController.isLoading.value
          //     ? const Center(child: LoadingPage())
          //     :
          DropdownButtonFormField<String>(
        style: AppTextStyle.hintText,
        decoration: InputDecoration(
          hintText: 'Remark Status',
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          hintStyle: AppTextStyle.hintText,
          labelStyle: const TextStyle(color: AppColors.primaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0.r),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0.r),
            borderSide: const BorderSide(color: AppColors.primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0.r),
            borderSide:
                const BorderSide(color: AppColors.primaryColor, width: 2),
          ),
          filled: true,
          fillColor: AppColors.whiteColor,
        ),
        value: null,
        items: _remarkController.remarkStatusList.map((status) {
          // _formController.remarkStatus.value =
          //     _remarkController.remarkStatusList.first.id ?? "";
          return DropdownMenuItem<String>(
            value: status.id, // Use the ID as the value
            child: Text(
              status.title ?? 'Select remark status',
              style: const TextStyle(color: AppColors.primaryColor),
            ),
          );
        }).toList(),
        onChanged: (newValue) {
          _formController.remarkStatus.value = newValue ?? '';

          logOutput("Selected ID: ${_formController.remarkStatus.value}");

          // Find the selected status using the ID
          var selectedStatus = _remarkController.remarkStatusList
              .firstWhereOrNull((status) => status.id == newValue);
          logOutput('selected status ${selectedStatus?.title}');

          // Check if the selected status title is 'CallBack'
          if (selectedStatus?.title == 'Callback') {
            logOutput("Setting isCallback to true");
            _remarkController.isCallback.value = true;
          } else {
            logOutput("Setting isCallback to false");
            _remarkController.isCallback.value = false;
          }
        },
        validator: (value) {
          if (_formController.remarkStatus.value.isEmpty) {
            return 'Please select a remark status';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildAllBankNamesDropdown() {
    return Obx(
      () =>
          // _formController.isLoading.value
          //     ? const Center(child: LoadingPage())
          //     :
          SizedBox(
        width: double.infinity,
        child: DropdownButtonFormField<String>(
          isExpanded: true,
          isDense: true,
          style: AppTextStyle.hintText,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 8),

            prefixIcon: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/images/bank.svg',
                      height: 24,
                      width: 24,
                    ),
                    const VerticalDivider(
                      thickness: 1,
                      color: AppColors.primaryColor,
                    ),
                  ],
                ),
              ),
            ),
            hintText: "Select Bank",
            hintStyle: AppTextStyle.hintText,

            // labelStyle: AppTextStyle.hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0.r),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0.r),
              borderSide: const BorderSide(color: AppColors.primaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0.r),
              borderSide:
                  const BorderSide(color: AppColors.primaryColor, width: 2),
            ),
            filled: true,
            fillColor: AppColors.whiteColor,
          ),

          value:
              _getInitialBankValue(), // Use the method to get the initial value
          items: _formController.allBankNamesList.map((bank) {
            return DropdownMenuItem<String>(
              value: bank.bankName,
              child: Text(bank.bankName ?? 'Select bank',
                  style: const TextStyle(color: AppColors.primaryColor)),
            );
          }).toList(),
          onChanged: (newValue) {
            logOutput("bank is $newValue");
            _formController.bankName.value = newValue ?? 'Select bank';
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a bank';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildDataSourcingDropdown() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        child: DropdownButtonFormField<String>(
          isExpanded: true,
          isDense: true,
          style: AppTextStyle.hintText,
          padding: EdgeInsets.zero,

          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 8),

            prefixIcon: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/images/data_type.svg',
                      height: 24,
                      width: 24,
                    ),
                    const VerticalDivider(
                      thickness: 1,
                      color: AppColors.primaryColor,
                    ),
                  ],
                ),
              ),
            ),
            hintText: "Select Source",
            hintStyle: AppTextStyle.hintText,
            //  labelStyle: const TextStyle(color: AppColors.primaryColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0.r),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0.r),
              borderSide: const BorderSide(color: AppColors.primaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0.r),
              borderSide:
                  const BorderSide(color: AppColors.primaryColor, width: 2),
            ),
            filled: true,
            fillColor: AppColors.whiteColor,
          ),
          value:
              _getInitialSourceValue(), // Use the method to get the initial value
          items: _buildSourceDropdownItems(),

          onChanged: (newValue) {
            _formController.dataType.value = newValue.toString();
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a source';
            }
            return null;
          },
        ),
      ),
    );
  }

  String? _getInitialBankValue() {
    // Check if the controller's bankName is in the available bank list
    if (_formController.bankName.value == 'Select bank') {
      return null; // Keep it null to show the placeholder
    }
    final existingBank = _formController.allBankNamesList.firstWhereOrNull(
        (bank) => bank.bankName == _formController.bankName.value);
    return existingBank
        ?.bankName; // If found, return it; otherwise, return null
  }

  // Helper method to get the initial bank value
  String? _getInitialSourceValue() {
    final existingSource =
        _loginRequestController.sourcingList.firstWhereOrNull(
      (source) =>
          source.sourcingTitle?.toLowerCase().trim() ==
          _loginRequestController.sourceId.value.toLowerCase().trim(),
    );

    return existingSource?.id;
  }

  Widget _buildSubmitButton() {
    return Obx(() => ElevatedButton(
          onPressed: _formController.isFormSubmitted.value
              ? null
              : () async {
                  if (_formKey.currentState!.validate()) {
                    final res = await _formController.submitFollowUp();
                    // Hide keyboard first (optional)
                    // FocusManager.instance.primaryFocus?.unfocus();

                    // Show snackbar here in the UI
                    if (res) {
                      Get.snackbar(
                        'Success',
                        'Follow up saved successfully',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green.shade400,
                        colorText: Colors.white,
                        margin: const EdgeInsets.all(12),
                        borderRadius: 8,
                        duration: const Duration(seconds: 2),
                      );
                    }
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            padding: EdgeInsets.symmetric(vertical: 15.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0.r),
            ),
          ),
          child: _formController.isLoading.value
              ? const LoadingPage()
              : Text(
                  'Submit',
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
        ));
  }

  // Helper method to build dropdown items
  List<DropdownMenuItem<String>> _buildSourceDropdownItems() {
    return _loginRequestController.sourcingList.map((source) {
      return DropdownMenuItem<String>(
          value: source.id,
          child: Text(
            source.sourcingTitle ?? '',
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.textStyle,
          ));
    }).toList();
  }
}

// Constants class for colors
class AppColors {
//  static const Color primaryColor = Color(0xFF2196F3);
  static const Color primaryColor = Color(0xFF356EFF);
  static const Color secondaryColor = Color(0xFF5E5E5E);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color ongoindCallColor = Color.fromARGB(255, 245, 43, 43);
  static const Color greyColor = Color(0xFFF1F1F1);
  static const Color greenColor = Color(0xFF00AB1A);
  static const Color blackColor = Color.fromARGB(255, 23, 23, 23);
  static const Color whiteColor = Colors.white;
}
