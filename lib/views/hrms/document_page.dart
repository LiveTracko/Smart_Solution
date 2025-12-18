import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DocumentsPage extends StatelessWidget {
  const DocumentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2F6DF6),
        leading: const BackButton(color: Color(0xffFFFFFF)),
        title: const Text(
          'Documents',
          style: TextStyle(
            color: Color(0xffFFFFFF),
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search Box
            TextField(
              decoration: InputDecoration(
                hintText: 'Search Text Here',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

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
        backgroundColor: color.withValues(alpha: 0.1),
        child: SvgPicture.asset(svgPath, width: 38, height: 38),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(date),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // Future: open document functionality
      },
    );
  }
}
