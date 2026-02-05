import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/controllers/theme_controller.dart';
import 'package:smart_solutions/widget/common_form_field.dart';
import 'package:smart_solutions/widget/common_scaffold.dart';

class BankDetailsPage extends StatefulWidget {
  const BankDetailsPage({super.key});

  @override
  State<BankDetailsPage> createState() => _BankDetailsPageState();
}

class _BankDetailsPageState extends State<BankDetailsPage> {
  final holderNameController = TextEditingController();
  final accountNumberController = TextEditingController();
  final bankNameController = TextEditingController();
  final ifscController = TextEditingController();
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  void dispose() {
    holderNameController.dispose();
    accountNumberController.dispose();
    bankNameController.dispose();
    ifscController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: CommonScaffold(
        title: 'Bank Details',

        /// ✅ FIXED BUTTON AT BOTTOM
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: SizedBox(
            height: 48,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: themeController.primaryColor.value,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              onPressed: () {
                FocusScope.of(context).unfocus();
                // TODO: Save bank details
              },
              child: const Text(
                'Save Details',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),

        /// ✅ PAGE BODY
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              children: [
                const SizedBox(height: 15),
                CommonTextField(
                  label: "Bank Holder's Name",
                  controller: holderNameController,
                ),
                CommonTextField(
                  label: "Account Number",
                  controller: accountNumberController,
                  keyboardType: TextInputType.number,
                ),
                CommonTextField(
                  label: "Bank Name",
                  controller: bankNameController,
                ),
                CommonTextField(
                  label: "IFSC Code",
                  controller: ifscController,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
