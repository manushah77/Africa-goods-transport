import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String apiUrl = "https://agt.jeuxtesting.com/";

  Future<Map<String, dynamic>> postApiwithToken(String path, Map<String, dynamic> data, String authToken) async {
    try {
      final response = await http.post(Uri.parse(apiUrl + path),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $authToken',
          });

      return jsonDecode(response.body);
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Future postApi(String path, Map data) async {
    try {
      final response = await http.post(Uri.parse(apiUrl + path),
          body: jsonEncode(data),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          });

      return jsonDecode(response.body);
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  // Other methods...

  Future getApi(String path, String authToken) async {
    try {
      final response = await http.get(Uri.parse(apiUrl + path),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $authToken',
          });

      return jsonDecode(response.body);
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  // Other methods...

  Future<Map<String, dynamic>> getApiWithToken(String path, Map<String, dynamic> data) async {
    var token = "";
    await getUser().then((value) {
      print(value);
      token = value["token"];
      print(token);
    });

    try {
      final response = await http.post(Uri.parse(apiUrl + path),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          });

      return jsonDecode(response.body);
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  // Other methods...

  Future getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var d = prefs.getString('id');
    if (d != null) {
      return jsonDecode(d);
    } else {
      return {};
    }
  }

  Future<bool> setUser(user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('notification', jsonEncode(user));
    await prefs.setBool('loggedIn', true);
    return true;
  }
}
