import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:goods_transport/Constant/colors_constant.dart';
import 'package:goods_transport/Constant/dialoag_widget.dart';
import 'package:goods_transport/Screens/BottomNavigationScreen/CompleteYourProfile/broker_complete_profile_one.dart';
import 'package:goods_transport/Screens/BottomNavigationScreen/CompleteYourProfile/user_complete_prfile.dart';
import 'package:goods_transport/Screens/LoginScreen/login_screen.dart';
import 'package:goods_transport/Widegts/custom_button.dart';
import 'package:goods_transport/Widegts/custom_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Constant/Controller/signup_controller.dart';
import '../../../Constant/const.dart';
import 'package:http/http.dart' as http;



class ForgetPasswordOtpScreen extends StatefulWidget {
  String? id;
  ForgetPasswordOtpScreen({this.id});

  @override
  State<ForgetPasswordOtpScreen> createState() => _ForgetPasswordOtpScreenState();
}

class _ForgetPasswordOtpScreenState extends State<ForgetPasswordOtpScreen> {

  String smssent = '';
  String verificationId = '';
  var errorController;
  String? namee;
  String? phone;
  String? Userpassword;
  String? type;
  String? id;
  bool isLoading = false;

  var controller = Get.put(authentication_Controller());


  Future<void> retrieveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      namee = prefs.getString('name');
      id = prefs.getString('id');
      phone = prefs.getString('phoneNo');

