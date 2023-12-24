import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/service_class.dart';

class VehicleOwnerReuestScreen_Controller extends GetxController {
  var data = [].obs;
  var searchData = [].obs;
  var isLoading = false.obs;
  RxString token = "".obs;
  RxString id = "".obs;

  Map <String,dynamic> dataa = {
    "limit": 50,
    "offset": 0,
  };

  getVehicleOwnerReuestData() async {
    try {
      isLoading(true);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getString("token") == null && prefs.getString("id") == null) {
        token.value = "";
        id.value = "";
      } else {
        token.value = prefs.getString('token')!;
        id.value = prefs.getString('id')!;
      }
      await UserService()
          .postApiwithToken("api/getVehicleRequests", dataa,token.value)
          .then((value) {
        // print(value);
        if (value["status"] == "success") {
          data.value = value["data"];
          searchData.value = value["data"];

          // print(data);
        } else {
          data.length = 0;
        }
      });
    } finally {
      isLoading(false);
    }
  }
}
