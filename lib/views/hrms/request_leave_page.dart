import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:smart_solutions/theme/app_theme.dart';
import 'package:smart_solutions/widget/common_scaffold.dart';

class RequestLeavePage extends StatefulWidget {
  const RequestLeavePage({super.key});

  @override
  State<RequestLeavePage> createState() => _RequestLeaveScreenState();
}

class _RequestLeaveScreenState extends State<RequestLeavePage> {
  String _leaveType = 'Sick Leave (04)';
  DateTime? _fromDate;
  DateTime? _toDate;

  final TextEditingController _reasonController =
      TextEditingController(text: 'Do Not Disturb..!!');

  Future<void> _pickFromDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fromDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => _fromDate = picked);
    }
  }

  Future<void> _pickToDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _toDate ?? (_fromDate ?? DateTime.now()),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => _toDate = picked);
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: 'Request Leave',
      showBack: true,
      isDrawer: false,
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 16),
          child: Icon(Icons.list, color: Colors.white),
        ),
      ],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min, // IMPORTANT
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Leave Type'),
            const SizedBox(height: 4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _leaveRadioRow(['Sick Leave (04)', 'Casual Leave (01)']),
                _leaveRadioRow(['Paid Leave (02)', 'Unpaid Leave']),
                _leaveRadioRow(['Half Day (03)']),
              ],
            ),
            const SizedBox(height: 15),
            const Text('From'),
            const SizedBox(height: 6),
            _dateField(
              text: _fromDate == null ? 'Select date' : _formatDate(_fromDate),
              onTap: _pickFromDate,
            ),
            const SizedBox(height: 12),
            const Text('To'),
            const SizedBox(height: 6),
            _dateField(
              text: _toDate == null ? 'Select date' : _formatDate(_toDate),
              onTap: _pickToDate,
            ),
            const SizedBox(height: 16),
            const Text('Reason For Leave'),
            const SizedBox(height: 6),
            TextField(
              controller: _reasonController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Reason',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  'Request Leave',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _leaveRadioRow(List<String> labels) {
    return Row(
      children: labels.map((label) {
        return Expanded(
          child: Row(
            children: [
              Radio<String>(
                value: label,
                groupValue: _leaveType,
                onChanged: (v) => setState(() => _leaveType = v!),
                activeColor: AppColors.primaryColor,
              ),
              Flexible(
                child: Text(label, style: const TextStyle(fontSize: 13)),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _dateField({required String text, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: text == 'Select date' ? Colors.grey : Colors.black87,
                ),
              ),
            ),
            SvgPicture.asset(
              "assets/hrms/calander_date.svg",
              width: 22,
              height: 22,
            ),
          ],
        ),
      ),
    );
  }
}
