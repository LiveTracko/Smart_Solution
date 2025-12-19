import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_solutions/widget/common_form_field.dart';
import 'package:smart_solutions/widget/common_scaffold.dart';

class DocumentsPage extends StatelessWidget {
  const DocumentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: "Documents",
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search Box
            CommonTextFieldWithSuffixIcon(
                label: "Search Text Here ",
                controller: SearchController(),
                suffixIcon: Icon(Icons.search_rounded)),

            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                children: const [
                  DocumentTile(
                    title: 'Salary Slip October 2025.pdf',
                    date: '16th May, 2024',
                    svgPath: 'assets/hrms/PDF.svg',
                    color: Color.fromARGB(255, 245, 242, 242),
                  ),
                  Divider(thickness: 1),
                  DocumentTile(
                    title: 'Appointment Letter.xlsx',
                    date: '16th May, 2024',
                    svgPath: 'assets/hrms/XSL.svg',
                    color: Color.fromARGB(255, 249, 253, 250),
                  ),
                  Divider(thickness: 1),
                  DocumentTile(
                    title: 'Passport Photo.jpg',
                    date: '16th May, 2024',
                    svgPath: 'assets/hrms/JPG.svg',
                    color: Color.fromARGB(255, 247, 251, 247),
                  ),
                  Divider(thickness: 1),
                  DocumentTile(
                    title: 'New Year Celebration.mp4',
                    date: '16th May, 2024',
                    svgPath: 'assets/hrms/MP4.svg',
                    color: Color.fromARGB(255, 254, 250, 255),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Single Document Row UI
class DocumentTile extends StatelessWidget {
  final String svgPath;
  final String title;
  final String date;
  final Color color;

  const DocumentTile({
    super.key,
    required this.svgPath,
    required this.title,
    required this.date,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: SvgPicture.asset(svgPath, width: 38, height: 38),
      ),

      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),

      /// 👇 SVG + DATE ROW
      subtitle: Row(
        children: [
          SvgPicture.asset(
            'assets/hrms/calander_date.svg', // your calendar svg
            width: 14,
            height: 14,
            colorFilter: const ColorFilter.mode(
              Colors.grey,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            date,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),

      trailing: const Icon(Icons.arrow_forward_ios, size: 16),

      onTap: () {},
    );
  }
}
