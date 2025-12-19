import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_solutions/widget/common_scaffold.dart';

class PersonalDetailScreen extends StatefulWidget {
  const PersonalDetailScreen({super.key});

  static const Color primaryBlue = Color(0xFF2F6DF6);
  static const Color borderGrey = Color(0xFFE0E0E0);
  static const Color textGrey = Color(0xFF757575);
  static const Color labelColor = Color(0xFF000000);

  @override
  State<PersonalDetailScreen> createState() => _PersonalDetailScreenState();
}

class _PersonalDetailScreenState extends State<PersonalDetailScreen> {
  final TextEditingController staffNameController = TextEditingController(
    text: 'Shashi 5',
  );
  final TextEditingController guardianNameController = TextEditingController(
    text: 'Yash',
  );
  final TextEditingController emergencyNameController = TextEditingController(
    text: 'Shashi 5',
  );
  final TextEditingController emergencyAddressController =
      TextEditingController(text: 'Address Here');

  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emergencyMobileController =
      TextEditingController();

  String gender = 'Male';
  String maritalStatus = 'Married';
  String bloodGroup = 'O+';
  String emergencyRelation = 'Father';

  DateTime? dob;

  String get dobText {
    if (dob == null) return 'DD/MM/YYYY';
    return '${dob!.day.toString().padLeft(2, '0')}/'
        '${dob!.month.toString().padLeft(2, '0')}/'
        '${dob!.year}';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: dob ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => dob = picked);
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: "Update Profiled",
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Personal Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            _inputField('Staff Name', staffNameController),
            CountryPhoneField(
              label: 'Mobile No.',
              controller: mobileController,
            ),
            _dateField('Date of Birth', dobText, _pickDate),
            _dropdownField(
                'Gender',
                gender,
                [
                  'Male',
                  'Female',
                  'Other',
                ],
                (v) => setState(() => gender = v!)),
            _dropdownField(
              'Marital Status',
              maritalStatus,
              ['Single', 'Married', 'Divorced', 'Widowed'],
              (v) => setState(() => maritalStatus = v!),
            ),
            _dropdownField(
                'Blood Group',
                bloodGroup,
                [
                  'O+',
                  'O-',
                  'A+',
                  'B+',
                  'AB+',
                ],
                (v) => setState(() => bloodGroup = v!)),
            _inputField('Guardian Name', guardianNameController),
            const Divider(thickness: 10, color: (Color(0xFFE0E0E0))),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Emergency Contact Details',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            _inputField('Emergency Contact Name', emergencyNameController),
            _dropdownField(
              'Emergency Relationship',
              emergencyRelation,
              ['Father', 'Mother', 'Brother', 'Sister', 'Spouse'],
              (v) => setState(() => emergencyRelation = v!),
            ),
            CountryPhoneField(
              label: 'Emergency Contact Mobile',
              controller: emergencyMobileController,
            ),
            _addressField('Emergency Address', emergencyAddressController),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PersonalDetailScreen.primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Save Details',
                    style: TextStyle(
                      color: Color(0xffFFFFFF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ================= LABEL FONT UPDATED HERE =================

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15, //
        fontWeight: FontWeight.w500,
        color: PersonalDetailScreen.labelColor,
      ),
    );
  }

  Widget _inputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label(label),
          const SizedBox(height: 8),
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: PersonalDetailScreen.borderGrey),
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: TextField(
              controller: controller,
              textAlign: TextAlign.start,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true, // ✅ removes extra height
                contentPadding: EdgeInsets.zero, // ✅ forces center alignment
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dropdownField(
    String label,
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
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
              border: Border.all(color: PersonalDetailScreen.borderGrey),
              borderRadius: BorderRadius.circular(6),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: items
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
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
                border: Border.all(color: PersonalDetailScreen.borderGrey),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(value, softWrap: true),
                  SvgPicture.asset("assets/hrms/calander_date.svg")
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addressField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label(label),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            height: 90,
            decoration: BoxDecoration(
              border: Border.all(color: PersonalDetailScreen.borderGrey),
              borderRadius: BorderRadius.circular(6),
            ),
            child: TextField(
              controller: controller,
              maxLines: null,
              decoration: const InputDecoration(border: InputBorder.none),
            ),
          ),
        ],
      ),
    );
  }
}

// ================= MOBILE FIELD WITH FLAG =================

class CountryPhoneField extends StatefulWidget {
  final String label;
  final TextEditingController controller;

  const CountryPhoneField({
    super.key,
    required this.label,
    required this.controller,
  });

  @override
  State<CountryPhoneField> createState() => _CountryPhoneFieldState();
}

class _CountryPhoneFieldState extends State<CountryPhoneField> {
  String selectedCode = '+91';

  final Map<String, String> countries = <String, String>{
    '+91': '🇮🇳',
    '+1': '🇺🇸',
    '+44': '🇬🇧',
    '+61': '🇦🇺',
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              // LEFT BOX (Country code box)
              Container(
                width: 110,
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    isDense: true,
                    value: selectedCode,
                    items: countries.keys.map((code) {
                      return DropdownMenuItem(
                        value: code,
                        child: Row(
                          children: [
                            Text(
                              countries[code]!,
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              code,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => selectedCode = val!),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // RIGHT BOX (Phone number box)
              Expanded(
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: TextField(
                    controller: widget.controller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: '9156046848',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
