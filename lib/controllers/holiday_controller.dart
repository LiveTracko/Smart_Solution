import 'package:get/get.dart';

class HolidayController extends GetxController {
  var isLoading = true.obs;
  var holidays = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchHolidays();
  }

  void fetchHolidays() async {
    await Future.delayed(const Duration(milliseconds: 800)); // mock API delay
    holidays.assignAll([
      {
        'date': '01 Jan 2025',
        'day': 'Wednesday',
        'name': 'New Year’s Day',
        'type': 'Public Holiday'
      },
      {
        'date': '01 Jan 2025',
        'day': 'Sunday',
        'name': 'Republic Day',
        'type': 'National Holiday'
      },
      {
        'date': '08 Mar 2025',
        'day': 'Saturday',
        'name': 'Holi',
        'type': 'Festival'
      },
      {
        'date': '15 Aug 2025',
        'day': 'Friday',
        'name': 'Independence Day',
        'type': 'National Holiday'
      },
      {
        'date': '02 Oct 2025',
        'day': 'Thursday',
        'name': 'Gandhi Jayanti',
        'type': 'Public Holiday'
      },
      {
        'date': '02 Nov 2025',
        'day': 'Thursday',
        'name': 'Gandhi Jayanti',
        'type': 'Public Holiday'
      },
      {
        'date': '02 Dec 2025',
        'day': 'Thursday',
        'name': 'Gandhi Jayanti',
        'type': 'Public Holiday'
      },
    ]);
    isLoading.value = false;
  }
}
