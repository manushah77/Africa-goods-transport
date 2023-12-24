import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/service_class.dart';

class ShowAllVehicle_Controller extends GetxController {
  var data = [].obs;
  var isLoading = false.obs;
  RxString token = "".obs;
  RxString id = "".obs;
  getAllvehicle() async {
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
          .getApi("api/getallvehicles", token.value)
          .then((value) {
        print(value);
        if (value["status"] == "success") {
          data.value = value["data"];
        } else {
          data.value.length = 0;
        }
      });
    } finally {
      isLoading(false);
    }
  }
}
