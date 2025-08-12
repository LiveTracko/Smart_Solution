import 'dart:convert';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_solutions/constants/static_stored_data.dart';
import 'package:smart_solutions/models/banker_name_model.dart';
import 'package:smart_solutions/models/customerData_mobileNumber.dart';
import 'package:smart_solutions/models/data_entery_model.dart';
import 'package:smart_solutions/models/data_entry_bank_list.dart';
import 'package:smart_solutions/models/dsa_bank_list.dart';
import 'package:smart_solutions/models/dsa_name_model.dart';
import 'package:smart_solutions/models/product_type.dart';
import 'package:smart_solutions/models/source_model.dart';
import 'package:smart_solutions/models/status_list_model.dart';
import 'package:smart_solutions/models/tellecaller_name_model.dart';
import 'package:smart_solutions/services/api_service.dart';
import 'package:smart_solutions/constants/api_urls.dart';
import '../constants/services.dart';

class DataController extends GetxController {
  final ApiService _apiService = ApiService();
  var dateRangeList = <DateTime?>[].obs;
  var isLoading = true.obs;
  var dataList = <Data>[].obs;
  var errorMessage = ''.obs;
  bool granted = false;

  var allBankNamesList = <DataEntryBankList>[].obs;

  var dsaName = ''.obs;
  RxString tellecallerId = ''.obs;
  RxString dataId = ''.obs;
  RxString dsaId = ''.obs;
  RxString Id = ''.obs;
  var dsaNameList = <DsaModel>[].obs;
  var dsaBankList = <DsaBank>[].obs;
  var producttypeList = <productData>[].obs;
  var sourcingList = <SourceModel>[].obs;
  var bankerNameList = <BankerNameData>[].obs;
  var telecallerlist = <TellecallerData>[].obs;
  var statuslist = <statusData>[].obs;
  var date = ''.obs;
  var contactNumber = ''.obs;
  var customerName = ''.obs;
  var income = ''.obs;
  var companyName = ''.obs;
  var caseType = ['BT & Topup', 'Fresh', 'OD'].obs;
  RxString selectedCaseType = ''.obs; // the selected value
  var loanAmount = ''.obs;
  var dob = ''.obs;
  var selectedproductType = ''.obs;
  var selectedBankName = ''.obs;
  var selectedBankerName = ''.obs;
  var selectTelecallerName = ''.obs;
  var selectedStatus = ''.obs;
  var selectedSource = ''.obs;

//  var loginBank = ''.obs;
  var bankName = ''.obs;
//  var bankerName = ''.obs;
  var bankerMobile = ''.obs;
  var bankerEmail = ''.obs;
  var losNo = ''.obs;
  var telecaller = ''.obs;
  var teamleader = ''.obs;
  var status = ''.obs;
  var source = ''.obs;
  var caseStudy = ''.obs;
  var comments = ''.obs;

  var isEdit = false.obs;
  var isNew = false.obs;

  // Default telecaller ID
  final String defaultTelecallerId = StaticStoredData.userId;
  //  "${StaticStoredData.userId}";

  @override
  void onInit() {
    super.onInit();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    try {
      await Future.wait([
        fetchDataEntryList(),
        getDsaNameList(),
        getProductTypeList(),
        getTelecallerData(),
        getStatusData(),
      ]);
      isLoading(false);
    } catch (e) {
      logOutput("Error loading data: $e");
    }
  }

