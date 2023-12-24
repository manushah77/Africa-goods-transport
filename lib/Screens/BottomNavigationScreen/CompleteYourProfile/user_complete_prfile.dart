import 'dart:convert';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:goods_transport/Models/broker_verification_model.dart';
import 'package:goods_transport/Screens/BottomNavigationScreen/ProfileScreen/borker_profile.dart';
import 'package:goods_transport/Screens/BottomNavigationScreen/ProfileScreen/profile_screen.dart';
import 'package:goods_transport/Screens/BottomNavigationScreen/ProfileScreen/vehicle_owner_profile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Constant/colors_constant.dart';
import '../../../Constant/dialoag_widget.dart';
import '../../../Widegts/custom_button.dart';
import '../../../Widegts/custom_text_field.dart';
import '../custom_bottom_bar.dart';
import 'package:http/http.dart' as http;

import '../user_side_custom_navigationbar.dart';

class UserCompleteProfile extends StatefulWidget {


  @override
  State<UserCompleteProfile> createState() =>
      _UserCompleteProfileState();
}

class _UserCompleteProfileState extends State<UserCompleteProfile> {

  bool isLoading = false;

  TextEditingController addressC = TextEditingController();
  String? token;
  String? userId;

  Future<void> retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      userId = prefs.getString('id');
    });
    // print('asdadasda $token');
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveToken().then((value)  {
      print('my user id is $userId');
      print('my user Token is $token');
    });

  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery
        .of(context)
        .size
        .height;
    var width = MediaQuery
        .of(context)
        .size
        .width;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Image.asset(
                  'assets/icons/back.png',
                  scale: 4,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            'Complete\n your Profile',
            style: TextStyle(
              fontFamily: 'Douro',
              fontSize: 25,
              fontWeight: FontWeight.w500,
              color: primayColor,
            ),
            textAlign: TextAlign.center,
            textScaleFactor: 1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            SizedBox(
              height: 20,
            ),
            Container(
              height: 270,
              width: width / 1.15,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12, spreadRadius: 0, blurRadius: 4)
                ],
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'User Detail\'s',
                    style: GoogleFonts.lato(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  // owner name

                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 22.0),
                        child: Text(
                          'Address',
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0,right: 20),
                    child: SizedBox(
                      width: width/1,
                      height: 60,
                      child: CustomTextField(
                        hintText: 'kalma garden',
                        controller: addressC,
                        validate: true,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 10,
                 ),

                  FutureBuilder<List<String>>(
                    future: getAllCities(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var data = snapshot.data!;
                        return Padding(
                          padding: const EdgeInsets.only(left: 20.0,right: 20),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              isExpanded: true,
                              hint: Row(
                                children: const [
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text('Select City')
                                ],
                              ),
                              items: data.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              value: dropdownvalue ,
                              onChanged: (value) {
                                setState(() {
                                  dropdownvalue = value as String;
                                });
                              },

                              buttonStyleData: ButtonStyleData(
                                width: width/1,
                                height: 50,
                                padding:
                                const EdgeInsets.only(left: 18, right: 18),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: Colors.grey.withOpacity(0.4),
                                  ),
                                ),
                              ),
                              iconStyleData: IconStyleData(
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                ),
                                iconSize: 22,
                                iconEnabledColor: Colors.black,
                                iconDisabledColor: Colors.black,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                direction: DropdownDirection.left,
                                maxHeight: 200,
                                width: 200,
                                padding: null,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white,
                                ),
                              ),
                              menuItemStyleData: MenuItemStyleData(
                                height: 40,
                                padding: EdgeInsets.only(left: 14, right: 14),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return  CircularProgressIndicator(
                          color: primayColor,
                        );
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),


                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            isLoading == true ? CircularProgressIndicator(
              color: primayColor,
            ) :
            CustomButton(
              title: 'Submit',
              btnclr: primayColorBlue,
              txtclr: Colors.white,
              onTap: () {
                addUserData().then((value) {
                  Get.offAll(()=>UserSideCustom_BottomBar(selectedIndex: 0));
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  File? imageTwo;
  final pickerTow = ImagePicker();

  //get cities
  String? dropdownvalue;
  Future<List<String>> getAllCities() async {
    var baseUrl = "https://agt.jeuxtesting.com/api/getCities";

    http.Response response = await http.get(Uri.parse(baseUrl), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      List<String> items = [];
      var jsonData = json.decode(response.body)['data'] as List;

      for (var element in jsonData) {
        items.add(element['city']);
      }

      return items;
    } else {
      // Handle Errors
      throw response.statusCode;
    }
  }

  Future<void> addUserData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Prepare the API request
      String apiUrl = 'https://agt.jeuxtesting.com/api/registerOwner';

      // Prepare the request body
      Map<String, dynamic> requestBody = {
        'userId': userId.toString(),
        'address': addressC.text.toString(),
        'location': dropdownvalue.toString(),
      };

      // Convert the request body to JSON
      String requestBodyJson = jsonEncode(requestBody);

      // Add the bearer token to the request headers
      String bearerToken = token.toString(); // Replace with your actual bearer token
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $bearerToken',
      };

      // Send the data to the server and wait for the response
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: requestBodyJson,
      );

      // Handle the API response here
      var data = jsonDecode(response.body.toString());

      print(data);
      if (response.statusCode == 200) {
        // Successful sign-up
        setState(() {
          isLoading = false;
        });

        CustomDialogs.showSnakcbar(context, data['message']);

        print(response.body);
        print('add data successful!');
      } else {
        setState(() {
          isLoading = false;
        });

        // Handle errors here
        if (data['message'] != null) {
          print(data);
          CustomDialogs.showSnakcbar(context, data['message']);
        } else {
          print(data);

          CustomDialogs.showSnakcbar(context, 'Unknown error occurred');
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      // Handle any other errors
      print('Error: $e');
      CustomDialogs.showSnakcbar(context, 'Error is $e');
    }
  }


}
