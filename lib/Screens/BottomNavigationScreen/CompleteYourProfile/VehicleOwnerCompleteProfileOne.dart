import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:goods_transport/Screens/BottomNavigationScreen/CompleteYourProfile/vehicleOwner_complete_profile_four.dart';
import 'package:goods_transport/Screens/BottomNavigationScreen/CompleteYourProfile/vehicleOwnerProfileTeo.dart';
import 'package:goods_transport/Screens/BottomNavigationScreen/CompleteYourProfile/vehicle_owner_profile_three.dart';
import 'package:goods_transport/Screens/BottomNavigationScreen/ProfileScreen/borker_profile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Constant/colors_constant.dart';
import '../../../Widegts/custom_button.dart';
import '../../../Widegts/custom_text_field.dart';

class VehicleOwnerCompleteProfileOne extends StatefulWidget {
  const VehicleOwnerCompleteProfileOne({super.key});

  @override
  State<VehicleOwnerCompleteProfileOne> createState() =>
      _VehicleOwnerCompleteProfileOneState();
}

class _VehicleOwnerCompleteProfileOneState
    extends State<VehicleOwnerCompleteProfileOne> {
  TextEditingController phoneC = TextEditingController();
  TextEditingController companyNameC = TextEditingController();
  TextEditingController companyTypeC = TextEditingController();
  TextEditingController vehicleLimitation = TextEditingController();
  TextEditingController addressC = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
        child: Form(
          key: formKey,
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
                    Text('1 of 3'),
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
                        width: 120,
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
                            '35%',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 20,
                        width: 150,
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
                height: 510,
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
                      'Personal Detail\'s',
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

                    // company name

                    textWidget(
                      text: 'Company Registration Number',
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, right: 18),
                      child: SizedBox(
                        width: width / 1,
                        height: 60,
                        child: CustomTextField(
                          hintText: 'Enter Company Registration Number',
                          controller: companyNameC,
                          validate: true,
                          keyboradType: TextInputType.number,
                          errorHint: 'Enter Company Reg Number',
                        ),
                      ),
                    ),

                    // address txt

                    textWidget(
                      text: 'Company Phone Number',
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, right: 18),
                      child: SizedBox(
                        width: width / 1,
                        height: 60,
                        child: CustomTextField(
                          hintText: 'Enter Company Phone Number',
                          controller: companyTypeC,
                          validate: true,
                          keyboradType: TextInputType.number,
                          errorHint: 'Enter Company Phone Number',
                          suffixIcon: Icon(
                            Icons.verified,
                            color: primayColor,
                            size: 16,
                          ),
                        ),
                      ),
                    ),

                    // id card txt

                    textWidget(
                      text: 'Geographical Limitations',
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, right: 18),
                      child: SizedBox(
                        width: width / 1,
                        height: 60,
                        child: CustomTextField(
                          hintText: 'Enter Geographical Limitations',
                          controller: phoneC,
                          validate: true,
                          errorHint: 'Enter Geographical Limitations',
                        ),
                      ),
                    ),

                    textWidget(
                      text: 'Vehicle Limitations',
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, right: 18),
                      child: SizedBox(
                        width: width / 1,
                        height: 60,
                        child: CustomTextField(
                          hintText: 'Enter Vehicle Limitations',
                          controller: vehicleLimitation,
                          validate: true,
                          keyboradType: TextInputType.number,
                          errorHint: 'Enter Vehicle Limitations',
                        ),
                      ),
                    ),

                    // visiting card txt

                    textWidget(
                      text: 'Company Address',
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, right: 18),
                      child: SizedBox(
                        width: width / 1,
                        height: 60,
                        child: CustomTextField(
                          hintText: 'Enter Company Address',
                          controller: addressC,
                          validate: true,
                          errorHint: 'Enter Adress',
                        ),
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
                  Get.to(() => VehicleOwnerCompleteProfileThree(
                        vehicleLimit: vehicleLimitation.text.toString(),
                    adress: addressC.text.toString(),
                        compPhnNum: int.parse(companyTypeC.text.toString()),
                        compRegNum: int.parse(companyNameC.text.toString()),
                        geograpLimit: phoneC.text.toString(),
                      ));
                  // dataStoredShare();

                },
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> dataStoredShare() async {
    String compRegNum = companyNameC.text.toString();
    String compPhnNum = companyTypeC.text.toString();
    String geograpLimit = phoneC.text.toString();
    String vehicleLimit = vehicleLimitation.text.toString();
    // String compAdress = addressC.text.toString();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('compRegNum', compRegNum);
    prefs.setString('compPhnNum', compPhnNum);
    prefs.setString('geograpLimit', geograpLimit);
    prefs.setString('vehicleLimit', vehicleLimit.toString());
    // prefs.setString('compAdress', compAdress.toString());
  }
}
