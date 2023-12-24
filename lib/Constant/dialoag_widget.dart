import 'package:flutter/material.dart';
import 'package:goods_transport/Constant/colors_constant.dart';

class CustomDialogs {
  static void showSnakcbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: primayColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
      ),
      content: Text(
        msg,
        style: TextStyle(color: Colors.white, fontSize: 19),
      ),
      duration: Duration(seconds: 2),
    ));
  }
}