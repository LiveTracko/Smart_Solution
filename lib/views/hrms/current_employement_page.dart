import 'package:flutter/material.dart';
import 'package:smart_solutions/widget/common_form_field.dart';
import 'package:smart_solutions/widget/common_scaffold.dart';

class CurrentEmploymentPage extends StatefulWidget {
  const CurrentEmploymentPage({super.key});

  static const Color primaryBlue = Color(0xFF2F6DF6);
  static const Color borderGrey = Color(0xFFE0E0E0);
  static const Color textGrey = Color.fromARGB(255, 27, 26, 26);
  static const Color labelColor = Color.fromARGB(255, 62, 59, 59);

  @override
  State<CurrentEmploymentPage> createState() => _CurrentEmploymentPageState();
}

class _CurrentEmploymentPageState extends State<CurrentEmploymentPage> {
  // Controllers
  final TextEditingController branchController = TextEditingController(
      // text: 'Smart Solution Main Branch',
      );
  final TextEditingController employeeIdController = TextEditingController(
      // text: 'SS-001',
      );
  final TextEditingController emailController = TextEditingController(
      // text: 'chiragwadhwani29@gmail.com',
      );
  final TextEditingController pfController = TextEditingController(
      // text: '63620hc762g',
      );
  final TextEditingController esiController = TextEditingController(
      // text: '63620hc762g',
      );

  String department = 'All Departments Assigned';
  String employeeType = 'Full Time';
  String jobTitle = 'Back Office';

  DateTime? joiningDate;
  DateTime? leavingDate;

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day.toString().padLeft(2, '0')} '
        '${_monthName(date.month)} '
        '${date.year}';
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  Future<void> _pickDate(bool isJoining) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isJoining) {
          joiningDate = picked;
        } else {
          leavingDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: "Current Employment",
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CommonTextField(label: "Branch", controller: branchController),
            CommonDropdownField(
              label: "Departments",
              value: department,
              items: const ['All Departments Assigned', 'HR', 'Finance', 'IT'],
              onChanged: (v) => setState(() => department = v!),
            ),
            CommonDropdownField(
              label: "Employee Type",
              value: employeeType,
              items: const ['Full Time', 'Part Time', 'Contract'],
              onChanged: (v) => setState(() => employeeType = v!),
            ),
            CommonDropdownField(
              label: "Job Title",
              value: jobTitle,
              items: const ['Back Office', 'Manager', 'Supervisor'],
              onChanged: (v) => setState(() => jobTitle = v!),
            ),
            CommonDateField(
              label: 'Date of Joining',
              value: joiningDate == null ? '' : _formatDate(joiningDate),
              onTap: () => _pickDate(true),
            ),
            CommonDateField(
              label: 'Date of Leaving',
              value: leavingDate == null ? '' : _formatDate(leavingDate),
              onTap: () => _pickDate(false),
            ),
            CommonTextField(
                label: "Emoloyee ID", controller: employeeIdController),
            CommonTextField(
                label: "Official Email ID", controller: emailController),
            CommonTextField(label: "PF A/C.", controller: pfController),
            CommonTextField(label: "ESI A/C No.", controller: esiController),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 1),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CurrentEmploymentPage.primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Save Details',
                    style: TextStyle(
                      color: Color(0xffFFFFFF),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
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
}
