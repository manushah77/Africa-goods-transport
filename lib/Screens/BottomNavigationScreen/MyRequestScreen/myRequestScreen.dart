import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:goods_transport/Constant/Controller/show_brokerRequest_cobtroller.dart';
import 'package:goods_transport/Constant/colors_constant.dart';
import 'package:goods_transport/Screens/BottomNavigationScreen/custom_bottom_bar.dart';
import 'package:goods_transport/Widegts/custom_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Constant/dialoag_widget.dart';
import '../../../Models/broker_verification_model.dart';
import '../../../Widegts/custom_text_field.dart';
import 'package:http/http.dart' as http;

class MyRequestScreen extends StatefulWidget {
  const MyRequestScreen({super.key});

  @override
  State<MyRequestScreen> createState() => _MyRequestScreenState();
}

class _MyRequestScreenState extends State<MyRequestScreen> {
  String? token;
  String? userId;
  String? type;
  String? name;
  String? address;

  Future<User> fetchCurrentUser() async {
    final response = await http.post(
        Uri.parse(
            'https://agt.jeuxtesting.com/api/getProfile?id=' + userId.toString()),
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
        address = jsonBody['data']['address'];

        return User.fromJson(userJson);
      } else {
        throw Exception(jsonBody['message']);
      }
    } else {
      throw Exception(
          'Failed to connect to the API. Error code: ${response.statusCode}');
    }
  }


  Future<void> retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      type = prefs.getString('personStatus');
      name = prefs.getString('name');
      userId = prefs.getString('id');
    });
    // print('asdadasda $token');
  }

  var controller = Get.put(BrokerReuestScreen_Controller());

  Future refresh() async {
    await controller.getBrokerReuestData();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveToken().then((value) {
      print('USer type is $type');
      print('USer name is $name');
      fetchCurrentUser();

      refresh();
    });
    setState(() {
      controller.getBrokerReuestData();
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

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
          'My Request\'s',
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
              right: 15.0,
            ),
            child: InkWell(
              onTap: () {
                //diloag calling
                _showMyDialog();
              },
              child: Center(
                child: Container(
                  height: 35,
                  width: 95,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 18,
                          width: 18,
                          decoration: BoxDecoration(
                              color: primayColor, shape: BoxShape.circle),
                          child: Center(
                            child: Icon(
                              Icons.add,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Add Request',
                          style: GoogleFonts.lato(
                              fontSize: 10, color: Colors.black),
                          textScaleFactor: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: Obx(
        () => controller.isLoading.value == true
            ? Center(
                child: Center(
                  child: CircularProgressIndicator(
                    color: primayColor,
                  ),
                ),
              )
            : Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: refresh,
                      child: ListView.builder(
                        itemCount: controller.data.length,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15, bottom: 10),
                            child: userId == controller.data[index]['userId']
                                ? Container(
                                    width: width / 1,
                                    height: height / 3.2,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black12,
                                            spreadRadius: 0,
                                            blurRadius: 2)
                                      ],
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Stack(
                                                children: [
                                                  Container(
                                                    width: width / 2.5,
                                                    height: height / 5,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                          '${controller.data[index]['image']}',
                                                        ),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    left: 115,
                                                    top: 10,
                                                    child: Center(
                                                      child: Container(
                                                        height: 22,
                                                        width: 22,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: PopupMenuButton(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                          // icon: Icon(Icons.more_vert),
                                                          // iconSize: 11,
                                                          child: Icon(
                                                            Icons.more_vert,
                                                            size: 14,
                                                          ),
                                                          onSelected: (value) {
                                                            if (value == 1) {
                                                              _showEditMyDialog(
                                                                '${controller.data[index]['image']}',
                                                                '${controller.data[index]['product']}',
                                                                '${controller.data[index]['weightPerItem']}',
                                                                '${controller.data[index]['noOfItems']}',
                                                                '${controller.data[index]['totalWeight']}',
                                                                '${controller.data[index]['freight']}',
                                                                '${controller.data[index]['vehicle']}',
                                                                '${controller.data[index]['vehicleType']}',
                                                                '${controller.data[index]['pickUp']}',
                                                                '${controller.data[index]['dropOff']}',
                                                                '${controller.data[index]['dropOff2']}',
                                                                '${controller.data[index]['dropOff3']}',
                                                                '${controller.data[index]['dropOff4']}',
                                                                '${controller.data[index]['dropOff5']}',
                                                                '${controller.data[index]['dropOff6']}',
                                                                '${controller.data[index]['user']['name']}',
                                                                '${controller.data[index]['user']['personStatus']}',
                                                                '${controller.data[index]['address']}',
                                                                controller.data[
                                                                        index]
                                                                    ['id'],
                                                                '${controller.data[index]['userId']}',
                                                                '${controller.data[index]['requestStatus']}',
                                                              );
                                                            } else if (value ==
                                                                2) {
                                                              retrieveToken()
                                                                  .then(
                                                                      (value) {
                                                                controller.data[index]
                                                                            [
                                                                            'requestStatus'] ==
                                                                        '1'
                                                                    ? statusDialog(
                                                                        controller.data[index]
                                                                            [
                                                                            'id'],
                                                                        '2')
                                                                    : statusDialog(
                                                                        controller.data[index]
                                                                            [
                                                                            'id'],
                                                                        '1');
                                                              });
                                                            } else {
                                                              retrieveToken()
                                                                  .then(
                                                                      (value) {
                                                                _deleteRequest(
                                                                    controller
                                                                            .data
                                                                            .value[index]
                                                                        ['id']);
                                                              });
                                                            }
                                                          },
                                                          itemBuilder:
                                                              (BuildContext
                                                                  bc) {
                                                            return [
                                                              PopupMenuItem(
                                                                child:
                                                                    Container(
                                                                  width: 65,
                                                                  child: Row(
                                                                    children: [
                                                                      Image
                                                                          .asset(
                                                                        'assets/icons/edit.png',
                                                                        scale:
                                                                            3.3,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                          "Edit"),
                                                                    ],
                                                                  ),
                                                                ),
                                                                value: 1,
                                                              ),
                                                              controller.data[index]
                                                                          [
                                                                          'requestStatus'] ==
                                                                      '1'
                                                                  ? PopupMenuItem(
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            70,
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Image.asset(
                                                                              'assets/icons/pause.png',
                                                                              scale: 3.3,
                                                                            ),
                                                                            SizedBox(
                                                                              width: 5,
                                                                            ),
                                                                            Text("Pause"),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      value: 2,
                                                                    )
                                                                  : PopupMenuItem(
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            70,
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Image.asset(
                                                                              'assets/icons/pause.png',
                                                                              scale: 3.3,
                                                                            ),
                                                                            SizedBox(
                                                                              width: 5,
                                                                            ),
                                                                            Text("Active"),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      value: 2,
                                                                    ),
                                                              PopupMenuItem(
                                                                child:
                                                                    Container(
                                                                  width: 70,
                                                                  child: Row(
                                                                    children: [
                                                                      Image
                                                                          .asset(
                                                                        'assets/icons/del.png',
                                                                        scale:
                                                                            3.3,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                          "Delete"),
                                                                    ],
                                                                  ),
                                                                ),
                                                                value: 3,
                                                              ),
                                                            ];
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              controller.data[index]['user']
                                                          ['isVerified'] ==
                                                      "1"
                                                  ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          '${controller.data[index]['name']}',
                                                          style:
                                                              GoogleFonts.lato(
                                                            fontSize: 17,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                          textScaleFactor: 1.0,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                          // softWrap: true,
                                                        ),
                                                        Icon(
                                                          Icons.verified,
                                                          color: primayColor,
                                                          size: 15,
                                                        ),
                                                      ],
                                                    )
                                                  : Text(
                                                      '${controller.data[index]['name']}',
                                                      style: GoogleFonts.lato(
                                                          fontSize: 18,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                      textScaleFactor: 1.0,
                                                      maxLines: 2,
                                                    ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Image.asset(
                                                    'assets/icons/location.png',
                                                    scale: 1.7,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    '${controller.data[index]['address']}',
                                                    style: GoogleFonts.lato(
                                                      fontSize: 10,
                                                      color: Colors.black
                                                          .withOpacity(0.5),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Image.asset(
                                                    'assets/icons/broker.png',
                                                    scale: 1.7,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    '${controller.data[index]['personStatus']}',
                                                    style: GoogleFonts.lato(
                                                      fontSize: 10,
                                                      color: Colors.black
                                                          .withOpacity(0.5),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Column(
                                          children: [
                                            SizedBox(
                                              height: 12,
                                            ),

                                            //1st row that has 2 column

                                            Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Product',
                                                      style: GoogleFonts.lato(
                                                        fontSize: 11,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${controller.data[index]['product']}',
                                                      style: GoogleFonts.lato(
                                                        fontSize: 10,
                                                        color: primayColor,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      'No of Items',
                                                      style: GoogleFonts.lato(
                                                        fontSize: 11,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${controller.data[index]['noOfItems']}',
                                                      style: GoogleFonts.lato(
                                                        fontSize: 10,
                                                        color: primayColor,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Weight Per Item',
                                                      style: GoogleFonts.lato(
                                                        fontSize: 11,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${controller.data[index]['weightPerItem']}',
                                                      style: GoogleFonts.lato(
                                                        fontSize: 10,
                                                        color: primayColor,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      'Total Weight',
                                                      style: GoogleFonts.lato(
                                                        fontSize: 11,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${controller.data[index]['totalWeight']}',
                                                      style: GoogleFonts.lato(
                                                        fontSize: 10,
                                                        color: primayColor,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),

                                            // 1st dash line text

                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 3.0, right: 3),
                                              child: Text(
                                                '--------------------',
                                                style: TextStyle(
                                                    letterSpacing: 2,
                                                    fontSize: 20,
                                                    color: Colors.black26),
                                              ),
                                            ),
                                            //2nd row that has 2 column

                                            Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Vehicle',
                                                      style: GoogleFonts.lato(
                                                        fontSize: 11,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${controller.data[index]['vehicle']}',
                                                      style: GoogleFonts.lato(
                                                        fontSize: 10,
                                                        color: primayColor,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      'Pick Up          ',
                                                      style: GoogleFonts.lato(
                                                        fontSize: 11,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${controller.data[index]['pickUp']}',
                                                      style: GoogleFonts.lato(
                                                        fontSize: 10,
                                                        color: primayColor,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Vehicle Type',
                                                      style: GoogleFonts.lato(
                                                        fontSize: 11,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${controller.data[index]['vehicleType']}',
                                                      style: GoogleFonts.lato(
                                                        fontSize: 10,
                                                        color: primayColor,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Drop Off  ',
                                                          style:
                                                              GoogleFonts.lato(
                                                            fontSize: 11,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            dropOffDialog(
                                                              '${controller.data[index]['dropOff2']}',
                                                              '${controller.data[index]['dropOff3']}',
                                                              '${controller.data[index]['dropOff4']}',
                                                              '${controller.data[index]['dropOff5']}',
                                                              '${controller.data[index]['dropOff6']}',
                                                            );
                                                          },
                                                          child: Text(
                                                            '(See more)',
                                                            style: GoogleFonts
                                                                .lato(
                                                              fontSize: 8,
                                                              color:
                                                                  primayColorBlue,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      '${controller.data[index]['dropOff']}',
                                                      style: GoogleFonts.lato(
                                                        fontSize: 10,
                                                        color: primayColor,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),

                                            // 2nd dash line text

                                            SizedBox(
                                              height: 15,
                                            ),
                                            //button
                                            controller.data[index]
                                                        ['requestStatus'] ==
                                                    '1'
                                                ? Container(
                                                    height: 35,
                                                    width: 120,
                                                    decoration: BoxDecoration(
                                                      color: primayColorBlue,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.check_circle,
                                                          color: Colors.white,
                                                          size: 15,
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          'Active',
                                                          style: GoogleFonts
                                                              .montserrat(
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : Container(
                                                    height: 35,
                                                    width: 120,
                                                    decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.pause_circle,
                                                          color: Colors.white,
                                                          size: 15,
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          'Paused',
                                                          style: GoogleFonts
                                                              .montserrat(
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                : null,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  File? imageTwo;
  final pickerTow = ImagePicker();

  // ---- filter sheet
  String dropdownValue = 'Mazda Truck';
  String dropdownValueTwo = 'Flat Bed';
  bool isLoading = false;
  TextEditingController productC = TextEditingController();
  TextEditingController weightItemC = TextEditingController();
  TextEditingController numItemC = TextEditingController();
  TextEditingController totalWeightC = TextEditingController();
  TextEditingController pickUpC = TextEditingController();
  TextEditingController dropOff1 = TextEditingController();
  TextEditingController dropOff2 = TextEditingController();
  TextEditingController dropOff3 = TextEditingController();
  TextEditingController dropOff4 = TextEditingController();
  TextEditingController dropOff5 = TextEditingController();
  TextEditingController dropOff6 = TextEditingController();
  TextEditingController fareC = TextEditingController();

  void _showBottomSheetTwo(Function(File) onImageSelected) {
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
                'Upload Photo',
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
                          onImageSelected(imageTwo!); // Call the callback

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
                          onImageSelected(imageTwo!); // Call the callback

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

  //dropOFfDialog

  Future<void> dropOffDialog(String text1, String text2, String text3,
      String text4, String text5) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            var width = MediaQuery.of(context).size.width;

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: SingleChildScrollView(
                child: Container(
                  height: 420,
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'All Drop Off',
                          style: TextStyle(
                            fontFamily: 'Douro',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: width / 1,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.5),
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    text1.isEmpty || text1 == 'null'
                                        ? 'No Drop Off'
                                        : text1,
                                    style: TextStyle(
                                      fontFamily: 'Douro',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: width / 1,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.5),
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    text2.isEmpty || text2 == 'null'
                                        ? 'No Drop Off'
                                        : text2,
                                    style: TextStyle(
                                      fontFamily: 'Douro',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: width / 1,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.5),
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    text3.isEmpty || text3 == 'null'
                                        ? 'No Drop Off'
                                        : text3,
                                    style: TextStyle(
                                      fontFamily: 'Douro',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: width / 1,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.5),
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    text4.isEmpty || text4 == 'null'
                                        ? 'No Drop Off'
                                        : text4,
                                    style: TextStyle(
                                      fontFamily: 'Douro',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: width / 1,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.5),
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    text5.isEmpty || text5 == 'null'
                                        ? 'No Drop Off'
                                        : text5,
                                    style: TextStyle(
                                      fontFamily: 'Douro',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CustomButton(
                          txtclr: Colors.white,
                          btnclr: primayColorBlue,
                          title: 'Back',
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  //show My add dialog function

  Future<void> _showMyDialog() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            var width = MediaQuery.of(context).size.width;

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: SingleChildScrollView(
                child: Container(
                  height: 1090,
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Request Details',
                          style: TextStyle(
                            fontFamily: 'Douro',
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        InkWell(
                          onTap: () {
                            _showBottomSheetTwo((File selectedImage) {
                              setState(() {
                                imageTwo = selectedImage;
                              });
                            });
                          },
                          child: imageTwo != null
                              ? Container(
                                  height: 155,
                                  width: 170,
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
                                      width: 170,
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 155,
                                  width: 170,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/add-to.png',
                                        scale: 1.7,
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          'Photo',
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.black),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Product',
                                  style: GoogleFonts.lato(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: Colors.black),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                  width: 120,
                                  height: 60,
                                  child: CustomTextField(
                                    hintText: 'Product',
                                    controller: productC,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Weight Per Item',
                                  style: GoogleFonts.lato(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: Colors.black),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                  width: 120,
                                  height: 60,
                                  child: CustomTextField(
                                    hintText: '50 kg',
                                    controller: weightItemC,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'No of Items',
                                  style: GoogleFonts.lato(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: Colors.black),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                  width: 120,
                                  height: 60,
                                  child: CustomTextField(
                                    hintText: '100',
                                    controller: numItemC,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Weight',
                                  style: GoogleFonts.lato(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: Colors.black),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                  width: 120,
                                  height: 60,
                                  child: CustomTextField(
                                    hintText: '5000 kg',
                                    controller: totalWeightC,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Fare',
                                  style: GoogleFonts.lato(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: Colors.black),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                  width: 245,
                                  height: 60,
                                  child: CustomTextField(
                                    hintText: '100',
                                    controller: fareC,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              'Vehicle',
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
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
                                'Mazda Truck',
                                '6 Wheeler',
                                '10 Wheeler',
                                '14 Wheeler',
                                '18 Wheeler',
                                '22 Wheeler',
                              ]
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: TextStyle(
                                            fontSize: 14,
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
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              'Vehicle Type',
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
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
                                'Flat Bed',
                                'Half Body',
                                'Full Body',
                                'Damper',
                                'Container',
                              ]
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ))
                                  .toList(),
                              value: dropdownValueTwo,
                              onChanged: (value) {
                                setState(() {
                                  dropdownValueTwo = value as String;
                                });
                              },
                              buttonStyleData: ButtonStyleData(
                                height: 50,
                                width: 160,
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
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              'Pick Up',
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: width / 1,
                          height: 60,
                          child: CustomTextField(
                            hintText: 'Sahiwal',
                            controller: pickUpC,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Drop Off',
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            // InkWell(
                            //   onTap: () {
                            //     setState(() {
                            //       dropOffControllers
                            //           .add(TextEditingController());
                            //     });
                            //   },
                            //   child: Image.asset(
                            //     'assets/icons/add.png',
                            //     scale: 7,
                            //   ),
                            // ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 200,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                // for (int i = 1;
                                //     i < dropOffControllers.length && i <= 6;
                                //     i++)
                                SizedBox(
                                  width: width / 1,
                                  height: 60,
                                  child: CustomTextField(
                                    hintText: 'Drop Off 1 (Required)',
                                    controller: dropOff1,
                                    // controller: dropOffControllers[i],
                                    // suffixIcon: InkWell(
                                    //   onTap: () {
                                    //     setState(() {
                                    //       if (dropOffControllers.isNotEmpty) {
                                    //         removeTextField(
                                    //             dropOffControllers.length -
                                    //                 1);
                                    //       }
                                    //     });
                                    //   },
                                    //   child: Icon(
                                    //     Icons.cancel,
                                    //     size: 18,
                                    //   ),
                                    // ),
                                  ),
                                ),
                                SizedBox(
                                  width: width / 1,
                                  height: 60,
                                  child: CustomTextField(
                                    hintText: 'Drop Off 2 (Optional)',
                                    controller: dropOff2,
                                  ),
                                ),
                                SizedBox(
                                  width: width / 1,
                                  height: 60,
                                  child: CustomTextField(
                                    hintText: 'Drop Off 3 (Optional)',
                                    controller: dropOff3,
                                  ),
                                ),
                                SizedBox(
                                  width: width / 1,
                                  height: 60,
                                  child: CustomTextField(
                                    hintText: 'Drop Off 4 (Optional)',
                                    controller: dropOff4,
                                  ),
                                ),
                                SizedBox(
                                  width: width / 1,
                                  height: 60,
                                  child: CustomTextField(
                                    hintText: 'Drop Off 5 (Optional)',
                                    controller: dropOff5,
                                  ),
                                ),
                                SizedBox(
                                  width: width / 1,
                                  height: 60,
                                  child: CustomTextField(
                                    hintText: 'Drop Off 6 (Optional)',
                                    controller: dropOff6,

                                    // ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
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
                            isLoading == true
                                ? CircularProgressIndicator(
                                    color: primayColor,
                                  )
                                : InkWell(
                                    onTap: () async {
                                      setState(() {
                                        isLoading =
                                            true; // Show the progress bar
                                      });

                                      try {
                                        await addRequest().then((value) {
                                          Get.offAll(() => Custom_BottomBar(
                                              selectedIndex: 0));
                                        });
                                      } finally {
                                        setState(() {
                                          isLoading =
                                              false; // Show the progress bar
                                        });
                                      }
                                    },
                                    child: Container(
                                      height: 47,
                                      width: 120,
                                      decoration: BoxDecoration(
                                          color: primayColor,
                                          borderRadius:
                                              BorderRadius.circular(30)),
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
      },
    );
  }

  //show my edit dialog function

  Future<void> _showEditMyDialog(
    String productImage,
    String productName,
    String itemWeight,
    String noOfItem,
    String totalWeight,
    String fare,
    String vehicle,
    String vehicleType,
    String pickUp,
    String dropOff,
    String dropOfftwo,
    String dropOff3,
    String dropOff4,
    String dropOff5,
    String dropOff6,
    String personaName,
    String address,
    String personaType,
    int id,
    String userId,
    String requestStatus,
  ) async {
    String image = productImage.toString();
    TextEditingController productController =
        TextEditingController(text: productName);
    TextEditingController weightController =
        TextEditingController(text: itemWeight);
    TextEditingController noOfItemsController =
        TextEditingController(text: noOfItem);
    TextEditingController totalWeightController =
        TextEditingController(text: totalWeight);
    TextEditingController fareController = TextEditingController(text: fare);
    TextEditingController pickUpController =
        TextEditingController(text: pickUp);
    TextEditingController dropOffController =
        TextEditingController(text: dropOff);
    String vehicleName = vehicle.toString();
    String vehicletype = vehicleType.toString();

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            var width = MediaQuery.of(context).size.width;

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: SingleChildScrollView(
                child: Container(
                  height: 970,
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Update Request Details',
                          style: TextStyle(
                            fontFamily: 'Douro',
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        InkWell(
                          onTap: () {
                            _showBottomSheetTwo((File selectedImage) {
                              setState(() {
                                imageTwo = selectedImage;
                              });
                            });
                            },
                          child: imageTwo != null
                              ? Container(
                                  height: 155,
                                  width: 170,
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
                                      width: 170,
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 155,
                                  width: 170,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Colors.grey.withOpacity(0.7),
                                      width: 1,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: CachedNetworkImage(
                                      height: 155,
                                      width: 170,
                                      imageUrl: "${image}",
                                      fit: BoxFit.cover,
                                      progressIndicatorBuilder:
                                          (context, url, downloadProgress) =>
                                              Center(
                                        child: CircularProgressIndicator(
                                            color: primayColor,
                                            value: downloadProgress.progress),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          CircleAvatar(
                                        child: Image.asset(
                                          'assets/images/pp.png',
                                          height: 140,
                                          width: 140,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          'Photo',
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.black),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Product',
                                  style: GoogleFonts.lato(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: Colors.black),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                  width: 120,
                                  height: 60,
                                  child: TextFormField(
                                    cursorColor: Colors.black,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                    ),
                                    onChanged: (newValue) {
                                      // Update the textFieldValue whenever the text field is edited
                                      setState(() {
                                        productName = newValue;
                                      });
                                    },
                                    controller: productController,

                                    // ignore: body_might_complete_normally_nullable
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please Enter product';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                          top: 2, left: 15, right: 15),

                                      border: InputBorder.none,

                                      hintText: 'product',
                                      hintStyle: TextStyle(
                                        color: Colors.black.withOpacity(0.5),
                                        fontSize: 14,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                      ),
                                      // filled: true,
                                      // fillColor: Colors.grey.withOpacity(0.2),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                            color: Colors.grey.withOpacity(0.4),
                                            width: 1),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                            color: Colors.black54, width: 1),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Weight Per Item',
                                  style: GoogleFonts.lato(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: Colors.black),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                  width: 120,
                                  height: 60,
                                  child: TextFormField(
                                    cursorColor: Colors.black,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                    ),
                                    onChanged: (newValue) {
                                      // Update the textFieldValue whenever the text field is edited
                                      setState(() {
                                        itemWeight = newValue;
                                      });
                                    },
                                    controller: weightController,

                                    // ignore: body_might_complete_normally_nullable
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please Enter product';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                          top: 2, left: 15, right: 15),

                                      border: InputBorder.none,

                                      hintText: '50 kg',
                                      hintStyle: TextStyle(
                                        color: Colors.black.withOpacity(0.5),
                                        fontSize: 14,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                      ),
                                      // filled: true,
                                      // fillColor: Colors.grey.withOpacity(0.2),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                            color: Colors.grey.withOpacity(0.4),
                                            width: 1),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                            color: Colors.black54, width: 1),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'No of Items',
                                  style: GoogleFonts.lato(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: Colors.black),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                  width: 120,
                                  height: 60,
                                  child: TextFormField(
                                    cursorColor: Colors.black,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                    ),
                                    onChanged: (newValue) {
                                      // Update the textFieldValue whenever the text field is edited
                                      setState(() {
                                        noOfItem = newValue;
                                      });
                                    },
                                    controller: noOfItemsController,

                                    // ignore: body_might_complete_normally_nullable
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please Enter product';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                          top: 2, left: 15, right: 15),

                                      border: InputBorder.none,

                                      hintText: '100',
                                      hintStyle: TextStyle(
                                        color: Colors.black.withOpacity(0.5),
                                        fontSize: 14,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                      ),
                                      // filled: true,
                                      // fillColor: Colors.grey.withOpacity(0.2),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                            color: Colors.grey.withOpacity(0.4),
                                            width: 1),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                            color: Colors.black54, width: 1),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Weight',
                                  style: GoogleFonts.lato(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: Colors.black),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                  width: 120,
                                  height: 60,
                                  child: TextFormField(
                                    cursorColor: Colors.black,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                    ),
                                    onChanged: (newValue) {
                                      // Update the textFieldValue whenever the text field is edited
                                      setState(() {
                                        totalWeight = newValue;
                                      });
                                    },
                                    controller: totalWeightController,

                                    // ignore: body_might_complete_normally_nullable
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please Enter product';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                          top: 2, left: 15, right: 15),

                                      border: InputBorder.none,

                                      hintText: '5000 kg',
                                      hintStyle: TextStyle(
                                        color: Colors.black.withOpacity(0.5),
                                        fontSize: 14,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                      ),
                                      // filled: true,
                                      // fillColor: Colors.grey.withOpacity(0.2),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                            color: Colors.grey.withOpacity(0.4),
                                            width: 1),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                            color: Colors.black54, width: 1),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Fare',
                                  style: GoogleFonts.lato(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: Colors.black),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                  width: 245,
                                  height: 60,
                                  child: TextFormField(
                                    cursorColor: Colors.black,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                    ),
                                    onChanged: (newValue) {
                                      // Update the textFieldValue whenever the text field is edited
                                      setState(() {
                                        fare = newValue;
                                      });
                                    },
                                    controller: fareController,

                                    // ignore: body_might_complete_normally_nullable
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please Enter product';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                          top: 2, left: 15, right: 15),

                                      border: InputBorder.none,

                                      hintText: 'fare',
                                      hintStyle: TextStyle(
                                        color: Colors.black.withOpacity(0.5),
                                        fontSize: 14,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                      ),
                                      // filled: true,
                                      // fillColor: Colors.grey.withOpacity(0.2),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                            color: Colors.grey.withOpacity(0.4),
                                            width: 1),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                            color: Colors.black54, width: 1),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              'Vehicle',
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
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
                                'Mazda Truck',
                                '6 Wheeler',
                                '10 Wheeler',
                                '14 Wheeler',
                                '18 Wheeler',
                                '22 Wheeler',
                              ]
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ))
                                  .toList(),
                              value: vehicleName,
                              onChanged: (value) {
                                setState(() {
                                  vehicleName = value as String;
                                });
                              },
                              buttonStyleData: ButtonStyleData(
                                height: 50,
                                width: 160,
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
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              'Vehicle Type',
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
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
                                'Flat Bed',
                                'Half Body',
                                'Full Body',
                                'Damper',
                                'Container',
                              ]
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ))
                                  .toList(),
                              value: vehicletype,
                              onChanged: (value) {
                                setState(() {
                                  vehicletype = value as String;
                                });
                              },
                              buttonStyleData: ButtonStyleData(
                                height: 50,
                                width: 160,
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
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              'Pick Up',
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: width / 1,
                          height: 60,
                          child: TextFormField(
                            cursorColor: Colors.black,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                            onChanged: (newValue) {
                              // Update the textFieldValue whenever the text field is edited
                              setState(() {
                                pickUp = newValue;
                              });
                            },
                            controller: pickUpController,

                            // ignore: body_might_complete_normally_nullable
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter product';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(top: 2, left: 15, right: 15),

                              border: InputBorder.none,

                              hintText: 'Sahiwal',
                              hintStyle: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                              // filled: true,
                              // fillColor: Colors.grey.withOpacity(0.2),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.4),
                                    width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide:
                                    BorderSide(color: Colors.black54, width: 1),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Drop Off',
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            // InkWell(
                            //   onTap: () {
                            //     setState(() {
                            //       dropOffControllers
                            //           .add(TextEditingController());
                            //     });
                            //   },
                            //   child: Image.asset(
                            //     'assets/icons/add.png',
                            //     scale: 7,
                            //   ),
                            // ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: width / 1,
                          height: 60,
                          child: TextFormField(
                            cursorColor: Colors.black,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                            onChanged: (newValue) {
                              // Update the textFieldValue whenever the text field is edited
                              setState(() {
                                dropOff = newValue;
                              });
                            },
                            controller: dropOffController,

                            // ignore: body_might_complete_normally_nullable
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter product';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(top: 2, left: 15, right: 15),

                              border: InputBorder.none,

                              hintText: 'Drop Off 1 (Required)',
                              hintStyle: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                              // filled: true,
                              // fillColor: Colors.grey.withOpacity(0.2),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.4),
                                    width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide:
                                    BorderSide(color: Colors.black54, width: 1),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
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
                            isLoading == true
                                ? CircularProgressIndicator(
                                    color: primayColor,
                                  )
                                : InkWell(
                                    onTap: () async {
                                      setState(() {
                                        isLoading =
                                            true; // Show the progress bar
                                      });

                                      try {
                                        await updateRequest(
                                          productImage,
                                          productName,
                                          itemWeight,
                                          noOfItem,
                                          totalWeight,
                                          fare,
                                          vehicleName,
                                          vehicletype,
                                          pickUp,
                                          dropOff,
                                          dropOfftwo,
                                          dropOff3,
                                          dropOff4,
                                          dropOff5,
                                          dropOff6,
                                          personaName,
                                          address,
                                          personaType,
                                          id.toString(),
                                          requestStatus,
                                        ).then((value) {
                                          Get.offAll(() => Custom_BottomBar(
                                              selectedIndex: 0));
                                        });
                                      } finally {
                                        setState(() {
                                          isLoading =
                                              false; // Show the progress bar
                                        });
                                      }
                                    },
                                    child: Container(
                                      height: 47,
                                      width: 120,
                                      decoration: BoxDecoration(
                                          color: primayColor,
                                          borderRadius:
                                              BorderRadius.circular(30)),
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
      },
    );
  }

  void _deleteRequest(int id) {
    print(id);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Request',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this Request?',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: primayColorBlue,
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                _confirmDialog(id);
                Navigator.pop(context);
              },
              child: Text(
                'Delete',
                style: TextStyle(
                  color: primayColor,
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _confirmDialog(int id) async {
    retrieveToken().then((value) async {
      var url = "https://agt.jeuxtesting.com/api/delRequest";

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'id': id}), // Include the id in the request body
      );

      if (response.statusCode == 200) {
        CustomDialogs.showSnakcbar(context, 'Request Deleted Successfully');
      } else {
        CustomDialogs.showSnakcbar(context, 'Deleted Unsuccessfully');
        print(response.body);
      }
      refresh();
    });
  }

  //active pause request

  void statusDialog(var id, var requestStatus) async {
    try {
      var url = "https://agt.jeuxtesting.com/api/updateRequestStatus";

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'id': id,
          'requestStatus': requestStatus,
        }),
      );

      print("Response Body: ${response.body}");

      var data = jsonDecode(response.body.toString());

      if (response.statusCode == 200) {
        CustomDialogs.showSnakcbar(context, data['message']);
      } else {
        CustomDialogs.showSnakcbar(context, "Failed to update status");
      }

      refresh();
    } catch (e) {
      print("Error: $e");
      CustomDialogs.showSnakcbar(context, "Error occurred: $e");
    }
  }

  //add my request function

  Future<void> addRequest() async {
    String product = productC.text.toString() ?? "";
    String weightOfProduct = weightItemC.text.toString() ?? '';
    String noOfItem = numItemC.text.toString() ?? '';
    String totalWeight = totalWeightC.text.toString() ?? '';
    String fare = fareC.text.toString() ?? '';
    String vehicleName = dropdownValue.toString() ?? '';
    String vehicleType = dropdownValueTwo.toString() ?? '';
    String pickUp = pickUpC.text.toString() ?? '';

    String dropOf1 = dropOff1.text.toString() ?? '';
    String dropOf2 = dropOff2.text.toString() ?? '';
    String dropOf3 = dropOff3.text.toString() ?? '';
    String dropOf4 = dropOff4.text.toString() ?? '';
    String dropOf5 = dropOff5.text.toString() ?? '';
    String dropOf6 = dropOff6.text.toString() ?? '';
    //
    File? imageUrl = imageTwo;

    setState(() {
      isLoading = true;
    });

    try {
      // Prepare the API request
      String apiUrl = 'https://agt.jeuxtesting.com/api/addRequests';

      // Create a new multipart request
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      var imageStream = http.ByteStream(imageUrl!.openRead());
      var length = await imageUrl.length();
      var multipartFile = http.MultipartFile(
        'image',
        imageStream,
        length,
        filename: '1.png', // Use a valid filename
      );
      request.files.add(multipartFile);

      // Add other sign-up fields as needed
      request.fields['userId'] = userId.toString();
      request.fields['name'] = name.toString();
      request.fields['address'] = address == null ? '' : '${address}';
      request.fields['personStatus'] = type.toString();
      request.fields['product'] = product.toString();
      request.fields['weightPerItem'] = weightOfProduct.toString();
      request.fields['noOfItems'] = noOfItem.toString();
      request.fields['totalWeight'] = totalWeight.toString();
      request.fields['freight'] = fare.toString();
      request.fields['vehicle'] = vehicleName.toString();
      request.fields['vehicleType'] = vehicleType.toString();
      request.fields['pickUp'] = pickUp.toString();

      request.fields['dropOff'] = dropOf1;
      request.fields['dropOff2'] = dropOf2;
      request.fields['dropOff3'] = dropOf3;
      request.fields['dropOff4'] = dropOf4;
      request.fields['dropOff5'] = dropOf5;
      request.fields['dropOff6'] = dropOf6;

      request.fields['note'] = '';
      request.fields['requestStatus'] = '1';

      // Add the bearer token to the request headers
      String bearerToken =
          token.toString(); // Replace with your actual bearer token
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

  //update my request

  Future<void> updateRequest(
    String productImage,
    String productName,
    String itemWeight,
    String noOffItem,
    String totalweight,
    String faree,
    String vehicle,
    String vehicleTypee,
    String pickUpp,
    String dropOff,
    String dropOff2,
    String dropOff3,
    String dropOff4,
    String dropOff5,
    String dropOff6,
    String personaName,
    String address,
    String personaType,
    String id,
    String requeststatus,
  ) async {
    String product = productName.toString() ?? "";
    String weightOfProduct = itemWeight.toString() ?? '';
    String noOfItem = noOffItem.toString() ?? '';
    String totalWeight = totalweight.toString() ?? '';
    String fare = faree.toString() ?? '';
    String vehicleName = vehicle.toString() ?? '';
    String vehicleType = vehicleTypee.toString() ?? '';
    String pickUp = pickUpp.toString() ?? '';
    String dropOf1 = dropOff.toString() ?? '';
    String Id = id;
    String namee = name.toString() ?? '';
    String userIdd = userId.toString() ?? '';

    //
    File? imageUrl = imageTwo;

    setState(() {
      isLoading = true;
    });

    try {
      // Prepare the API request
      String apiUrl = 'https://agt.jeuxtesting.com/api/updateRequests';

      // Create a new multipart request
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      if (imageTwo != null) {
        var imageStream = http.ByteStream(imageUrl!.openRead());
        var length = await imageUrl.length();
        var multipartFile = http.MultipartFile(
          'image',
          imageStream,
          length,
          filename: '1.png', // Use a valid filename
        );
        request.files.add(multipartFile);
      }

      // Add other sign-up fields as needed
      request.fields['id'] = Id;
      request.fields['userId'] = userIdd.toString();
      request.fields['name'] = namee.toString();
      request.fields['address'] = address.isEmpty ? '' : '${address}';
      request.fields['personStatus'] = type.toString();
      request.fields['product'] = product.toString();
      request.fields['weightPerItem'] = weightOfProduct;
      request.fields['noOfItems'] = noOfItem;
      request.fields['totalWeight'] = totalWeight;
      request.fields['freight'] = fare;
      request.fields['vehicle'] = vehicleName.toString();
      request.fields['vehicleType'] = vehicleType.toString();
      request.fields['requestStatus'] = requeststatus.toString();
      request.fields['pickUp'] = pickUp.toString();
      request.fields['dropOff'] = dropOf1.toString();
      request.fields['dropOff2'] = dropOff2.isEmpty ? "" : dropOff2.toString();
      request.fields['dropOff3'] = dropOff3.isEmpty ? "" : dropOff3.toString();
      request.fields['dropOff4'] = dropOff4.isEmpty ? "" : dropOff4.toString();
      request.fields['dropOff5'] = dropOff5.isEmpty ? "" : dropOff5.toString();
      request.fields['dropOff6'] = dropOff6.isEmpty ? "" : dropOff6.toString();
      request.fields['note'] = "---";

      // Add the bearer token to the request headers
      String bearerToken =
          token.toString(); // Replace with your actual bearer token
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
        print(request.fields);

        // Handle errors here
        if (data['message'] != null) {
          print(data);
          CustomDialogs.showSnakcbar(context, data['message']);
        } else {
          print(data);
          print(request.fields);

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
