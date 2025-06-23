import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ContentType { success, failure, warning }

void showCustomToast({
  required BuildContext context,
  required String message,
  required ContentType contentType,
}) {
  Color bgColor;
  IconData icon;

  switch (contentType) {
    case ContentType.success:
      bgColor = Colors.green;
      icon = Icons.check_circle;
      break;
    case ContentType.failure:
      bgColor = Colors.red;
      icon = Icons.error;
      break;
    case ContentType.warning:
      bgColor = Colors.orange;
      icon = Icons.warning;
      break;
  }

  final fToast = FToast();
  fToast.init(context);

  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    margin: const EdgeInsets.symmetric(horizontal: 24),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: bgColor,
      boxShadow: [
        const BoxShadow(
          color: Colors.black26,
          blurRadius: 6,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 12,
      children: [
        Icon(icon, color: Colors.white, size: 24),
        Text(
          message,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ],
    ),
  );

  fToast.showToast(
    child: toast,
    gravity: ToastGravity.BOTTOM,
    toastDuration: const Duration(seconds: 2),
  );
}
