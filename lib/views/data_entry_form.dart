import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_solutions/controllers/data_entry_controller.dart';
import 'package:smart_solutions/theme/app_theme.dart';
import '../constants/services.dart';

class DataEntryForm extends StatefulWidget {
  String? id;
  String? tellecallerId;
  String? dsaId;
  String? bankerId;
  DataEntryForm(
      {super.key,
      required this.id,
      required this.tellecallerId,
      required this.dsaId,
      required this.bankerId});

  @override
  State<DataEntryForm> createState() => _DataEntryFormState();
}

class _DataEntryFormState extends State<DataEntryForm> {
  final DataController controller = Get.put(DataController());

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller.tellecallerId.value = widget.tellecallerId ?? '';
    controller.dataId.value = widget.id ?? '';
    controller.dsaId.value = widget.dsaId ?? '';

    // Call APIs here
    controller.fetchDataEntryListSpecificId();
    controller.getSourcingList();
    controller.getDsaBankList(widget.dsaId ?? '');
    controller.getBankerName(widget.bankerId ?? '');
    controller.getMobileByCustomerData(controller.contactNumber.value);
    controller.getTeamLeadById(widget.tellecallerId.toString());
  }

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
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              'Data Entry Form',
              style: TextStyle(fontSize: 20),
            ),
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
          ),
          body: Obx(
            () => controller.isLoading.value
                ? const CircularProgressIndicator()
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10.h),
                            _buildDsaDropdown(),
                            const SizedBox(height: 10),

                            _buildTextField(
                                content: controller.date,
                                label: 'Date',
                                validator: (value) => _validatePhone(value),
                                onChanged: (value) =>
                                    controller.date.value = value),

                            // _buildDateField(
                            //   label: 'Date',
                            //   content: controller.date,
                            //   context: context,
                            // ),
                            // _buildDateField(
                            //     label: 'Date',
                            //     content:controller.dob.map((date) => DateFormat('yyyy-MM-dd').format(date)),
                            //     onChanged: (value) =>
                            //         controller.date.value = DateTime.parse(value),
                            //     inputType: TextInputType.phone,
                            //     validator: _validatePhone),

                            _buildTextField(
                              label: 'Mobile Number',
                              content: controller.contactNumber,
                              onChanged: (value) =>
                                  controller.contactNumber.value = value,
                              inputType: TextInputType.phone,
                              validator: _validatePhone,
                            ),
                            Obx(
                              () => _buildTextField(
                                label: 'Customer Name',
                                content: controller.customerName,
                                onChanged: (value) =>
                                    controller.customerName.value = value,
                                inputType: TextInputType.phone,
                                validator: _validateNotEmpty,
                              ),
                            ),

                            _buildTextField(
                              label: 'Income',
                              content: controller.income,
                              onChanged: (value) =>
                                  controller.income.value = value,
                              inputType: TextInputType.phone,
                              validator: _validateNotEmpty,
                            ),

                            _buildTextField(
                              label: 'Company Name',
                              content: controller.companyName,
                              onChanged: (value) =>
                                  controller.companyName.value = value,
                              inputType: TextInputType.phone,
                              validator: _validateNotEmpty,
                            ),
                            _buildCaseTypeDropdown(),
                            const SizedBox(height: 10),
                            _buildTextField(
                              label: 'Loan Amount',
                              content: NumberFormat.currency(
                                      locale: 'en_IN',
                                      symbol: '',
                                      decimalDigits: 0)
                                  .format(int.tryParse(controller
                                          .loanAmount.value
                                          .replaceAll(RegExp(r'[^\d]'), '')) ??
                                      0)
                                  .obs,
                              // ?
                              // NumberFormat.currency(
                              //     locale: 'en_IN',
                              //     symbol: '',
                              //     decimalDigits: 0,
                              //   )
                              //     .format(
                              //       int.tryParse(controller.loanAmount.value
                              //               .replaceAll(',', '')) ??
                              //           0,
                              //     )
                              //     .obs
                              // : ''.obs, // ✅ convert to RxString
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
                            _buildTextField(
                              content: controller.dob,
                              label: 'DOB',
                              validator: (value) => _validateNotEmpty(value),
                              onChanged: (value) =>
                                  controller.dob.value = value,
                            ),

                            // _buildDateField(
                            //     label: 'DOB',
                            //     content: controller.dob,
                            //     // onChanged: (value) =>
                            //     //     controller.dob.value = DateTime.parse(value),
                            //     context: context
                            //     // validator: _validateNotEmpty,
                            //     ),
                            const SizedBox(height: 10),

                            _buildProductTypeDropdown(),
                            const SizedBox(height: 10),

                            _buildloginBankDropdown(),
                            const SizedBox(height: 10),

                            _buildBankerNameDropdown(),
                            const SizedBox(height: 10),

                            _buildTextField(
                              label: 'Banker Mobile',
                              content: controller.bankerMobile,
                              onChanged: (value) =>
                                  controller.bankerMobile.value = value,
                              // validator: _validateNotEmpty,
                            ),

                            _buildTextField(
                              label: 'Banker Email',
                              content: controller.bankerEmail,
                              onChanged: (value) =>
                                  controller.bankerEmail.value = value,
                              // validator: _validateNotEmpty,
                            ),
                            const SizedBox(height: 10),

                            _buildTextField(
                              label: 'LOS No.',
                              content: controller.losNo,
                              onChanged: (value) =>
                                  controller.losNo.value = value,
                              // validator: _validateNotEmpty,
                            ),
                            const SizedBox(height: 10),

                            _buildTeleCallerDropdown(),
                            const SizedBox(height: 10),

                            _buildTextField(
                              label: 'Team Leader',
                              content: controller.teamleader,
                              onChanged: (value) =>
                                  controller.teamleader.value = value,
                              // validator: _validateNotEmpty,
                            ),

                            const SizedBox(height: 10),

                            _buildStatusDropdown(),
                            const SizedBox(height: 10),

                            _buildSourcingDropdown(),
                            const SizedBox(height: 10),

                            _buildTextField(
                              label: 'Case Study ',
                              content: controller.caseStudy,
                              onChanged: (value) =>
                                  controller.caseStudy.value = value,
                              // validator: _validateNotEmpty,
                            ),
                            const SizedBox(height: 10),

                            _buildTextField(
                              label: 'Comments ',
                              content: controller.comments,
                              onChanged: (value) =>
                                  controller.comments.value = value,
                              // validator: _validateNotEmpty,
                            ),
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
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        controller
                                            .saveDataEntryForm(); // Call save method
                                        //        controller.getLoginRequestList();
                                      }
                                    },
                                    child: controller.isLoading.value
                                        ? const CircularProgressIndicator(
                                            color: Colors.white,
                                          )
                                        : const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 24.0),
                                            child: Text(
                                              'Submit',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        ));
  }

  Widget _buildDateField({
    required String label,
    required Rx<DateTime> content,
    required BuildContext context,
  }) {
    return Obx(() {
      final controller = TextEditingController(
        text: DateFormat('yyyy-MM-dd').format(content.value),
      );

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          style: const TextStyle(color: AppColors.primaryColor),
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            labelText: label,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: const BorderSide(color: AppColors.primaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide:
                  const BorderSide(color: AppColors.primaryColor, width: 2),
            ),
            filled: true,
            fillColor: AppColors.backgroundColor,
          ),
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: content.value,
              firstDate: DateTime(1950),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              content.value = picked;
            }
          },
        ),
      );
    });
  }

  Widget _buildTextField({
    required RxString content,
    required String label,
    required ValueChanged<String> onChanged,
    TextInputType inputType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    final textController = TextEditingController(text: content.value);

    // Keep the controller in sync with the content
    textController.selection = TextSelection.fromPosition(
      TextPosition(offset: textController.text.length),
    );

    return Obx(() {
      // Sync Rx -> Controller
      if (textController.text != content.value) {
        textController.text = content.value;
      }
      return Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            keyboardType: inputType,
            maxLines: maxLines,
            readOnly: !controller.isEdit.value,
            controller: textController,
            //  initialValue: content.isNotEmpty ? content : null,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(color: AppColors.secondayColor),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(color: AppColors.primaryColor),
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: const BorderSide(
                      color: AppColors.primaryColor, width: 2)),
              filled: true,
              fillColor: AppColors.backgroundColor,
            ),
            style: const TextStyle(color: AppColors.primaryColor),
            onChanged: onChanged,
            validator: validator,
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
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: InputDecoration(
                  labelStyle: const TextStyle(color: AppColors.secondayColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0.r),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0.r),
                    borderSide: const BorderSide(color: AppColors.primaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0.r),
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
        child: DropdownButtonFormField<String>(
          isExpanded: true,
          decoration: InputDecoration(
            labelText: 'Select Source',
            labelStyle: const TextStyle(color: AppColors.secondayColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0.r),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0.r),
              borderSide: const BorderSide(color: AppColors.primaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0.r),
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
      ),
    );
  }

  Widget _buildDsaDropdown() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonFormField<String>(
          isExpanded: true,
          decoration: InputDecoration(
            labelText: 'DSA Name',
            labelStyle: const TextStyle(color: AppColors.secondayColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0.r),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0.r),
              borderSide: const BorderSide(color: AppColors.primaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0.r),
              borderSide: const BorderSide(
                color: AppColors.primaryColor,
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
            labelText: 'Case Type',
            labelStyle: const TextStyle(color: AppColors.secondayColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0.r),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0.r),
              borderSide: const BorderSide(color: AppColors.primaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0.r),
              borderSide: const BorderSide(
                color: AppColors.primaryColor,
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
        child: DropdownButtonFormField<String>(
          isExpanded: true,
          decoration: InputDecoration(
            labelText: 'Product Type',
            labelStyle: const TextStyle(color: AppColors.secondayColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0.r),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0.r),
              borderSide: const BorderSide(color: AppColors.primaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0.r),
              borderSide: const BorderSide(
                color: AppColors.primaryColor,
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
      ),
    );
  }

  Widget _buildloginBankDropdown() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonFormField<String>(
          isExpanded: true,
          decoration: InputDecoration(
            labelText: 'Login Bank',
            labelStyle: const TextStyle(color: AppColors.secondayColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0.r),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0.r),
              borderSide: const BorderSide(color: AppColors.primaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0.r),
              borderSide: const BorderSide(
                color: AppColors.primaryColor,
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
                    controller.getBankerName(controller.dsaName.value);
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

  Widget _buildBankerNameDropdown() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonFormField<String>(
          isExpanded: true,
          decoration: InputDecoration(
            labelText: 'Banker Name',
            labelStyle: const TextStyle(color: AppColors.secondayColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0.r),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0.r),
              borderSide: const BorderSide(color: AppColors.primaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0.r),
              borderSide: const BorderSide(
                color: AppColors.primaryColor,
                width: 2,
              ),
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
      ),
    );
  }

  Widget _buildTeleCallerDropdown() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonFormField<String>(
          isExpanded: true,
          decoration: InputDecoration(
            labelText: 'Tele Caller',
            labelStyle: const TextStyle(color: AppColors.secondayColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0.r),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0.r),
              borderSide: const BorderSide(color: AppColors.primaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0.r),
              borderSide: const BorderSide(
                color: AppColors.primaryColor,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: AppColors.backgroundColor,
          ),
          value: _getInitialTellecallerValue(),
          hint: const Text(
            'Select Tele Caller',
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
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonFormField<String>(
          isExpanded: true,
          decoration: InputDecoration(
            labelText: 'Status',
            labelStyle: const TextStyle(color: AppColors.secondayColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0.r),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0.r),
              borderSide: const BorderSide(color: AppColors.primaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0.r),
              borderSide: const BorderSide(
                color: AppColors.primaryColor,
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
      ),
    );
  }

  // // Helper method to build dropdown items
  List<DropdownMenuItem<String>> _buildDsaDropdownItems() {
    print(controller.dsaNameList.first);
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
}
