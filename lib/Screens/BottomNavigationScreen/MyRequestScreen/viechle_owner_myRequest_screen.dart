import 'dart:convert';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:goods_transport/Constant/Controller/show_vehicleOwner_request_controller.dart';
import 'package:goods_transport/Constant/colors_constant.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Constant/const.dart';
import '../../../Constant/dialoag_widget.dart';
import '../../../Models/broker_verification_model.dart';
import '../../../Widegts/custom_text_field.dart';
import 'package:http/http.dart' as http;

import '../viechleOwner_side_custom_navigationbar.dart';

class ViechleOwnerMyRequestScreen extends StatefulWidget {
  const ViechleOwnerMyRequestScreen({super.key});

  @override
  State<ViechleOwnerMyRequestScreen> createState() =>
      _ViechleOwnerMyRequestScreenState();
}

class _ViechleOwnerMyRequestScreenState
    extends State<ViechleOwnerMyRequestScreen> {
  TextEditingController pickUpC = TextEditingController();
  TextEditingController dropOffC = TextEditingController();

  String dropdownValue = 'Mazda Truck';
  String dropdownValueTwo = 'Flat Bed';
  String? token;
  String? userId;
  String? type;
  String? name;
  String? phone;
  bool isLoading = false;
  String? address;

  Future<void> retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      type = prefs.getString('personStatus');
      name = prefs.getString('name');
      userId = prefs.getString('id');
      phone = prefs.getString('phoneNo');
    });
  }

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

  Future<List<String>> getAllCategory() async {
    var baseUrl = "https://gssskhokhar.com/api/classes/";

    http.Response response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<String> items = [];
      var jsonData = json.decode(response.body) as List;
      for (var element in jsonData) {
        items.add(element["ClassName"]);
      }
      return items;
    } else {
      //Handle Errors
      throw response.statusCode;
    }
  }

  var controller = Get.put(VehicleOwnerReuestScreen_Controller());

  Future refresh() async {
    await controller.getVehicleOwnerReuestData();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveToken().then((value) {
      refresh();
      fetchCurrentUser();
    });
    setState(() {
      controller.getVehicleOwnerReuestData();
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
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15, bottom: 10),
                            child: userId == controller.data[index]['userId']
                                ? Container(
                                    width: width / 1,
                                    height: 210,
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
                                          padding: EdgeInsets.all(5.0),
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
                                                    height: 195,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                          '${controller.data[index]['user']['imageUrl']}',
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
                                                              _showUpdateMyDialog(
                                                                '${controller.data[index]['vehicle']}',
                                                                '${controller.data[index]['vehicleType']}',
                                                                controller.data[
                                                                            index]
                                                                        [
                                                                        'pickUp'] ??
                                                                    '',
                                                                controller.data[
                                                                            index]
                                                                        [
                                                                        'dropOff'] ??
                                                                    '',
                                                                controller.data[index]
                                                                            [
                                                                            'user']
                                                                        [
                                                                        'name'] ??
                                                                    '',
                                                                controller.data[
                                                                            index]
                                                                        [
                                                                        'address'] ??
                                                                    '',
                                                                controller.data[index]
                                                                            [
                                                                            'user']
                                                                        [
                                                                        'personStatus'] ??
                                                                    '',
                                                                controller.data[
                                                                            index]
                                                                        [
                                                                        'userId'] ??
                                                                    '',
                                                                controller.data[
                                                                            index]
                                                                        [
                                                                        'requestStatus'] ??
                                                                    '',
                                                                controller.data[
                                                                        index]
                                                                    ['id'],
                                                                controller.data[
                                                                            index]
                                                                        [
                                                                        'phone'] ??
                                                                    '',
                                                                controller.data[
                                                                            index]
                                                                        [
                                                                        'phoneOpt'] ??
                                                                    '',
                                                                controller.data[
                                                                            index]
                                                                        [
                                                                        'vOwnerId'] ??
                                                                    '',
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
                                                                _deleteFeed(controller
                                                                        .data
                                                                        .value[
                                                                    index]['id']);
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
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            controller.data[index]['user']['isVerified'] == "1"
                                                ? Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '${controller.data[index]['name']}',
                                                  style: GoogleFonts.lato(
                                                    fontSize: 17,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  textScaleFactor: 1.0,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  // softWrap: true,
                                                ),
                                                Icon(
                                                  Icons.verified,
                                                  color: primayColor,
                                                  size: 15,
                                                ),
                                              ],
                                            ) :
                                            Text(
                                              '${controller.data[index]['user']['name']}',
                                              style: GoogleFonts.lato(
                                                fontSize: 18,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              textScaleFactor: 1.0,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                              maxLines:
                                                  2, // Adjust this value to control the number of lines before ellipsis.
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Image.asset(
                                                  'assets/icons/location.png',
                                                  scale: 1.4,
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
                                                  'assets/icons/car.png',
                                                  scale: 1.4,
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
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 3.0, right: 3),
                                              child: Text(
                                                '-------------------',
                                                style: TextStyle(
                                                    letterSpacing: 2,
                                                    fontSize: 20,
                                                    color: Colors.black26),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                //left column
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 5,
                                                    ),
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
                                                      'Available From',
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

                                                //right column

                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 5,
                                                    ),
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
                                                    Text(
                                                      'Available To',
                                                      style: GoogleFonts.lato(
                                                        fontSize: 11,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
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
                                            SizedBox(
                                              height: 8,
                                            ),
                                            controller.data[index]
                                                        ['requestStatus'] ==
                                                    '1'
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 15.0),
                                                    child: Container(
                                                      height: 35,
                                                      width: 120,
                                                      decoration: BoxDecoration(
                                                        color: primayColorBlue,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
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
                                                                    fontSize:
                                                                        10,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 15.0),
                                                    child: Container(
                                                      height: 35,
                                                      width: 120,
                                                      decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
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
                                                                    fontSize:
                                                                        10,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                            SizedBox(
                                              height: 6,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
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

  // ---- filter sheet

  Future<void> _showMyDialog() async {
    showDialog(
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
                  height: 480,
                  width: 150,
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
                          height: 15,
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
                              'Available From',
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
                              'Available To',
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            // Image.asset('assets/icons/add.png',scale: 7,),
                          ],
                        ),

                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: width / 1,
                          height: 60,
                          child: CustomTextField(
                            hintText: 'Lahore',
                            controller: dropOffC,
                          ),
                        ),

                        SizedBox(
                          height: 5,
                        ),
                        // SizedBox(
                        //   width: width/1,
                        //   height: 60,
                        //   child: CustomTextField(
                        //     hintText: 'Lahore no 2',
                        //     // controller: passwordC,
                        //   ),
                        // ),
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
                            isLoading
                                ? CircularProgressIndicator(
                                    color: primayColor,
                                  )
                                : InkWell(
                                    onTap: () async {
                                      setState(() {
                                        isLoading = true;
                                      });

                                      try {
                                        await  postVehicleRequestData().then((value) {
                                          Get.offAll(
                                                () =>
                                                ViechleOwnerSideCustom_BottomBar(
                                                    selectedIndex: 0),
                                          );
                                        });
                                      }
                                      finally {
                                        setState(() {
                                          isLoading = false;
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

  //show my update dialog

  Future<void> _showUpdateMyDialog(
    String vehicle,
    String vehicleType,
    String pickUp,
    String dropOff,
    String personalName,
    String address,
    String personaType,
    String userId,
    String requestStatus,
    int id,
    String phone,
    String phoneOTP,
    String vOwnerId,
  ) async {
    String vehicleName = vehicle.toString();
    String vehicletype = vehicleType.toString();

    TextEditingController pickUpController =
        TextEditingController(text: pickUp);
    TextEditingController dropOffController =
        TextEditingController(text: dropOff);

    showDialog(
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
                  height: 480,
                  width: 150,
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
                          height: 15,
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
                                print(value);
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
                              'Available From',
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
                              'Available To',
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            // Image.asset('assets/icons/add.png',scale: 7,),
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
                          height: 5,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                // Navigator.pop(context);
                                Navigator.pop(context);
                                print('my id is $id');
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
                                : isLoading == true
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
                                            await updateVehicleRequestData(
                                              vehicleName,
                                              vehicletype,
                                              pickUp,
                                              dropOff,
                                              personalName,
                                              address,
                                              personaType,
                                              userId,
                                              requestStatus,
                                              id,
                                              phone,
                                              phoneOTP,
                                              vOwnerId,
                                            );

                                            Get.offAll(
                                              () =>
                                                  ViechleOwnerSideCustom_BottomBar(
                                                      selectedIndex: 0),
                                            );
                                          } finally {
                                            setState(() {
                                              isLoading =
                                                  false; // Hide the progress bar
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

  void _deleteFeed(int id) {
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
      var url = "https://agt.jeuxtesting.com/api/delVehicleRequest";

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
      var url = "https://agt.jeuxtesting.com/api/updateVehicleRequestStatus";

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

      print("HTTP Status Code: ${response.statusCode}");
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

  //add request function

  Future<void> postVehicleRequestData() async {
    final String apiUrl = "https://agt.jeuxtesting.com/api/addVehicleRequest";


    print('user id $userId');
    print('user name $name');
    print('user typ $type');
    print('user phone $phone');

    setState(() {
      isLoading = true;
    });

    // Replace this map with your actual data
    Map<String, dynamic> data = {
      "userId": userId.toString(),
      "name": name.toString(),
      "address": address == null ? '' : '${address}',
      "personStatus": type.toString(),
      "vehicle": dropdownValue.toString(),
      "vehicleType": dropdownValueTwo.toString(),
      "pickUp": pickUpC.text.toString(),
      "dropOff": dropOffC.text.toString(),
      "requestStatus": 1,
      "phone": phone,
      "vOwnerId": 123,
      "phoneOpt": 1122,
      "note": '',
      // Add other fields as needed
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          // "Accept": "application/json",
          "Authorization": "Bearer $token",
          "Content-Type": "application/json", // Add Content-Type header
        },
        body: jsonEncode(data),
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        print("POST request successful!");
        CustomDialogs.showSnakcbar(context, 'Data Added Successfully');
        print("Response: ${response.body}");
      } else {
        CustomDialogs.showSnakcbar(context, 'Failed to add data');
        throw Exception(
            "Failed to post data. Status code: ${response.statusCode}");
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

  //update request function

  Future<void> updateVehicleRequestData(
    String vehicle,
    String vehicleType,
    String pickUp,
    String dropOff,
    String personalName,
    String address,
    String personaType,
    String userIds,
    String requestStatus,
    int id,
    String phone,
    String phoneOTP,
    String vOwnerId,
  ) async {
    try {
      // Add print statements to identify the null variable
      print('personalName: $personalName');

      String vehicleName = vehicle ?? "";
      String vehicleTypee = vehicleType ?? "";
      String pickUpp = pickUp ?? "";
      String dropOf1 = dropOff ?? "";
      String type = personaType ?? "";
      String reqStatus = requestStatus ?? "";
      String phn = phone ?? "";
      String phnOtp = phoneOTP ?? "";
      String vID = vOwnerId ?? "";
      int Id = id;

      print('vehicleName: $vehicleName');
      print('vehicleTypee: $vehicleTypee');
      print('pickUpp: $pickUpp');
      print('dropOf1: $dropOf1');
      print('Id: $Id');

      final String apiUrl =
          "https://agt.jeuxtesting.com/api/updateVehicleRequest";

      setState(() {
        isLoading = true;
      });

      // Replace this map with your actual data
      Map<String, dynamic> data = {
        "vehicle": vehicleName.toString(),
        "vehicleType": vehicleTypee.toString(),
        "pickUp": pickUpp.toString() ?? "",
        "dropOff": dropOf1 ?? "",
        "name": personalName.toString() ?? "",
        "address": address.isEmpty ? '' : '${address}',
        "personStatus": type.toString() ?? "",
        "userId": userId.toString() ?? "",
        "requestStatus": reqStatus ?? "",
        "id": Id,
        "phone": phn ?? "",
        "phoneOpt": phnOtp ?? "",
        "vOwnerId": vID ?? "",
        "note": '--',
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        print(data);
        CustomDialogs.showSnakcbar(context, 'Update data');
        print("Response: ${response.body}");
      } else {
        CustomDialogs.showSnakcbar(context, 'Failed to add data');
        throw Exception(
            "Failed to post data. Status code: ${response.statusCode}");
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
