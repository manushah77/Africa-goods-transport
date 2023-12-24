import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:goods_transport/Constant/colors_constant.dart';
import 'package:goods_transport/Widegts/custom_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../Constant/dialoag_widget.dart';

class RequestVerificationScreen extends StatefulWidget {
  const RequestVerificationScreen({super.key});

  @override
  State<RequestVerificationScreen> createState() =>
      _RequestVerificationScreenState();
}

class _RequestVerificationScreenState extends State<RequestVerificationScreen> {
  File? imageOne;
  final pickerOne = ImagePicker();
  File? imageTwo;
  final pickerTow = ImagePicker();
  File? imageThree;
  final pickerThree = ImagePicker();
  File? imageFour;
  final pickerFour = ImagePicker();

  String? token;
  String? userId;
  bool isLoading = false;

  Future<void> retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      userId = prefs.getString('id');
    });

    print('asdadasda $userId');
    print('My token is $token');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ),
        automaticallyImplyLeading: false,
        leading: Material(
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
        centerTitle: true,
        title: Text(
          'Request\n Verification',
          style: TextStyle(
            fontFamily: 'Douro',
            fontSize: 25,
            fontWeight: FontWeight.w500,
            color: primayColor,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  _showBottomSheet();
                },
                child: imageOne != null
                    ? Container(
                        height: 155,
                        width: 310,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: 1,
                                  blurRadius: 4)
                            ]),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            imageOne!,
                            fit: BoxFit.cover,
                            height: 155,
                            width: 310,
                          ),
                        ),
                      )
                    : Container(
                        height: 155,
                        width: 310,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: 1,
                                  blurRadius: 4)
                            ]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/camera.png',
                              scale: 1.7,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Selfie',
                              style: GoogleFonts.lato(
                                  fontSize: 16, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
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
                        width: 310,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: 1,
                                  blurRadius: 4)
                            ]),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            imageTwo!,
                            fit: BoxFit.cover,
                            height: 155,
                            width: 310,
                          ),
                        ),
                      )
                    : Container(
                        height: 155,
                        width: 310,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: 1,
                                  blurRadius: 4)
                            ]),
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
                              'ID Card Front Side',
                              style: GoogleFonts.lato(
                                  fontSize: 16, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  _showBottomSheetThree();
                },
                child: imageThree != null
                    ? Container(
                        height: 155,
                        width: 310,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: 1,
                                  blurRadius: 4)
                            ]),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            imageThree!,
                            fit: BoxFit.cover,
                            height: 155,
                            width: 310,
                          ),
                        ),
                      )
                    : Container(
                        height: 155,
                        width: 310,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: 1,
                                  blurRadius: 4)
                            ]),
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
                              'ID Card Back Side',
                              style: GoogleFonts.lato(
                                  fontSize: 16, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  _showBottomSheetFour();
                },
                child: imageFour != null
                    ? Container(
                        height: 155,
                        width: 310,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: 1,
                                  blurRadius: 4)
                            ]),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            imageFour!,
                            fit: BoxFit.cover,
                            height: 155,
                            width: 310,
                          ),
                        ),
                      )
                    : Container(
                        height: 155,
                        width: 310,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: 1,
                                  blurRadius: 4)
                            ]),
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
                              'CPIC',
                              style: GoogleFonts.lato(
                                  fontSize: 16, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
              ),
              SizedBox(
                height: 15,
              ),
              isLoading == true
                  ? Center(
                  child: CircularProgressIndicator(
                    color: primayColor,
                  ))
                  : Padding(
                padding: const EdgeInsets.only(left: 22.0, right: 22, bottom: 18),
                child: InkWell(
                  onTap: () {
                    if (imageOne == null || imageTwo == null || imageThree == null || imageFour == null) {
                      CustomDialogs.showSnakcbar(context, 'Please select all images');
                    } else {
                      requestVerification().then((value) {
                        Get.back();
                      });
                    }
                  },
                  child: Container(
                    height: 57,
                    width: 300,
                    decoration: BoxDecoration(
                      color: primayColorBlue,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        'Request',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


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
                'Upload Your\n Selfie photo',
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
                          source: ImageSource.gallery);

                      setState(() {
                        if (pickImage != null) {
                          imageOne = File(pickImage.path);
                          print(imageOne);
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
                      await pickerOne.pickImage(source: ImageSource.camera);

                      setState(() {
                        if (pickImage != null) {
                          imageOne = File(pickImage.path);
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
                'Upload Your Id Card\n Front photo',
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


  void _showBottomSheetThree() {
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
                'Upload Your Id Card\n Back photo',
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
                      var pickImage = await pickerThree.pickImage(
                          source: ImageSource.gallery);

                      setState(() {
                        if (pickImage != null) {
                          imageThree = File(pickImage.path);
                          print(imageThree);
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
                      await pickerThree.pickImage(source: ImageSource.camera);

                      setState(() {
                        if (pickImage != null) {
                          imageThree = File(pickImage.path);
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

  void _showBottomSheetFour() {
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
                'Upload Your CPIC\n photo',
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
                      var pickImage = await pickerFour.pickImage(
                          source: ImageSource.gallery);

                      setState(() {
                        if (pickImage != null) {
                          imageFour = File(pickImage.path);
                          print(imageFour);
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
                      await pickerFour.pickImage(source: ImageSource.camera);

                      setState(() {
                        if (pickImage != null) {
                          imageFour = File(pickImage.path);
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


  //request verification function

  Future<void> requestVerification() async {
    // Other sign-up data...
    File? imageUrl = imageOne;
    File? imageUrlTwo = imageTwo;
    File? imageUrlThree = imageThree;
    File? imageUrlFour = imageFour;

    if (imageUrl == null || imageUrlTwo == null || imageUrlThree == null || imageUrlFour == null) {
      CustomDialogs.showSnakcbar(context, 'Please select all images');
      return; // Stop further execution if any image is null
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Prepare the API request
      String apiUrl = 'https://agt.jeuxtesting.com/api/addProfileRequest';

      // Create a new multipart request
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      //for image selfe
      var imageStream = http.ByteStream(imageUrl.openRead());
      var length = await imageUrl.length();
      var multipartFile = http.MultipartFile(
        'selfie',
        imageStream,
        length,
        filename: 'selfie.png', // Use a valid filename
      );
      request.files.add(multipartFile);

//for image front id card
      var imageStreamTwo = http.ByteStream(imageUrlTwo.openRead());
      var lengthtwo = await imageUrlTwo.length();  // Use imageUrlTwo.length() here
      var multipartFileTwo = http.MultipartFile(
        'front_card',
        imageStreamTwo,
        lengthtwo,
        filename: 'frontIdCard.png', // Use a valid filename
      );
      request.files.add(multipartFileTwo);

//for image back id card
      var imageStreamThree = http.ByteStream(imageUrlThree.openRead());
      var lengththree = await imageUrlThree.length();  // Use imageUrlThree.length() here
      var multipartFileThree = http.MultipartFile(
        'back_card',
        imageStreamThree,
        lengththree,
        filename: 'backIdCard.png', // Use a valid filename
      );
      request.files.add(multipartFileThree);

//for image front id card
      var imageStreamFour = http.ByteStream(imageUrlFour.openRead());
      var lengthtFour = await imageUrlFour.length();  // Use imageUrlFour.length() here
      var multipartFileFour = http.MultipartFile(
        'visiting',
        imageStreamFour,
        lengthtFour,
        filename: 'CPIC.png', // Use a valid filename
      );
      request.files.add(multipartFileFour);


      // Add other fields as needed
      request.fields['userId'] = userId.toString();

      // Add the bearer token to the request headers


      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] = 'Bearer $token';

      // Send the data to the server and wait for the response

      var streamedResponse = await request.send();

      // Convert the streamed response to a regular http.Response

      var response = await http.Response.fromStream(streamedResponse);

      var data = jsonDecode(response.body.toString());

      // Handle the API response here
      // Handle the API response here
      print(data);
      if (response.statusCode == 200 && data['status'] == 'success') {
        // Successful sign-up
        setState(() {
          isLoading = false;
        });

        CustomDialogs.showSnakcbar(context, data['message']);

        print(response.body);
        print('add data successful!');
      } else {
        setState(() {
          isLoading = false;
        });

        // Handle errors here
        if (data['message'] != null) {
          print(data);
          CustomDialogs.showSnakcbar(context, data['message']);
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
      // CustomDialogs.showSnakcbar(context, 'Error is ');
    }
  }
}
