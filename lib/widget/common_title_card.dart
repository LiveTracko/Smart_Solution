import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:smart_solutions/views/spacing_constants.dart';
import 'package:smart_solutions/widget/text_style.dart';

class CommonTitleCard extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String subtitle;
  final String? status;
  final Color? statusColor;
  final String amount;
  final List<Widget> children;
  final bool showEdit;
  final VoidCallback? onEdit;
  final VoidCallback? onLeadingTap;
  final ValueChanged<bool>? onExpansionChanged;
  String? followupdate;

  CommonTitleCard(
      {super.key,
      this.leading,
      required this.title,
      required this.subtitle,
      this.status,
      this.statusColor,
      required this.amount,
      required this.children,
      this.showEdit = false,
      this.onEdit,
      this.onLeadingTap,
      this.onExpansionChanged,
      this.followupdate});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            ExpansionTile(
              minTileHeight: 40,
              tilePadding: EdgeInsets.zero,
              childrenPadding: EdgeInsets.zero,
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              shape: const RoundedRectangleBorder(
                side: BorderSide(color: Colors.transparent, width: 0),
              ),
              onExpansionChanged:
                  children.isNotEmpty ? onExpansionChanged : null,
              leading: leading != null
                  ? GestureDetector(
                      onTap: onLeadingTap,
                      child: leading!,
                    )
                  : null,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: null,
                    overflow: TextOverflow.visible,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: null,
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  if (followupdate != null) // your follow up date string
                    Obx(
                      () => Text(
                        "Follow Up: $followupdate",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextColor.primaryText(12),
                      ),
                    )
                ],
              ),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     if (status != null && status!.isNotEmpty)
                  //       Container(
                  //         decoration: BoxDecoration(
                  //           color: statusColor,
                  //           borderRadius: BorderRadius.circular(6),
                  //         ),
                  //         padding: const EdgeInsets.symmetric(
                  //             horizontal: 5, vertical: 3),
                  //         child: Text(
                  //           status ?? '',
                  //           style: const TextStyle(
                  //             fontSize: 10,
                  //             color: Colors.white,
                  //             fontWeight: FontWeight.bold,
                  //           ),
                  //         ),
                  //       ),
                  //     showEdit
                  //         ? GestureDetector(
                  //             onTap: onEdit,
                  //             child: const Padding(
                  //               padding: EdgeInsets.symmetric(horizontal: 8),
                  //               child: Icon(Icons.edit, size: 18),
                  //             ),
                  //           )
                  //         : const SizedBox.shrink(),
                  //   ],
                  // ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (status != null && status!.isNotEmpty)
                        Container(
                          decoration: BoxDecoration(
                            color: statusColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 3),
                          child: Text(
                            status ?? '',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      showEdit
                          ? GestureDetector(
                              onTap: onEdit,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Icon(Icons.edit, size: 18),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                  // showEdit
                  //     ? GestureDetector(
                  //         onTap: onEdit,
                  //         child: const Padding(
                  //           padding: EdgeInsets.symmetric(horizontal: 8),
                  //           child: Icon(Icons.edit, size: 20),
                  //         ),
                  //       )
                  //     : const SizedBox.shrink(),
                  // if (status != null && status!.isNotEmpty)
                  //   Container(
                  //     decoration: BoxDecoration(
                  //       color: statusColor,
                  //       borderRadius: BorderRadius.circular(6),
                  //     ),
                  //     padding: const EdgeInsets.symmetric(
                  //         horizontal: 5, vertical: 3),
                  //     child: Text(
                  //       status ?? '',
                  //       style: const TextStyle(
                  //         fontSize: 10,
                  //         color: Colors.white,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //   ),

                  // if (status != null && status!.isNotEmpty)
                  //   Container(
                  //     decoration: BoxDecoration(
                  //       color: statusColor,
                  //       borderRadius: BorderRadius.circular(6),
                  //     ),
                  //     padding: const EdgeInsets.symmetric(
                  //         horizontal: 5, vertical: 3),
                  //     child: Text(
                  //       status ?? '',
                  //       style: const TextStyle(
                  //         fontSize: 10,
                  //         color: Colors.white,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //   ),
                  // showEdit
                  //     ? GestureDetector(
                  //         onTap: onEdit,
                  //         child: const Padding(
                  //           padding: EdgeInsets.symmetric(horizontal: 8),
                  //           child: Icon(Icons.edit, size: 18),
                  //         ),
                  //       )
                  //     : const SizedBox.shrink(),

                  kVerticalSpace(4.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Text(
                          amount,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      if (children.isNotEmpty)
                        const Icon(Icons.keyboard_arrow_down,
                            size: 18, color: Colors.black),
                      // const Icon(Icons.keyboard_arrow_down,
                      //     size: 18, color: Colors.black),
                    ],
                  ),
                ],
              ),
              children: [
                const Divider(height: 20, color: Colors.black12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: children,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
