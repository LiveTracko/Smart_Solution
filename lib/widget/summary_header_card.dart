import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/theme_controller.dart';

// import '../controllers/theme_controller.dart';

// class SummaryHeaderCard extends StatelessWidget {
//   final String title;
//   final String duration;
//   final List<Widget> rows;
//   final double height;
//   final EdgeInsets padding;

//   SummaryHeaderCard({
//     super.key,
//     required this.title,
//     required this.duration,
//     required this.rows,
//     this.height = 80,
//     this.padding = const EdgeInsets.all(14),
//   });

//   final ThemeController themeController = Get.find<ThemeController>();

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//       child: Container(
//         width: double.infinity,
//         padding: padding,
//         decoration: BoxDecoration(
//           color: themeController.primaryColor.value.withOpacity(0.2),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     title,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   Text(
//                     duration,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black87,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             ...rows,
//           ],
//         ),
//       ),
//     );
//   }
// }

class SummaryHeaderCard extends StatelessWidget {
  final String title;
  final String? duration;
  final List<Widget> rows;
  final EdgeInsets padding;

  SummaryHeaderCard({
    super.key,
    required this.title,
    this.duration,
    required this.rows,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
  });

  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    final primary = themeController.primaryColor.value;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primary.withOpacity(.16),
              primary.withOpacity(.05),
            ],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // Text(
                  //   duration,
                  //   style: const TextStyle(
                  //     fontSize: 14,
                  //     fontWeight: FontWeight.w600,
                  //   ),
                  // ),
                ],
              ),
            ),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              alignment: WrapAlignment.end,
              children: rows,
            ),
          ],
        ),
      ),
    );
  }
}
