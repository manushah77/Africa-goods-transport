import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:goods_transport/Constant/colors_constant.dart';
import 'package:goods_transport/Constant/dialoag_widget.dart';
import 'package:goods_transport/Screens/BottomNavigationScreen/CompleteYourProfile/broker_complete_profile_one.dart';
import 'package:goods_transport/Screens/BottomNavigationScreen/CompleteYourProfile/user_complete_prfile.dart';
import 'package:goods_transport/Widegts/custom_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Constant/Controller/signup_controller.dart';
import '../../../Constant/const.dart';
import 'package:http/http.dart' as http;

import '../../BottomNavigationScreen/CompleteYourProfile/VehicleOwnerCompleteProfileOne.dart';
import '../../BottomNavigationScreen/user_side_custom_navigationbar.dart';

class OtpScreen extends StatefulWidget {
  File? image;
   OtpScreen({this.image});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {

   String smssent = '';
   String verificationId = '';
  var errorController;
  String? namee;
  String? phone;
  String? Userpassword;
  String? type;
  String? userEmail;
   bool isLoading = false;

   var controller = Get.put(authentication_Controller());


   Future<void> retrieveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      namee = prefs.getString('name');
      userEmail = prefs.getString('email');
      phone = prefs.getString('phoneNo');
      type = prefs.getString('personStatus');
      Userpassword = prefs.getString('password');

      print("this is Name $namee");
      print("this is email $userEmail");
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
       timeout: Duration(seconds: 60),
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
           await _signUp();
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
     fcmTokenFunc();



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
                    Padding(
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                            child: Image.asset('assets/icons/cancel.png',scale: 4,)),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Image.asset('assets/images/otp2.png',scale: 4.5,),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Hurray!!!',
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      'Account Registered!',
                      style: GoogleFonts.lato(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // SizedBox(
                    //   height: 3,
                    // ),
                    Text(
                      'We will need some more details about you\n to complete your profile.',
                      style: GoogleFonts.lato(
                        fontSize: 12,
                        color: Color(0xff707070),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CustomButton(
                      title: 'Verify',
                      txtclr: Colors.white,
                      btnclr: primayColor,
                      onTap: (){

                        if(type == 'Broker') {
                          Get.offAll(BrokerCompleteProfileOneScreen());
                        }
                        else if(type == 'Vehicle Owner') {
                          Get.offAll(VehicleOwnerCompleteProfileOne());

                        }
                        else {
                          Get.offAll(UserCompleteProfile());
                        }


                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

   String? fcmToken;

   fcmTokenFunc () {
     FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
     _firebaseMessaging.getToken().then((token){
       setState(() {
         fcmToken = token;
       });
       print("my token is $fcmToken");
     });
   }

   Future<void> _signUp() async {
     // Other sign-up data...
     String name = namee ?? '';
     String phoneNo = phone ?? '';
     String password = Userpassword ?? '';
     String isVerified = '0' ;
     String isCompleted = '0';
     String isRequested = '0';
     String personStatus = type ?? '';
     File? imageUrl = widget.image;
     String otp = '123123';

     setState(() {
       isLoading = true;
     });

     try {
       // Prepare the API request
       String apiUrl = 'https://agt.jeuxtesting.com/api/register';

       // Create a new multipart request
       var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

       var imageStream = http.ByteStream(imageUrl!.openRead());
       var length = await imageUrl.length();
       var multipartFile = http.MultipartFile(
         'imageUrl',
         imageStream,
         length,
         filename: '1.png', // Use a valid filename
       );
       request.files.add(multipartFile);

       // Add other sign-up fields as needed
       request.fields['name'] = name;
       request.fields['password'] = password;
       request.fields['phoneNo'] = phoneNo;
       request.fields['personStatus'] = personStatus;
       request.fields['isVerified'] =   "\"0\"";
       // request.fields['isVerified'] =   "\"0\"";
       request.fields['otp'] = otp;
       request.fields['isCompleted'] = "\"0\"";
       request.fields['isRequested'] = "\"0\"";
       request.fields['deviceToken'] = fcmToken.toString();


       // Send the data to the server and wait for the response


       var streamedResponse = await request.send();

       // Convert the streamed response to a regular http.Response



       var response = await http.Response.fromStream(streamedResponse);

       var data = jsonDecode(response.body.toString());

       // Handle the API response here
       print(data);
       if (response.statusCode == 200 && data['status'] == 'success') {
         // Successful sign-up
         setState(() {
           isLoading = false;
         });

         CustomDialogs.showSnakcbar(context, 'Successfully Signup');

         String token = data['token'];
         String id = data['user']['id'].toString();
         String nam = data['user']['name'];
         String userType = data['user']['personStatus'];

         // Store the token in SharedPreferences
         SharedPreferences prefs = await SharedPreferences.getInstance();
         prefs.setString('token', token);
         prefs.setString('id', id);
         prefs.setString('name', nam);
         prefs.setString('personStatus', userType);

         print(
           'The nam and the token and id is : $nam , $token, $id ',
         );

         _showMyDialog();

         print(response.body);
         print('Sign-up successful!');
       } else {
         setState(() {
           isLoading = false;
         });

         // Handle errors here
         if (data['message'] != null) {
           print(data);
           CustomDialogs.showSnakcbar(context, 'Phone number Already Taken');
           // CustomDialogs.showSnakcbar(context, data['message']);
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
