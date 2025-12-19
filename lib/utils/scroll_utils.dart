import 'package:flutter/material.dart';

class ScrollUtils {
  /// Scroll any ScrollController to the start (0 position)
  static Future<void> scrollToStart(
    ScrollController controller, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOut,
  }) async {
    if (!controller.hasClients) return;

    await controller.animateTo(
      0,
      duration: duration,
      curve: curve,
    );
  }
}
