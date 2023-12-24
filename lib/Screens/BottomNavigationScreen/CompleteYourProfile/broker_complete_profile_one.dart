import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:goods_transport/Screens/BottomNavigationScreen/CompleteYourProfile/broker_complete_profile_two.dart';
import 'package:goods_transport/Screens/BottomNavigationScreen/CompleteYourProfile/vehicleOwner_complete_profile_four.dart';
import 'package:goods_transport/Screens/BottomNavigationScreen/ProfileScreen/borker_profile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Constant/colors_constant.dart';
import '../../../Widegts/custom_button.dart';
import '../../../Widegts/custom_text_field.dart';

class BrokerCompleteProfileOneScreen extends StatefulWidget {
  const BrokerCompleteProfileOneScreen({super.key});

  @override
  State<BrokerCompleteProfileOneScreen> createState() =>
      _BrokerCompleteProfileOneScreenState();
}

class _BrokerCompleteProfileOneScreenState extends State<BrokerCompleteProfileOneScreen> {

  TextEditingController phoneC = TextEditingController();
  TextEditingController addressC = TextEditingController();
  TextEditingController idCardC = TextEditingController();
  String? token;
  String? userId;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();


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
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

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
        child: Form(
          key: formKey,
          child: Column(
            children: [

              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('1 of 2'),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0,right: 20),
                child: Container(
                  height: 20,
                  width: width/1,
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
                        width: 160,
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
                            '50%',
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
                height:540,
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

                 // phone txt

                    textWidget(
                      text: 'Phone Number',
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
                          hintText: '',
                          controller: phoneC,
                          validate: true,
                          errorHint: 'Enter Phone Number',

                          keyboradType: TextInputType.number,
                          suffixIcon:   Icon(
                            Icons.verified,
                            color: primayColor,
                            size: 16,
                          ),
                        ),
                      ),
                    ),

                    // address txt

                    textWidget(
                      text: 'Address',
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, right: 18),
                      child: SizedBox(
                        width: width/1,
                        height: 60,
                        child: CustomTextField(
                          hintText: '',
                          controller: addressC,
                          validate: true,
                          errorHint: 'Enter Adress',

                        ),
                      ),
                    ),

                    // id card txt


                    textWidget(
                      text: 'ID Card Number',
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, right: 18),
                      child: SizedBox(
                        width: width/1,
                        height: 60,
                        child: CustomTextField(
                          hintText: '',
                          keyboradType: TextInputType.number,
                          controller: idCardC,
                          errorHint: 'Enter Id Card Number',
                          validate: true,
                        ),
                      ),
                    ),


                    // visiting card txt


                    textWidget(
                      text: 'Business Card (Optional)',
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        _showBottomSheetTwo();
                      },
                      child: imageTwo != null
                          ? Container(
                        height: 155,
                        width: 280,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                spreadRadius: 1,
                                blurRadius: 4)
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            imageTwo!,
                            fit: BoxFit.cover,
                            height: 155,
                            width: 280,
                          ),
                        ),
                      )
                          : Container(
                        height: 155,
                        width: 280,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.7),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/add-to.png',
                              scale: 1.7,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Business Card',
                              style: GoogleFonts.lato(
                                  fontSize: 16, color: Colors.black),
                            ),
                          ],
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
                onTap: (){
                  if(formKey.currentState!.validate()) {
                    Get.to(()=>BrokerCompleteProfileTwo(
                      phn: phoneC.text.toString(),
                      idCard : int.parse(idCardC.text.toString()),
                      adress : addressC.text.toString(),
                      // image: imageTwo,
                    ));
                  }

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

  File? imageTwo;
  final pickerTow = ImagePicker();

  void _showBottomSheetTwo() {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        context: context,
        builder: (_) {
          return ListView(
            padding: EdgeInsets.only(top: 15),
            shrinkWrap: true,
            children: [
              Text(
                'Upload Business\n Card',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      fixedSize: Size(110, 110),
                      elevation: 1,
                      shape: CircleBorder(),
                    ),
                    onPressed: () async {
                      var pickImage = await pickerTow.pickImage(
                          source: ImageSource.gallery);

                      setState(() {
                        if (pickImage != null) {
                          imageTwo = File(pickImage.path);
                          print(imageTwo);
                        } else {
                          print('no image selected');
                        }
                      });
                      Navigator.pop(context);
                    },
                    child: Image.asset('assets/images/gal.png'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      fixedSize: Size(110, 110),
                      shape: CircleBorder(),
                      elevation: 1,
                    ),
                    onPressed: () async {
                      var pickImage =
                      await pickerTow.pickImage(source: ImageSource.camera);

                      setState(() {
                        if (pickImage != null) {
                          imageTwo = File(pickImage.path);
                        } else {
                          print('no image selected');
                        }
                      });
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      'assets/images/camera.png',
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
            ],
          );
        });
  }

}
