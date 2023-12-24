import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goods_transport/Models/service_class.dart';
import 'package:goods_transport/Screens/BottomNavigationScreen/custom_bottom_bar.dart';
import 'package:goods_transport/Screens/BottomNavigationScreen/viechleOwner_side_custom_navigationbar.dart';
import 'package:goods_transport/Screens/LoginScreen/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Screens/BottomNavigationScreen/user_side_custom_navigationbar.dart';

class Splash_Controller extends GetxController {
  RxString token = "".obs;
  RxString status = "".obs;
  Future<void> retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("token") == null && prefs.getString("status") == null) {
      token.value = "";
      status.value = "";
    } else {
      token.value = prefs.getString('token')!;
      // status.value = prefs.getString('status')!;
    }
    print('My fetch token is $token');
  }

  fetchCurrentUser(String id) async {
    await UserService().getApi("api/getProfile?id="+id.toString(), token.value).then((value) {
      print(value);
      if (value["status"] == "success") {
        if (value["user"]["status"] == 0 && token.value != '') {

          if (value["user"]["personStatus"] == 'Broker') {
            Get.offAll(() => Custom_BottomBar(selectedIndex: 0));

          } else if (value["user"]["personStatus"] == 'Vehicle Owner') {
            Get.offAll(() => ViechleOwnerSideCustom_BottomBar(selectedIndex: 0));

          } else {
            Get.offAll(() => UserSideCustom_BottomBar(selectedIndex: 0));

          }
        } else if (value["user"]["status"] == 1 ) { // Check for user status here
          Get.offAll(() => LoginScreen());
          Get.snackbar(
            "Blocked by Admin",
            "You are blocked by the admin.",
            icon: Icon(Icons.block),
            duration: Duration(seconds: 3),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.grey.withOpacity(0.5),
          );
        } else {
          // Handle other cases if needed
        }
      } else {
        throw Exception('Failed to connect to the API. Error code: ');
      }
    }).catchError((error) {
      // Handle the error from fetchCurrentUser() here

      Get.offAll(() => LoginScreen());
      // CustomDialogs.showSnackbar(context, 'You are blocked by Admin');
    });
  }
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
}
