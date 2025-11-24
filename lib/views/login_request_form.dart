import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_solutions/constants/static_stored_data.dart';
import 'package:smart_solutions/controllers/follow_form.dart';
import 'package:smart_solutions/controllers/login_request_controller.dart';
import 'package:smart_solutions/widget/common_scaffold.dart';
import 'package:smart_solutions/widget/loading_page.dart';
import 'package:smart_solutions/widget/suggestin_textfiels.dart';
import 'package:smart_solutions/widget/text_style.dart';

import '../constants/services.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF356EFF);
  //Colors.blue;
  static const Color secondaryColor = Colors.grey;
  static const Color backgroundColor = Colors.white;
}

class LoginRequestForm extends StatelessWidget {
  final LoginRequestController controller = Get.put(LoginRequestController());
  final FollowBackFormController _followBackFormController =
      Get.find<FollowBackFormController>();

  final _formKey = GlobalKey<FormState>(); // Form key for validation

  LoginRequestForm({super.key});

  final TextEditingController customerNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          controller.remarksList.clear();
          controller.isEdit.value = false;
          controller.isNew.value = false;
          controller.loginRequestDate = DateTime.now().obs;
          controller.telecallerId = StaticStoredData.userId.obs;
          controller.customerName.value = '';
          controller.contactNumber.value = '';
          controller.loanStatus.value = '1'; // Default loan status
          controller.bankId.value = '';
          controller.loanAmount.value = '';
          controller.commonRemark.value = '';
          controller.remarksList.value = []; // To hold multiple remarks
          controller.currentId = ''.obs;
          controller.sourceId.value = '';
        }
      },
      child: CommonScaffold(
        title: 'Login Request Form',
        showBack: true,
        actions: [
          Obx(() => controller.isNew.value
              ? const SizedBox.shrink()
              : IconButton(
                  onPressed: () {
                    controller.isEdit.value = !controller.isEdit.value;
                  },
                  icon: Icon(
                    Icons.edit,
                    color: controller.isEdit.value ? Colors.red : Colors.white,
                  )))
        ],
        body: Container(
          color: AppColors.backgroundColor,
          child: Obx(() {
            if (customerNameController.text != controller.customerName.value) {
              customerNameController.text = controller.customerName.value;
            }
            final filteredNames = _followBackFormController.allCustomerName
                .where((e) => e.contactNumber == controller.contactNumber.value)
                .map((e) => e.customerName ?? '')
                .toList();
            return controller.iseditLoading.value
                ? const LoadingPage()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10.h),
                            _buildTextField(
                              label: 'Contact Number',
                              prefixIcon:
                                  SvgPicture.asset('assets/images/phone.svg'),
                              content: controller.contactNumber.value,
                              onChanged: (value) {
                                controller.contactNumber.value = value;
                              },
                              inputType: TextInputType.phone,
                              validator: _validatePhone,
                            ),
                            const SizedBox(height: 10),
                            SuggestionTextField(
                                label: 'Customer Name',
                                svgIconPath: 'assets/images/user.svg',
                                onChanged: (value) {
                                  controller.customerName.value = value;

                                  final matchedCustomer =
                                      _followBackFormController.allCustomerName
                                          .firstWhereOrNull(
                                    (e) =>
                                        e.customerName ==
                                        controller.customerName.value,
                                  );

                                  final sourceTitle =
                                      matchedCustomer?.dataType ?? '';

                                  // 🔍 find match by name (case-insensitive)
                                  final matchedSource = controller.sourcingList
                                      .firstWhereOrNull((source) =>
                                          (source.id ?? '')
                                              .toLowerCase()
                                              .trim() ==
                                          sourceTitle.toLowerCase().trim());

                                  if (matchedSource != null) {
                                    // ✅ update values when name matches
                                    controller.sourceId.value =
                                        matchedSource.sourcingTitle.toString();
                                    // controller.sourceId.value =
                                    //     matchedSource.sourcingTitle ?? '';
                                    log('Matched: ${matchedSource.sourcingTitle} (ID: ${matchedSource.id})');
                                    _getInitialSourceValue();
                                  } else {
                                    // ❌ clear if no match found
                                    controller.sourceId.value = '';

                                    log('No matching source found for name: $value');
                                  }
                                },
                                controller: customerNameController,
                                suggestions: filteredNames),

                            // _buildTextField(
                            //   label: 'Customer Name',
                            //   prefixIcon: SvgPicture.asset(
                            //     'assets/images/user.svg',
                            //     height: 24,
                            //     width: 24,
                            //   ),
                            //   content: controller.customerName.value,
                            //   onChanged: (value) =>
                            //       controller.customerName.value = value,
                            //   validator: _validateNotEmpty,
                            // ),
                            const SizedBox(height: 10),

                            _buildTextField(
                              label: 'Loan Amount',
                              prefixIcon: SvgPicture.asset(
                                'assets/images/rupees.svg',
                                height: 24,
                                width: 24,
                              ),
                              content: controller.loanAmount.value.isNotEmpty
                                  ? NumberFormat.currency(
                                          locale: 'en_IN',
                                          symbol: '',
                                          decimalDigits: 0)
                                      .format(int.tryParse(
                                              controller.loanAmount.value) ??
                                          0)
                                  : '',
                              onChanged: (value) {
                                // Remove commas to get the numeric value before formatting
                                String plainTextValue =
                                    value.replaceAll(',', '');
                                controller.loanAmount.value = plainTextValue;

                                // Format the numeric value back to the Indian format
                                String formattedValue = NumberFormat.currency(
                                        locale: 'en_IN',
                                        symbol: '',
                                        decimalDigits: 0)
                                    .format(int.tryParse(plainTextValue) ?? 0);

                                controller.loanAmount.value = formattedValue;
                              },
                              inputType: TextInputType.number,
                              validator: _validateNumber,
                            ),

                            const SizedBox(height: 10),

                            // _buildLoanStatusDropdown(),
                            // const SizedBox(height: 10),
                            _buildAllBankNamesDropdown(),
                            const SizedBox(height: 10),

                            _buildSourcingDropdown(),
                            const SizedBox(height: 10),

                            // _buildTextField(
                            //   label: 'Common remark',
                            //   content: controller.commonRemark.value,
                            //   onChanged: (value) => controller.commonRemark.value = value,
                            //   // validator: _validateNotEmpty,
                            // ),
                            const SizedBox(height: 10),
                            // Dynamic Remarks Section
                            _buildRemarksSection(),

                            Center(
                              child: Obx(() => SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          controller
                                              .saveLoginRequest(); // Call save method
                                          controller.getLoginRequestList();
                                        }
                                      },
                                      child: controller.isLoading.value
                                          ? const LoadingPage()
                                          : const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 24.0),
                                              child: Text(
                                                'Save Request',
                                              ),
                                            ),
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
          }),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String content,
    required String label,
    required ValueChanged<String> onChanged,
    Widget? prefixIcon,
    TextInputType inputType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
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
          const SizedBox(
            width: 5,
          )
        ],
      );
    }
    return Obx(() => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
          child: TextFormField(
            keyboardType: inputType,
            maxLines: maxLines,
            readOnly: !controller.isEdit.value,
            initialValue: content.isNotEmpty ? content : null,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              prefixIcon: decoratedPrefixIcon,
              //   labelText: label,
              hintText: label,

              //    labelStyle: const TextStyle(color: AppColors.primaryColor),
              hintStyle: AppTextStyle.hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: AppColors.primaryColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide:
                    const BorderSide(color: AppColors.primaryColor, width: 2),
              ),
              filled: true,
              fillColor: AppColors.backgroundColor,
            ),
            style: const TextStyle(color: AppColors.primaryColor),
            onChanged: onChanged,
            validator: validator,
          ),
        ));
  }

  // Dynamic Remarks Section
  Widget _buildRemarksSection() {
    return Obx(() {
      // List to hold dynamic remark TextField widgets
      List<Widget> remarkFields = [];

      for (int i = 0; i < controller.remarksList.length; i++) {
        remarkFields.add(
          _buildTextField(
            content: controller.remarksList[i],
            maxLines: 3,
            label: 'Remark ${i + 1}',
            onChanged: (value) {
              // Update remarksList with the new value
              controller.remarksList[i] = value.trim();
            },
            validator: _validateNotEmpty,
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...remarkFields,
          // Add button to create a new remark field
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.add, color: AppColors.primaryColor),
                onPressed: () {
                  // Add a new empty remark to the list
                  controller.remarksList.add('');
                },
              ),
              const Text(
                'Add remark',
                style: TextStyle(color: Colors.black),
              )
            ],
          ),
        ],
      );
    });
  }

  // Validation Functions
  String? _validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
  }

  String? _validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }
    final numeric = value.replaceAll(',', '');
    if (double.tryParse(numeric) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }
    if (value.length < 10) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  Widget _buildAllBankNamesDropdown() {
    return Obx(
      () => controller.isLoading.value
          ? const Center(child: LoadingPage())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                isDense: true,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  prefixIcon: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 5.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/images/bank.svg',
                            height: 24,
                            width: 24,
                          ),
                          SizedBox(width: 5.w),
                          const VerticalDivider(
                            thickness: 1,
                            color: AppColors.primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
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
                    borderSide: const BorderSide(
                      color: AppColors.primaryColor,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: AppColors.backgroundColor,
                ),
                value: _getInitialBankValue(),
                hint: const Text(
                  'Select bank',
                  style: TextStyle(color: Colors.grey),
                ),
                // isExpanded: true, // Ensures the dropdown takes full width
                items: _buildBankDropdownItems(),
                onChanged: !controller.isEdit.value
                    ? null
                    : (newValue) {
                        logOutput("new value is $newValue");
                        if (newValue != null) {
                          controller.bankId.value = newValue;
                        }
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

// Helper method to get the initial bank value
  String? _getInitialBankValue() {
    log('controller.bankId.value: ${controller.bankId.value}');
    // Check if the controller's bankId is in the available bank list
    final existingBank = controller.allBankNamesList
        .firstWhereOrNull((bank) => bank.bankName == controller.bankId.value);
    return existingBank?.id; // If found, return it; otherwise, return null
  }

// Helper method to build dropdown items
  List<DropdownMenuItem<String>> _buildBankDropdownItems() {
    return controller.allBankNamesList.map((bank) {
      return DropdownMenuItem<String>(
        value: bank.id,
        child: Text(
          bank.bankName,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }).toList();
  }

  //
  Widget _buildSourcingDropdown() {
    return Obx(
      () => controller.isLoading.value
          ? const Center(child: LoadingPage())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                isDense: true,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  prefixIcon: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 5.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/images/data_type.svg',
                            height: 24,
                            width: 24,
                          ),
                          SizedBox(width: 5.w),
                          const VerticalDivider(
                            thickness: 1,
                            color: AppColors.primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  hintText: 'Select Source',
                  //  labelText: 'Select Source',
                  //   labelStyle: const TextStyle(color: AppColors.secondaryColor),
                  hintStyle: const TextStyle(color: AppColors.primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0.r),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0.r),
                    borderSide: const BorderSide(color: AppColors.primaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0.r),
                    borderSide: const BorderSide(
                      color: AppColors.primaryColor,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: AppColors.backgroundColor,
                ),
                value: _getInitialSourceValue(),
                hint: const Text(
                  'Select Source',
                  style: TextStyle(color: Colors.grey),
                ),
                items: _buildSourceDropdownItems(),
                onChanged: controller.isEdit.value
                    ? (newValue) {
                        if (newValue != null) {
                          controller.sourceId.value = newValue;
                        }
                      }
                    : null,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a Source';
                  }
                  return null;
                },
              ),
            ),
    );
  }

  // Helper method to build dropdown items
  List<DropdownMenuItem<String>> _buildSourceDropdownItems() {
    return controller.sourcingList.map((source) {
      return DropdownMenuItem<String>(
        value: source.id,
        child: Text(
          source.sourcingTitle ?? '',
          overflow: TextOverflow.ellipsis,
        ),
      );
    }).toList();
  }

  // Helper method to get the initial bank value
  String? _getInitialSourceValue() {
    log('controller.sourceId.value: ${controller.sourceId.value}');

    final existingSource = controller.sourcingList.firstWhereOrNull(
      (source) =>
          source.sourcingTitle?.toLowerCase().trim() ==
          controller.sourceId.value.toLowerCase().trim(),
    );

    return existingSource?.id;
  }
}
