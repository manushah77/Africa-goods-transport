
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goods_transport/Screens/ForgetScreen/forgetPassword_otp.dart';
import 'package:goods_transport/Screens/ForgetScreen/reset_password_screen.dart';
import 'package:goods_transport/Screens/LoginScreen/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/service_class.dart';
import '../colors_constant.dart';

class authentication_Controller extends GetxController {
  // TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController phoneC = TextEditingController();

  var signUpInformKey = GlobalKey<FormState>().obs;
  var passwordReset = GlobalKey<FormState>().obs;
  var isLoading = false.obs;


  ressetPass(var userPhone, String userId) async {
    try {
      isLoading(true);
      Map data = {"phoneNo": userPhone.toString()};
      await UserService().postApi("api/forgot", data).then((value) {
        // print(value);
        if (value['status'] == "success") {
          phoneC.clear();
          Get.offAll(() => ResetPasswordScreen(id: userId,));
          // Get.to(() => ForgetPasswordOtpScreen(id: userId,));

          Get.snackbar(
            "Success",
            value["message"].toString(),
            icon: Icon(Icons.thumb_up),
            duration: Duration(seconds: 5),
            snackPosition:
                SnackPosition.BOTTOM, // Optional: Position of the snackbar
            backgroundColor: primayColorBlue
                .withOpacity(0.5), // Optional: Background color of the snackbar
            // colorText: Colors.white, // Optional: Text color of the snackbar
          );
        } else {
          phoneC.clear();
          pass.clear();
          Get.snackbar(
            value["status"].toString(),
            value["Password reset successfully"].toString(),
            // value["message"].toString(),
            icon: Icon(Icons.thumb_down),
            duration: Duration(seconds: 5),
            snackPosition:
                SnackPosition.BOTTOM, // Optional: Position of the snackbar
            backgroundColor: primayColorBlue
                .withOpacity(0.5), // Optional: Background color of the snackbar
            // colorText: Colors.white, // Optional: Text color of the snackbar
          );
        }
      });
    } finally {
      isLoading(false);
    }
  }


}
