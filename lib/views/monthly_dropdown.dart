import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DropdownController extends GetxController {
  var selectedMonth = Rx<String?>(null); // Allow null values

  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];




  void setMonth(String? month) async {
    selectedMonth.value = month;
  }
}

class MonthDropdown extends StatelessWidget {


    Map<String, String> monthMap = {
    'January': '1',
    'February': '2',
    'March': '3',
    'April': '4',
    'May': '5',
    'June': '6',
    'July': '7',
    'August': '8',
    'September': '9',
    'October': '10',
    'November': '11',
    'December': '12'
  };
  final Function(String value) onChanged;
  final DropdownController controller = Get.put(DropdownController());
  MonthDropdown({required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Obx(() {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey, // Border color
              width: 1.5, // Border width
            ),
            borderRadius: BorderRadius.circular(8), // Border radius
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              padding: EdgeInsets.symmetric(vertical: 0),
              elevation: 2,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
              // menuMaxHeight: 30,
              value: controller.selectedMonth.value,
              hint: Text('Month'), // Display "Select" when nothing is selected
              onChanged: (value) {
                controller.setMonth(value);
                onChanged(monthMap[value] ?? "");
              },
              items: controller.months
                  .map<DropdownMenuItem<String>>((String month) {
                return DropdownMenuItem<String>(
                  value: month,
                  child: Text(
                    month,
                    strutStyle: StrutStyle(
                      fontSize: 14,
                      // height: 1.5,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                );
              }).toList(),
            ),
          ),
        );
      }),
    );
  }
}

// class MonthController extends GetxController {
//   // List of months
//   final months = [
//     'January',
//     'February',
//     'March',
//     'April',
//     'May',
//     'June',
//     'July',
//     'August',
//     'September',
//     'October',
//     'November',
//     'December'
//   ];

//   // Selected month
//   var selectedMonth = ''.obs;

//   // Function to update selected month
//   void setSelectedMonth(String month) {
//     selectedMonth.value = month;
//   }
// }

// class MonthDropdown extends StatelessWidget {
//   final MonthController controller = Get.put(MonthController());
//   // final DropdownController controller = Get.put(DropdownController());

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Obx(() => DropdownButtonFormField<String>(
//               decoration: InputDecoration(
//                 labelText: 'now i need to sa',
//                 border: OutlineInputBorder(),
//               ),
//               value: controller.selectedMonth.value == null
//                   ? null
//                   : controller.selectedMonth.value,
//               items: controller.months.map((String month) {
//                 return DropdownMenuItem<String>(
//                   value: month,
//                   child: Text(month),
//                 );
//               }).toList(),
//               onChanged: (newValue) {
//                 if (newValue != null) {
//                   controller.setSelectedMonth(newValue);
//                 }
//               },
//             )),
//         SizedBox(height: 20),
//         // Show selected month
//         Obx(() => Text(
//               'Selected Month: ${controller.selectedMonth.value}',
//               style: TextStyle(fontSize: 18),
//             )),
//       ],
//     );
//   }
// }

// class MonthlyDropdown extends StatefulWidget {
//   const MonthlyDropdown({super.key});

//   @override
//   State<MonthlyDropdown> createState() => _MonthlyDropdownState();
// }

// class _MonthlyDropdownState extends State<MonthlyDropdown> {
//   String month = '';
//   List<String> months = [
//     'january',
//     'february',
//     'march',
//     'april',
//     'may',
//     'june',
//     'july',
//     'august',
//     'september',
//     'october',
//     'november',
//     'december'
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: DropdownButtonFormField(
//           items: months.map((String month) {
//             return DropdownMenuItem(
//               child: Text(month),
//               value: month,
//             );
//           }).toList()
//           //  items: months.map((String month) {
//           //         return DropdownMenuItem<String>(
//           //           value: month,
//           //           child: Text(month),
//           //         );
//           //       }).toList(),

//           ,
//           onChanged: (value) {
//             setState(() {});
//           }),
//     );
//   }
// }
