import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_solutions/controllers/leave_request_controller.dart';
import 'package:smart_solutions/widget/common_scaffold.dart';

class RequestLeavePage extends StatelessWidget {
  const RequestLeavePage({super.key});

  Future<void> _pickDate(
      BuildContext context, bool isFrom, LeaveController c) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      if (isFrom) {
        c.updateFromDate(picked);
      } else {
        c.updateToDate(picked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.put(LeaveController());
    final theme = Theme.of(context);
    String formatDate(DateTime? date) =>
        date != null ? DateFormat('dd MMM yyyy').format(date) : 'Select date';

    return CommonScaffold(
      title: 'Request Leave',
      body: Obx(
        () => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER CARD
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(Icons.beach_access,
                        color: theme.primaryColor, size: 40),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        "Submit your leave request easily. Fill out the details below.",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // LEAVE TYPE
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: DropdownButtonFormField<String>(
                    value: c.leaveType.value.isEmpty ? null : c.leaveType.value,
                    items: const [
                      DropdownMenuItem(
                          value: 'Sick Leave', child: Text('Sick Leave')),
                      DropdownMenuItem(
                          value: 'Casual Leave', child: Text('Casual Leave')),
                      DropdownMenuItem(
                          value: 'Paid Leave', child: Text('Paid Leave')),
                      DropdownMenuItem(
                          value: 'Unpaid Leave', child: Text('Unpaid Leave')),
                      DropdownMenuItem(
                          value: 'Half Day', child: Text('Half Day')),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Leave Type',
                      prefixIcon: Icon(Icons.category_outlined),
                      border: InputBorder.none,
                    ),
                    onChanged: c.updateLeaveType,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // HALF-DAY SESSION DROPDOWN (show only when selected)
              if (c.leaveType.value == 'Half Day') ...[
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: DropdownButtonFormField<String>(
                      value: c.halfDaySession.value.isEmpty
                          ? null
                          : c.halfDaySession.value,
                      items: const [
                        DropdownMenuItem(
                            value: 'Morning', child: Text('Morning')),
                        DropdownMenuItem(
                            value: 'Afternoon', child: Text('Afternoon')),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Select Session',
                        prefixIcon: Icon(Icons.wb_sunny_outlined),
                        border: InputBorder.none,
                      ),
                      onChanged: c.updateHalfDaySession,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // DATE SELECTION
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _pickDate(context, true, c),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey[100],
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "From: ${formatDate(c.fromDate.value)}",
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _pickDate(context, false, c),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey[100],
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.event_available_outlined,
                                size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "To: ${formatDate(c.toDate.value)}",
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // REASON FIELD
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextFormField(
                    maxLines: 4,
                    style: const TextStyle(color: Colors.black87),
                    decoration: const InputDecoration(
                      labelText: 'Reason for Leave',
                      prefixIcon: Icon(Icons.note_alt_outlined),
                      border: InputBorder.none,
                    ),
                    onChanged: c.updateReason,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // SUBMIT BUTTON
              c.isSubmitting.value
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.send, color: Colors.white),
                        label: const Text(
                          "Submit Request",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                        ),
                        onPressed: () => c.submitLeave(context),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
