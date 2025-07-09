import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ToastType {
  success,
  warning,
  info,
  error,
}

class Toast {
  static final FToast _fToast = FToast();

  static show(String msg, BuildContext context, {
    int duration = 2,
    ToastGravity gravity = ToastGravity.TOP,
    ToastType type = ToastType.error,
  }) {
    // initToast();
    _fToast.removeCustomToast();
    _fToast.init(context);
    _fToast.showToast(
      child: getToastWidget(msg, type),
      gravity: gravity,
      toastDuration: Duration(seconds: duration),
    );
  }

  static Widget getToastWidget(String msg, ToastType type) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: getTypeColor(type),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          /*Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),*/
          Text(
            msg,
            softWrap: true,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  static Color getTypeColor(ToastType type) {
    switch(type) {
      case ToastType.success:
        return const Color(0xFF67C23A);
      case ToastType.warning:
        return const Color(0xFFE6A23C);
      case ToastType.info:
        return const Color(0xFF909399);
      case ToastType.error:
        return const Color(0xFFF56C6C);
        // return ThemeColors.main;
    }
  }
}