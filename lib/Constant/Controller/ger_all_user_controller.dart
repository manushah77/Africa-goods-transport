import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/service_class.dart';

class GetAllUser_Controller extends GetxController {
  var data = [].obs;
  var searchData = [].obs;
  var isLoading = false.obs;
  RxString token = "".obs;
  RxString id = "".obs;
  getAllVerifiedUser() async {
    try {
      isLoading(true);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // setState(() {
      if (prefs.getString("token") == null && prefs.getString("id") == null) {
        token.value = "";
        id.value = "";
      } else {
        token.value = prefs.getString('token')!;
        id.value = prefs.getString('id')!;
      }
      await UserService()
          .getApi("api/getUsers", token.value)
          .then((value) {
        print(value);
        if (value["status"] == "success") {
          data.value = value["data"];
          searchData.value = value["data"];

        } else {
          data.value.length = 0;
        }
      });
    } finally {
      isLoading(false);
    }
  }
}
