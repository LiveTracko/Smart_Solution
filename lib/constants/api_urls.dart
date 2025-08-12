class APIUrls {
  static const String baseUrl = 'https://smartdial.co.in/api/index.php/';
  // static const String baseUrl = 'https://smartsolutionsmumbai.com/mis/api/index.php/';
  static const String loginUrl = 'Auth/login_user';
  static const String apiKey = 'ftc_apikey@';
  static const String loginApiKey = 'Surplus_apikey@';
  static const String todaysDashboard = 'Auth/getdashboarddata';
  static const String followListData = 'Auth/followupsave';
  static const String remarkStatusCode = 'Auth/getremarkstatus';
  static const String followUpSubmitedData = 'Auth/getfollowuplist';
  static const String callBackdData = 'Auth/getfollowuplistbyfilter';
  static const String dataEntryFeild = 'Auth/getdataentry';
  static const String fetchNumber = 'Auth/mobile_fetch';
  static const String allBankNames = 'Auth/getBanksGroupbyName';
  static const String allLoginRequestBankNames = 'Auth/getBanksName';
  static const String loginRequestList = 'Auth/login_requestlist';
  static const String loginRequestSave = 'Auth/login_request_save';
  static const String getLoanStatus = 'Auth/getloanstatus';
  static const String getRemarkList = 'Auth/login_remarklist';
  static const String newBaseUrl = 'https://smartdial.co.in/';
  static const String logoutCheck = 'Auth/useractivecheck';
  static const String filteronMonthURL =
      'https://smartdial.co.in/misadmin/api/index.php/Auth/getfollowuplist';
  static const String changePassword = "Auth/change_password";
  static const String activity = "Auth/useractivecheck";
  static const String sourcingList = "Auth/getdatasourcingapi";
  static const String getUserGroup = 'Auth/getstatusgroup';
  static const String getTimeGraphData = 'Auth/getdashboarddata';
  static const String getnotificationData = 'Auth/notificationlist';
  static const String updatenotificationData = 'Auth/notificationupdate';
  static const String pinCodelist = 'Auth/getpincodelist';
  static const String companylist = 'Auth/getcompanylist';

  // adda dataentry

  static const String dsaNameList = "Auth/getdsalist";
  static const String productTypeList = "Auth/getproductlist";
  static const String dsaBanklist = "Auth/getloginbankbydsa";
  static const String bankerNamelist = "Auth/getBankerDetailsbyid";
  static const String telecallerlist = 'Auth/gettelecallerdata';
  static const String statuslist = 'Auth/getleaddatastatus';
  static const String dataentrySave = 'Auth/savedataentry';
  static const String mobileByCustomeData = 'Auth/getmobilebycustomerdata';
  static const String teamLeadByTeamId = 'Auth/gettelecallerbyteamid';
}
