import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_solutions/theme/app_theme.dart';
import 'package:smart_solutions/widget/common_scaffold.dart';
import 'package:smart_solutions/widget/text_style.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  TextEditingController staffNameController =
      TextEditingController(text: "Shashi S");
  TextEditingController mobileController =
      TextEditingController(text: "9999888832");
  TextEditingController dobController =
      TextEditingController(text: "DD/MM/YYYY");
  TextEditingController genderController = TextEditingController(text: "Male");
  TextEditingController marriedStatusController =
      TextEditingController(text: "Married");
  TextEditingController bloodGroupController =
      TextEditingController(text: "O+");
  TextEditingController guardiansHomeController =
      TextEditingController(text: "Shashi");

  // Emergency contact controllers
  TextEditingController emergencyNameController =
      TextEditingController(text: "Shashi S");
  TextEditingController emergencyRelationshipController =
      TextEditingController(text: "Male");
  TextEditingController emergencyMobileController =
      TextEditingController(text: "9999888832");
  TextEditingController emergencyAddressController =
      TextEditingController(text: "Address Here");

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: "Update Profile",
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Personal Details Section
              Text("Personal Details", style: AppTextStyle.textfieldheading),
              const SizedBox(height: 16),

              // Staff Name
              _buildTextFieldWithLabel(
                "Staff Name",
                staffNameController,
                isRequired: true,
              ),
              const SizedBox(height: 16),

              // Mobile Number
              _buildTextFieldWithLabel(
                "Mobile No.",
                mobileController,
                isRequired: true,
                keyboardType: TextInputType.phone,
                prefixText: "+91 ",
              ),
              const SizedBox(height: 16),

              // Date of Birth
              _buildTextFieldWithLabel(
                "Date of Birth",
                dobController,
                isRequired: true,
                svgIconPath: "assets/hrms/calander_date.svg",
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 16),

              // Gender
              _buildDropdownField(
                "Gender",
                genderController,
                options: ["Male", "Female", "Other"],
              ),
              const SizedBox(height: 16),

              // Married Status
              _buildDropdownField(
                "Married Status",
                marriedStatusController,
                options: ["Married", "Single", "Divorced", "Widowed"],
              ),
              const SizedBox(height: 16),

              // Blood Group
              _buildDropdownField(
                "Blood Group",
                bloodGroupController,
                options: ["O+", "O-", "A+", "A-", "B+", "B-", "AB+", "AB-"],
              ),
              const SizedBox(height: 16),

              // Guardians Home
              _buildTextFieldWithLabel(
                "Guardians Home",
                guardiansHomeController,
                isRequired: true,
              ),

              const SizedBox(height: 24),
              const Text("Emergency Contact Details",
                  style: AppTextStyle.textfieldheading),
              const SizedBox(height: 16),

              // Emergency Contact Name
              _buildTextFieldWithLabel(
                "Emergency Contact Name",
                emergencyNameController,
                isRequired: true,
              ),
              const SizedBox(height: 16),

              // Emergency Contact Relationship
              _buildDropdownField(
                "Emergency Contact Relationship",
                emergencyRelationshipController,
                options: [
                  "Father",
                  "Mother",
                  "Brother",
                  "Sister",
                  "Spouse",
                  "Other"
                ],
              ),
              const SizedBox(height: 16),

              // Emergency Contact Mobile
              _buildTextFieldWithLabel(
                "Emergency Contact Mobile",
                emergencyMobileController,
                isRequired: true,
                keyboardType: TextInputType.phone,
                prefixText: "+91 ",
              ),
              const SizedBox(height: 16),

              // Emergency Contact Address
              _buildTextFieldWithLabel(
                "Emergency Contact Address",
                emergencyAddressController,
                isRequired: true,
                maxLines: 3,
              ),

              const SizedBox(height: 40),

              // Update Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _updateProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Update",
                    style: AppTextStyle.bodyBoldTxt.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldWithLabel(
    String label,
    TextEditingController controller, {
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
    String? prefixText,
    String? svgIconPath,
    VoidCallback? onTap,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: AppTextStyle.textfieldabove.copyWith(),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            onTap: onTap,
            readOnly: onTap != null,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: InputBorder.none,
              prefixText: prefixText,
              prefixStyle: AppTextStyle.bodyBoldTxt.copyWith(
                color: Colors.black87,
              ),
              suffixIcon: svgIconPath != null
                  ? Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SvgPicture.asset(
                        svgIconPath,
                        width: 20,
                        height: 20,
                      ),
                    )
                  : null,
            ),
            style: AppTextStyle.bodyBoldTxt.copyWith(
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(
    String label,
    TextEditingController controller, {
    required List<String> options,
    bool isRequired = false,
  }) {
    String? selectedValue = controller.text.isNotEmpty ? controller.text : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: AppTextStyle.textfieldabove.copyWith(),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          // child: DropdownButtonFormField<String>(
          //   value: selectedValue,
          //   items: options.map((String value) {
          //     return DropdownMenuItem<String>(
          //       value: value,
          //       child: Text(
          //         value,
          //         style: AppTextStyle.bodyBoldTxt.copyWith(
          //           color: Colors.black87,
          //         ),
          //       ),
          //     );
          //   }).toList(),
          //   onChanged: (String? newValue) {
          //     setState(() {
          //       controller.text = newValue ?? '';
          //     });
          //   },
          //   decoration: InputDecoration(
          //     contentPadding: const EdgeInsets.symmetric(
          //       horizontal: 16,
          //       vertical: 12,
          //     ),
          //     border: InputBorder.none,
          //     suffixIcon: Padding(
          //       padding: const EdgeInsets.all(12.0),
          //       child: SvgPicture.asset("assets/hrms/dropdown.svg"),
          //     ),
          //   ),
          //   style: AppTextStyle.bodyBoldTxt.copyWith(
          //     color: Colors.black87,
          //   ),
          //   icon: const SizedBox.shrink(), // Hide default dropdown icon
          //   isExpanded: true,
          // ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        dobController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _updateProfile() {
    if (_formKey.currentState!.validate()) {
      // Handle update profile logic here
      print("Profile updated successfully");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Profile updated successfully"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  void dispose() {
    // Dispose all controllers
    staffNameController.dispose();
    mobileController.dispose();
    dobController.dispose();
    genderController.dispose();
    marriedStatusController.dispose();
    bloodGroupController.dispose();
    guardiansHomeController.dispose();
    emergencyNameController.dispose();
    emergencyRelationshipController.dispose();
    emergencyMobileController.dispose();
    emergencyAddressController.dispose();
    super.dispose();
  }
}
