import 'package:get/get.dart';

class AttendanceController extends GetxController {
  var isLoading = true.obs;
  var attendanceList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAttendance();
  }

  void fetchAttendance() async {
    await Future.delayed(
        const Duration(milliseconds: 600)); // simulate API delay

    attendanceList.value = [
      {
        'date': DateTime(2025, 11, 1),
        'status': 'Present',
        'checkIn': '09:10 AM',
        'checkOut': '06:12 PM',
      },
      {
        'date': DateTime(2025, 10, 2),
        'status': 'Absent',
      },
      {
        'date': DateTime(2025, 10, 3),
        'status': 'Half Day',
        'checkIn': '09:25 AM',
        'checkOut': '01:00 PM',
      },
      {
        'date': DateTime(2025, 9, 30),
        'status': 'Leave',
      },
    ];

    isLoading.value = false;
  }
}
