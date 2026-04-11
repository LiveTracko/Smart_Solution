import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_solutions/controllers/data_entry_controller.dart';
import 'package:smart_solutions/theme/app_theme.dart';
import 'package:smart_solutions/utils/currency_util.dart';
import 'package:smart_solutions/widget/common_scaffold.dart';
import 'package:smart_solutions/widget/loading_page.dart';
import '../constants/services.dart';
import '../controllers/theme_controller.dart';

class DataEntryForm extends StatefulWidget {
  final String? id;
  final String? tellecallerId;
  final String? dsaId;
  final String? bankerId;
  final bool isMovetoLogin;
  const DataEntryForm(
      {super.key,
      required this.id,
      required this.tellecallerId,
      required this.dsaId,
      required this.bankerId,
      this.isMovetoLogin = false});

  @override
  State<DataEntryForm> createState() => _DataEntryFormState();
}

class _DataEntryFormState extends State<DataEntryForm> {
  final DataController controller = Get.find<DataController>();
  final _formKey = GlobalKey<FormState>();

  final ThemeController themeController = Get.find<ThemeController>();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initialLoad(); // ✅ SAFE
    });
    // controller.tellecallerId.value = widget.tellecallerId ?? '';
    // controller.dataId.value = widget.id ?? '';
    // controller.dsaId.value = widget.dsaId ?? '';

    // controller.fetchDataEntryListSpecificId();
    // controller.getSourcingList();
    // controller.getDsaBankList(widget.dsaId ?? '');
    // controller.getBankerNameByloginBank(
    //     widget.dsaId.toString(), controller.selectedBankName.toString());
    // // controller.getBankerDetailsName(widget.bankerId ?? '');
    // controller.getMobileByCustomerData(controller.contactNumber.value);
    // controller.getTeamLeadById(widget.tellecallerId.toString());
  }

  initialLoad() {
    controller.isMovetoLogin.value = widget.isMovetoLogin ?? false;
    controller.isLoading.value = true;
    controller.tellecallerId.value = widget.tellecallerId ?? '';
    controller.dataId.value = widget.id ?? '';
    controller.dsaId.value = widget.dsaId ?? '';
    if (widget.isMovetoLogin == true) {
      controller.fetchmoveToLoginData(widget.id.toString());
    } else {
      controller.fetchDataEntryListSpecificId();
    }
    controller.getSourcingList();
    controller.getDsaBankList(widget.dsaId ?? '');
    controller.getBankerNameByloginBank(
        widget.dsaId.toString(), controller.selectedBankName.toString());
    // controller.getBankerDetailsName(widget.bankerId ?? '');
    controller.getMobileByCustomerData(controller.contactNumber.value);
    controller.getTeamLeadById(widget.tellecallerId.toString());
  }

  List<DropdownMenuItem<String>> yesNoItems = const [
    DropdownMenuItem(value: 'Yes', child: Text('Yes')),
    DropdownMenuItem(value: 'No', child: Text('No')),
  ];

  List<DropdownMenuItem<String>> openorClose = const [
    DropdownMenuItem(value: 'Open', child: Text('Open')),
    DropdownMenuItem(value: 'Closed', child: Text('Closed')),
  ];
  @override
  Widget build(BuildContext context) {
    return PopScope(
        onPopInvoked: (didPop) {
          if (didPop) {
            controller.dsaName.value = '';
            controller.date.value = '';
            controller.contactNumber.value = '';
            controller.customerName.value = '';

            // controller.date = ''.obs;
            // controller.telecallerId = StaticStoredData.userId.obs;
            controller.customerName.value = '';
            controller.income.value = '';
            controller.companyName.value = ''; // Default loan status
            //    controller.caseType.value = '';
            controller.loanAmount.value = '';
            controller.dob.value = '';
            controller.selectedCaseType.value = '';
            controller.selectedproductType.value =
                ''; // To hold multiple remarks
            controller.bankName = ''.obs;
            controller.bankerMobile.value = '';
            controller.bankerEmail.value = '';
            controller.losNo.value = '';
            controller.telecaller.value = '';
            controller.status.value = '';
            controller.source.value = '';
            controller.caseStudy.value = '';
            controller.comments.value = '';
            controller.teamleader.value = '';
          }
        },
        child: CommonScaffold(
            title: 'Data Entry Form',
            actions: [
              Obx(() => controller.isNew.value
                  ? const SizedBox.shrink()
                  : IconButton(
                      onPressed: () {
                        controller.isEdit.value = !controller.isEdit.value;
                      },
                      icon: Icon(
                        Icons.edit,
                        color:
                            controller.isEdit.value ? Colors.red : Colors.white,
                      )))
            ],
            // appBar: AppBar(
            //   centerTitle: true,
            //   title:
            //       const Text('Data Entry Form', style: TextStyle(fontSize: 20)),
            //   actions: [
            //     Obx(() => controller.isNew.value
            //         ? const SizedBox.shrink()
            //         : IconButton(
            //             onPressed: () {
            //               controller.isEdit.value = !controller.isEdit.value;
            //             },
            //             icon: Icon(
            //               Icons.edit,
            //               color: controller.isEdit.value
            //                   ? Colors.red
            //                   : Colors.white,
            //             )))
            //   ],
            // ),
            body: Obx(() {
              if (controller.isDataEntryLoading.value) {
                return const LoadingPage();
              }
              return Container(
                color: const Color(0xffF5F7FB), // light modern background
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5.h),
                          titileWithIcon(
                              title: 'Customer Information',
                              iconPath: 'assets/images/basic_info.svg'),
                          SizedBox(height: 10.h),

                          _buildTextField(
                            label: 'Mobile Number',
                            prefixIcon: SvgPicture.asset(
                              'assets/images/phone.svg',
                              color: themeController.primaryColor.value,
                              height: 20,
                              width: 20,
                            ),
                            content: controller.contactNumber,
                            onChanged: (value) =>
                                controller.contactNumber.value = value,
                            inputType: TextInputType.phone,
                            validator: _validatePhone,
                          ),
                          Obx(
                            () => _buildTextField(
                              label: 'Customer Name',
                              prefixIcon: SvgPicture.asset(
                                'assets/images/user.svg',
                                color: themeController.primaryColor.value,
                                height: 20,
                                width: 20,
                              ),
                              content: controller.customerName,
                              onChanged: (value) =>
                                  controller.customerName.value = value,
                              inputType: TextInputType.text,
                              validator: _validateNotEmpty,
                            ),
                          ),

                          _buildTextField(
                            content: controller.dob,
                            prefixIcon: SvgPicture.asset(
                              'assets/images/dob.svg',
                              color: themeController.primaryColor.value,
                              height: 20,
                              width: 20,
                            ),
                            label: 'DOB',
                            //   validator: (value) => _validateNotEmpty(value),
                            onChanged: (value) => controller.dob.value = value,
                          ),
                          _buildTextField(
                            label: 'Company Name',
                            prefixIcon: SvgPicture.asset(
                              'assets/images/company_name.svg',
                              color: themeController.primaryColor.value,
                              height: 20,
                              width: 20,
                            ),
                            content: controller.companyName,
                            onChanged: (value) =>
                                controller.companyName.value = value,
                            inputType: TextInputType.phone,
                            validator: _validateNotEmpty,
                          ),

                          _buildTextField(
                            label: 'Income',
                            prefixIcon: SvgPicture.asset(
                              'assets/images/data_type.svg',
                              height: 20,
                              width: 20,
                              color: themeController.primaryColor.value,
                            ),
                            content: controller.income,
                            onChanged: (value) =>
                                controller.income.value = value,
                            inputType: TextInputType.phone,
                            validator: _validateNotEmpty,
                          ),

                          titileWithIcon(
                              title: 'Sourcing Details',
                              iconPath: 'assets/images/basic_info.svg'),

                          _buildDsaDropdown(),

                          _buildTextField(
                              content: controller.date,
                              prefixIcon: SvgPicture.asset(
                                  'assets/images/calendar.svg',
                                  color: themeController.primaryColor.value,
                                  height: 20,
                                  width: 20),
                              label: 'Entry Date',
                              validator: (value) => _validatePhone(value),
                              onChanged: (value) =>
                                  controller.date.value = value),

                          _buildTeleCallerDropdown(),

                          _buildTextField(
                            label: 'Team Leader',
                            prefixIcon: SvgPicture.asset(
                              'assets/images/teamleader.svg',
                              height: 20,
                              width: 20,
                              color: themeController.primaryColor.value,
                            ),
                            content: controller.teamleader,
                            onChanged: (value) =>
                                controller.teamleader.value = value,
                            // validator: _validateNotEmpty,
                          ),

                          _buildSourcingDropdown(),

                          titileWithIcon(
                              title: 'Loan & Case Details',
                              iconPath: 'assets/images/basic_info.svg'),

                          const SizedBox(height: 10),

                          _buildProductTypeDropdown(),

                          Obx(
                            () => buildCommonDropdown(
                              hint: 'Balance Transfer',
                              items: yesNoItems,
                              iconPath: 'assets/images/teamleader.svg',
                              value:
                                  controller.selectedBanktransactionType.value,
                              onChanged: (newValue) {
                                if (newValue != null) {
                                  controller.selectedBanktransactionType.value =
                                      newValue;

                                  if (newValue == 'Yes') {
                                    controller.selectedDemandDraftStatus.value =
                                        'Open';
                                  } else if (newValue == 'No') {
                                    controller.selectedDemandDraftStatus.value =
                                        'Closed';
                                  }
                                }
                              },
                            ),
                          ),

                          Obx(
                            () => buildCommonDropdown(
                                hint: 'Demand Draft Status',
                                items: openorClose,
                                iconPath: 'assets/images/teamleader.svg',
                                value:
                                    controller.selectedDemandDraftStatus.value,
                                onChanged: (newValue) {
                                  if (newValue != null) {
                                    controller.selectedDemandDraftStatus.value =
                                        newValue;
                                  }
                                }),
                          ),

                          //   _buildCaseTypeDropdown(),

                          titileWithIcon(
                              title: 'Bank Information',
                              iconPath: 'assets/images/basic_info.svg'),

                          const SizedBox(height: 10),

                          _buildloginBankDropdown(),
                          const SizedBox(height: 10),

                          _buildBankerNameDropdown(),
                          const SizedBox(height: 10),

                          _buildTextField(
                            label: 'Banker Mobile',
                            prefixIcon: SvgPicture.asset(
                              'assets/images/phone.svg',
                              color: themeController.primaryColor.value,
                              height: 20,
                              width: 20,
                            ),
                            content: controller.bankerMobile,
                            onChanged: (value) =>
                                controller.bankerMobile.value = value,
                            // validator: _validateNotEmpty,
                          ),

                          _buildTextField(
                              label: 'Banker Email',
                              prefixIcon: SvgPicture.asset(
                                'assets/images/email.svg',
                                color: themeController.primaryColor.value,
                                height: 20,
                                width: 20,
                              ),
                              content: controller.bankerEmail,
                              onChanged: (value) =>
                                  controller.bankerEmail.value = value),

                          _buildTextField(
                            label: 'Loan Amount',
                            prefixIcon: SvgPicture.asset(
                              'assets/images/rupees.svg',
                              color: themeController.primaryColor.value,
                              height: 20,
                              width: 20,
                            ),
                            content: controller.loanAmount,
                            formatAsCurrency: true,
                            // CurrencyUtils.formatIndianCurrency(
                            //     controller.loanAmount.value),
                            onChanged: (value) {
                              // Remove commas to get the numeric value before formatting
                              String plainTextValue = value.replaceAll(',', '');
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

                          _buildTextField(
                            label: 'LOS No.',
                            prefixIcon: SvgPicture.asset(
                              'assets/images/company_name.svg',
                              color: themeController.primaryColor.value,
                              height: 20,
                              width: 20,
                            ),
                            content: controller.losNo,
                            onChanged: (value) =>
                                controller.losNo.value = value,
                            // validator: _validateNotEmpty,
                          ),
                          const SizedBox(height: 10),

                          _buildStatusDropdown(),
                          const SizedBox(height: 10),

                          titileWithIcon(
                              title: 'Case Study & Comments',
                              iconPath: 'assets/images/basic_info.svg'),

                          _buildTextField(
                            label: 'Case Study ',
                            content: controller.caseStudy,

                            onChanged: (value) =>
                                controller.caseStudy.value = value,
                            // validator: _validateNotEmpty,
                          ),

                          Obx(
                            () => ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.commentList.length,
                              itemBuilder: (context, index) {
                                final comment = controller.commentList[index];

                                return Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xffF5F5F5),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _buildTextField(
                                              content:
                                                  (comment.comment ?? '').obs,
                                              label: 'Comment',
                                              onChanged: (value) =>
                                                  comment.comment = value,
                                            ),
                                          ),

                                          /// ✅ Show cross ONLY for new comments
                                          if (comment.isLocal)
                                            GestureDetector(
                                              onTap: () {
                                                controller.commentList
                                                    .removeAt(index);
                                              },
                                              child: const Icon(
                                                Icons.close,
                                                size: 18,
                                                color: Colors.red,
                                              ),
                                            ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: Text(
                                              'By ${comment.name ?? 'N/A'} '
                                              'on ${DateFormat('MMM dd, yyyy hh:mm:ss').format(DateTime.parse(comment.date ?? ''))}',
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),

                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: controller.addComment,
                              child: const Text('Add Comment'),
                            ),
                          ),

                          // _buildTextField(
                          //   label: 'Comments ',
                          //   content: controller.comments,
                          //   onChanged: (value) =>
                          //       controller.comments.value = value,
                          //   // validator: _validateNotEmpty,
                          // ),
                          // const SizedBox(height: 5),
                          // Container(
                          //   alignment: Alignment.bottomRight,
                          //   child: Text(
                          //     textAlign: TextAlign.end,
                          //     'By ${controller.adminSubadminName.value.isNotEmpty ? controller.adminSubadminName.value : 'N/A'}  ',
                          //     //on ${DateFormat('dd-MM-yy HH:mm:ss').format(DateTime.parse(controller.date.toString()))}',
                          //     style: const TextStyle(
                          //         fontSize: 15, color: Colors.grey),
                          //   ),
                          // ),

                          const SizedBox(height: 20),

                          // // _buildLoanStatusDropdown(),
                          // // const SizedBox(height: 10),
                          // _buildAllBankNamesDropdown(),
                          // const SizedBox(height: 10),

                          // _buildSourcingDropdown(),
                          // const SizedBox(height: 10),

                          // _buildTextField(
                          //   label: 'Common remark',
                          //   content: controller.commonRemark.value,
                          //   onChanged: (value) => controller.commonRemark.value = value,
                          //   // validator: _validateNotEmpty,
                          // ),
                          // const SizedBox(height: 10),
                          // // Dynamic Remarks Section
                          // _buildRemarksSection(),
                          // const SizedBox(height: 20),

                          Center(
                            child: Obx(() => ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(120, 45),
                                  ),
                                  onPressed: controller.isDataEntryLoading.value
                                      ? null
                                      : () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            final success = await controller
                                                .saveDataEntryForm();

                                            if (!mounted) return;

                                            if (success) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Data Entry saved successfully!'),
                                                  backgroundColor: Colors.green,
                                                ),
                                              );

                                              Navigator.pop(context); // ✅ SAFE
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Failed to save data'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          }
                                        },
                                  child: controller.isSaveLoading.value
                                      ? const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              height: 18,
                                              width: 18,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              "Submitting...",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        )
                                      : const Text(
                                          'Submit',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                )),
                          )

                          // Center(
                          //   child: Obx(() => ElevatedButton(
                          //         onPressed: () {
                          //           if (_formKey.currentState!.validate()) {
                          //             controller
                          //                 .saveDataEntryForm(); // Call save method
                          //             //        controller.getLoginRequestList();
                          //           }
                          //         },
                          //         child: controller.isDataEntryLoading.value
                          //             ? const LoadingPage()
                          //             : const Padding(
                          //                 padding: EdgeInsets.symmetric(
                          //                     horizontal: 24.0),
                          //                 child: Text(
                          //                   'Submit',
                          //                   style:
                          //                       TextStyle(color: Colors.white),
                          //                 ),
                          //               ),
                          //       )),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            })));
  }

  Widget _buildTextField({
    required RxString content,
    required String label,
    required ValueChanged<String> onChanged,
    Widget? prefixIcon,
    TextInputType inputType = TextInputType.text,
    String? Function(String?)? validator,
    bool formatAsCurrency = false, // optional flag
  }) {
    final textController = TextEditingController(text: content.value);

    // Keep the controller in sync with the content
    textController.selection = TextSelection.fromPosition(
      TextPosition(offset: textController.text.length),
    );

    Widget? decoratedPrefixIcon;

    if (prefixIcon != null) {
      decoratedPrefixIcon = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 8.0),
              child: prefixIcon),
          SizedBox(
            height: 50,
            width: 5,
            child: VerticalDivider(
                width: 1,
                thickness: 1,
                color: themeController.primaryColor.value),
          ),
        ],
      );
    }
    return Obx(() {
      final displayValue = formatAsCurrency
          ? CurrencyUtils.formatIndianCurrency(content.value)
          : content.value;

      if (textController.text != displayValue) {
        textController.text = displayValue;
        textController.selection = TextSelection.fromPosition(
          TextPosition(offset: textController.text.length),
        );
      }

      return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(color: AppColors.secondayColor)),
              TextFormField(
                keyboardType: inputType,
                maxLines: null,
                readOnly: !controller.isEdit.value,
                controller: textController,
                //  initialValue: content.isNotEmpty ? content : null,
                decoration: InputDecoration(
                  prefixIcon: decoratedPrefixIcon,
                  hintText: "Enter $label",
                  labelStyle: const TextStyle(color: AppColors.secondayColor),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide(color: themeController.primaryColor.value),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                          color: themeController.primaryColor.value, width: 2)),
                  filled: true,
                  fillColor: AppColors.backgroundColor,
                ),
                style: TextStyle(color: AppColors.secondayColor),
                onChanged: onChanged,
                validator: validator,
              ),
            ],
          ));
    });
  }

  // // Dynamic Remarks Section
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
    final numeric = value.replaceAll(RegExp(r'[^\d]'), '');
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
                decoration: InputDecoration(
                  labelStyle: const TextStyle(color: AppColors.secondayColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: themeController.primaryColor.value,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: themeController.primaryColor.value,
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
                          controller.bankName.value = newValue;
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
    //   log('controller.bankId.value: ${controller.bankName.value}');
    // Check if the controller's bankId is in the available bank list
    final existingBank = controller.allBankNamesList
        .firstWhereOrNull((bank) => bank.bankName == controller.bankName.value);
    return existingBank
        ?.bankName; // If found, return it; otherwise, return null
  }

// Helper method to build dropdown items
  List<DropdownMenuItem<String>> _buildBankDropdownItems() {
    return controller.allBankNamesList.map((bank) {
      return DropdownMenuItem<String>(
        value: bank.dsaId,
        child: Text(
          bank.bankName ?? '',
          overflow: TextOverflow.ellipsis,
        ),
      );
    }).toList();
  }

  //
  Widget _buildSourcingDropdown() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Source',
                style: TextStyle(color: AppColors.secondayColor)),
            DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: InputDecoration(
                hintText: 'Select Source',
                prefixIcon: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 5.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset('assets/images/data_type.svg',
                            color: themeController.primaryColor.value,
                            height: 20,
                            width: 20),
                        SizedBox(width: 5.w),
                        VerticalDivider(
                          thickness: 1,
                          color: themeController.primaryColor.value,
                        ),
                      ],
                    ),
                  ),
                ),
                labelStyle: const TextStyle(color: AppColors.secondayColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: themeController.primaryColor.value,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: themeController.primaryColor.value,
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
                        controller.source.value = newValue;
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
          ],
        ),
      ),
    );
  }

  Widget _buildDsaDropdown() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('DSA Name',
                style: TextStyle(color: AppColors.secondayColor)),
            DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: InputDecoration(
                hintText: 'DSA Name',
                prefixIcon: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 5.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/images/bank.svg',
                          color: themeController.primaryColor.value,
                          height: 20,
                          width: 20,
                        ),
                        SizedBox(width: 5.w),
                        VerticalDivider(
                          thickness: 1,
                          color: themeController.primaryColor.value,
                        ),
                      ],
                    ),
                  ),
                ),
                labelStyle: const TextStyle(color: AppColors.secondayColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: themeController.primaryColor.value,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: themeController.primaryColor.value,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: AppColors.backgroundColor,
              ),
              value: _getInitialDsaValue(),
              hint: const Text(
                'Select DSA Name',
                style: TextStyle(color: Colors.grey),
              ),
              items: _buildDsaDropdownItems(),
              onChanged: controller.isEdit.value
                  ? (newValue) {
                      if (newValue != null) {
                        controller.dsaName.value = newValue;
                        controller.selectedDsaId.value = newValue;
                        controller.caseType.clear();
                        controller.producttypeList.clear();
                        controller.selectedBankName.value = '';
                        controller.dsaName.value = '';
                        controller.bankerNameList.clear();
                        controller.bankerMobile.value = '';
                        controller.bankerEmail.value = '';
                        controller.telecaller.value = '';
                        controller.teamleader.value = '';
                        controller.status.value = '';
                        controller.getDsaBankList(newValue);
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
          ],
        ),
      ),
    );
  }

  Widget _buildCaseTypeDropdown() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonFormField<String>(
          isExpanded: true,
          decoration: InputDecoration(
            hintText: 'Case Type',
            prefixIcon: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 5.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/images/case_type.svg',
                      height: 24,
                      width: 24,
                      color: themeController.primaryColor.value,
                    ),
                    SizedBox(width: 5.w),
                    VerticalDivider(
                      thickness: 1,
                      color: themeController.primaryColor.value,
                    ),
                  ],
                ),
              ),
            ),
            labelStyle: const TextStyle(color: AppColors.secondayColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: themeController.primaryColor.value,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: themeController.primaryColor.value,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: AppColors.backgroundColor,
          ),
          value: _getInitialCaseTypeValue(),
          hint: const Text(
            'Select Case Type',
            style: TextStyle(color: Colors.grey),
          ),
          items: _buildCaseTypeDropdownItems(),
          onChanged: controller.isEdit.value
              ? (newValue) {
                  if (newValue != null) {
                    //  controller.caseType.value = newValue;
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

  Widget _buildProductTypeDropdown() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Product Type',
                style: TextStyle(color: AppColors.secondayColor)),
            DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: InputDecoration(
                hintText: 'Product Type',
                prefixIcon: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 5.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/images/loan_amount.svg',
                          color: themeController.primaryColor.value,
                          height: 24,
                          width: 24,
                        ),
                        SizedBox(width: 5.w),
                        VerticalDivider(
                          thickness: 1,
                          color: themeController.primaryColor.value,
                        ),
                      ],
                    ),
                  ),
                ),
                labelStyle: const TextStyle(color: AppColors.secondayColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: themeController.primaryColor.value,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: themeController.primaryColor.value,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: AppColors.backgroundColor,
              ),
              value: _getInitialProductTypeValue(),
              hint: const Text(
                'Select Product Type',
                style: TextStyle(color: Colors.grey),
              ),
              items: _buildProductTypeDropdownItems(),
              onChanged: controller.isEdit.value
                  ? (newValue) {
                      if (newValue != null) {
                        controller.selectedproductType.value = newValue;
                      }
                    }
                  : null,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a Product type';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildloginBankDropdown() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Login Bank',
                style: TextStyle(color: AppColors.secondayColor)),
            DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: InputDecoration(
                prefixIcon: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 5.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset('assets/images/bank.svg',
                            color: themeController.primaryColor.value,
                            height: 24,
                            width: 24),
                        SizedBox(width: 5.w),
                        VerticalDivider(
                          thickness: 1,
                          color: themeController.primaryColor.value,
                        ),
                      ],
                    ),
                  ),
                ),
                hintText: 'Login Bank',
                labelStyle: const TextStyle(color: AppColors.secondayColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: themeController.primaryColor.value,
                    )),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: themeController.primaryColor.value,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: AppColors.backgroundColor,
              ),
              value: _getInitialloginBankValue(),
              hint: const Text(
                'Select Bank Name ',
                style: TextStyle(color: Colors.grey),
              ),
              items: _buildDsaBankloginNameDropdownItems(),
              onChanged: controller.isEdit.value
                  ? (newValue) {
                      if (newValue != null) {
                        controller.selectedBankName.value = newValue;
                        controller.getBankerNameByloginBank(
                            controller.selectedDsaId.toString(),
                            controller.selectedBankName.toString());
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
          ],
        ),
      ),
    );
  }

  Widget _buildBankerNameDropdown() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Banker Name',
                style: TextStyle(color: AppColors.secondayColor)),
            DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: InputDecoration(
                hintText: 'Banker Name',
                prefixIcon: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 5.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/images/user.svg',
                          height: 20,
                          width: 20,
                          color: themeController.primaryColor.value,
                        ),
                        SizedBox(width: 5.w),
                        VerticalDivider(
                          thickness: 1,
                          color: themeController.primaryColor.value,
                        ),
                      ],
                    ),
                  ),
                ),
                labelStyle: const TextStyle(color: AppColors.secondayColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: themeController.primaryColor.value,
                    )),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: themeController.primaryColor.value, width: 2),
                ),
                filled: true,
                fillColor: AppColors.backgroundColor,
              ),
              value: _getInitialBankerValue(),
              hint: const Text(
                'Select Banker Name ',
                style: TextStyle(color: Colors.grey),
              ),
              items: _buildBankerNameDropdownItems(),
              onChanged: controller.isEdit.value
                  ? (newValue) {
                      if (newValue != null) {
                        controller.bankName.value = newValue;
                        controller.getBankerDetailsName(newValue.toString());
                      }
                    }
                  : null,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a Banker Name';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCommonDropdown({
    required String hint,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required Function(String?)? onChanged,
    required String iconPath,
    String? Function(String?)? validator,
    bool isEnabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(hint, style: const TextStyle(color: AppColors.secondayColor)),
          DropdownButtonFormField<String>(
            isExpanded: true,
            value: value,
            items: items,
            onChanged: isEnabled ? onChanged : null,
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,

              /// SAME PREFIX DESIGN ✅
              prefixIcon: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 5.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        iconPath,
                        color: themeController.primaryColor.value,
                        height: 20,
                        width: 20,
                      ),
                      const SizedBox(width: 6),
                      VerticalDivider(
                        thickness: 1,
                        color: themeController.primaryColor.value,
                      ),
                    ],
                  ),
                ),
              ),

              labelStyle: const TextStyle(color: AppColors.secondayColor),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),

              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: themeController.primaryColor.value,
                  )),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: themeController.primaryColor.value,
                  width: 2,
                ),
              ),

              filled: true,
              fillColor: AppColors.backgroundColor,
            ),
            hint: Text(
              hint,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeleCallerDropdown() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('TeleCaller',
                style: TextStyle(color: AppColors.secondayColor)),
            DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: InputDecoration(
                hintText: 'TeleCaller',
                prefixIcon: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 5.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/images/telecaller_call.svg',
                          height: 24,
                          width: 24,
                          color: themeController.primaryColor.value,
                        ),
                        SizedBox(width: 5.w),
                        VerticalDivider(
                          thickness: 1,
                          color: themeController.primaryColor.value,
                        ),
                      ],
                    ),
                  ),
                ),
                labelStyle: const TextStyle(color: AppColors.secondayColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: themeController.primaryColor.value,
                    )),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: themeController.primaryColor.value,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: AppColors.backgroundColor,
              ),
              value: _getInitialTellecallerValue(),
              hint: const Text(
                'Select TeleCaller',
                style: TextStyle(color: Colors.grey),
              ),
              items: _buildTellecallerNameDropdownItems(),
              onChanged: controller.isEdit.value
                  ? (newValue) {
                      if (newValue != null) {
                        controller.telecaller.value = newValue;
                      }
                    }
                  : null,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a Tellecaller';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Status',
                style: TextStyle(color: AppColors.secondayColor)),
            DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: InputDecoration(
                hintText: 'Status',
                prefixIcon: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 5.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/images/status.svg',
                          height: 24,
                          width: 24,
                          color: themeController.primaryColor.value,
                        ),
                        SizedBox(width: 5.w),
                        VerticalDivider(
                          thickness: 1,
                          color: themeController.primaryColor.value,
                        ),
                      ],
                    ),
                  ),
                ),
                labelStyle: const TextStyle(color: AppColors.secondayColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: themeController.primaryColor.value,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: themeController.primaryColor.value,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: AppColors.backgroundColor,
              ),
              value: _getInitialStatusValue(),
              hint: const Text(
                'Select Status',
                style: TextStyle(color: Colors.grey),
              ),
              items: _buildStatusDropdownItems(),
              onChanged: controller.isEdit.value
                  ? (newValue) {
                      if (newValue != null) {
                        controller.status.value = newValue;
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
          ],
        ),
      ),
    );
  }

  // // Helper method to build dropdown items
  List<DropdownMenuItem<String>> _buildDsaDropdownItems() {
    for (final item in controller.dsaNameList) {
      print('ID: ${item.id}, Name: ${item.dsaName}');
    }
    return controller.dsaNameList.map((dsa) {
      return DropdownMenuItem<String>(
        value: dsa.id,
        child: Text(
          dsa.dsaName ?? '',
          overflow: TextOverflow.ellipsis,
        ),
      );
    }).toList();
  }

  List<DropdownMenuItem<String>> _buildProductTypeDropdownItems() {
    return controller.producttypeList.map((product) {
      return DropdownMenuItem<String>(
        value: product.id,
        child: Text(
          product.name,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }).toList();
  }

  List<DropdownMenuItem<String>> _buildDsaBankloginNameDropdownItems() {
    return controller.dsaBankList.map((dsaBank) {
      return DropdownMenuItem<String>(
        value: dsaBank.bankName,
        child: Text(
          dsaBank.bankName,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }).toList();
  }

  List<DropdownMenuItem<String>> _buildCaseTypeDropdownItems() {
    return controller.caseType.map((type) {
      return DropdownMenuItem<String>(
        value: type,
        child: Text(
          type,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }).toList();
  }

  List<DropdownMenuItem<String>> _buildBankerNameDropdownItems() {
    return controller.bankerNameList.map((bank) {
      return DropdownMenuItem<String>(
        value: bank.id,
        child: Text(
          bank.bankerName,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }).toList();
  }

  List<DropdownMenuItem<String>> _buildTellecallerNameDropdownItems() {
    return controller.telecallerlist.map((tellecaller) {
      return DropdownMenuItem<String>(
        value: tellecaller.id,
        child: Text(
          tellecaller.name,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }).toList();
  }

  List<DropdownMenuItem<String>> _buildStatusDropdownItems() {
    return controller.statuslist.map((status) {
      return DropdownMenuItem<String>(
        value: status.id,
        child: Text(
          status.dataEntryStatus,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }).toList();
  }

  String? _getInitialProductTypeValue() {
    final existingSource = controller.producttypeList.firstWhereOrNull(
      (product) =>
          product.id.toLowerCase().trim() ==
          controller.selectedproductType.value.toLowerCase().trim(),
    );

    return existingSource?.id;
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

  String? _getInitialloginBankValue() {
    final existing = controller.dsaBankList.firstWhereOrNull((e) =>
        (e.bankName).toLowerCase().trim() ==
        controller.selectedBankName.value.toLowerCase().trim());
    return existing?.bankName;
  }

  String? _getInitialBankerValue() {
    final existing = controller.bankerNameList.firstWhereOrNull((e) =>
        e.bankerName.toLowerCase().trim() ==
        controller.selectedBankerName.value.toLowerCase().trim());
    return existing?.id;
  }

  String? _getInitialTellecallerValue() {
    final existing = controller.telecallerlist.firstWhereOrNull((e) =>
        (e.id).toLowerCase().trim() ==
        controller.selectTelecallerName.value.toLowerCase().trim());
    return existing?.id;
  }

  String? _getInitialStatusValue() {
    final existing = controller.statuslist.firstWhereOrNull((e) =>
        (e.dataEntryStatus).toLowerCase().trim() ==
        controller.selectedStatus.value.toLowerCase().trim());
    return existing?.id;
  }

  String? _getInitialSourceValue() {
    final existing = controller.sourcingList.firstWhereOrNull((e) =>
        (e.id)?.toLowerCase().trim() ==
        controller.selectedSource.value.toLowerCase().trim());
    return existing?.id;
  }

  String? _getInitialDsaValue() {
    final existing = controller.dsaNameList.firstWhereOrNull((e) =>
        (e.id ?? '').toLowerCase().trim() ==
        controller.dsaName.value.toLowerCase().trim());
    return existing?.id;
  }

  String? _getInitialCaseTypeValue() {
    final existing = controller.caseType.firstWhereOrNull(
      (e) =>
          e.toLowerCase().trim() ==
          controller.selectedCaseType.value.toLowerCase().trim(),
    );
    return existing;
  }

  Widget titileWithIcon({
    required String title,
    required String iconPath,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: themeController.primaryColor.value,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          /// Icon Box
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.appBarTextColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: SvgPicture.asset(
              iconPath,
              height: 18,
              width: 18,
              color: themeController.primaryColor.value,
            ),
          ),

          SizedBox(width: 10.w),

          /// Title
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.appBarTextColor),
            ),
          ),

          /// Optional small divider line (modern touch)
          Container(
            width: 30,
            height: 2,
            decoration: BoxDecoration(
              color: themeController.primaryColor.value,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}
