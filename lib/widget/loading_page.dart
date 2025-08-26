import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Image.asset('assets/images/loading.gif'));
  }
}
