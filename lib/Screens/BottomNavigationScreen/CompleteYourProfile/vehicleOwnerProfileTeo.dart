import 'dart:convert';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:goods_transport/Screens/BottomNavigationScreen/CompleteYourProfile/vehicleOwner_complete_profile_four.dart';
import 'package:goods_transport/Screens/BottomNavigationScreen/CompleteYourProfile/vehicle_owner_profile_three.dart';
import 'package:goods_transport/Screens/BottomNavigationScreen/ProfileScreen/borker_profile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Constant/colors_constant.dart';
import '../../../Constant/dialoag_widget.dart';
import '../../../Widegts/custom_button.dart';
import '../../../Widegts/custom_text_field.dart';
import 'package:http/http.dart' as http;

class VehicleOwnerCompleteProfileTwo extends StatefulWidget {
  int? compRegNum;
  int? compPhnNum;
  String? geograpLimit;
  String? vehicleLimit;
  String? compAdress;


   VehicleOwnerCompleteProfileTwo({this.compAdress,this.compPhnNum,this.compRegNum,this.geograpLimit,this.vehicleLimit});

  @override
  State<VehicleOwnerCompleteProfileTwo> createState() =>
      _VehicleOwnerCompleteProfileTwoState();
}

class _VehicleOwnerCompleteProfileTwoState
    extends State<VehicleOwnerCompleteProfileTwo> {
  TextEditingController vehicleRegisterationC = TextEditingController();
  TextEditingController vehicleModelC = TextEditingController();
  String dropdownValue = 'Mazda Truck';
  String dropdownValueTwo = 'Flat Bed';
  bool isLoading = false;

  String? userId;
  String? token;

  Future<void> retrieveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      userId = prefs.getString('id');

      print('user id is $userId');
      print('user token is $token');

    });
    // print('asdadasda $token');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveData();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ),
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset(
            'assets/icons/back.png',
            scale: 4,
          ),
        ),
        centerTitle: true,
        title: Text(
          '',
          style: GoogleFonts.duruSans(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: primayColor,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.transparent,
        toolbarHeight: 25,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Text(
                'Let\'s Complete It!!!',
                style: TextStyle(
                  fontFamily: 'Douro',
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  color: primayColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('2 of 3'),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Container(
                height: 20,
                width: width / 1,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12, spreadRadius: 0, blurRadius: 4)
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      height: 20,
                      width: 220,
                      decoration: BoxDecoration(
                        color: primayColorBlue,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              spreadRadius: 0,
                              blurRadius: 4)
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '70%',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 20,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Container(
                height: 400,
                width: width / 1.15,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  onTap: () {
                   _showMyDialog();
                  },
                  child: imageTwo != null
                      ? Container(
                          height: 400,
                          width: width / 1,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.file(
                              imageTwo!,
                              fit: BoxFit.cover,
                              height: 400,
                              width: width / 1,
                            ),
                          ),
                        )
                      : Stack(
                          children: [
                            Container(
                              height: 400,
                              width: width / 1,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black26,
                                        spreadRadius: 0,
                                        blurRadius: 1)
                                  ]),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Add Your',
                                    style: GoogleFonts.lato(
                                        fontSize: 30, color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Vehicle\'s',
                                    style: GoogleFonts.lato(
                                        fontSize: 30, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0,left: 270),
                              child: Image.asset(
                                'assets/icons/add.png',
                                scale: 7,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            CustomButton(
              title: 'Next',
              btnclr: primayColorBlue,
              txtclr: Colors.white,
              onTap: () {
                _showMyDialog();
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

  //dialog

  Future<void> _showMyDialog() async {
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
                              value: dropdownValue,
                              onChanged: (value) {
                                setState(() {
                                  dropdownValue = value as String;
                                });
                              },
                              buttonStyleData: ButtonStyleData(
                                height: 50,
                                width: 160,
                                padding: const EdgeInsets.only(left: 18, right: 18),
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
                              value: dropdownValueTwo,
                              onChanged: (value) {
                                setState(() {
                                  dropdownValueTwo = value as String;
                                });
                              },
                              buttonStyleData: ButtonStyleData(
                                height: 50,
                                width: 160,
                                padding: const EdgeInsets.only(left: 18, right: 18),
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
                            InkWell(
                              onTap: () {
                                _vehicleOwnerData().then((value) {
                                  Get.off(()=> VehicleOwnerCompleteProfileThree());

                                });
                              },
                              child: Container(
                                height: 47,
                                width: 120,
                                decoration: BoxDecoration(
                                    color: primayColor,
                                    borderRadius: BorderRadius.circular(30)),
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


  List<Map<String, String>> vehicles = [];





  Future<void> _vehicleOwnerData() async {


    // // Other sign-up data...
    String compRegNum = widget.compRegNum.toString() ?? '';
    String compPhnNum = widget.compPhnNum.toString() ?? '';
    String geograpLimit = widget.geograpLimit.toString() ?? '';
    String vehicleLimit = widget.vehicleLimit.toString() ?? '';
    String compAdress = widget.compAdress.toString() ?? '';
    String vehicleName = dropdownValue.toString() ?? '';
    String vehicleType = dropdownValueTwo.toString() ?? '';
    String vehicleNumber = vehicleRegisterationC.text.toString() ?? '';
    String vehicleModel = vehicleModelC.text.toString() ?? '';



    // Store the token in SharedPreferences

    SharedPreferences prefs = await SharedPreferences.getInstance();

    // itemData.add(vehicleName.toString());
    // itemData.add(vehicleType.toString());
    // itemData.add(vehicleNumber.toString());
    // itemData.add(vehicleModel.toString());
    //
    // prefs.setStringList('vehicleName', itemData);

    prefs.setString('compRegNum', compRegNum);
    prefs.setString('compPhnNum', compPhnNum);
    prefs.setString('geograpLimit', geograpLimit);
    prefs.setString('vehicleLimit', vehicleLimit.toString());
    prefs.setString('compAdress', compAdress.toString());
    prefs.setString('vehicleName', vehicleName.toString());
    prefs.setString('vehicleType', vehicleType.toString());
    prefs.setString('vehicleNumber', vehicleNumber.toString());
    prefs.setString('vehicleModel', vehicleModel.toString());


    print(
      'The : $compRegNum , $compPhnNum ,$vehicleModel, $vehicleNumber  , $vehicleType',
    );


    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VehicleOwnerCompleteProfileThree(),
      ),
    );


  }




  //add vehicle data function

  // Future<void> postVehicleData() async {
  //   final String apiUrl = "https://agt.jeuxtesting.com/api/addVehicle";
  //
  //   // Replace this map with your actual data
  //   Map<String, dynamic> data = {
  //     "vehicle": dropdownValue.toString(),
  //     "type": dropdownValueTwo.toString(),
  //     "regNo": vehicleRegisterationC.text.toString(),
  //     "modelYear": vehicleModelC.text.toString(),
  //     "userId": userId.toString(),
  //     "vOwnerId": userId.toString(),
  //     // Add other fields as needed
  //   };
  //   setState(() {
  //     isLoading = true;
  //   });
  //   try {
  //     final response = await http.post(
  //       Uri.parse(apiUrl),
  //       headers: {
  //         "Accept": "application/json",
  //         "Authorization": "Bearer $token",
  //         "Content-Type": "application/json", //
  //       },
  //       body: jsonEncode(data),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       setState(() {
  //         isLoading = false;
  //       });
  //       print("POST request successful!");
  //       CustomDialogs.showSnakcbar(context, 'Data Added SuccessFully');
  //       print("Response: ${response.body}");
  //     } else {
  //       setState(() {
  //         isLoading = false;
  //       });
  //
  //       CustomDialogs.showSnakcbar(context, 'Failed to add data');
  //
  //       throw Exception("Failed to post data");
  //     }
  //   } catch (e) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     // Handle errors
  //     print("Error: $e");
  //     CustomDialogs.showSnakcbar(context, 'Error : $e');
  //
  //   }
  // }





}
