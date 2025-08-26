import 'package:flutter/material.dart';
import 'package:smart_solutions/widget/common_scaffold.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: 'Report Page',
      body: const Center(
        child: Text(
          'Report Page Are in Progress',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
