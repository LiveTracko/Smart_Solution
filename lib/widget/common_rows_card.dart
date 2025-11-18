import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_solutions/widget/text_style.dart';

class CommonRows {
  Widget buildSingleRow(dynamic icon, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
      child: Row(
        children: [
          _buildIcon(icon),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.black),
              maxLines: 10,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDoubleRow({
    required dynamic iconLeft,
    required String valueLeft,
    required dynamic iconRight,
    required String valueRight,
    Color? textColorRight,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                _buildIcon(iconLeft),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    valueLeft,
                    style: const TextStyle(fontSize: 12, color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildIcon(iconLeft),
                //  Icon(iconRight, size: 14, color: Colors.grey[700]),
                const SizedBox(width: 4),
                Text(
                  valueRight,
                  style: TextStyle(
                    fontSize: 12,
                    color: textColorRight ?? Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // New method without Expanded for end alignment
  Widget buildSingleRowNoExpand(dynamic icon, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.max, // ← Important
        children: [
          _buildIcon(icon),
          const SizedBox(width: 5),
          Text(
            value,
            style: AppTextStyle.headerTitle,
            maxLines: 10,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Mask mobile digits
  static String mask(String number) {
    if (number.length < 6) return number;
    return "xxxxxx${number.substring(6)}";
  }

  Widget _buildIcon(dynamic icon) {
    if (icon is String) {
      // SVG PATH
      return SvgPicture.asset(
        icon,
        width: 22,
        height: 22,
        // color: Colors.grey[700],
      );
    } else if (icon is IconData) {
      // NORMAL ICON
      return Icon(icon, size: 24, color: Colors.grey[700]);
    } else {
      return const SizedBox();
    }
  }
}
