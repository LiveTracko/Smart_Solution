import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_solutions/models/incentive_model.dart';
import 'package:smart_solutions/views/spacing_constants.dart';
import 'package:smart_solutions/widget/text_style.dart';

class IncentiveCard extends StatelessWidget {
  final String title;
  // final String target;
  // final String achievement;
  final String? duration;
  final Color statusColor;
  final List<IncentiveItem> items;
  bool isNextPage;
  final VoidCallback? onTap;

  IncentiveCard(
      {super.key,
      required this.title,
      // required this.target,
      // required this.achievement,
      this.duration,
      required this.statusColor,
      required this.items,
      this.isNextPage = false,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (duration != null) ...[
                      Text(duration!, style: AppTextStyle.blueHeaderTitletStyle)
                    ],
                    kHorizontalSpace(15.w),
                    isNextPage
                        ? const Icon(Icons.arrow_forward_ios,
                            size: 12, color: Colors.black45)
                        : SizedBox.shrink()
                  ],
                )
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(items.length, (index) {
                final item = items[index];
                final isLast = index == items.length - 1;
                return Expanded(
                    child: Row(
                  children: [
                    _buildInfoItem(item.label, item.value),
                    if (!isLast) _divider(),
                    // if (isLast)
                    //   if (isNextPage)
                    //     const Icon(Icons.arrow_forward_ios,
                    //         size: 12, color: Colors.black45)
                  ],
                ));
              }),

              // _buildInfoItem("Target", target),
              // _divider(),
              // _buildInfoItem("Achievement", achievement),
              // _divider(),
              // _buildInfoItem("Incentive", incentive),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable info section
  Widget _buildInfoItem(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black54),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ],
      ),
    );
  }

  // Vertical divider between columns
  Widget _divider() {
    return Container(
      height: 28,
      width: 1,
      color: Colors.grey.withOpacity(0.3),
    );
  }
}
