import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:goods_transport/Constant/colors_constant.dart';
import 'package:goods_transport/Constant/dialoag_widget.dart';
import 'package:goods_transport/Screens/BottomNavigationScreen/CompleteYourProfile/VehicleOwnerCompleteProfileOne.dart';
import 'package:goods_transport/Screens/BottomNavigationScreen/ProfileScreen/update_profile.dart';
import 'package:goods_transport/Screens/BottomNavigationScreen/RequestVerificationScreen/request_verification_screen.dart';
import 'package:goods_transport/Screens/BottomNavigationScreen/VerifiedAccountScreen/verified_account_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Models/broker_verification_model.dart';
import '../../../Models/service_class.dart';
import '../../LoginScreen/login_screen.dart';
import 'package:http/http.dart' as http;

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String? token;
  String? id;
  String address = '';

  Future retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      id = prefs.getString('id');
    });
    print('sadasd $id');
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
        // address = jsonBody['data']['address'];

        return User.fromJson(userJson);
      } else {
        throw Exception(jsonBody['message']);
      }
    } else {
      throw Exception(
          'Failed to connect to the API. Error code: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveToken().then((value) {
      fetchCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: primayColorBlue,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
        ),
        backgroundColor: primayColorBlue,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'Douro',
            fontSize: 32,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        actions: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 10.0,
                ),
                child: InkWell(
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString('token', '');
                    // prefs.setString('id', '');

                    CustomDialogs.showSnakcbar(context, 'Successfully Logout');

                    Get.offAll(LoginScreen());
                  },
                  child: Center(
                    child: Container(
                      height: 35,
                      width: 85,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(30)),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.logout,
                              size: 12,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Logout',
                              style: GoogleFonts.lato(
                                  fontSize: 11, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              FutureBuilder<User>(
                  future: fetchCurrentUser(),
                  builder: (context, AsyncSnapshot sp) {
                    if (!sp.hasData) {
                      return Container();
                    }

                    var currentUser = sp.data;

                    return Padding(
                      padding: const EdgeInsets.only(
                        right: 10.0,
                      ),
                      child: InkWell(
                        onTap: () {
                          Get.to(() => UpdaateProfile(
                                name: '${currentUser.name}',
                                img: '${currentUser.imageUrl}',
                              ));
                        },
                        child: Center(
                          child: Container(
                            height: 35,
                            width: 85,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30)),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.edit,
                                    size: 12,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Profile Edit',
                                    style: GoogleFonts.lato(
                                        fontSize: 11, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
              SizedBox(
                width: 15,
              )
            ],
          ),
        ],
      ),
      body: FutureBuilder<User>(
          future: fetchCurrentUser(),
          builder: (context, AsyncSnapshot sp) {
            if (!sp.hasData) {
              return Center(
                  child: CircularProgressIndicator(
                color: primayColor,
              ));
            }

            var currentUser = sp.data;

            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 80,
                  ),
                  Stack(
                    children: [
                      Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: primayColorBlue,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(40),
                            bottomRight: Radius.circular(40),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Center(
                          child: Container(
                            height: 160,
                            child: Stack(
                              children: [
                                Container(
                                  height: 155,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: primayColor, width: 2),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Container(
                                      height: 125,
                                      width: 125,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            '${currentUser.imageUrl}',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                currentUser.isVerified == 1
                                    ? Positioned(
                                        top: 115,
                                        left: 100,
                                        child: Container(
                                          height: 32,
                                          width: 32,
                                          decoration: BoxDecoration(
                                              color: primayColor,
                                              shape: BoxShape.circle),
                                          child: Icon(
                                            Icons.verified,
                                            color: Colors.white,
                                            size: 22,
                                          ),
                                        ),
                                      )
                                    : Positioned(
                                        top: 115,
                                        left: 100,
                                        child: Container(),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  //user name
                  currentUser.isVerified == "1"
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${currentUser.name}',
                              style: GoogleFonts.lato(
                                  fontSize: 24,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                            Icon(
                              Icons.verified,
                              color: primayColor,
                              size: 17,
                            ),
                          ],
                        )
                      : Text(
                          '${currentUser.name}',
                          style: GoogleFonts.lato(
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),

                  SizedBox(
                    height: 5,
                  ),

                  Text(
                    '(${currentUser.personStatus})',
                    style: GoogleFonts.lato(
                        fontSize: 11,
                        color: Colors.black54,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 5,
                  ),

                  // Text(
                  //  'Kalma garden',
                  //   style: GoogleFonts.lato(
                  //       fontSize: 15,
                  //       color: Colors.black,
                  //       fontWeight: FontWeight.w400),
                  // ),
                  SizedBox(
                    height: 20,
                  ),
                  currentUser.isVerified == "2" || currentUser.isVerified == "1"
                      ? InkWell(
                    onTap: () {
                      Get.to(()=>VerifiedAccountScreen());
                    },
                        child: Container(
                            height: 46,
                            width: 240,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12,
                                      spreadRadius: 1,
                                      blurRadius: 4)
                                ]),
                            child: Center(
                              child: Text(
                                'Verified Accounts',
                                style: GoogleFonts.lato(
                                    fontSize: 14, color: Colors.black),
                              ),
                            ),
                          ),
                      )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        RequestVerificationScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                height: 46,
                                width: 130,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black12,
                                          spreadRadius: 1,
                                          blurRadius: 4)
                                    ]),
                                child: Center(
                                  child: Text(
                                    'Request Verification',
                                    style: GoogleFonts.lato(
                                        fontSize: 12, color: Colors.black),
                                    textScaleFactor: 1,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(()=>VerifiedAccountScreen());

                              },
                              child: Container(
                                height: 46,
                                width: 130,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black12,
                                          spreadRadius: 1,
                                          blurRadius: 4)
                                    ]),
                                child: Center(
                                  child: Text(
                                    'Verified Accounts',
                                    style: GoogleFonts.lato(
                                        fontSize: 12, color: Colors.black),
                                    textScaleFactor: 1,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  textWidget(
                    text: 'Phone Number',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  containerWidget(
                    txt: '${currentUser.phoneNo}',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  textWidget(
                    text: 'Password',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  containerWidget(
                    txt: '*********',
                  ),

                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class textWidget extends StatelessWidget {
  String? text;

  textWidget({
    this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 22.0),
          child: Text(
            text.toString(),
            style: GoogleFonts.lato(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }
}

class containerWidget extends StatelessWidget {
  String? txt;

  containerWidget({
    this.txt,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(left: 22.0, right: 22),
      child: Container(
        height: 50,
        width: width / 1,
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.grey.withOpacity(0.6), width: 1)),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 25,
              ),
              Text(
                txt.toString(),
                style: GoogleFonts.lato(fontSize: 14, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
