import 'dart:convert';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:goods_transport/Models/addVehicleModel.dart';
import 'package:goods_transport/Screens/BottomNavigationScreen/CompleteYourProfile/vehicleOwner_complete_profile_four.dart';
import 'package:goods_transport/Screens/BottomNavigationScreen/ProfileScreen/borker_profile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Constant/colors_constant.dart';
import '../../../Widegts/custom_button.dart';
import '../../../Widegts/custom_text_field.dart';

class VehicleOwnerCompleteProfileThree extends StatefulWidget {
  int? compRegNum;
  int? compPhnNum;
  String? geograpLimit;
  String? vehicleLimit;
  String? adress;

  VehicleOwnerCompleteProfileThree(
      {this.adress,
      this.compPhnNum,
      this.compRegNum,
      this.geograpLimit,
      this.vehicleLimit});

  @override
  State<VehicleOwnerCompleteProfileThree> createState() =>
      _VehicleOwnerCompleteProfileThreeState();
}

class _VehicleOwnerCompleteProfileThreeState
    extends State<VehicleOwnerCompleteProfileThree> {
  String? compRegNum;
  String? compPhnNum;
  String? geograpLimit;
  String? vehicleLimit;
  String? compAdress;

  // String? vehicleName;
  //
  // // List<String>? vehicleName;
  // String? vehicleType;
  // String? vehicleNumber;
  // String? vehicleModel;
  bool isLoading = false;

  List<Vehicles> vehicle = List.empty(growable: true);

  late SharedPreferences sp;

  getSharedPReferences() async {
    sp = await SharedPreferences.getInstance();
    readDataSp();
  }

  saveIntoSp() {
    List<String> vehicleList =
        vehicle.map((e) => jsonEncode(e.toJson())).toList();
    sp.setStringList('myData', vehicleList);
  }

  readDataSp() {
    List<String>? vehicleList = sp.getStringList('myData');
    if (vehicleList != null) {
      vehicle =
          vehicleList.map((e) => Vehicles.fromJson(jsonDecode(e))).toList();
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSharedPReferences();
    print('asdas ${widget.adress}');
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
            Container(
              height: 500,
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
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Vehicle\'s',
                          style: GoogleFonts.lato(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        InkWell(
                          onTap: () {
                            _showMyDialog();
                          },
                          child: Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                              color: primayColor,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
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
                  vehicle.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Add vehicle',
                                style: TextStyle(fontSize: 22),
                              ),
                            ],
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: vehicle.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  height: 185,
                                  width: width / 1.25,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10),
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
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Vehichle Name',
                                              style: GoogleFonts.lato(
                                                  fontSize: 14,
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              '${vehicle[index].vehicle}',
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
                                        color: Colors.grey.withOpacity(0.3),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, right: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Type of Vehichles',
                                              style: GoogleFonts.lato(
                                                  fontSize: 14,
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              '${vehicle[index].type}',
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
                                        color: Colors.grey.withOpacity(0.3),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, right: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Registration Number',
                                              style: GoogleFonts.lato(
                                                  fontSize: 14,
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              '${vehicle[index].regNo}',
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
                                        color: Colors.grey.withOpacity(0.3),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, right: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Vehicle Model Year',
                                              style: GoogleFonts.lato(
                                                  fontSize: 14,
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              '${vehicle[index].modelYear}',
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
                                        color: Colors.grey.withOpacity(0.3),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ],
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
                _vehicleOwnerData().then((value) {
                  Get.to(() => VehicleOwnerCompleteProfileFour(
                        addres: widget.adress,
                        geograpLimit: widget.geograpLimit,
                        vehicleLimit: widget.vehicleLimit,
                        veName: vehicle[0].vehicle,
                        veModel: vehicle[0].modelYear,
                        veNumber: vehicle[0].regNo,
                        veType: vehicle[0].type,
                      ));
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

  TextEditingController vehicleRegisterationC = TextEditingController();
  TextEditingController vehicleModelC = TextEditingController();
  String dropdownValue = 'Mazda Truck';
  String dropdownValueTwo = 'Flat Bed';

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
                                if (vehicleModelC.text.isNotEmpty &&
                                    vehicleRegisterationC.text.isNotEmpty) {
                                  setState(() {
                                    vehicle.add(Vehicles(
                                      vehicle: dropdownValue,
                                      type: dropdownValueTwo,
                                      regNo:
                                          vehicleRegisterationC.text.toString(),
                                      modelYear: vehicleModelC.text.toString(),
                                    ));
                                  });
                                  saveIntoSp();
                                }
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            VehicleOwnerCompleteProfileThree(
                                              adress: widget.adress,
                                              geograpLimit: widget.geograpLimit,
                                              vehicleLimit: widget.vehicleLimit,
                                            )));
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

  //save function

  Future<void> _vehicleOwnerData() async {
    String vehicleName = dropdownValue.toString() ?? '';
    String vehicleType = dropdownValueTwo.toString() ?? '';
    String vehicleNumber = vehicleRegisterationC.text.toString() ?? '';
    String vehicleModel = vehicleModelC.text.toString() ?? '';

    // Store the token in SharedPreferences

    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('vehicleLimit', vehicleLimit.toString());
    prefs.setString('compAdress', compAdress.toString());
    prefs.setString('vehicleName', dropdownValue.toString());
    prefs.setString('vehicleType', dropdownValueTwo.toString());
    prefs.setString('vehicleNumber', vehicleRegisterationC.text.toString());
    prefs.setString('vehicleModel', vehicleModelC.text.toString());

    print(
      'The : $compRegNum , $compPhnNum ,$vehicleModel, $vehicleNumber  , $vehicleType',
    );

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => VehicleOwnerCompleteProfileThree(),
    //   ),
    // );
  }
}
