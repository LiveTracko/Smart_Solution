import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_solutions/widget/common_scaffold.dart';

class BankDetailsPage extends StatefulWidget {
  const BankDetailsPage({super.key});

  static const Color primaryBlue = Color(0xFF2F6DF6);
  static const Color borderGrey = Color(0xFFE0E0E0);
  static const Color textGrey = Color(0xFF757575);
  static const Color labelColor = Color(0xFF000000);

  @override
  State<BankDetailsPage> createState() => _BankDetailsPageState();
}

class _BankDetailsPageState extends State<BankDetailsPage> {
  final TextEditingController holderNameController = TextEditingController(
    text: 'Rahul Mehta',
  );
  final TextEditingController accountNumberController = TextEditingController(
    text: '235478965412',
  );
  final TextEditingController bankNameController = TextEditingController(
    text: 'HDFC Bank',
  );
  final TextEditingController ifscController = TextEditingController(
    text: 'HDFC0001523',
  );

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
    return CommonScaffold(
      title: 'Bank Details',
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            const SizedBox(height: 15),
            _inputField('Bank Holder\'s Name', holderNameController),
            _inputField('Account Number', accountNumberController,
                keyboardType: TextInputType.number),
            _inputField('Bank Name', bankNameController),
            _inputField('IFSC Code', ifscController),
            const SizedBox(height: 30),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                width: 400,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2F6DF6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Save Details',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: BankDetailsPage.labelColor,
      ),
    );
  }

  Widget _inputField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label(label),
          const SizedBox(height: 8),
          Container(
            height: 40,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: BankDetailsPage.borderGrey),
              borderRadius: BorderRadius.circular(6),
            ),
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(0),
                  border: InputBorder.none,
                  isDense: true),
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
