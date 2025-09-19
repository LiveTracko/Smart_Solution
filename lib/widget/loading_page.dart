import 'package:flutter/material.dart';
import 'package:smart_solutions/theme/app_theme.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
        child: SizedBox(
      height: 40, // set height
      width: 40, // set width
      child: CircularProgressIndicator(
        strokeWidth: 5, // thickness of the circle
        color: AppColors.primaryColor,
      ),
    ));
  }
}
