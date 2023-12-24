import 'dart:convert';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:goods_transport/Models/broker_verification_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Constant/colors_constant.dart';
import '../../../Constant/dialoag_widget.dart';
import '../../../Widegts/custom_button.dart';
import '../../../Widegts/custom_text_field.dart';
import '../custom_bottom_bar.dart';
import 'package:http/http.dart' as http;

class BrokerCompleteProfileTwo extends StatefulWidget {
  String? adress;
  String? phn;
  int? idCard;


   BrokerCompleteProfileTwo({this.phn,this.adress,this.idCard});

  @override
  State<BrokerCompleteProfileTwo> createState() =>
      _BrokerCompleteProfileTwoState();
}

class _BrokerCompleteProfileTwoState extends State<BrokerCompleteProfileTwo> {
  TextEditingController ownerPhoneC = TextEditingController();
  TextEditingController ownerNameC = TextEditingController();
  TextEditingController managerNameC = TextEditingController();
  TextEditingController managerPhoneC = TextEditingController();
  bool isLoading = false;
  BrokerData? data;

  String? userId;
  String? userstatus;
  String? token;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      userId = prefs.getString('id');
      userstatus = prefs.getString('status');
    });
    print('asdadasda $userstatus');
  }

  //get cities
  String? dropdownvalue;
  Future<List<String>> getAllCities() async {
    var baseUrl = "https://agt.jeuxtesting.com/api/getCities";

    http.Response response = await http.get(Uri.parse(baseUrl), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      List<String> items = [];
      var jsonData = json.decode(response.body)['data'] as List;

      for (var element in jsonData) {
        items.add(element['city']);
      }

      return items;
    } else {
      // Handle Errors
      throw response.statusCode;
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.adress);
    print(widget.idCard);
    print(widget.phn);
    retrieveToken().then((value) {
      print('my user id is $userId');
      print('my user Token is $token');
    });

  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery
        .of(context)
        .size
        .height;
    var width = MediaQuery
        .of(context)
        .size
        .width;

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
                    Text('2 of 2'),
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
                    color: primayColorBlue,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12, spreadRadius: 0, blurRadius: 4)
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '100%',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 690,
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
                      'Company Detail\'s',
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

                    // owner visiting card

                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 22.0),
                          child: Text(
                            'Company Logo',
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        _showBottomSheetTwo();
                      },
                      child: imageTwo != null
                          ? Padding(
                            padding: const EdgeInsets.only(left: 20.0,right: 20),
                            child: Container(
                        height: 155,
                        width: width/1,
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
                      ),
                          )
                          : Padding(
                        padding: const EdgeInsets.only(left: 20.0,right: 20),
                            child: Container(
                        height: 155,
                        width: width/1,
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
                                'Company Logo',
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16, color: Colors.black),
                              ),
                            ],
                        ),
                      ),
                          ),
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    // owner name

                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 22.0),
                          child: Text(
                            'Company Name',
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0,right: 20),
                      child: SizedBox(
                        width: width/1,
                        height: 60,
                        child: CustomTextField(
                          hintText: 'Roy McDonald',
                          controller: ownerNameC,
                          validate: true,
                          errorHint: 'Enter Company Name',

                        ),
                      ),
                    ),

                    // owner number

                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 22.0),
                          child: Text(
                            'Company Number',
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0,right: 20),
                      child: SizedBox(
                        width: width/1,
                        height: 60,
                        child: CustomTextField(
                          keyboradType: TextInputType.phone,
                          hintText: '(781)227-9152',
                          controller: ownerPhoneC,
                          validate: true,
                          errorHint: 'Enter Company Number',

                        ),
                      ),
                    ),

                    // manager name

                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 22.0),
                          child: Text(
                            'Manager Name',
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0,right: 20),
                      child: SizedBox(
                        width: width/1,
                        height: 60,
                        child: CustomTextField(
                          hintText: 'Justin Gilbert',
                          controller: managerNameC,
                          validate: true,
                          errorHint: 'Enter Manager Name',

                        ),
                      ),
                    ),

                    // manager number

                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 22.0),
                          child: Text(
                            'Manager Number',
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0,right: 20),
                      child: SizedBox(
                        width: width/1,
                        height: 60,
                        child: CustomTextField(
                          keyboradType: TextInputType.phone,
                          hintText: '(781)227-9152',
                          controller: managerPhoneC,
                          validate: true,
                          errorHint: 'Enter Manager Number',


                        ),
                      ),
                    ),


                    SizedBox(
                      height: 10,
                    ),
                    FutureBuilder<List<String>>(
                      future: getAllCities(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var data = snapshot.data!;
                          return Padding(
                            padding: const EdgeInsets.only(left: 20.0,right: 20),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                isExpanded: true,
                                hint: Row(
                                  children: const [
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text('Select City')
                                  ],
                                ),
                                items: data.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                value: dropdownvalue ,
                                onChanged: (value) {
                                  setState(() {
                                    dropdownvalue = value as String;
                                  });
                                },

                                buttonStyleData: ButtonStyleData(
                                  width: width/1,
                                  height: 50,
                                  padding:
                                  const EdgeInsets.only(left: 18, right: 18),
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
                          );
                        } else {
                          return  CircularProgressIndicator(
                            color: primayColor,
                          );
                        }
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              isLoading == true ? CircularProgressIndicator(
                color: primayColor,
              ) :
              CustomButton(
                title: 'Next',
                btnclr: primayColorBlue,
                txtclr: Colors.white,
                onTap: () {
                if(formKey.currentState!.validate()) {
                  addBrokerDetail().then((value) {
                    Get.offAll(()=>Custom_BottomBar(selectedIndex: 0));
                  });
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
                'Upload Company\'s\n Logo',
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

  Future<void> addBrokerDetail() async {

    if (imageTwo == null) {
      CustomDialogs.showSnakcbar(context, 'Please select an image');
      return;
    }

    File? imageUrl =imageTwo;

    setState(() {
      isLoading = true;
    });

    try {
      // Prepare the API request
      String apiUrl = 'https://agt.jeuxtesting.com/api/registerBroker';

      // Create a new multipart request
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      var imageStream = http.ByteStream(imageUrl!.openRead());
      var length = await imageUrl.length();
      var multipartFile = http.MultipartFile(
        'visitingUrl',
        imageStream,
        length,
        filename: '1.png', // Use a valid filename
      );
      request.files.add(multipartFile);

      // Add other sign-up fields as needed
      request.fields['userId'] = userId.toString();
      request.fields['address'] = widget.adress.toString();
      request.fields['company_name'] = ownerNameC.text.trim().toString();
      request.fields['phoneOpt'] = widget.phn.toString();
      request.fields['ntn'] = widget.idCard.toString();
      request.fields['managerNo1'] = managerPhoneC.text.trim().toString();
      request.fields['working_forum'] = 'testing';
      request.fields['manager_name'] = managerNameC.text.trim().toString();
      request.fields['owner_number'] = ownerPhoneC.text.trim().toString();
      request.fields['location'] = dropdownvalue.toString();


      // Add the bearer token to the request headers
      String bearerToken = token.toString(); // Replace with your actual bearer token
      request.headers['Authorization'] = 'Bearer $bearerToken';

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
      CustomDialogs.showSnakcbar(context, 'Error is $e');
    }
  }



}
