import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../Constant/Controller/signup_controller.dart';
import '../../Constant/colors_constant.dart';
import '../../Widegts/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgetPasswordScreeen extends StatefulWidget {
  const ForgetPasswordScreeen({super.key});

  @override
  State<ForgetPasswordScreeen> createState() => _ForgetPasswordScreeenState();
}

class _ForgetPasswordScreeenState extends State<ForgetPasswordScreeen> {
  var controller = Get.put(authentication_Controller());
  TextEditingController phoneC = TextEditingController();

  String selectedCountryCode = '+92'; // Default country code

  void handleCountryChange(Country country) {
    setState(() {
      selectedCountryCode = '+${country.dialCode}';
    });
  }

  String? token;
  String? userId;
  String? type;
  String? name;

  Future<void> retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      type = prefs.getString('personStatus');
      name = prefs.getString('name');
      userId = prefs.getString('id');
    });
    print('asdadasda $name');
    print('asdadasda $userId');
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveToken();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Forget Password',
            style:TextStyle(
              fontFamily: 'Douro',
              fontSize: 32,
              fontWeight: FontWeight.w500,
              color: primayColor,
            ),
          ),
          leading:   Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap : () {
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      'assets/icons/back.png',
                      scale: 4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        body: SingleChildScrollView(
          child: Center(
            child: Form(
              key: controller.passwordReset.value,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Image.asset('assets/images/forget.png',scale: 4.5,),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Forgot your password?',
                    style:TextStyle(
                      fontFamily: 'Douro',
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Please enter the Phone Number associated\n with your account. We\'ll mail you a \nlink to reset your password.',
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: Color(0xff1A242C).withOpacity(0.5),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(),
                  Container(
                    height: MediaQuery.of(context).size.width / 2.6,
                  ),

                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 22.0),
                        child: Text(
                          'Mobile Number',
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0,right: 18),
                    child: SizedBox(
                      width: width/1,
                      height: 70,
                      child: IntlPhoneField(
                        showCountryFlag: false,
                        invalidNumberMessage: '',
                        dropdownIcon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey,
                        ),
                        cursorColor: Colors.black,
                        controller: controller.phoneC,
                        validator: (_) {
                          if (_ == null || _ == '') {
                            return 'Enter number';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: '',
                          hintTextDirection: TextDirection.rtl,
                          hintStyle: TextStyle(
                            color:Colors.black38,
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.4),
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Colors.black38,
                            ),
                          ),
                        ),
                        initialCountryCode: 'PK',
                        onChanged: (value) {},
                        onCountryChanged: handleCountryChange,

                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
              Obx(
                    () => controller.isLoading.value == true
                    ? CircularProgressIndicator(
                  color: primayColor,
                )
                    :
                  CustomButton(
                    title: 'Send',
                    onTap: () {
                      if (controller.passwordReset.value.currentState!
                          .validate()) {
                        controller
                            .ressetPass('$selectedCountryCode${controller.phoneC.value.text}',userId.toString());
                      }
                      print('$selectedCountryCode${controller.phoneC.value.text}');
                    },
                    btnclr: primayColorBlue,
                    txtclr: Colors.white,
                  ),
              ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),

      ),
    );
  }
}