  Future<void> fetchDataEntryList() async {
    try {
      DateTime? first;
      DateTime? second;

      if (dateRangeList.isNotEmpty) {
        first = dateRangeList.first;
        second = dateRangeList.last;
      }
      DateTime now = DateTime.now();
      DateTime startDate = DateTime(now.year, now.month, 1);

      String dateRange =
          '${DateFormat('dd-MM-yyyy').format(startDate)},${DateFormat('dd-MM-yyyy').format(now)}';
      String selectedDateRange =
          ' ${DateFormat('dd-MM-yyyy').format(first ?? startDate)},${DateFormat('dd-MM-yyyy').format(second ?? now)}';
      logOutput('date range is $dateRange and $defaultTelecallerId');
      if (dateRangeList.isNotEmpty) {
        logOutput('date range is$selectedDateRange');
      }
      // Create form data with required telecaller_id
      final Map<String, dynamic> formData = {
        'telecaller_id': defaultTelecallerId,
        'daterange': dateRange.isEmpty ? dateRange : selectedDateRange,
      };

      // Using POST request instead of GET since it requires form-data
      final response = await _apiService.postRequest(
        APIUrls.dataEntryFeild,
        formData,
      );
      logOutput("${response.statusCode}");
      logOutput(response.body);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final dataEntryModel = DataEntryModel.fromJson(responseData);
        if (dataEntryModel.data != null) {
          dataList.assignAll(dataEntryModel.data!);
        }
      } else if (response.statusCode == 204) {
        Get.snackbar(
          'Opps',
          'No Data Available',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        throw Exception('Failed to load data entries');
      }
    } catch (e) {
      errorMessage.value = 'Error fetching data: ${e.toString()}';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {}
  }

  // Refresh data
  Future<void> refreshData() async {
    dataList.clear();
    await fetchDataEntryList();
  }

  // Search functionality
  void searchData(String query) {
    if (query.isEmpty) {
      fetchDataEntryList();
      return;
    }

    final filteredList = dataList
        .where((data) =>
            (data.customerName?.toLowerCase().contains(query.toLowerCase()) ??
                false) ||
            (data.mobileNo?.contains(query) ?? false) ||
            (data.bankName?.toLowerCase().contains(query.toLowerCase()) ??
                false))
        .toList();

    dataList.assignAll(filteredList);
  }

  // Save login request
  Future<void> saveDataEntryForm() async {
    try {
      // Prepare the fields map
      var fields = {
        'dsaName': dsaId.value,
        'date': date.value,
        'mobile_no': contactNumber.value,
        "customer_name": customerName.value,
        'customer_id': customerName.value,
        'income': income.value,
        'company_name': companyName.value,
        'caseType': selectedCaseType.value,
        'loanAmount': loanAmount.value,
        'loginBank': bankName.value,
        'bankerName': selectedBankerName.value,
        'bankerMobile': bankerMobile.value,
        'bankerEmail': bankerEmail.value,
        'caseStudy': caseStudy.value,
        'product_type': selectedproductType.value,
        'sourcing': selectedSource.value,
        'dob': dob.value,
        'losNo': losNo.value,
        'telecallerid': tellecallerId.value,
        'teamLeader': teamleader.value,
        'status': selectedStatus.value,
        'id': Id.value,
      };

      logOutput('Request fields: $fields');

      // Make the API request
      final response =
          await ApiService().postRequest(APIUrls.dataentrySave, fields);

      if (response.statusCode == 200) {
        // getLoginRequestList();
        // currentId.value = '';

        // loginRequestDate = DateTime.now().obs;
        // telecallerId = StaticStoredData.userId.obs;
        // customerName.value = '';
        // contactNumber.value = '';
        // loanStatus.value = '1'; // Default loan status
        // bankId.value = '';
        // loanAmount.value = '';
        // commonRemark.value = '';
        // remarksList.value = []; // To hold multiple remarks
        // id = ''.obs;
        // sourceId.value = '';
        Get.back();
        Get.snackbar('Success', 'Data Entry saved successfully!');
      } else {
        Get.snackbar('Error', 'Failed to save login request.');
      }
    } catch (e) {
      logOutput("An error occurred while saving the login request: $e");
    } finally {
      // Stop loading
    }
  }

  Future<void> getDsaNameList() async {
    try {
      var response = await ApiService().getRequest(APIUrls.dsaNameList);

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body)['data'];
        final List<DsaModel> sourceList =
            responseData.map((e) => DsaModel.fromJson(e)).toList();
        if (sourceList.isNotEmpty) {
          dsaNameList.assignAll(sourceList);
        }
      }
    } catch (e) {
      logOutput('An error occurred while fetching source list: $e');
      // Ensure loading is set to false on error as well
    }
  }

  Future<void> getProductTypeList() async {
    try {
      var response = await ApiService().getRequest(APIUrls.productTypeList);

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body)['data'];
        final List<productData> productlist =
            responseData.map((e) => productData.fromJson(e)).toList();
        if (productlist.isNotEmpty) {
          producttypeList.assignAll(productlist);
        }
      }
    } catch (e) {
      logOutput('An error occurred while fetching source list: $e');
      // Ensure loading is set to false on error as well
    }
  }

  Future<void> getDsaBankList(String dsaId) async {
    try {
      var body = {
        "dsa_id": dsaId
      }; // You can define your request body as needed
      var response = await ApiService().postRequest(APIUrls.dsaBanklist, body);

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body)['data'];
        final List<DsaBank> sourceList =
            responseData.map((e) => DsaBank.fromJson(e)).toList();
        if (sourceList.isNotEmpty) {
          dsaBankList.assignAll(sourceList);
        }
      }
    } catch (e) {
      logOutput('An error occurred while fetching source list: $e');
      // Ensure loading is set to false on error as well
    }
  }

  Future<void> getSourcingList() async {
    try {
      var body = {
        "telecaller_id": tellecallerId.value
      }; // You can define your request body as needed
      var response = await ApiService().postRequest(APIUrls.sourcingList, body);

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body)['data'];
        final List<SourceModel> sourceList =
            responseData.map((e) => SourceModel.fromJson(e)).toList();
        if (sourceList.isNotEmpty) {
          sourcingList.assignAll(sourceList);
        }
      }
    } catch (e) {
      logOutput('An error occurred while fetching source list: $e');
      // Ensure loading is set to false on error as well
    }
  }

  Future<void> getBankerName(String id) async {
    try {
      var body = {
        "id": id,
        //     "bankName": bankName,
      };
      var response =
          await ApiService().postRequest(APIUrls.bankerNamelist, body);

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body)['data'];
        final List<BankerNameData> bankername =
            responseData.map((e) => BankerNameData.fromJson(e)).toList();
        if (bankername.isNotEmpty) {
          bankerNameList.assignAll(bankername);
        }
      }
    } catch (e) {
      logOutput('An error occurred while fetching source list: $e');
      // Ensure loading is set to false on error as well
    }
  }

  Future<void> getTelecallerData() async {
    try {
      var response = await ApiService().getRequest(APIUrls.telecallerlist);

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body)['data'];
        final List<TellecallerData> tellecallerData =
            responseData.map((e) => TellecallerData.fromJson(e)).toList();
        if (tellecallerData.isNotEmpty) {
          telecallerlist.assignAll(tellecallerData);
        }
      }
    } catch (e) {
      logOutput('An error occurred while fetching source list: $e');
    }
  }

  Future<void> getStatusData() async {
    try {
      Map<String, dynamic> data = {};
      var response = await ApiService().postRequest(APIUrls.statuslist, data);

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body)['data'];
        final List<statusData> data =
            responseData.map((e) => statusData.fromJson(e)).toList();
        if (data.isNotEmpty) {
          statuslist.assignAll(data);
        }
      }
    } catch (e) {
      logOutput('An error occurred while fetching source list: $e');
    }
  }

  Future<void> fetchDataEntryListSpecificId() async {
    try {
      Map<String, dynamic> body = {"telecaller_id": tellecallerId.value};
      var response =
          await ApiService().postRequest(APIUrls.dataEntryFeild, body);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final dataEntryModel = DataEntryModel.fromJson(responseData);
        if (dataEntryModel.data != null) {
          final entry = dataEntryModel.data!.firstWhere(
            (entry) => entry.id == dataId.toString(),
          );

          // Assigning values to observables
          Id.value = entry.id.toString();
          dsaName.value = entry.dsaName.toString();
          contactNumber.value = entry.mobileNo.toString();
          customerName.value = entry.customerName ?? '';
          income.value = entry.income ?? '';
          companyName.value = entry.companyName ?? '';
          selectedCaseType.value = entry.caseType.toString();
          loanAmount.value = entry.loanAmount.toString();
          date.value = entry.date.toString();
          dob.value = entry.dob.toString();
          selectedproductType.value = entry.productType ?? '';
          selectedBankName.value = entry.loginBank ?? '';
          selectedBankerName.value = entry.bankerName ?? '';
          selectedStatus.value = entry.status ?? '';
          selectedSource.value = entry.sourcing ?? '';

          //      loginBank.value = entry.loginBank ?? '';
          bankName.value = entry.bankName ?? '';
          //   bankerName.value = entry.bankerName ?? '';
          bankerMobile.value = entry.bankerMobile ?? '';
          bankerEmail.value = entry.bankerEmail ?? '';
          losNo.value = entry.losNo ?? '';
          selectTelecallerName.value = entry.teleCallerId ?? '';
          //    telecaller.value = entry.teleCallerName ?? '';
          teamleader.value = entry.tlName ?? '';
          //     status.value = entry.status ?? '';
          //    source.value = entry.sourcing ?? '';
          caseStudy.value = entry.caseStudy ?? '';
          comments.value = entry.comments ?? '';
        }
      }
    } catch (e) {
      logOutput('An error occurred while fetching source list: $e');
    }
  }

  Future<void> getMobileByCustomerData(String number) async {
    try {
      var body = {"mobile": number};
      var response =
          await ApiService().postRequest(APIUrls.mobileByCustomeData, body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData =
            json.decode(response.body)['data'];
        CustomerData data = CustomerData.fromJson(responseData);

        income.value = data.netIncome.toString();
        companyName.value = data.companyName.toString();
        customerName.value = data.name.toString();
      }
    } catch (e) {
      logOutput('An error occurred while fetching source list: $e');
    }
  }

  Future<void> getTeamLeadById(String id) async {
    try {
      var body = {"telecaller_id": id};
      var response =
          await ApiService().postRequest(APIUrls.teamLeadByTeamId, body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // final List<dynamic> dataList = responseData['data'];

        // final Map<String, dynamic> firstItem = dataList[0];

        teamleader.value = responseData['data']['name'];
        date.value = DateFormat('dd-MM-yy HH:mm:ss').format(DateTime.now());
      }
    } catch (e) {
      logOutput('An error occurred while fetching source list: $e');
    }
  }
}
