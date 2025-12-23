import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommonFormStyles {
  static const Color borderGrey = Color(0xFFE0E0E0);
  static const Color labelColor = Color(0xFF000000);
}

/// ================= LABEL =================
class CommonLabel extends StatelessWidget {
  final String text;
  const CommonLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Colors.grey.shade700,
      ),
    );
  }
}

/// ================= TEXT FIELD =================
class CommonTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;

  const CommonTextField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonLabel(label),
          const SizedBox(height: 8),
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: CommonFormStyles.borderGrey),
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: TextFormField(
              controller: controller,
              validator: validator,
              keyboardType: keyboardType,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= DROPDOWN =================
class CommonDropdownField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const CommonDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonLabel(label),
          const SizedBox(height: 8),
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: CommonFormStyles.borderGrey),
              borderRadius: BorderRadius.circular(6),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: items
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= DATE FIELD =================
class CommonDateField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const CommonDateField({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonLabel(label),
          const SizedBox(height: 8),
          InkWell(
            onTap: onTap,
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: CommonFormStyles.borderGrey),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(value),
                  SvgPicture.asset("assets/hrms/calander_date.svg"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= ADDRESS FIELD =================
class CommonAddressField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const CommonAddressField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonLabel(label),
          const SizedBox(height: 8),
          Container(
            height: 90,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: CommonFormStyles.borderGrey),
              borderRadius: BorderRadius.circular(6),
            ),
            child: TextFormField(
              controller: controller,
              validator: validator,
              maxLines: null,
              decoration: const InputDecoration(border: InputBorder.none),
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= TEXT FIELD WITH SUFFIX ICON =================
class CommonTextFieldWithPrefixIcon extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Widget prefixIcon;
  final VoidCallback? onPrefixTap;
  final String? hintText; // ✅ FIXED
  final bool readOnly;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const CommonTextFieldWithPrefixIcon({
    super.key,
    required this.label,
    required this.controller,
    required this.prefixIcon,
    this.onPrefixTap,
    this.hintText,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: CommonFormStyles.borderGrey),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                /// PREFIX ICON
                InkWell(
                  onTap: onPrefixTap,
                  child: prefixIcon,
                ),

                const SizedBox(width: 8),

                /// TEXT FIELD
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    validator: validator,
                    readOnly: readOnly,
                    keyboardType: keyboardType,
                    decoration: InputDecoration(
                      hintText: hintText, // ✅ ADDED
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


/// ================= COUNTRY PHONE FIELD =================
class CommonCountryPhoneField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const CommonCountryPhoneField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
  });

  @override
  State<CommonCountryPhoneField> createState() =>
      _CommonCountryPhoneFieldState();
}

class _CommonCountryPhoneFieldState extends State<CommonCountryPhoneField> {
  String selectedCode = '+91';

  final Map<String, String> countries = {
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
          CommonLabel(widget.label),
          const SizedBox(height: 8),
          Row(
            children: [
              /// COUNTRY CODE
              Container(
                width: 110,
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: CommonFormStyles.borderGrey),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedCode,
                    isExpanded: true,
                    items: countries.keys.map((code) {
                      return DropdownMenuItem(
                        value: code,
                        child: Row(
                          children: [
                            Text(countries[code]!,
                                style: const TextStyle(fontSize: 20)),
                            const SizedBox(width: 6),
                            Text(code),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => selectedCode = val!),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              /// PHONE NUMBER
              Expanded(
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: CommonFormStyles.borderGrey),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  alignment: Alignment.center,
                  child: TextFormField(
                    controller: widget.controller,
                    keyboardType: TextInputType.number,
                    validator: widget.validator,
                    decoration: const InputDecoration(
                      hintText: '9156046848',
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
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
