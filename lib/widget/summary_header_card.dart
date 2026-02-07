import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/theme_controller.dart';

class SummaryHeaderCard extends StatelessWidget {
  final String title;
  final String duration;
  final List<Widget> rows;
  final double height;
  final EdgeInsets padding;

  SummaryHeaderCard({
    super.key,
    required this.title,
    required this.duration,
    required this.rows,
    this.height = 80,
    this.padding = const EdgeInsets.all(14),
  });

  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Container(
        width: double.infinity,
        padding: padding,
        decoration: BoxDecoration(
          color: themeController.primaryColor.value.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    duration,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            ...rows,
          ],
        ),
      ),
    );
  }
}
