import 'package:flutter/material.dart';

class HeaderTitle extends StatelessWidget {
  final String title;
  final TextStyle style;

  const HeaderTitle({
    super.key,
    required this.title,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Text(title, style: style),
    );
  }
}
