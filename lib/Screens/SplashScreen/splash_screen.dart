import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goods_transport/Constant/colors_constant.dart';
import 'package:goods_transport/Constant/dialoag_widget.dart';
import 'package:goods_transport/Screens/BottomNavigationScreen/custom_bottom_bar.dart';
import 'package:goods_transport/Screens/LoginScreen/login_screen.dart';
import 'package:goods_transport/Screens/SplashScreen/welcome_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/broker_verification_model.dart';
import '../BottomNavigationScreen/user_side_custom_navigationbar.dart';
import '../BottomNavigationScreen/viechleOwner_side_custom_navigationbar.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? token;
  String? id;
  String? personStatus;
  int? status;

  Future retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      id = prefs.getString('id');
      personStatus = prefs.getString('personStatus');
      print('My fetch token is $token');
      print('My fetch id is $id');
    });
  }

  Future<User> fetchCurrentUser() async {
    final response = await http.post(
        Uri.parse(
            'https://agt.jeuxtesting.com/api/getProfile?id=' + id.toString()),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + token.toString(),
        });

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);

      // print(jsonBody.toString());

      if (jsonBody['status'] == 'success') {
        final userJson = jsonBody['user'];
        status = jsonBody['user']['status'];
        // print('My fetch status is $status');

        return User.fromJson(userJson);
      } else {
        throw Exception(jsonBody['message']);
      }
    } else {
      throw Exception(
          'Failed to connect to the API. Error code: ${response.statusCode}');
    }
  }

  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  Future getConnectivity() async {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      isDeviceConnected = await InternetConnectionChecker().hasConnection;
      if (!isDeviceConnected && isAlertSet == false) {
        showDialogBox();
        setState(() => isAlertSet = true);
      }
    });
  }

  showDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('No Connection'),
          content: const Text('Please check your internet connectivity'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Cancel');
                setState(() => isAlertSet = false);
                isDeviceConnected =
                    await InternetConnectionChecker().hasConnection;
                if (!isDeviceConnected && isAlertSet == false) {
                  showDialogBox();
                  setState(() => isAlertSet = true);
                }
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );

  void handleUserNavigation(User user) {
    if (token == null || token == '') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => WelComeScreen(),
        ),
      );
    } else {
      if (status == 1) {
        if (personStatus == 'Broker') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  Custom_BottomBar(selectedIndex: 0),
            ),
          );
        } else if (personStatus == 'Vehicle Owner') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  ViechleOwnerSideCustom_BottomBar(selectedIndex: 0),
            ),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  UserSideCustom_BottomBar(selectedIndex: 0),
            ),
          );
        }
      } else {
        CustomDialogs.showSnakcbar(context, 'You are blocked by admin');
        // Don't navigate to LoginScreen here
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getConnectivity().then((_) {
      retrieveToken().then((_) {
        Timer(
          Duration(seconds: 4),
              () {
            if (isDeviceConnected) {
              // If there is an internet connection, fetch user data
              if (token != null && token != '' && id != null && id != '') {
                fetchCurrentUser().then((user) {
                  // Check user status and navigate accordingly
                  handleUserNavigation(user);
                }).catchError((error) {
                  // Handle API call errors
                  CustomDialogs.showSnakcbar(context, 'Failed to fetch user data');
                });
              } else {
                // If token or id is null or empty, show the login screen
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) => WelComeScreen(),
                  ),
                );
              }
            } else {
              // If there is no internet connection, show the connectivity dialog
              showDialogBox();
            }
          },
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/images/splash.png'),fit: BoxFit.cover)
          ),
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Center(
                child: Image.asset(
                  'assets/images/splash_logo.png',
                  scale: 1.5,
                ),
              ),
              Container(
                width: 180,
                color: Colors.black,
                height: 1,
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                'Africa Goods Transport',
                style: TextStyle(
                    fontFamily: 'Douro',
                    fontSize: 22,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                'Right Load. Right Time. Anywhere in Africa',
                style: GoogleFonts.lato(
                  fontSize: 12,
                ),
              ),
              SizedBox(
                height: 40,
              ),

            ],
          ),
        ),
      ),
    );
  }
}
