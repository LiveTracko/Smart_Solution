import 'package:flutter/material.dart';

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
    text: 'Smart Solution Main Branch',
  );
  final TextEditingController employeeIdController = TextEditingController(
    text: 'SS-001',
  );
  final TextEditingController emailController = TextEditingController(
    text: 'chiragwadhwani29@gmail.com',
  );
  final TextEditingController pfController = TextEditingController(
    text: '63620hc762g',
  );
  final TextEditingController esiController = TextEditingController(
    text: '63620hc762g',
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
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      appBar: AppBar(
        backgroundColor: CurrentEmploymentPage.primaryBlue,
        elevation: 0,
        leading: const BackButton(color: Color(0xffFFFFFF)),
        title: const Text(
          'Current Employment',
          style: TextStyle(
            color: Color(0xffFFFFFF),
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _inputField('Branch', branchController),
            _dropdownField(
              label: 'Departments',
              value: department,
              items: const ['All Departments Assigned', 'HR', 'Finance', 'IT'],
              onChanged: (v) => setState(() => department = v!),
            ),
            _dropdownField(
              label: 'Employee Type',
              value: employeeType,
              items: const ['Full Time', 'Part Time', 'Contract'],
              onChanged: (v) => setState(() => employeeType = v!),
            ),
            _dropdownField(
              label: 'Job Title',
              value: jobTitle,
              items: const ['Back Office', 'Manager', 'Supervisor'],
              onChanged: (v) => setState(() => jobTitle = v!),
            ),
            _dateField(
              'Date of Joining',
              joiningDate == null ? 'Select Date' : _formatDate(joiningDate),
              () => _pickDate(true),
            ),
            _dateField(
              'Date of Leaving',
              leavingDate == null ? 'Select Date' : _formatDate(leavingDate),
              () => _pickDate(false),
            ),
            _inputField('Employee ID', employeeIdController),
            _inputField('Official Email ID', emailController),
            _inputField('PF A/C No.', pfController),
            _inputField('ESI A/C No.', esiController),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: CurrentEmploymentPage.labelColor,
      ),
    );
  }

  Widget _inputField(String label, TextEditingController controller) {
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
              border: Border.all(
                color: CurrentEmploymentPage.borderGrey,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: TextField(
              controller: controller,
              textAlign: TextAlign.start,
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

  Widget _dropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
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
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: CurrentEmploymentPage.borderGrey),
              borderRadius: BorderRadius.circular(6),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: CurrentEmploymentPage.textGrey,
                ),
                items: items
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e, style: const TextStyle(fontSize: 14)),
                      ),
                    )
                    .toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateField(String label, String value, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label(label),
          const SizedBox(height: 8),
          InkWell(
            onTap: onTap,
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: CurrentEmploymentPage.borderGrey),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    value.isEmpty ? 'Select Date' : value,
                    style: TextStyle(
                      fontSize: 14,
                      color: value.isEmpty
                          ? CurrentEmploymentPage.textGrey
                          : CurrentEmploymentPage.labelColor,
                    ),
                  ),
                  const Icon(
                    Icons.calendar_today,
                    size: 18,
                    color: Color(0xFF340EFF),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
