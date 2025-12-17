import 'package:flutter/material.dart';

class HolidayListPage extends StatelessWidget {
  const HolidayListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2F6DF6),
        leading: const BackButton(color: Color(0xffFFFFFF)),
        title: const Text(
          'Holiday List',
          style: TextStyle(
            color: Color(0xffFFFFFF),
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: const [
          // ========== January ==========
          _SectionTitle('January'),
          SizedBox(height: 8),
          _HolidayCard(
            title: 'New Years',
            weekday: 'Sunday',
            dateText: '1st Jan 2025',
          ),
          SizedBox(height: 10),
          _HolidayCard(
            title: 'Republic Day',
            weekday: 'Monday',
            dateText: '26th Jan 2025',
          ),

          SizedBox(height: 24),

          // ========== March ==========
          _SectionTitle('March'),
          SizedBox(height: 8),
          _HolidayCard(
            title: 'Holi',
            weekday: 'Sunday',
            dateText: '08th Mar 2025',
          ),

          SizedBox(height: 24),

          // ========== August ==========
          _SectionTitle('August'),
          SizedBox(height: 8),
          _HolidayCard(
            title: 'Independence Day',
            weekday: 'Monday',
            dateText: '15th Aug 2025',
          ),
        ],
      ),
    );
  }
}

// ---------- Section heading (January / March / August) ----------
class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
      ),
    );
  }
}

// ---------- Single holiday card ----------
class _HolidayCard extends StatelessWidget {
  final String title;
  final String weekday;
  final String dateText;

  const _HolidayCard({
    required this.title,
    required this.weekday,
    required this.dateText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD0E3FF)),
        gradient: const LinearGradient(
          colors: [Color(0xFFE8F2FF), Color(0xffFFFFFF)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // left: name + weekday
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  weekday,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          // right: date
          Text(
            dateText,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
