import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // add intl: ^0.19.0 in pubspec if not added

class RequestLeavePage extends StatefulWidget {
  const RequestLeavePage({super.key});

  @override
  State<RequestLeavePage> createState() => _RequestLeaveScreenState();
}

class _RequestLeaveScreenState extends State<RequestLeavePage> {
  String _leaveType = 'Sick Leave (04)';
  DateTime? _fromDate;
  DateTime? _toDate;
  final TextEditingController _reasonController = TextEditingController(
    text: 'Do Not Disturb..!!',
  );

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
    return DateFormat('dd MMM yyyy').format(date); // 11 Nov 2025
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 254, 254, 254),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2F6DF6),
        leading: const BackButton(color: Color(0xffFFFFFF)),
        title: const Text(
          'Request Leave',
          style: TextStyle(
            color: Color(0xffFFFFFF),
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: const [
          Padding(padding: EdgeInsets.only(right: 16), child: Icon(Icons.list)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Leave Type'),
            const SizedBox(height: 4),

            // ---- horizontal radio row like design ----
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _leaveRadioRow(['Sick Leave (04)', 'Casual Leave (01)']),
                _leaveRadioRow(['Paid Leave (02)', 'Unpaid Leave']),
                _leaveRadioRow(['Half Day (03)']),
              ],
            ),

            const SizedBox(height: 15),

            // From date
            const Text('From'),
            const SizedBox(height: 6),
            _dateField(
              text: _fromDate == null ? 'Select date' : _formatDate(_fromDate),
              onTap: _pickFromDate,
            ),

            const SizedBox(height: 12),

            // To date
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

            const SizedBox(height: 250),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2F6DF6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Request Leave',
                    style: TextStyle(
                      color: Color.fromARGB(255, 254, 254, 254),
                      fontWeight: FontWeight.w600,
                    ),
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
      children: labels
          .map(
            (label) => Expanded(
              child: Row(
                children: [
                  Radio<String>(
                    value: label,
                    // ignore: deprecated_member_use
                    groupValue: _leaveType,
                    // ignore: deprecated_member_use
                    onChanged: (v) => setState(() => _leaveType = v!),
                    activeColor: Color(0xFF2F6DF6),
                  ),
                  Flexible(
                    child: Text(label, style: const TextStyle(fontSize: 13)),
                  ),
                ],
              ),
            ),
          )
          .toList(),
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
          color: Color(0xffFFFFFF),
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
            const Icon(Icons.calendar_today_outlined, size: 18),
          ],
        ),
      ),
    );
  }
}
