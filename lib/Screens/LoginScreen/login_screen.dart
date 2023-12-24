import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goods_transport/Constant/Controller/login_controller.dart';
import 'package:goods_transport/Constant/colors_constant.dart';
import 'package:goods_transport/Screens/BottomNavigationScreen/CompleteYourProfile/broker_complete_profile_one.dart';
import 'package:goods_transport/Widegts/custom_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Constant/dialoag_widget.dart';
import '../../Models/broker_verification_model.dart';
import '../../Widegts/custom_text_field.dart';
import '../ForgetScreen/forget_passwrod_screen.dart';
import '../SignupScreen/signup_screen.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // TextEditingController phoneC = TextEditingController();
  // TextEditingController passwordC = TextEditingController();

  bool ispasswordvisible = true;
  var controller = Get.put(login_Controller());
  String selectedCountryCode = '+92'; // Default country code

  void handleCountryChange(Country country) {
    setState(() {
      selectedCountryCode = '+${country.dialCode}';
    });
  }

  String? token;
  String? type;
  int? status;
  String? id;


  Future<void> retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      type = prefs.getString('personStatus');
      id = prefs.getString('id');
    });
    // print('asdadasda $token');
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
        status = userJson['status'];
        // print('My fetch status is $status');


        return User.fromJson(userJson);
      } else {
        throw Exception(jsonBody['message']);
      }
    } else {
      throw Exception(
          '${response.statusCode}');
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveToken().then((value)  {
      fetchCurrentUser();
      print('my user type is $type');
      print('my user Token is $token');
    });

  }



  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Form(
            key: controller.logInformKey.value,
            child: Column(
              children: [
                SizedBox(
                  height: 80,
                ),
                Center(
                  child: Text(
                    'Welcome back',
                    style: TextStyle(
                      fontFamily: 'Douro',
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      color: primayColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Please enter your mobile number\n to proceed further.',
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: Color(0xff1A242C).withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 22.0),
                      child: Text(
                        'Phone Number',
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
                      controller: controller.email,
                      validator: (_) {
                        if (_ == null || _ == '') {
                          return 'Enter number';
                        }
                        String phoneNumber = controller.email.text.replaceAll(RegExp(r'[^0-9]'), '');

                        // Check if the entered value is a valid phone number
                        if (phoneNumber.length < 10) {
                          return 'Invalid phone number';
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
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 22.0),
                      child: Text(
                        'Password',
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
                  padding: const EdgeInsets.only(left: 18.0, right: 18),
                  child: SizedBox(
                    width: width / 1,
                    height: 65,
                    child: CustomTextField(
                      hintText: 'Enter Password',
                      controller: controller.pass,
                      validate: true,
                      errorHint: 'Enter Password',

                      obsecureText: ispasswordvisible,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            ispasswordvisible = !ispasswordvisible;
                          });
                        },
                        icon: Icon(
                          size: 16,
                          ispasswordvisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgetPasswordScreeen(),
                            ),
                          );
                        },
                        child: Text(
                          'Forgot Password ?',
                          style: GoogleFonts.lato(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black.withOpacity(0.49),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Obx(
                  () => controller.isLoading.value == true
                      ? CircularProgressIndicator(
                          color: primayColor,
                        )
                      : CustomButton(
                          title: 'Login',
                          onTap: () {
                            if (controller.logInformKey.value.currentState!
                                .validate()) {
                              controller.loginUser(
                                  '$selectedCountryCode${controller.email.value.text}',
                                  controller.pass.value.text
                              );
                            }
                          },
                          btnclr: Colors.black,
                          txtclr: Colors.white,
                        ),
                ),
                SizedBox(
                  height: 20,
                ),
                CustomButton(
                  title: 'Sign Up',
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => SignUpScreen(),
                    //   ),
                    // );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUpScreen(),
                      ),
                    );
                  },
                  btnclr: primayColorBlue,
                  txtclr: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
