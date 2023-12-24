import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:goods_transport/Constant/colors_constant.dart';
import 'package:goods_transport/Screens/BottomNavigationScreen/RequestVerificationScreen/request_verification_screen.dart';
import 'package:goods_transport/Screens/BottomNavigationScreen/VerifiedAccountScreen/verified_account_screen.dart';
import 'package:goods_transport/Widegts/custom_button.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Widegts/custom_text_field.dart';
import '../../LoginScreen/login_screen.dart';
import '../custom_bottom_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {


  TextEditingController phoneC = TextEditingController();
  TextEditingController fullNameC = TextEditingController();
  TextEditingController passwordC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Color(0xff98C7DB),
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
        ),
        backgroundColor: Color(0xff98C7DB),
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
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
          Padding(
            padding: const EdgeInsets.only(
              right: 12.0,
            ),
            child: InkWell(
              onTap: (){

                //diloag calling
                _showMyDialog();

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
                          style:
                              GoogleFonts.lato(fontSize: 11, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      // backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 120,
              ),
              InkWell(
                onTap: () {
                  Get.to(Custom_BottomBar(selectedIndex: 0));
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 25.0,right: 25),
                  child: Container(
                    height: 56,
                    width: width/1,
                    decoration: BoxDecoration(
                      color: Color(0xffDBDBDB),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        'Complete Profile',
                        style: GoogleFonts.lato(fontSize: 14, color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0,right: 25),
                child: Container(
                  height: 300,
                  width: width/1,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12, spreadRadius: 1, blurRadius: 4)
                      ]),
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: primayColor, width: 2),
                          ),
                          child: Image.asset(
                            'assets/images/pp.png',
                           scale: 4,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Alex Mendoza',
                          style: GoogleFonts.lato(fontSize: 22, color: Colors.black,fontWeight: FontWeight.w600),
                        ),  Text(
                          '(061)179-5158',
                          style: GoogleFonts.lato(fontSize: 14, color: Colors.black),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25.0,right: 25,top: 5),
                          child: CustomButton(
                            title: 'Logout',
                            btnclr: Colors.red,
                            txtclr: Colors.white,
                            onTap: (){
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));

                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: (){
                  Get.to(RequestVerificationScreen());
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 25.0,right: 25),
                  child: Container(
                    height: 56,
                    width: width/1,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12, spreadRadius: 1, blurRadius: 4)
                        ]),
                    child: Center(
                      child: Text(
                        'Request Verification',
                        style: GoogleFonts.lato(fontSize: 14, color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: (){
                  Get.to(VerifiedAccountScreen());
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 25.0,right: 25),
                  child: Container(
                    height: 56,
                    width: width/1,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12, spreadRadius: 1, blurRadius: 4)
                        ]),
                    child: Center(
                      child: Text(
                        'Verified Accounts',
                        style: GoogleFonts.lato(fontSize: 14, color: Colors.black),
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
        ),
      ),
    );
  }

  //alert dialog

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: SingleChildScrollView(
            child: Container(
              height: 385,
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Personal Details',
                          style: TextStyle(
                            fontFamily: 'Douro',
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                            color: primayColor,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(Icons.mode_edit_outline,size: 16,)
                      ],
                    ),

                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          'Full Name',
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
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
                        hintText: 'Enter Name',
                        controller: fullNameC,
                      ),
                    ),

                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          'Phone Number',
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
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
                        hintText: '(031)606-7678',
                        controller: phoneC,
                      ),
                    ),

                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          'Password',
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
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
                        hintText: '*********',
                        controller: passwordC,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: (){
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
                        Container(
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

}
