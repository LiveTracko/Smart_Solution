import 'package:get/get.dart';

class DocumentsController extends GetxController {
  final salarySlipUrl = ''.obs;

  void loadSalarySlip(String url) {
    salarySlipUrl.value = url;
  }
}
