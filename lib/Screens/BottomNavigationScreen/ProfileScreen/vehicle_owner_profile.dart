import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:goods_transport/Constant/colors_constant.dart';
import 'package:goods_transport/Models/get_vechileOwner_profile_Data.dart';
import 'package:goods_transport/Screens/BottomNavigationScreen/CompleteYourProfile/VehicleOwnerCompleteProfileOne.dart';
import 'package:goods_transport/Screens/BottomNavigationScreen/ProfileScreen/update_profile.dart';
import 'package:goods_transport/Screens/BottomNavigationScreen/RequestVerificationScreen/request_verification_screen.dart';
import 'package:goods_transport/Screens/BottomNavigationScreen/VerifiedAccountScreen/verified_account_screen.dart';
import 'package:goods_transport/Screens/LoginScreen/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Constant/Controller/show_all_vehicle_controller.dart';
import '../../../Constant/dialoag_widget.dart';
import '../../../Models/broker_verification_model.dart';
import '../../../Widegts/custom_text_field.dart';
import 'package:http/http.dart' as http;

import '../viechleOwner_side_custom_navigationbar.dart';

class VehicleOwnerProfile extends StatefulWidget {
  const VehicleOwnerProfile({super.key});

  @override
  State<VehicleOwnerProfile> createState() => _VehicleOwnerProfileState();
}

class _VehicleOwnerProfileState extends State<VehicleOwnerProfile> {
  TextEditingController locationC = TextEditingController();
  TextEditingController phoneNumberC = TextEditingController();
  TextEditingController addNoteC = TextEditingController();
  String dropdownValueTwo = 'Mazda Truck';
  String? token;
  String? id;

  String? type;
  String? name;
  bool isLoading = false;

  Future retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      type = prefs.getString('personStatus');
      name = prefs.getString('name');
      id = prefs.getString('id');
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

