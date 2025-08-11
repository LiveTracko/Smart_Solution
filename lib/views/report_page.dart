import 'package:flutter/material.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Report Page',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: const Center(
        child: Text(
          'Report Page Are in Progress',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
