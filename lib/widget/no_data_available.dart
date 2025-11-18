import 'package:flutter/material.dart';
import 'package:smart_solutions/views/login_request_form.dart';

class NoDataAvailable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.inbox, size: 100, color: AppColors.primaryColor),
            SizedBox(height: 20),
            Text(
              'No content available',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