        return User.fromJson(userJson);
      } else {
        throw Exception(jsonBody['message']);
      }
    } else {
      throw Exception(
          'Failed to connect to the API. Error code: ${response.statusCode}');
    }
  }



  var controller = Get.put(ShowAllVehicle_Controller());

  TextEditingController vehicleRegisterationC = TextEditingController();
  TextEditingController vehicleModelC = TextEditingController();
  TextEditingController searchData = TextEditingController();
  String dropdownValue = 'Mazda Truck';
  String dropdownValueThree = 'Flat Bed';



  Future<void> _showAddVehicleDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            var width = MediaQuery.of(context).size.width;

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Container(
                    height: 470,
                    width: 300,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Vehicle Detail\'s',
                            style: TextStyle(
                              fontFamily: 'Douro',
                              fontSize: 26,
                              fontWeight: FontWeight.w500,
                              color: primayColor,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                'Vehicle Name',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: width / 1,
                            height: 50,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                isExpanded: true,
                                hint: Row(
                                  children: const [
                                    SizedBox(
                                      width: 4,
                                    ),
                                  ],
                                ),
                                items: <String>[
                                  'Mazda Truck',
                                  '6 Wheeler',
                                  '10 Wheeler',
                                  '14 Wheeler',
                                  '18 Wheeler',
                                  '22 Wheeler',
                                ]
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ))
                                    .toList(),
                                value: dropdownValue,
                                onChanged: (value) {
                                  setState(() {
                                    dropdownValue = value as String;
                                  });
                                },
                                buttonStyleData: ButtonStyleData(
                                  height: 50,
                                  width: 160,
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
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                'Type Of Vehicles',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: width / 1,
                            height: 50,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                isExpanded: true,
                                hint: Row(
                                  children: const [
                                    SizedBox(
                                      width: 4,
                                    ),
                                  ],
                                ),
                                items: <String>[
                                  'Flat Bed',
                                  'Half Body',
                                  'Full Body',
                                  'Damper',
                                  'Container',
                                ]
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ))
                                    .toList(),
                                value: dropdownValueThree,
                                onChanged: (value) {
                                  setState(() {
                                    dropdownValueThree = value as String;
                                  });
                                },
                                buttonStyleData: ButtonStyleData(
                                  height: 50,
                                  width: 160,
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
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                'Vehicle Registration Numbers',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            width: 300,
                            height: 60,
                            child: CustomTextField(
                              hintText: '3233757-4',
                              controller: vehicleRegisterationC,
                              validate: true,
                              errorHint: 'Enter Regieteration Number',
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                'Vehicle Model Year',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            width: 300,
                            height: 60,
                            child: CustomTextField(
                              hintText: '2014',
                              controller: vehicleModelC,
                              validate: true,
                              errorHint: 'Enter Model',
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 47,
                                  width: 120,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Center(
                                    child: Text(
                                      'Cancel',
                                      style: GoogleFonts.lato(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              isLoading == true
                                  ? CircularProgressIndicator(
                                      color: primayColor,
                                    )
                                  : InkWell(
                                      onTap: () async {

                                        if(_formKey.currentState!.validate()) {
                                          setState(() {
                                            isLoading =
                                            true; // Show the progress bar
                                          });
                                          try {
                                            await postVehicleData().then((value) {
                                              Get.offAll(() =>
                                                  ViechleOwnerSideCustom_BottomBar(
                                                      selectedIndex: 0));
                                            });
                                          } finally {
                                            setState(() {
                                              isLoading =
                                              false; // Show the progress bar
                                            });
                                          }
                                        }

                                      },
                                      child: Container(
                                        height: 47,
                                        width: 120,
                                        decoration: BoxDecoration(
                                            color: primayColor,
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: Center(
                                          child: Text(
                                            'Apply',
                                            style: GoogleFonts.lato(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  //update vehicle dialog

  Future<void> _updateAddVehicleDialog(
    String vehicleRegNo,
    String vehicleModelNo,
    String vehicleName,
    String vehicleType,
    String vehicleID,
  ) async {
    TextEditingController updateVehicleRegisterationC =
        TextEditingController(text: vehicleRegNo);
    TextEditingController updatevehicleModelC =
        TextEditingController(text: vehicleModelNo);
    String vehiclename = vehicleName.toString();
    String vehicletype = vehicleType.toString();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            var width = MediaQuery.of(context).size.width;

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: SingleChildScrollView(
                child: Container(
                  height: 470,
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Vehicle Detail\'s',
                          style: TextStyle(
                            fontFamily: 'Douro',
                            fontSize: 26,
                            fontWeight: FontWeight.w500,
                            color: primayColor,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              'Vehicle Name',
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: width / 1,
                          height: 50,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              isExpanded: true,
                              hint: Row(
                                children: const [
                                  SizedBox(
                                    width: 4,
                                  ),
                                ],
                              ),
                              items: <String>[
                                'Mazda Truck',
                                '6 Wheeler',
                                '10 Wheeler',
                                '14 Wheeler',
                                '18 Wheeler',
                                '22 Wheeler',
                              ]
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ))
                                  .toList(),
                              value: vehiclename,
                              onChanged: (value) {
                                setState(() {
                                  vehiclename = value as String;
                                });
                              },
                              buttonStyleData: ButtonStyleData(
                                height: 50,
                                width: 160,
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
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              'Type Of Vehicles',
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: width / 1,
                          height: 50,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              isExpanded: true,
                              hint: Row(
                                children: const [
                                  SizedBox(
                                    width: 4,
                                  ),
                                ],
                              ),
                              items: <String>[
                                'Flat Bed',
                                'Half Body',
                                'Full Body',
                                'Damper',
                                'Container',
                              ]
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ))
                                  .toList(),
                              value: vehicletype,
                              onChanged: (value) {
                                setState(() {
                                  vehicletype = value as String;
                                });
                              },
                              buttonStyleData: ButtonStyleData(
                                height: 50,
                                width: 160,
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
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              'Vehicle Registration Numbers',
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: 300,
                          height: 60,
                          child: CustomTextField(
                            hintText: '3233757-4',
                            controller: updateVehicleRegisterationC,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              'Vehicle Model Year',
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: 300,
                          height: 60,
                          child: CustomTextField(
                            hintText: '2014',
                            controller: updatevehicleModelC,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 47,
                                width: 120,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(30)),
                                child: Center(
                                  child: Text(
                                    'Cancel',
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            isLoading == true
                                ? CircularProgressIndicator(
                                    color: primayColor,
                                  )
                                : InkWell(
                                    onTap: () async {
                                      setState(() {
                                        isLoading =
                                            true; // Show the progress bar
                                      });
                                      try {
                                        await updateVehicleData(
                                          updateVehicleRegisterationC.text
                                              .toString(),
                                          updatevehicleModelC.text.toString(),
                                          vehiclename,
                                          vehicletype,
                                          vehicleID,
                                        ).then((value) {
                                          Get.offAll(() =>
                                              ViechleOwnerSideCustom_BottomBar(
                                                  selectedIndex: 0));
                                        });
                                      } finally {
                                        setState(() {
                                          isLoading =
                                              false; // Show the progress bar
                                        });
                                      }
                                    },
                                    child: Container(
                                      height: 47,
                                      width: 120,
                                      decoration: BoxDecoration(
                                          color: primayColor,
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Center(
                                        child: Text(
                                          'Apply',
                                          style: GoogleFonts.lato(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }






  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveToken().then((value) {
      fetchCurrentUser();
      getAllData();
      print(id);

    });

    setState(() {
      controller.getAllvehicle();
    });
  }


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
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
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          FutureBuilder<User>(
              future: fetchCurrentUser(),
              builder: (context, AsyncSnapshot sp) {
                if (!sp.hasData) {
                  return Container();
                }

                var currentUser = sp.data;

                return Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 10.0,
                      ),
                      child: InkWell(
                        onTap: () {
                          currentUser.isRequested == "\"0\"" ||
                                  currentUser.isRequested == "0"
                              ? _showHelpDialog()
                              : _deleteHelpRequest(
                                  int.parse(id.toString()),
                                );
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
                                    Icons.info,
                                    size: 16,
                                    color: Colors.red,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Help',
                                    style: GoogleFonts.lato(
                                      fontSize: 13,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
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
                    ),
                  ],
                );
              }),
          SizedBox(
            width: 10,
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
                        height: 120,
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
                            height: 145,
                            width: 145,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: primayColor, width: 2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
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
                        ),
                      ),
                    ],
                  ),
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
                  Padding(
                    padding: const EdgeInsets.only(left: 22.0),
                    child: Row(
                      children: [
                        Text(
                          'Details',
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  currentUser.isVerified == "1" || currentUser.isVerified == "2"
                      ? Padding(
                          padding: const EdgeInsets.only(left: 22.0, right: 22),
                          child: Container(
                            width: width / 1,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12,
                                    spreadRadius: 0,
                                    blurRadius: 4)
                              ],
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                   mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        _showMyPersonalDialog(
                                          currentUser.id,
                                          currentUser.name,
                                          currentUser.otp,
                                          currentUser.phoneNo,
                                        );
                                        print(currentUser.id);
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 92,
                                        decoration: BoxDecoration(
                                          color: primayColor,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Personal',
                                            style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        _showMyVehicleDialog();
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 92,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Vehicle\'s',
                                            style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    FutureBuilder<Data>(
                                        future: getAllData(),
                                        builder: (context, AsyncSnapshot sp) {
                                          if (!sp.hasData) {
                                            return Center(
                                              child: CircularProgressIndicator(
                                                color: primayColorBlue,
                                              ),
                                            );
                                          }

                                          var availablData = sp.data;

                                          return InkWell(
                                            onTap: () {
                                              _showMyCompanyDialog(
                                                availablData.id,
                                                availablData.address,
                                                availablData.companyName,
                                                availablData.phoneOpt == null ||
                                                        availablData.phoneOpt ==
                                                            ''
                                                    ? availablData.managerNo1
                                                    : availablData.phoneOpt,
                                                availablData.companyType,
                                              );
                                            },
                                            child: Container(
                                              height: 40,
                                              width: 92,
                                              decoration: BoxDecoration(
                                                color: primayColorBlue,
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Company',
                                                  style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '--------------------------------------',
                                    style: TextStyle(
                                        letterSpacing: 2,
                                        fontSize: 20,
                                        color: Colors.black26),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 18.0, right: 18),
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(() => VerifiedAccountScreen());
                                    },
                                    child: Container(
                                      height: 46,
                                      width: width / 1,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(30),
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
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(left: 22.0, right: 22),
                          child: Container(
                            width: width / 1,
                            height: 250,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12,
                                    spreadRadius: 0,
                                    blurRadius: 4)
                              ],
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        _showMyPersonalDialog(
                                          currentUser.id,
                                          currentUser.name,
                                          currentUser.otp,
                                          currentUser.phoneNo,
                                        );
                                        print(currentUser.id);
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 92,
                                        decoration: BoxDecoration(
                                          color: primayColor,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Personal',
                                            style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        _showMyVehicleDialog();
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 92,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Vehicle\'s',
                                            style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    FutureBuilder<Data>(
                                        future: getAllData(),
                                        builder: (context, AsyncSnapshot sp) {
                                          if (!sp.hasData) {
                                            return Center(
                                              child: CircularProgressIndicator(
                                                color: primayColorBlue,
                                              ),
                                            );
                                          }

                                          var availablData = sp.data;

                                          return InkWell(
                                            onTap: () {
                                              _showMyCompanyDialog(
                                                availablData.id,
                                                availablData.address,
                                                availablData.companyName,
                                                availablData.phoneOpt == null ||
                                                        availablData.phoneOpt ==
                                                            ''
                                                    ? availablData.managerNo1
                                                    : availablData.phoneOpt,
                                                availablData.companyType,
                                              );
                                            },
                                            child: Container(
                                              height: 40,
                                              width: 92,
                                              decoration: BoxDecoration(
                                                color: primayColorBlue,
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Company',
                                                  style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '--------------------------------------',
                                    style: TextStyle(
                                        letterSpacing: 2,
                                        fontSize: 20,
                                        color: Colors.black26),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 18.0, right: 18),
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(() => RequestVerificationScreen());
                                    },
                                    child: Container(
                                      height: 46,
                                      width: width / 1,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(30),
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
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 18.0, right: 18),
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(() => VerifiedAccountScreen());
                                    },
                                    child: Container(
                                      height: 46,
                                      width: width / 1,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(30),
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
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  SizedBox(
                    height: 30,
                  ),


                  InkWell(
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString('token', '');
                      // prefs.setString('id', '');

                      CustomDialogs.showSnakcbar(
                          context, 'Successfully Logout');

                      Get.offAll(LoginScreen());
                    },
                    child: Center(
                      child: Container(
                        height: 50,
                        width: 193,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(30)),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.logout,
                                size: 17,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Logout',
                                style: GoogleFonts.lato(
                                    fontSize: 14, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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


  //delete help request dialog


  void _deleteHelpRequest(int id) {
    print(id);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Previous Help Request ?',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
          content: Text(
            'Are you sure you want to delete Help Request?',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: primayColorBlue,
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                _confirmHelpDialog(id).then((value) {
                  Get.offAll(
                          () => ViechleOwnerSideCustom_BottomBar(selectedIndex: 0));
                });
                Navigator.pop(context);
              },
              child: Text(
                'Delete',
                style: TextStyle(
                  color: primayColor,
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future _confirmHelpDialog(int id) async {
    retrieveToken().then((value) async {
      var url = "https://agt.jeuxtesting.com/api/delHelpRequest";

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'userId': id}), // Include the id in the request body
      );

      if (response.statusCode == 200) {
        CustomDialogs.showSnakcbar(context, 'Request Deleted Successfully');
      } else {
        CustomDialogs.showSnakcbar(context, 'Deleted Unsuccessfully');
        print(response.body);
      }
    });
  }


  //show personal dialog

  Future<void> _showMyPersonalDialog(
    int id,
    String fullName,
    String ntn,
    String phomeNumber,
  ) async {
    TextEditingController FullName = TextEditingController(text: fullName);
    TextEditingController PhoneNumber =
        TextEditingController(text: phomeNumber);
    TextEditingController Password = TextEditingController();

    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        var width = MediaQuery.of(context).size.width;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: SingleChildScrollView(
            child: Container(
              height: 300,
              width: 300,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          'Personal Detail\'s',
                          style: TextStyle(
                            fontFamily: 'Douro',
                            fontSize: 26,
                            fontWeight: FontWeight.w500,
                            color: primayColor,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.4),
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.edit,
                              size: 15,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    textWidget(
                      text: 'Full Name',
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: width / 1,
                      height: 60,
                      child: TextFormField(
                        cursorColor: Colors.black,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                        onChanged: (newValue) {
                          // Update the textFieldValue whenever the text field is edited
                          setState(() {
                            fullName = newValue;
                          });
                        },
                        readOnly: true,
                        controller: FullName,

                        // ignore: body_might_complete_normally_nullable
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter product';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(top: 2, left: 15, right: 15),

                          border: InputBorder.none,

                          hintText: 'product',
                          hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                          // filled: true,
                          // fillColor: Colors.grey.withOpacity(0.2),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.4), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.4), width: 1),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    textWidget(
                      text: 'Phone Number',
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: width / 1,
                      height: 60,
                      child: TextFormField(
                        readOnly: true,
                        cursorColor: Colors.black,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                        onChanged: (newValue) {
                          // Update the textFieldValue whenever the text field is edited
                          setState(() {
                            phomeNumber = newValue;
                          });
                        },
                        controller: PhoneNumber,

                        // ignore: body_might_complete_normally_nullable
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter product';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(top: 2, left: 15, right: 15),

                          border: InputBorder.none,

                          hintText: 'phone',
                          hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                          // filled: true,
                          // fillColor: Colors.grey.withOpacity(0.2),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.4), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.4), width: 1),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    // textWidget(
                    //   text: 'Password',
                    // ),
                    // SizedBox(
                    //   height: 5,
                    // ),
                    // SizedBox(
                    //   width: width / 1,
                    //   height: 60,
                    //   child: TextFormField(
                    //     readOnly: true,
                    //     cursorColor: Colors.black,
                    //     style: TextStyle(
                    //       color: Colors.black,
                    //       fontSize: 14,
                    //       fontFamily: 'Inter',
                    //       fontWeight: FontWeight.w400,
                    //     ),
                    //     onChanged: (newValue) {
                    //       // Update the textFieldValue whenever the text field is edited
                    //       setState(() {
                    //         phomeNumber = newValue;
                    //       });
                    //     },
                    //     controller: Password,
                    //
                    //     // ignore: body_might_complete_normally_nullable
                    //     validator: (value) {
                    //       if (value!.isEmpty) {
                    //         return 'Please Enter product';
                    //       }
                    //       return null;
                    //     },
                    //     decoration: InputDecoration(
                    //       contentPadding:
                    //           EdgeInsets.only(top: 2, left: 15, right: 15),
                    //
                    //       border: InputBorder.none,
                    //
                    //       hintText: '********',
                    //       hintStyle: TextStyle(
                    //         color: Colors.black.withOpacity(0.5),
                    //         fontSize: 14,
                    //         fontFamily: 'Inter',
                    //         fontWeight: FontWeight.w400,
                    //       ),
                    //       // filled: true,
                    //       // fillColor: Colors.grey.withOpacity(0.2),
                    //       enabledBorder: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(30),
                    //         borderSide: BorderSide(
                    //             color: Colors.grey.withOpacity(0.4), width: 1),
                    //       ),
                    //       focusedBorder: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(30),
                    //         borderSide: BorderSide(
                    //             color: Colors.grey.withOpacity(0.4), width: 1),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 47,
                            width: 120,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(30)),
                            child: Center(
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        // InkWell(
                        //   onTap: () {
                        //     updataPersonalData(id, adress, fullName, ntn,
                        //             phomeNumber, compnayType)
                        //         .then((value) {
                        //       Navigator.pop(context);
                        //     });
                        //   },
                        //   child: Container(
                        //     height: 47,
                        //     width: 120,
                        //     decoration: BoxDecoration(
                        //         color: primayColor,
                        //         borderRadius: BorderRadius.circular(30)),
                        //     child: Center(
                        //       child: Text(
                        //         'Okay',
                        //         style: GoogleFonts.lato(
                        //           fontSize: 16,
                        //           color: Colors.white,
                        //           fontWeight: FontWeight.w500,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  //show company dialog

  Future<void> _showMyCompanyDialog(
    int id,
    String adress,
    String fullName,
    String phomeNumber,
    String type,
  ) async {
    TextEditingController FullName = TextEditingController(text: fullName);
    TextEditingController PhoneNumber =
        TextEditingController(text: phomeNumber);
    TextEditingController Adress = TextEditingController(text: adress);
    TextEditingController TypeController = TextEditingController(text: type);

    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        var width = MediaQuery.of(context).size.width;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: SingleChildScrollView(
            child: Container(
              height: 500,
              width: 300,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          'Company Detail\'s',
                          style: TextStyle(
                            fontFamily: 'Douro',
                            fontSize: 26,
                            fontWeight: FontWeight.w500,
                            color: primayColor,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.4),
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.edit,
                              size: 15,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    textWidget(
                      text: 'Company Name',
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: width / 1,
                      height: 60,
                      child: TextFormField(
                        cursorColor: Colors.black,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                        onChanged: (newValue) {
                          // Update the textFieldValue whenever the text field is edited
                          setState(() {
                            fullName = newValue;
                          });
                        },
                        controller: FullName,

                        // ignore: body_might_complete_normally_nullable
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter product';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(top: 2, left: 15, right: 15),

                          border: InputBorder.none,

                          hintText: 'Name',
                          hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                          // filled: true,
                          // fillColor: Colors.grey.withOpacity(0.2),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.4), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide:
                                BorderSide(color: Colors.black54, width: 1),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    textWidget(
                      text: 'Company Type',
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: width / 1,
                      height: 60,
                      child: TextFormField(
                        cursorColor: Colors.black,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                        onChanged: (newValue) {
                          // Update the textFieldValue whenever the text field is edited
                          setState(() {
                            type = newValue;
                          });
                        },
                        controller: TypeController,

                        // ignore: body_might_complete_normally_nullable
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter type';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(top: 2, left: 15, right: 15),

                          border: InputBorder.none,

                          hintText: 'Type',
                          hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                          // filled: true,
                          // fillColor: Colors.grey.withOpacity(0.2),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.4), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide:
                                BorderSide(color: Colors.black54, width: 1),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    textWidget(
                      text: 'Phone Number',
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: width / 1,
                      height: 60,
                      child: TextFormField(
                        cursorColor: Colors.black,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                        onChanged: (newValue) {
                          // Update the textFieldValue whenever the text field is edited
                          setState(() {
                            phomeNumber = newValue;
                          });
                        },
                        controller: PhoneNumber,

                        // ignore: body_might_complete_normally_nullable
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter phone';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(top: 2, left: 15, right: 15),

                          border: InputBorder.none,

                          hintText: 'Phone',
                          hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                          // filled: true,
                          // fillColor: Colors.grey.withOpacity(0.2),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.4), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide:
                                BorderSide(color: Colors.black54, width: 1),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    textWidget(
                      text: 'Address',
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: width / 1,
                      height: 60,
                      child: TextFormField(
                        cursorColor: Colors.black,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                        onChanged: (newValue) {
                          // Update the textFieldValue whenever the text field is edited
                          setState(() {
                            adress = newValue;
                          });
                        },
                        controller: Adress,

                        // ignore: body_might_complete_normally_nullable
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter phone';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(top: 2, left: 15, right: 15),

                          border: InputBorder.none,

                          hintText: 'Phone',
                          hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                          // filled: true,
                          // fillColor: Colors.grey.withOpacity(0.2),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.4), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide:
                                BorderSide(color: Colors.black54, width: 1),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 47,
                            width: 120,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(30)),
                            child: Center(
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        isLoading == true
                            ? CircularProgressIndicator(
                                color: primayColor,
                              )
                            : InkWell(
                                onTap: () async {
                                  setState(() {
                                    isLoading = true; // Show the progress bar
                                  });

                                  try {
                                    await updataCompanyData(
                                      id,
                                      Adress.text.toString(),
                                      FullName.text.toString(),
                                      PhoneNumber.text.toString(),
                                      TypeController.text.toString(),
                                    ).then((value) {
                                      Navigator.pop(context);
                                    });
                                  } finally {
                                    setState(() {
                                      isLoading =
                                          false; // Show the progress bar
                                    });
                                  }
                                },
                                child: Container(
                                  height: 47,
                                  width: 120,
                                  decoration: BoxDecoration(
                                      color: primayColor,
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Center(
                                    child: Text(
                                      'Okay',
                                      style: GoogleFonts.lato(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  //show vehicle dialog

  Future<void> _showMyVehicleDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        var width = MediaQuery.of(context).size.width;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            height: 530,
            width: width / 1.15,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 4)
              ],
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Vehicle\'s Details',
                        style: TextStyle(
                          fontFamily: 'Douro',
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: primayColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      InkWell(
                        onTap: () {
                          _showAddVehicleDialog();
                        },
                        child: Center(
                          child: Container(
                            height: 30,
                            width: 80,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12,
                                      spreadRadius: 1,
                                      blurRadius: 4)
                                ],
                                borderRadius: BorderRadius.circular(30)),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 15,
                                    width: 15,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 10,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Add Vehicle',
                                    style: GoogleFonts.lato(
                                        fontSize: 10, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),

                // 1st contianer
                Obx(
                  () => controller.isLoading.value == true
                      ? Center(
                          child: Center(
                            child: CircularProgressIndicator(
                              color: primayColor,
                            ),
                          ),
                        )
                      : Container(
                          height: 450,
                          child: ListView.builder(
                            itemCount: controller.data.length,
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10, bottom: 5),
                                child: controller.data[index]['userId'] == id
                                    ? Container(
                                        height: 220,
                                        width: width / 1.45,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0, right: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Vehichle Name',
                                                    style: GoogleFonts.lato(
                                                        fontSize: 14,
                                                        color: Colors.black),
                                                  ),
                                                  Text(
                                                    controller.data[index]
                                                        ['vehicle'],
                                                    style: GoogleFonts.lato(
                                                        fontSize: 14,
                                                        color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              height: 1,
                                              width: 250,
                                              color:
                                                  Colors.grey.withOpacity(0.3),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0, right: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Types of Vehichle',
                                                    style: GoogleFonts.lato(
                                                        fontSize: 14,
                                                        color: Colors.black),
                                                  ),
                                                  Text(
                                                    controller.data[index]
                                                        ['type'],
                                                    style: GoogleFonts.lato(
                                                        fontSize: 14,
                                                        color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              height: 1,
                                              width: 250,
                                              color:
                                                  Colors.grey.withOpacity(0.3),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0, right: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Registration Number',
                                                    style: GoogleFonts.lato(
                                                        fontSize: 14,
                                                        color: Colors.black),
                                                  ),
                                                  Text(
                                                    controller.data[index]
                                                        ['regNo'],
                                                    style: GoogleFonts.lato(
                                                        fontSize: 14,
                                                        color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              height: 1,
                                              width: 250,
                                              color:
                                                  Colors.grey.withOpacity(0.3),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0, right: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Vehichle Model Year',
                                                    style: GoogleFonts.lato(
                                                        fontSize: 14,
                                                        color: Colors.black),
                                                  ),
                                                  Text(
                                                    controller.data[index]
                                                        ['model_year'],
                                                    style: GoogleFonts.lato(
                                                        fontSize: 14,
                                                        color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              height: 1,
                                              width: 250,
                                              color:
                                                  Colors.grey.withOpacity(0.3),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                //edit
                                                InkWell(
                                                  onTap: () {
                                                    _updateAddVehicleDialog(
                                                      controller.data[index]
                                                          ['regNo'],
                                                      controller.data[index]
                                                          ['model_year'],
                                                      controller.data[index]
                                                          ['vehicle'],
                                                      controller.data[index]
                                                          ['type'],
                                                      '${controller.data[index]['id']}',
                                                    );
                                                  },
                                                  child: Center(
                                                    child: Container(
                                                      height: 40,
                                                      width: 108,
                                                      decoration: BoxDecoration(
                                                          color: Colors.grey
                                                              .withOpacity(0.7),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30)),
                                                      child: Center(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Image.asset(
                                                              'assets/icons/edit.png',
                                                              scale: 4,
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(
                                                              'Edit',
                                                              style: GoogleFonts
                                                                  .lato(
                                                                      fontSize:
                                                                          10,
                                                                      color: Colors
                                                                          .black),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                //delete

                                                InkWell(
                                                  onTap: () {
                                                    _deleteRequest(controller
                                                        .data
                                                        .value[index]['id']);
                                                  },
                                                  child: Center(
                                                    child: Container(
                                                      height: 40,
                                                      width: 108,
                                                      decoration: BoxDecoration(
                                                          color:
                                                              primayColorBlue,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30)),
                                                      child: Center(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Image.asset(
                                                              'assets/icons/del.png',
                                                              scale: 4,
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(
                                                              'Delete',
                                                              style: GoogleFonts
                                                                  .lato(
                                                                      fontSize:
                                                                          10,
                                                                      color: Colors
                                                                          .black),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //delete
  void _deleteRequest(int id) {
    print(id);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Request',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this Vehicle?',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: primayColorBlue,
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                _confirmDialog(id).then((value) {
                  Get.offAll(
                      () => ViechleOwnerSideCustom_BottomBar(selectedIndex: 0));
                });
                Navigator.pop(context);
              },
              child: Text(
                'Delete',
                style: TextStyle(
                  color: primayColor,
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future _confirmDialog(int id) async {
    retrieveToken().then((value) async {
      var url = "https://agt.jeuxtesting.com/api/delVehicle";

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'id': id}), // Include the id in the request body
      );

      if (response.statusCode == 200) {
        CustomDialogs.showSnakcbar(context, 'Request Deleted Successfully');
      } else {
        CustomDialogs.showSnakcbar(context, 'Deleted Unsuccessfully');
        print(response.body);
      }
    });
  }
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //help dialog

  Future<void> _showHelpDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            var width = MediaQuery.of(context).size.width;

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Container(
                    height: 520,
                    width: 300,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Help Request',
                            style: TextStyle(
                              fontFamily: 'Douro',
                              fontSize: 26,
                              fontWeight: FontWeight.w500,
                              color: primayColor,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          textWidget(
                            text: 'Vehicle Type',
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: width / 1,
                            height: 50,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                isExpanded: true,
                                hint: Row(
                                  children: const [
                                    SizedBox(
                                      width: 4,
                                    ),
                                  ],
                                ),
                                items: <String>[
                                  'Mazda Truck',
                                  '6 Wheeler',
                                  '10 Wheeler',
                                  '14 Wheeler',
                                  '18 Wheeler',
                                  '22 Wheeler',
                                ]
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ))
                                    .toList(),
                                value: dropdownValueTwo,
                                onChanged: (value) {
                                  setState(() {
                                    dropdownValueTwo = value as String;
                                  });
                                },
                                buttonStyleData: ButtonStyleData(
                                  height: 50,
                                  width: 160,
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
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          textWidget(
                            text: 'Location',
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            width: width / 1,
                            height: 60,
                            child: CustomTextField(
                              hintText: 'Sahiwal',
                              controller: locationC,
                              validate: true,
                              errorHint: 'Enter Location',
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          textWidget(
                            text: 'Phone Number',
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            width: width / 1,
                            height: 60,
                            child: CustomTextField(
                              hintText: '(031)606-7678',
                              keyboradType: TextInputType.phone,
                              validate: true,
                              errorHint: 'Enter Number',
                              suffixIcon: Icon(
                                Icons.verified,
                                color: primayColor,
                                size: 16,
                              ),
                              controller: phoneNumberC,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          textWidget(
                            text: 'Notes',
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            width: width / 1,
                            height: 100,
                            child: TextFormField(
                              cursorColor: primayColor,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                              controller: addNoteC,

                              // ignore: body_might_complete_normally_nullable
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Enter Notes';
                                }
                                return null;
                              },
                              maxLines: 10,

                              decoration: InputDecoration(
                                suffixIconColor: Colors.black12,
                                contentPadding: EdgeInsets.only(
                                    top: 10, left: 15, right: 13, bottom: 10),
                                border: InputBorder.none,

                                hintText: 'Enter Your notes Detail',
                                hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                ),
                                // filled: true,
                                // fillColor: Colors.grey.withOpacity(0.2),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      color: Colors.grey.withOpacity(0.4),
                                      width: 1),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Colors.black54, width: 1),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 47,
                                  width: 120,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Center(
                                    child: Text(
                                      'Cancel',
                                      style: GoogleFonts.lato(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              isLoading == true
                                  ? CircularProgressIndicator(
                                color: primayColor,
                              )
                                  : InkWell(
                                onTap: () async {
                                  if(_formKey.currentState!.validate()) {
                                    setState(() {
                                      isLoading =
                                      true; // Show the progress bar
                                    });
                                    try {
                                      await postHelpRequestData().then((value) {
                                        Get.offAll(() =>
                                            ViechleOwnerSideCustom_BottomBar(
                                                selectedIndex: 0));
                                      });
                                    } finally {
                                      setState(() {
                                        isLoading =
                                        false; // Show the progress bar
                                      });
                                    }
                                  }

                                },
                                child: Container(
                                  height: 47,
                                  width: 120,
                                  decoration: BoxDecoration(
                                      color: primayColor,
                                      borderRadius:
                                      BorderRadius.circular(30)),
                                  child: Center(
                                    child: Text(
                                      'Apply',
                                      style: GoogleFonts.lato(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                    )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  //add help functtion

  //add request function

  Future<void> postHelpRequestData() async {
    final String apiUrl = "https://agt.jeuxtesting.com/api/addHelpRequest";

    setState(() {
      isLoading = true;
    });

    // Replace this map with your actual data
    Map<String, dynamic> data = {
      "userId": id.toString(),
      "type": type.toString(),
      "location": locationC.text.toString(),
      "phone": phoneNumberC.text.toString(),
      "vehicle": dropdownValueTwo.toString(),
      "phoneOptional": 03001231231,
      "notes": addNoteC.text.toString(),

      // Add other fields as needed
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          // "Accept": "application/json",
          "Authorization": "Bearer $token",
          "Content-Type": "application/json", // Add Content-Type header
        },
        body: jsonEncode(data),
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        print("POST request successful!");
        CustomDialogs.showSnakcbar(context, 'Data Added Successfully');
        print("Response: ${response.body}");
      } else {
        CustomDialogs.showSnakcbar(context, 'Failed to add data');
        throw Exception(
            "Failed to post data. Status code: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle errors
      print("Error: $e");
      CustomDialogs.showSnakcbar(context, 'Error: $e');
    }
  }

  //get all vehicle owner data
  Future<Data> getAllData() async {
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
        final dataJsons = jsonBody['data'];
        return Data.fromJson(dataJsons);
      } else {
        throw Exception(jsonBody['message']);
      }
    } else {
      throw Exception(
          'Failed to connect to the API. Error code: ${response.statusCode}');
    }
  }

  // update personal data

  Future<void> updataPersonalData(
    int id,
    String adress,
    String name,
    String ntn,
    String phoneOpt,
    String compnayType,
  ) async {
    final String apiUrl =
        "https://agt.jeuxtesting.com/api/updateVehicleOwnerPersonal";

    setState(() {
      isLoading = true;
    });

    // Replace this map with your actual data
    Map<String, dynamic> data = {
      "id": id,
      "address": adress,
      "company_name": name,
      "ntn": ntn,
      "phoneOpt": phoneOpt,
      "company_type": compnayType,

      // Add other fields as needed
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          // "Accept": "application/json",
          "Authorization": "Bearer $token",
          "Content-Type": "application/json", // Add Content-Type header
        },
        body: jsonEncode(data),
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        // print("POST request successful!");
        print("Response: ${response.body}");
        CustomDialogs.showSnakcbar(context, 'Update data');
      } else {
        CustomDialogs.showSnakcbar(context, 'Failed to add data');
        throw Exception(
            "Failed to post data. Status code: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle errors
      print("Error: $e");
      CustomDialogs.showSnakcbar(context, 'Error: $e');
    }
  }

  // update company data

  Future<void> updataCompanyData(
    int id,
    String adress,
    String name,
    String phoneOpt,
    String compnayType,
  ) async {
    final String apiUrl =
        "https://agt.jeuxtesting.com/api/updateVehicleOwnerCompany";

    setState(() {
      isLoading = true;
    });

    // Replace this map with your actual data
    Map<String, dynamic> data = {
      "id": id,
      "address": adress,
      "company_name": name,
      "phoneOpt": phoneOpt,
      "company_type": compnayType,
      // "managerNo1": phoneOpt,

      // Add other fields as needed
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          // "Accept": "application/json",
          "Authorization": "Bearer $token",
          "Content-Type": "application/json", // Add Content-Type header
        },
        body: jsonEncode(data),
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        print("POST request successful!");
        print("Response: ${response.body}");
        CustomDialogs.showSnakcbar(context, 'Data Added Successfully');
      } else {
        CustomDialogs.showSnakcbar(context, 'Failed to add data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle errors
      print("Error: $e");
      CustomDialogs.showSnakcbar(context, 'Error: $e');
    }
  }

  //post vehicle data

  Future<void> postVehicleData() async {
    final String apiUrl = "https://agt.jeuxtesting.com/api/addVehicle";

    // Replace this map with your actual data
    Map<String, dynamic> data = {
      "vehicle": dropdownValue,
      "type": dropdownValueThree,
      "regNo": vehicleRegisterationC.text.toString(),
      "model_year": vehicleModelC.text.toString(),
      "userId": id,
      "vOwnerId": "234",
    };
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
        });
        print("POST request successful!");
        CustomDialogs.showSnakcbar(context, 'Data Added');
        print("Response: ${response.body}");
      } else {
        setState(() {
          isLoading = false;
        });

        CustomDialogs.showSnakcbar(context, 'Failed to add data');

        throw Exception("Failed to post data");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle errors
      print("Error: $e");
      CustomDialogs.showSnakcbar(context, 'Error : $e');
    }
  }

  //update vehicle data

  Future<void> updateVehicleData(
    String vehicleRegNo,
    String vehicleModelNo,
    String vehicleName,
    String vehicleType,
    String vehicleID,
  ) async {
    final String apiUrl = "https://agt.jeuxtesting.com/api/updateVehicle";

    // Replace this map with your actual data
    Map<String, dynamic> data = {
      "regNo": vehicleRegNo,
      "model_year": vehicleModelNo,
      "vehicle": vehicleName,
      "type": vehicleType,
      "id": vehicleID,
    };
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
        });
        print("POST request successful!");
        CustomDialogs.showSnakcbar(context, 'Data updated');
        print("Response: ${response.body}");
      } else {
        setState(() {
          isLoading = false;
        });

        CustomDialogs.showSnakcbar(context, 'Failed to add data');

        throw Exception("Failed to post data");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle errors
      print("Error: $e");
      CustomDialogs.showSnakcbar(context, 'Error : $e');
    }
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
          padding: const EdgeInsets.only(left: 5.0),
          child: Text(
            text.toString(),
            style: GoogleFonts.lato(
              fontSize: 14,
              fontWeight: FontWeight.w400,
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
    return Container(
      height: 50,
      width: 320,
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
    );
  }
}
