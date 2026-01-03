import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/controllers/theme_controller.dart';
import 'package:smart_solutions/theme/app_theme.dart';
import 'package:smart_solutions/widget/text_style.dart';

class SuggestionTextField extends StatelessWidget {
  final String label;
  final String? svgIconPath;
  final TextEditingController controller;
  final List<String> suggestions;
  final ValueChanged<String>? onChanged;

  SuggestionTextField({
    super.key,
    required this.label,
    this.svgIconPath,
    required this.controller,
    required this.suggestions,
    this.onChanged,
  });

  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<String>(
      controller:
          controller, // ✅ Pass controller directly (no builder text sync)
      suggestionsCallback: (pattern) {
        if (pattern.isEmpty) {
          // show all if user hasn't typed anything
          return suggestions;
        }
        final lowerPattern = pattern.toLowerCase();
        return suggestions
            .where((s) => s.toLowerCase().contains(lowerPattern))
            .toList();
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          leading: const Icon(Icons.person_outline),
          title: Text(suggestion),
        );
      },
      onSelected: (suggestion) {
        controller.text = suggestion;
        onChanged?.call(suggestion);
      },
      builder: (context, textController, focusNode) {
        // Prefix icon
        Widget? decoratedPrefixIcon;
        if (svgIconPath != null) {
          decoratedPrefixIcon = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 0.0, right: 3.0),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SvgPicture.asset(
                    svgIconPath!,
                    color: themeController.primaryColor.value,
                  ),
                ),
              ),
              SizedBox(
                height: 50,
                width: 5,
                child: VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: themeController.primaryColor.value,
                ),
              ),
            ],
          );
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: textController,
            focusNode: focusNode,
            onChanged: onChanged,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              hintText: label,
              hintStyle: AppTextStyle.hintText,
              prefixIcon: decoratedPrefixIcon,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide:
                    BorderSide(color: themeController.primaryColor.value),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                    color: themeController.primaryColor.value, width: 2),
              ),
              filled: true,
              fillColor: AppColors.appBarTextColor,
            ),
            style: TextStyle(color: themeController.primaryColor.value),
          ),
        );
      },
    );
  }
}
