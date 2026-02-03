import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ToastUtils {
  static bool showLoading = false;
  static void showToast(BuildContext context, String? message) {
    if (showLoading) {
      return;
    }
    showLoading = true;
    Future.delayed(Duration(seconds: 3), () {
      showLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        width: 180,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
        content: Text(message ?? "加载中...", textAlign: TextAlign.center,),
      )
    );
  }
}