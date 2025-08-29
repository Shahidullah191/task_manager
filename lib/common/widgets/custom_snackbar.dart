import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:task_manager/utils/dimensions.dart';

  void showCustomSnackBar(String? message, {bool isError = true}) {
  if(message != null && message.isNotEmpty) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: isError ? Colors.red : Colors.green,
      textColor: Colors.white,
      fontSize: Dimensions.fontSizeFourteen,
    );
  }
}