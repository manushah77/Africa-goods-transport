import 'dart:convert';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:goods_transport/Screens/BottomNavigationScreen/custom_bottom_bar.dart';
import 'package:goods_transport/Screens/BottomNavigationScreen/user_side_custom_navigationbar.dart';
import 'package:goods_transport/Screens/BottomNavigationScreen/viechleOwner_side_custom_navigationbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constant/colors_constant.dart';
import '../../Constant/const.dart';
import '../../Constant/dialoag_widget.dart';
import '../../Widegts/custom_button.dart';
import '../../Widegts/custom_text_field.dart';
import '../BottomNavigationScreen/CompleteYourProfile/VehicleOwnerCompleteProfileOne.dart';
import 'OTP_Screen/otp_screen.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController phoneC = TextEditingController();
  TextEditingController fullNameC = TextEditingController();
  String dropdownValue = 'Broker';
  TextEditingController passwordC = TextEditingController();
  bool ispasswordvisible = true;
  bool isLoading = false;

  final formKey = GlobalKey<FormState>();

  String selectedCountryCode = '+92'; // Default country code

  void handleCountryChange(Country country) {
    setState(() {
      selectedCountryCode = '+${country.dialCode}';
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
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
                          onTap: () {
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
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    'Let\'s Get Started.',
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
                InkWell(
                  onTap: () {
                    _showBottomSheet();
                  },
                  child: imageOne != null
                      ? ClipOval(
                          child: Image.file(
                            imageOne!,
                            fit: BoxFit.cover,
                            height: 140,
                            width: 140,
                          ),
                        )
                      : Container(
                          height: 160,
                          child: Stack(
                            children: [
                              ClipOval(
                                child: Container(
                                  height: 140,
                                  width: 140,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/pp.png'),
                                          fit: BoxFit.cover)),
                                ),
                              ),
                              Positioned(
                                top: 120,
                                left: 55,
                                child: Image.asset(
                                  'assets/icons/add.png',
                                  scale: 4.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 22.0),
                      child: Text(
                        'Full Name',
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
                      hintText: 'Enter Name',
                      controller: fullNameC,
                      validate: true,
                      errorHint: 'Enter Full Name',

                    ),
                  ),
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
                  padding: const EdgeInsets.only(left: 18.0, right: 18),
                  child: SizedBox(
                    width: width / 1,
                    height: 70,
                    child: IntlPhoneField(
                      showCountryFlag: false,
                      invalidNumberMessage: '',
                      dropdownIcon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                      cursorColor: Colors.black,
                      controller: phoneC,
                      validator: (_) {
                        if (_ == null || _ == '') {
                          return 'Enter number';
                        }

                        if (RegExp(r'\D').allMatches(_.toString()).length < 10) {
                          return 'Invalid number, too short';
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: '',
                        hintTextDirection: TextDirection.rtl,
                        hintStyle: TextStyle(
                          color: Colors.black38,
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
                  height: 5,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 22.0),
                      child: Text(
                        'Select User',
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
                  child: Container(
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
                          'Broker',
                          'Vehicle Owner',
                          'User',
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
                ),
                SizedBox(
                  height: 10,
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
                      controller: passwordC,
                      validate: true,
                      obsecureText: ispasswordvisible,
                      errorHint: 'Enter Password',

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
                  height: 30,
                ),
                CustomButton(
                  title: 'Sign Up',
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      _signUp();
                    }
                    // if(dropdownValue == 'Broker') {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => OtpScreen(),
                    //     ),
                    //   );
                    // }
                    // else if(dropdownValue == 'Vehicle Owner') {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => VehicleOwnerCompleteProfileOne (),
                    //     ),
                    //   );
                    // }
                    // else {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => UserSideCustom_BottomBar(selectedIndex: 0),
                    //     ),
                    //   );
                    // }
                  },
                  btnclr: primayColorBlue,
                  txtclr: Colors.white,
                ),
                SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  File? imageOne;
  final pickerOne = ImagePicker();

  // bool isUploaded = false;

  void _showBottomSheet() {
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
                'Upload Profile\n photos',
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
                      var pickImage = await pickerOne.pickImage(
                        source: ImageSource.gallery,
                        maxHeight: 1080,
                        maxWidth: 1080,
                      );
                      if (pickImage != null) {
                        // Crop the selected image
                        CroppedFile? croppedImage =
                            await ImageCropper().cropImage(
                          sourcePath: pickImage.path,
                        );

                        if (croppedImage != null) {
                          setState(() {
                            imageOne = File(croppedImage
                                .path); // Convert CroppedFile to File
                          });
                        }
                      } else {
                        print('No image selected');
                      }
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
                      var pickImage = await pickerOne.pickImage(
                        source: ImageSource.camera,
                        maxHeight: 1080,
                        maxWidth: 1080,
                      );
                      if (pickImage != null) {
                        // Crop the selected image
                        CroppedFile? croppedImage =
                            await ImageCropper().cropImage(
                          sourcePath: pickImage.path,
                        );

                        if (croppedImage != null) {
                          setState(() {
                            imageOne = File(croppedImage
                                .path); // Convert CroppedFile to File
                          });
                        }
                      } else {
                        print('No image selected');
                      }
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

  Future<void> _signUp() async {
    if (imageOne == null) {
      // Handle case when no image is selected
      CustomDialogs.showSnakcbar(context, 'Pick Profile Image');
      return;
    } else if (fullNameC.text.isEmpty) {
      CustomDialogs.showSnakcbar(context, 'Please enter full name');
      return;
    } else if (passwordC.text.isEmpty) {
      CustomDialogs.showSnakcbar(context, 'Please enter password');
      return;
    } else if (phoneC.text.isEmpty) {
      CustomDialogs.showSnakcbar(context, 'Please enter phone number');
      return;
    }

    // // Other sign-up data...
    String nam = fullNameC.text.toString() ?? '';
    String passwor = passwordC.text.toString() ?? '';
    String phon = phoneC.text.toString() ?? '';
    File? image = imageOne;

    setState(() {
      isLoading = true;
    });

    String formattedPhoneNumber = '$selectedCountryCode$phon';

    try {
      String name = nam.toString();
      String phone = formattedPhoneNumber;
      String pass = passwor;
      String personStatus = dropdownValue.toString();
      String isVerified = '';
      String isCompleted = '';
      String otp = '';
      String isRequested = '';
      File? img = image;

      // Store the token in SharedPreferences

      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString('name', name);
      prefs.setString('password', pass);
      prefs.setString('phoneNo', '$phone');
      prefs.setString('personStatus', personStatus.toString());
      prefs.setString('isVerified', isVerified.toString());
      prefs.setString('isCompleted', isCompleted.toString());
      prefs.setString('otp', otp.toString());
      prefs.setString('isRequested', isRequested.toString());
      prefs.setString('imageUrl', img.toString());

      print(
        'The nam and the status and phone and id is : $nam , $personStatus, $phone , $pass',
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpScreen(
            image: imageOne,
          ),
        ),
      );

      // print(response.body);
      // print('Sign-up successful!');
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle any other errors
      // print('Error: $e');
      CustomDialogs.showSnakcbar(context, 'Error is $e');
    }
  }
}
