import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goods_transport/Constant/colors_constant.dart';
import 'package:goods_transport/Screens/BottomNavigationScreen/custom_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/service_class.dart';
import '../../Screens/BottomNavigationScreen/user_side_custom_navigationbar.dart';
import '../../Screens/BottomNavigationScreen/viechleOwner_side_custom_navigationbar.dart';

class login_Controller extends GetxController {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  var logInformKey = GlobalKey<FormState>().obs;

  var isLoading = false.obs;
 Future loginUser(var userEmail, var userPass) async {
    try {
      isLoading(true);
      print("User phone: $userEmail, User Password: $userPass");

      Map data = {
        "phoneNo": userEmail.toString(),
        "password": userPass.toString(),
      };
      await UserService().postApi("api/login", data).then((value) async {
        print("API Response: $value");

        // print(value);
        if (value['status'] == 200) {
           if(value['user']['status'] == 1) {
             String token = value['token'];
             String id = value['user']['id'].toString();
             String name = value['user']['name'].toString();
             String type = value['user']['personStatus'].toString();
             String phone = value['user']['phoneNo'].toString();

             // Store the token in SharedPreferences
             SharedPreferences prefs = await SharedPreferences.getInstance();
             prefs.setString('token', token);
             prefs.setString('id', id);
             prefs.setString('name', name);
             prefs.setString('personStatus', type);
             prefs.setString('phoneNo', phone);

             print(' My data is , $token');
             print(' My iddddd is , $id');
             print(' My personStatus is , $type');
             print(' My phone is , $phone');


             email.clear();
             pass.clear();

             if(value['user']['personStatus'] == 'Broker') {
               Get.offAll(Custom_BottomBar(selectedIndex: 0,));
             }
             else if(value['user']['personStatus'] == 'Vehicle Owner') {
               Get.offAll(()=>ViechleOwnerSideCustom_BottomBar(selectedIndex: 0));

             }
             else  {
               Get.offAll(()=>UserSideCustom_BottomBar(selectedIndex: 0));
             }


             Get.snackbar(
               value["message"].toString(),
               'User Login SuccessFully',
               icon: Icon(Icons.thumb_up),
               duration: Duration(seconds: 2),
               snackPosition:
               SnackPosition.BOTTOM, // Optional: Position of the snackbar
               backgroundColor: primayColorBlue
                   .withOpacity(
                   0.5), // Optional: Background color of the snackbar
               // colorText: Colors.white, // Optional: Text color of the snackbar
             );
           }
           else if (value['user']['status'] == 0) {
             // User is blocked by admin
             email.clear();
             pass.clear();
             Get.snackbar(
               "Blocked by Admin",
               "You are blocked by the admin.",
               icon: Icon(Icons.block),
               duration: Duration(seconds: 2),
               snackPosition: SnackPosition.BOTTOM,
               backgroundColor: primayColorBlue
                   .withOpacity(
                   0.5),             );
           }
           else {
             email.clear();
             pass.clear();
             Get.snackbar(
               value["status"].toString(),
               value["message"].toString(),
               icon: Icon(Icons.thumb_down),
               duration: Duration(seconds: 2),
               snackPosition:
               SnackPosition.BOTTOM, // Optional: Position of the snackbar
               backgroundColor: Colors.grey.withOpacity(
                   0.5), // Optional: Background color of the snackbar
               // colorText: Colors.white, // Optional: Text color of the snackbar
             );
           }
        }
        else {
          email.clear();
          pass.clear();
          Get.snackbar(
           'Error',
            'Login Error',
            icon: Icon(Icons.thumb_down),
            duration: Duration(seconds: 3),
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
