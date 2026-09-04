import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../common/app_colors.dart';

void showToast({bool isError = false, required String message}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: isError ? AppColors.red : AppColors.bgAsphaltLight,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}