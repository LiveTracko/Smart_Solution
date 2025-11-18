import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:smart_solutions/controllers/holiday_controller.dart';
import 'package:smart_solutions/widget/common_scaffold.dart';

class HolidayListPage extends StatelessWidget {
  const HolidayListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(HolidayController());
    final theme = Theme.of(context);

    Map<String, List<Map<String, String>>> groupByMonth(
        List<Map<String, String>> holidays) {
      final Map<String, List<Map<String, String>>> grouped = {};
      for (var h in holidays) {
        final month = h['date']?.split(' ')[1] ?? '';
        if (!grouped.containsKey(month)) grouped[month] = [];
        grouped[month]!.add(h);
      }
      return grouped;
    }

    return CommonScaffold(
      title: "Holiday List",
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (c.holidays.isEmpty) {
          return const Center(child: Text("No holidays found."));
        }

        final groupedHolidays = groupByMonth(c.holidays);

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
          children: groupedHolidays.entries.map((entry) {
            final month = entry.key;
            final holidays = entry.value;

            return StickyHeader(
              header: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.primaryColor.withOpacity(0.95),
                      theme.primaryColor.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: theme.primaryColor.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                margin: const EdgeInsets.only(bottom: 10),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    const Icon(Icons.calendar_month_rounded,
                        color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      month.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              content: Column(
                children: holidays.asMap().entries.map((entry) {
                  final index = entry.key;
                  final holiday = entry.value;

                  return Stack(
                    children: [
                      // timeline line
                      Positioned(
                        left: 30,
                        top: 0,
                        bottom: index == holidays.length - 1 ? 40 : 0,
                        child: Container(
                          width: 2,
                          color: theme.primaryColor.withOpacity(0.3),
                        ),
                      ),
                      // holiday card
                      Container(
                        margin: const EdgeInsets.only(left: 60, bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(
                            holiday['name'] ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            "${holiday['day']} • ${holiday['type']}",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          trailing: Text(
                            holiday['date'] ?? '',
                            style: TextStyle(
                              color: theme.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      // timeline dot
                      Positioned(
                        top: 32,
                        left: 23,
                        child: Container(
                          height: 16,
                          width: 16,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: theme.primaryColor,
                              width: 3,
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            );
          }).toList(),
        );
      }),
    );
  }
}
