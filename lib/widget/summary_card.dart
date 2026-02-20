import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smart_solutions/constants/api_urls.dart';
import 'package:smart_solutions/widget/text_style.dart';

class SummaryCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String duration;
  final List<Widget> rows;
  final double height;
  final EdgeInsets padding;
  final IconData icon;

  const SummaryCard({
    super.key,
    required this.imageUrl,
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
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(.08),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: '${APIUrls.imagebaseUrl}$imageUrl',
                width: 36,
                height: 36,
                fit: BoxFit.cover,
                // placeholder: (_, __) => const SizedBox(
                //   width: 16,
                //   height: 16,
                //   child: CircularProgressIndicator(strokeWidth: 2),
                // ),
                errorWidget: (_, __, ___) => const Icon(Icons.person, size: 20),
              ),
            ),
          )

          //  Image.network('${APIUrls.imagebaseUrl}$imageUrl',
          //     fit: BoxFit.cover,
          //     errorBuilder: (context, error, stackTrace) =>
          //         const Icon(Icons.image_not_supported)),
          ,
          const SizedBox(width: 12),
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

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (duration.isNotEmpty) ...[
                      Text(
                        duration,
                        style: AppTextStyle.blueHeaderTitletStyle.copyWith(
                          fontSize: 12,
                        ),
                      ),
                    ],
                    Expanded(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: rows,
                      ),
                    ),
                  ],
                ),

                // if (duration.isNotEmpty) ...[
                //   const SizedBox(height: 4),
                //   Text(
                //     duration,
                //     style: AppTextStyle.blueHeaderTitletStyle.copyWith(
                //       fontSize: 12,
                //     ),
                //   ),
                // ],

                // const SizedBox(height: 5),

                // /// Stats Row
                // Wrap(
                //   spacing: 8,
                //   runSpacing: 6,
                //   children: rows,
                // ),
              ],
            ),
          ),
        ]));
  }
}
