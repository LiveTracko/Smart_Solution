import 'package:flutter/material.dart';
import 'package:smart_solutions/widget/text_style.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final String duration;
  final List<Widget> rows;
  final double height;
  final EdgeInsets padding;

  const SummaryCard({
    super.key,
    required this.title,
    required this.duration,
    required this.rows,
    this.height = 80,
    this.padding = const EdgeInsets.all(14),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        dense: true,
        leading: const CircleAvatar(
          child: Icon(Icons.person),
        ),
        title: Text(title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.smallbodyTxt),
        subtitle: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: duration.isNotEmpty
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.end,
          children: [
            if (duration.isNotEmpty)
              Text(duration,
                  style: AppTextStyle.blueHeaderTitletStyle
                      .copyWith(fontSize: 12)),
            Row(
              children: rows,
            )
          ],
        ),
        // trailing: Row(
        //   mainAxisSize: MainAxisSize.min,
        //   children: rows,
        // ),
      ),
    );
  }
}
