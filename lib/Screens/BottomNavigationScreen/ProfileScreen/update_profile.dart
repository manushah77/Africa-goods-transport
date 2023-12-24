import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:goods_transport/Constant/colors_constant.dart';
import 'package:goods_transport/Screens/BottomNavigationScreen/custom_bottom_bar.dart';
import 'package:goods_transport/Screens/BottomNavigationScreen/user_side_custom_navigationbar.dart';
import 'package:goods_transport/Widegts/custom_button.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../Constant/dialoag_widget.dart';
import '../viechleOwner_side_custom_navigationbar.dart';

class UpdaateProfile extends StatefulWidget {
  String? img;
  String? name;

   UpdaateProfile({this.name,this.img});

  @override
  State<UpdaateProfile> createState() => _UpdaateProfileState();
}

class _UpdaateProfileState extends State<UpdaateProfile> {

  TextEditingController nameC = TextEditingController();
  String? nam;
  String? personType;
  String? token;
  String? id;
  String? image;
  File? imageOne;
  final pickerOne = ImagePicker();


  Future<void> retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
       id = prefs.getString('id');
      personType = prefs.getString('personStatus');
    });
    print(id);
    print(token);
    print(personType);
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
                        CroppedFile? croppedImage = await ImageCropper().cropImage(
                          sourcePath: pickImage.path,
                        );

                        if (croppedImage != null) {
                          setState(() {
                            imageOne = File(croppedImage.path); // Convert CroppedFile to File
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
                        CroppedFile? croppedImage = await ImageCropper().cropImage(
                          sourcePath: pickImage.path,
                        );

                        if (croppedImage != null) {
                          setState(() {
                            imageOne = File(croppedImage.path); // Convert CroppedFile to File
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameC.text = widget.name.toString();
    image = widget.img.toString();
    retrieveToken();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Color(0xff98C7DB),
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
        ),
        backgroundColor: Color(0xff98C7DB),
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        title: Text(
          'Update Profile',
          style: TextStyle(
            fontFamily: 'Douro',
            fontSize: 27,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        leading:  Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset(
              'assets/icons/back.png',
              scale: 4.4,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
         child: Column(
          children: [
            SizedBox(
              height: 30,
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
                  : ClipOval(
                child: CachedNetworkImage(
                  height: 140,
                  width: 140,
                  imageUrl: "${image}",
                  fit: BoxFit.cover,
                  progressIndicatorBuilder:
                      (context, url, downloadProgress) => Center(
                    child: CircularProgressIndicator(
                        color: primayColor,
                        value: downloadProgress.progress),
                  ),
                  errorWidget: (context, url, error) => CircleAvatar(
                    child: Image.asset(
                      'assets/images/pp.png',
                      height: 140,
                      width: 140,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0, left: 18),
              child: SizedBox(
                width: 380,
                height: 60,
                child: TextFormField(
                  cursorColor:  Colors.black,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                  onChanged: (newValue) {
                    // Update the textFieldValue whenever the text field is edited
                    setState(() {
                      nam = newValue;
                    });
                  },
                  controller: nameC,

                  // ignore: body_might_complete_normally_nullable
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Name';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 2, left: 15, right: 15),

                    border: InputBorder.none,

                    hintText: 'Name',
                    hintStyle: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                    // filled: true,
                    // fillColor: Colors.grey.withOpacity(0.2),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color:Colors.grey.withOpacity(0.4), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.black54, width: 1),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            CustomButton(
              title: 'Update',
              txtclr: Colors.white,
              btnclr: primayColorBlue,
              onTap: (){
                isLoading == true
                    ? Center(
                    child: CircularProgressIndicator(
                      color: primayColor,
                    ))
                    : updateProfile().then((value) {

                      if(personType == 'Broker') {
                        Get.offAll(()=>Custom_BottomBar(selectedIndex: 0));
                      }
                      else if (personType == 'Vehicle Owner') {
                        Get.offAll(()=>ViechleOwnerSideCustom_BottomBar(selectedIndex: 0));
                      }
                      else {
                        Get.offAll(()=>UserSideCustom_BottomBar(selectedIndex: 0));

                      }

                });
                print('poko');
              },
            )
          ],
        ),
      ),

    );
  }


  //update profile function

  bool isLoading = false;

  Future<void> updateProfile() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Prepare the API request
      String apiUrl = 'https://agt.jeuxtesting.com/api/updateProfile';

      // Create a new multipart request
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Add other fields as needed
      request.fields['id'] = id.toString();
      request.fields['name'] = nameC.text.toString();

      // Add the bearer token to the request headers
      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] = 'Bearer $token';

      // Add image to the request if available
      if (imageOne != null) {
        var imageStream = http.ByteStream(imageOne!.openRead());
        var length = await imageOne!.length();
        var multipartFile = http.MultipartFile(
          'imageUrl',
          imageStream,
          length,
          filename: 'imageUrl.png',
        );
        request.files.add(multipartFile);
      }

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
