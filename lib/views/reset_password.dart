import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/controllers/reset_password_controller.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final ResetPasswordController controller = Get.put(ResetPasswordController());

  String _userName = "";
  bool isobsucred = true;
  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? "User";
    });
  }

  // void _changePassword() async {
  //   String newPassword = _newPasswordController.text.trim();

  //   if (newPassword.isEmpty) {
  //     Get.snackbar("Error", "fields are required");
  //     return;
  //   }

  //   //api response

  //   final response = await ApiService().postRequest(
  //     APIUrls.changePassword,
  //     {"telecaller_id": StaticStoredData.userId, "newpassword": newPassword},
  //   );
  //   var responsedata = jsonDecode(response.body);
  //   if (response.statusCode == 200) {
  //     Get.snackbar("Success", "${jsonDecode(response.body)['message']}");
  //     _newPasswordController.clear();

  //     return;
  //   } else {
  //     // Implement password change logic (API call or local validation)
  //     Get.snackbar("Error", "Failed to change password");
  //     _newPasswordController.clear();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Change Password")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blue,
              child: Text(
                _userName.isNotEmpty ? _userName[0].toUpperCase() : "U",
                style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Hii👋  ${_userName.toUpperCase()}',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            const SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.number,
              maxLength: 6,
              controller: controller.passwordController,
              style: TextStyle(
                color: Colors.black,
              ),
              obscureText: isobsucred,
              decoration: InputDecoration(
                labelText: "Enter New Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(
                      () {
                        isobsucred = !isobsucred;
                      },
                    );
                  },
                  icon: isobsucred
                      ? Icon(Icons.visibility_off)
                      : Icon(Icons.visibility),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Obx(() => controller.isLoading.value
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () => controller.resetPassword(),
                    child: Text(
                      "Submit",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}
