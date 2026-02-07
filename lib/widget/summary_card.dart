import 'package:flutter/material.dart';
import 'package:smart_solutions/widget/text_style.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final String duration;
  final List<Widget> rows;
  final double height;
  final EdgeInsets padding;
  final IconData icon;

  const SummaryCard({
    super.key,
    required this.title,
    required this.duration,
    required this.rows,
    this.height = 90,
    this.padding = const EdgeInsets.all(14),
    this.icon = Icons.person_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Avatar
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.blue),
          ),

          const SizedBox(width: 12),

          /// Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.smallbodyTxt.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                if (duration.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    duration,
                    style: AppTextStyle.blueHeaderTitletStyle.copyWith(
                      fontSize: 12,
                    ),
                  ),
                ],

                const SizedBox(height: 10),

                /// Stats Row
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: rows,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