      print("this is Name $namee");
      print("this is email $id");
      print("this is phone $phone");
      print("this is type $type");
    });
    // print('asdadasda $token');
  }
  late String phoneNo;

  Future<void> verifyPhone({bool resend = false}) async {

    setState(() {
      isLoading = true; // Set loading to true when the function is called
    });

    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationId = verId;
    };
    final PhoneCodeSent smsCodeSent = (String verId, [int? forceCodeResend]) {
      this.verificationId = verId;

    } as PhoneCodeSent;

    final PhoneVerificationCompleted verifiedSuccess = (AuthCredential auth) {
      setState(() {
        isLoading = false; // Set loading to true when the function is called
      });

      CustomDialogs.showSnakcbar(context, 'Successfully done');
    };

    final PhoneVerificationFailed verifyFailed = (FirebaseAuthException e) {
      setState(() {
        isLoading = false; // Set loading to true when the function is called
      });

      CustomDialogs.showSnakcbar(context, 'Verification Failed');
      print('${e.message}');
    };
    setState(() {
      isLoading = false; // Set loading to true when the function is called
    });
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: Duration(seconds: 5),
      verificationCompleted: verifiedSuccess,
      verificationFailed: verifyFailed,
      codeSent: smsCodeSent,
      codeAutoRetrievalTimeout: autoRetrieve,
    );
  }


  Future<void> signIn(String smsCode) async {
    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    try {
      // Sign in with the provided credential
      await FirebaseAuth.instance.signInWithCredential(credential).then((user) async {
        final User? users = FirebaseAuth.instance.currentUser;

        // Check if OTP verification is successful
        if (users != null) {
          // OTP verification successful, now call the signUp function
          // passwordReset();
          _showMyDialog();
        } else {
          // Handle the case where OTP verification failed
          CustomDialogs.showSnakcbar(context, "OTP verification failed");
          print("OTP verification failed");
          // You can show an error message to the user here.
        }
      });
    } catch (e) {
      CustomDialogs.showSnakcbar(context, "${e}");
      print(e);
    }
  }


  int secondsRemaining = 60;
  bool enableResend = false;
  Timer? timer;


  timerFunction () {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
        // timer!.cancel(); // Stop the timer when time is up

      }
    });
  }

  @override
  initState() {

    super.initState();
    retrieveData().then((value) {
      verifyPhone();
      timerFunction ();
    });



    // verifyPhone();
  }

  void _resendCode() {
    //other code here
    verifyPhone(resend: true);
    setState((){
      secondsRemaining = 60;
      enableResend = false;
    });
    // timer!.cancel(); // Stop the timer when time is up

  }

  @override
  dispose(){
    timer!.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Form(
                key: controller.signUpInformKey.value,
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 20.0),
                    //   child: Row(
                    //     children: [
                    //       InkWell(
                    //         onTap : () {
                    //           Navigator.pop(context);
                    //         },
                    //         child: Image.asset(
                    //           'assets/icons/back.png',
                    //           scale: 4,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    Image.asset('assets/images/otp1.png',scale: 3.9,),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Enter OTP',
                      style: GoogleFonts.lato(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'We have sent you access code',
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Via SMS for mobile number verification',
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        color: Color(0xff1F1F24).withOpacity(0.6),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0,right: 18),
                      child: PinCodeTextField(
                        length: 6,
                        keyboardType: TextInputType.number,
                        obscureText: false,
                        animationType: AnimationType.fade,
                        animationDuration: Duration(milliseconds: 300),
                        errorAnimationController: errorController,
                        textStyle: TextStyle(fontWeight: FontWeight.w500),
                        // Pas// s it here
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.circle,
                          // borderRadius: BorderRadius.circular(10),
                          fieldHeight: 45,
                          fieldWidth: 45,
                          activeFillColor: Colors.black12,
                          activeColor: Colors.black12,
                          errorBorderColor: Colors.black12,
                          inactiveColor: Colors.black12,
                          selectedColor: Colors.black12,
                          selectedFillColor: Colors.black12,
                          inactiveFillColor: Colors.black12,
                        ),
                        onChanged: (value) {
                          setState(() {
                            this.smssent = value;
                          });
                        },
                        appContext: context,
                      ),
                    ),

                    InkWell(
                      onTap: (){
                        retrieveData().then((value) {
                          enableResend ? _resendCode() : null;
                        });
                      },
                      child: Text(
                        'Resend OTP',
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          color:primayColor,
                          decoration: enableResend
                              ? TextDecoration.underline
                              : TextDecoration.none,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      'after $secondsRemaining seconds',
                      style: GoogleFonts.lato(
                        fontSize: 12,
                        color:primayColor,
                        fontWeight: FontWeight.w600,
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
                          :
                      CustomButton(
                        title: 'Verify',
                        btnclr: primayColorBlue,
                        txtclr: Colors.white,
                        onTap: (){

                          signIn(smssent);


                        },
                      ),),
                  ],
                ),
              ),
            ),
            if(isLoading)
              Container(
                color: Colors.black.withOpacity(0.7),
                child: Center(
                  child: CircularProgressIndicator(
                    color: primayColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }


  TextEditingController phoneC = TextEditingController();

  String selectedCountryCode = '+92'; // Default country code

  void handleCountryChange(Country country) {
    setState(() {
      selectedCountryCode = '+${country.dialCode}';
    });
  }


  //alert dialog

  Future<void> _showMyDialog() async {
    return showDialog<void>(
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
              height: 210,
              width: 300,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                 children: [
                   SizedBox(
                     height: 15,
                   ),
                   Row(
                     children: [
                       Padding(
                         padding: const EdgeInsets.only(left: 22.0),
                         child: Text(
                           'Password Reset',
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
                       height: 60,
                       child: CustomTextField(
                         hintText: 'Enter Password',
                         controller: passwordC,
                         validate: true,
                         // obsecureText: ispasswordvisible,
                         // suffixIcon: IconButton(
                           // onPressed: () {
                           //   setState(() {
                           //     ispasswordvisible = !ispasswordvisible;
                           //   });
                           // },
                           // icon: Icon(
                           //   size: 16,
                           //   ispasswordvisible
                           //       ? Icons.visibility_off
                           //       : Icons.visibility,
                           //   color: Colors.grey,
                           // ),
                         // ),
                       ),
                     ),
                   ),


                   CustomButton(
                     title: 'Reset',
                     txtclr: Colors.white,
                     btnclr: primayColor,
                     onTap: (){
                        passwordReset().then((value) {
                          Get.offAll(LoginScreen());
                        });
                     },
                   )                 ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  bool ispasswordvisible = true;
  TextEditingController passwordC = TextEditingController();




  Future<void> passwordReset() async {
    final String apiUrl = "https://agt.jeuxtesting.com/api/password/reset";

    // Replace this map with your actual data
    Map<String, dynamic> data = {
      "id": widget.id.toString(),
      "password": passwordC.text.toString(),
      // Add other fields as needed
    };

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        print("POST request successful!");
        // Parse the response body as JSON
        final responseData = jsonDecode(response.body);

        // Check if the 'message' key exists and is not null
        if (responseData.containsKey('message') && responseData['message'] != null) {
          CustomDialogs.showSnakcbar(context, responseData['message']);
        } else {
          CustomDialogs.showSnakcbar(context, 'Unexpected response format: ${response.body}');
        }

        print("Response: ${response.body}");
      } else {
        CustomDialogs.showSnakcbar(context, 'Failed to reset password');
        throw Exception("Failed to post data");
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


}
