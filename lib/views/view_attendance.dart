import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:smart_solutions/controllers/attendence_controller.dart';
import 'package:smart_solutions/widget/common_scaffold.dart';

class ViewAttendancePage extends StatefulWidget {
  const ViewAttendancePage({super.key});

  @override
  State<ViewAttendancePage> createState() => _ViewAttendancePageState();
}

class _ViewAttendancePageState extends State<ViewAttendancePage> {
  final c = Get.put(AttendanceController());
  String selectedMonth = DateFormat('MMMM yyyy').format(DateTime.now());

  // 🟢 Generate all available months based on data
  List<String> _getAvailableMonths() {
    final months = c.attendanceList
        .map((r) => DateFormat('MMMM yyyy').format(r['date'] as DateTime))
        .toSet()
        .toList();
    months.sort((a, b) => DateFormat('MMMM yyyy')
        .parse(b)
        .compareTo(DateFormat('MMMM yyyy').parse(a)));
    return months;
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: "View Attendance",
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (c.attendanceList.isEmpty) {
          return const Center(child: Text("No attendance records found."));
        }

        final months = _getAvailableMonths();
        final filteredData = c.attendanceList.where((r) {
          final date = r['date'] as DateTime;
          return DateFormat('MMMM yyyy').format(date) == selectedMonth;
        }).toList();

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 🔹 Month Dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Select Month",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              value: selectedMonth,
              items: months
                  .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                  .toList(),
              onChanged: (val) {
                setState(() => selectedMonth = val!);
              },
            ),

            const SizedBox(height: 20),

            // 🔹 Summary Row
            _buildSummaryRow(filteredData),

            const SizedBox(height: 20),

            // 🔹 Calendar
            _buildCalendar(filteredData),
          ],
        );
      }),
    );
  }

  // 🟡 Summary Row Widget
  Widget _buildSummaryRow(List<Map<String, dynamic>> data) {
    final present = data.where((e) => e['status'] == 'Present').length;
    final absent = data.where((e) => e['status'] == 'Absent').length;
    final halfDay = data.where((e) => e['status'] == 'Half Day').length;
    final paidLeave = data.where((e) => e['status'] == 'Paid Leave').length;
    final weekOff = data.where((e) => e['status'] == 'Week Off').length;

    final summary = [
      {'label': 'Present', 'count': present, 'color': Colors.green},
      {'label': 'Absent', 'count': absent, 'color': Colors.redAccent},
      {'label': 'Half Day', 'count': halfDay, 'color': Colors.orange},
      {'label': 'Paid Leave', 'count': paidLeave, 'color': Colors.blue},
      {'label': 'Week Off', 'count': weekOff, 'color': Colors.purple},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: summary.map((s) {
          final color = s['color'] as Color; // 👈 FIX: cast to Color

          return Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color, width: 0.8),
            ),
            child: Column(
              children: [
                Text(
                  s['count'].toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  s['label'].toString(),
                  style: const TextStyle(fontSize: 12, color: Colors.blue),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // 🟣 Calendar Widget
  Widget _buildCalendar(List<Map<String, dynamic>> data) {
    return TableCalendar(
      focusedDay: DateTime.now(),
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      calendarFormat: CalendarFormat.month,
      availableCalendarFormats: const {CalendarFormat.month: 'Month'},
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        leftChevronVisible: false, // 👈 Hides the "previous" arrow
        rightChevronVisible: false, // 👈 Hides the "next" arrow
        leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black),
        rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black),
      ),
      daysOfWeekStyle: const DaysOfWeekStyle(
        weekendStyle: TextStyle(color: Colors.redAccent),
      ),
      calendarStyle: const CalendarStyle(
        outsideDaysVisible: false,
        weekendTextStyle: TextStyle(color: Colors.redAccent),
        todayDecoration: BoxDecoration(
          color: Colors.orangeAccent,
          shape: BoxShape.circle,
        ),
      ),

      // 🟢 Custom Day Cell Builder
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, _) {
          // find matching record for this date
          final record = data.firstWhereOrNull(
            (r) =>
                DateFormat('yyyy-MM-dd').format(r['date']) ==
                DateFormat('yyyy-MM-dd').format(day),
          );

          // 🎨 color code based on status
          if (record != null) {
            final status = record['status'];
            Color bgColor;
            Color textColor;

            switch (status) {
              case 'Present':
                bgColor = Colors.green.withOpacity(0.15);
                textColor = Colors.green;
                break;
              case 'Absent':
                bgColor = Colors.redAccent.withOpacity(0.15);
                textColor = Colors.redAccent;
                break;
              case 'Half Day':
                bgColor = Colors.orange.withOpacity(0.15);
                textColor = Colors.orange;
                break;
              case 'Paid Leave':
                bgColor = Colors.blue.withOpacity(0.15);
                textColor = Colors.blue;
                break;
              case 'Week Off':
                bgColor = Colors.purple.withOpacity(0.15);
                textColor = Colors.purple;
                break;
              default:
                bgColor = Colors.grey.withOpacity(0.1);
                textColor = Colors.grey;
            }

            // 🟢 Return colored day cell
            return Center(
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }

          return Center(
            child: Text(
              '${day.day}',
              style: const TextStyle(color: Colors.black54),
            ),
          );
        },
      ),
    );
  }
}
