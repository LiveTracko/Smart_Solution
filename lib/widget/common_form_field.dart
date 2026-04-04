import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/controllers/theme_controller.dart';

class CommonFormStyles {
  // Use ThemeController for dynamic colors
  static Color borderColor(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return themeController.primaryColor.value.withOpacity(0.3);
  }

  static Color focusedBorderColor(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return themeController.primaryColor.value;
  }

  static Color errorColor(BuildContext context) =>
      Theme.of(context).colorScheme.error;

  static Color labelColor(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.7);
  }

  static Color hintColor(BuildContext context) => Theme.of(context).hintColor;

  static Color textColor(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.color!;
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
        color: CommonFormStyles.labelColor(context),
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
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? textColor;
  final Color? fillColor;
  final bool filled;

  const CommonTextField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.borderColor,
    this.focusedBorderColor,
    this.textColor,
    this.fillColor,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonLabel(label),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            validator: validator,
            keyboardType: keyboardType,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            maxLength: keyboardType == TextInputType.number ? 10 : null,
            style: TextStyle(
                color: textColor ?? CommonFormStyles.textColor(context)),
            decoration: InputDecoration(
              filled: filled,
              fillColor:
                  fillColor ?? (filled ? theme.cardColor : Colors.transparent),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(
                  color: borderColor ?? CommonFormStyles.borderColor(context),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(
                  color: focusedBorderColor ??
                      CommonFormStyles.focusedBorderColor(context),
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(
                  color: CommonFormStyles.errorColor(context),
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(
                  color: CommonFormStyles.errorColor(context),
                ),
              ),
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
  final Color? borderColor;
  final Color? textColor;
  final Color? fillColor;

  const CommonDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.borderColor,
    this.textColor,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              color: fillColor ?? theme.cardColor,
              border: Border.all(
                color: borderColor ?? CommonFormStyles.borderColor(context),
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                icon: Icon(Icons.keyboard_arrow_down,
                    color: CommonFormStyles.textColor(context)),
                dropdownColor: theme.cardColor,
                style: TextStyle(
                    color: textColor ?? CommonFormStyles.textColor(context)),
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
  final Color? borderColor;
  final Color? textColor;
  final Color? fillColor;

  const CommonDateField({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
    this.borderColor,
    this.textColor,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                color: fillColor ?? theme.cardColor,
                border: Border.all(
                  color: borderColor ?? CommonFormStyles.borderColor(context),
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                        color:
                            textColor ?? CommonFormStyles.textColor(context)),
                  ),
                  SvgPicture.asset(
                    "assets/hrms/calander_date.svg",
                    colorFilter: ColorFilter.mode(
                      CommonFormStyles.focusedBorderColor(context),
                      BlendMode.srcIn,
                    ),
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

/// ================= ADDRESS FIELD =================
class CommonAddressField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Color? borderColor;
  final Color? textColor;
  final Color? fillColor;

  const CommonAddressField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.borderColor,
    this.textColor,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              color: fillColor ?? theme.cardColor,
              border: Border.all(
                color: borderColor ?? CommonFormStyles.borderColor(context),
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: TextFormField(
              controller: controller,
              validator: validator,
              maxLines: null,
              style: TextStyle(
                  color: textColor ?? CommonFormStyles.textColor(context)),
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= TEXT FIELD WITH PREFIX ICON =================
class CommonTextFieldWithPrefixIcon extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Widget prefixIcon;
  final VoidCallback? onPrefixTap;
  final String? hintText;
  final bool readOnly;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Color? borderColor;
  final Color? textColor;
  final Color? hintColor;
  final Color? fillColor;

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
    this.borderColor,
    this.textColor,
    this.hintColor,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              color: fillColor ?? theme.cardColor,
              border: Border.all(
                color: borderColor ?? CommonFormStyles.borderColor(context),
              ),
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
                    style: TextStyle(
                        color:
                            textColor ?? CommonFormStyles.textColor(context)),
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: TextStyle(
                        color: hintColor ?? CommonFormStyles.hintColor(context),
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
  final Color? borderColor;
  final Color? textColor;
  final Color? fillColor;

  const CommonCountryPhoneField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.borderColor,
    this.textColor,
    this.fillColor,
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
    final theme = Theme.of(context);

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
                  color: widget.fillColor ?? theme.cardColor,
                  border: Border.all(
                    color: widget.borderColor ??
                        CommonFormStyles.borderColor(context),
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedCode,
                    isExpanded: true,
                    dropdownColor: theme.cardColor,
                    style: TextStyle(
                      color: widget.textColor ??
                          CommonFormStyles.textColor(context),
                    ),
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
                    color: widget.fillColor ?? theme.cardColor,
                    border: Border.all(
                      color: widget.borderColor ??
                          CommonFormStyles.borderColor(context),
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  alignment: Alignment.center,
                  child: TextFormField(
                    controller: widget.controller,
                    keyboardType: TextInputType.number,
                    validator: widget.validator,
                    style: TextStyle(
                        color: widget.textColor ??
                            CommonFormStyles.textColor(context)),
                    decoration: InputDecoration(
                      hintText: '9156046848',
                      hintStyle: TextStyle(
                        color: CommonFormStyles.hintColor(context),
                      ),
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
