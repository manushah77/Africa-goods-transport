import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:goods_transport/Constant/Controller/show_brokerRequest_cobtroller.dart';
import 'package:goods_transport/Constant/colors_constant.dart';
import 'package:goods_transport/Constant/dialoag_widget.dart';
import 'package:goods_transport/Screens/BottomNavigationScreen/HomeScreen/help_request_screen.dart';
import 'package:goods_transport/Screens/BottomNavigationScreen/MyRequestScreen/myRequestScreen.dart';
import 'package:goods_transport/Widegts/custom_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Models/broker_verification_model.dart';
import '../../../Widegts/custom_text_field.dart';
import 'package:http/http.dart' as http;

class ViechleOwnerHomeScreen extends StatefulWidget {
  const ViechleOwnerHomeScreen({super.key});

  @override
  State<ViechleOwnerHomeScreen> createState() => _ViechleOwnerHomeScreenState();
}

class _ViechleOwnerHomeScreenState extends State<ViechleOwnerHomeScreen> {
  String? token;
  String? id;

  Future retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      id = prefs.getString('id');
    });
  }

  var controller = Get.put(BrokerReuestScreen_Controller());

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
        return User.fromJson(userJson);
      } else {
        throw Exception(jsonBody['message']);
      }
    } else {
      throw Exception(
          'Failed to connect to the API. Error code: ${response.statusCode}');
    }
  }

  void search(String keyword) {
    setState(() {
      controller.data.value = controller.searchData.value.where((item) {
        final title = item['name'].toString().toLowerCase();
        return title.contains(keyword.toLowerCase());
      }).toList();
    });
  }

  void filter(String keyword, String types, String pickup, String userType) {
    setState(() {
      controller.data.value = controller.searchData.value.where((item) {
        final title = item['vehicle'].toString().toLowerCase();
        final type = item['vehicleType'].toString().toLowerCase();
        final pickUp = item['pickUp'].toString().toLowerCase();
        final usertype = item['personStatus'].toString().toLowerCase();
        return title.contains(keyword.toLowerCase().trim()) &&
            type.contains(types.toLowerCase().trim()) &&
            pickUp.contains(pickup.toLowerCase().trim()) &&
            usertype.contains(userType.toLowerCase().trim());
      }).toList();
    });
  }

  Future refresh() async {
    await controller.getBrokerReuestData();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveToken().then((value) {
      fetchCurrentUser();
      refresh();
    });
    controller.getBrokerReuestData();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: primayColorBlue,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
        ),
        backgroundColor: Color(0xff98C7DB),
        automaticallyImplyLeading: false,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            FutureBuilder<User>(
                future: fetchCurrentUser(),
                builder: (context, AsyncSnapshot sp) {
                  if (!sp.hasData) {
                    return Center();
                  }

                  var currentUser = sp.data;

                  return Container(
                    height: 170,
                    width: double.infinity,
                    color: primayColorBlue,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20, top: 10),
                          child: Row(
                            children: [
                              Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        NetworkImage('${currentUser.imageUrl}'),
                                    fit: BoxFit.cover,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome Back',
                                    style: GoogleFonts.lato(
                                        fontSize: 14, color: Colors.white),
                                  ),
                                  Text(
                                    '${currentUser.name}',
                                    style: GoogleFonts.lato(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  Get.to(HelpRequetScreen());
                                },
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.info,
                                      color: Colors.black,
                                      size: 23,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30)),
                            width: width / 1,
                            child: CustomTextField(
                              prefixIcon: Image.asset(
                                'assets/icons/search.png',
                                scale: 1.5,
                              ),
                              onchange: (val) {
                                search(val);
                                print(val);
                              },
                              hintText: 'Search...',
                              suffixIcon: Padding(
                                padding: EdgeInsets.only(right: 12.0),
                                child: InkWell(
                                  onTap: () {
                                    filterSheetModel();
                                  },
                                  child: Container(
                                    height: 10,
                                    width: 10,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xffDBDBDB),
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                        'assets/icons/filter.png',
                                        scale: 1.7,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            SizedBox(
              height: 20,
            ),
            Obx(
              () => controller.isLoading.value == true
                  ? Center(
                      child: CircularProgressIndicator(
                        color: primayColor,
                      ),
                    )
                  : controller.data.isEmpty
                      ? Center(
                          child: Text('No matching data found.'),
                        )
                      : Container(
                          height:  height / 1.71,
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
                                  child: controller.data[index]
                                              ['requestStatus'] ==
                                          '1'
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
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
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
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.grey,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16),
                                                            image:
                                                                DecorationImage(
                                                              image:
                                                                  NetworkImage(
                                                                '${controller.data[index]['image']}',
                                                              ),
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    controller.data[index]
                                                                    ['user'][
                                                                'isVerified'] ==
                                                            "1"
                                                        ? Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                '${controller.data[index]['name']}',
                                                                style:
                                                                    GoogleFonts
                                                                        .lato(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                                textScaleFactor:
                                                                    1.0,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 2,
                                                                // softWrap: true,
                                                              ),
                                                              Icon(
                                                                Icons.verified,
                                                                color:
                                                                    primayColor,
                                                                size: 15,
                                                              ),
                                                            ],
                                                          )
                                                        : Text(
                                                            '${controller.data[index]['name']}',
                                                            style: GoogleFonts.lato(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                            textScaleFactor:
                                                                1.0,
                                                            maxLines: 2,
                                                          ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
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
                                                          style:
                                                              GoogleFonts.lato(
                                                            fontSize: 10,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.5),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
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
                                                          style:
                                                              GoogleFonts.lato(
                                                            fontSize: 10,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.5),
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
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Product',
                                                            style: GoogleFonts
                                                                .lato(
                                                              fontSize: 11,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                          Text(
                                                            '${controller.data[index]['product']}',
                                                            style: GoogleFonts
                                                                .lato(
                                                              fontSize: 10,
                                                              color:
                                                                  primayColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            'No of Items',
                                                            style: GoogleFonts
                                                                .lato(
                                                              fontSize: 11,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                          Text(
                                                            '${controller.data[index]['noOfItems']}',
                                                            style: GoogleFonts
                                                                .lato(
                                                              fontSize: 10,
                                                              color:
                                                                  primayColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: 15,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Weight Per Item',
                                                            style: GoogleFonts
                                                                .lato(
                                                              fontSize: 11,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                          Text(
                                                            '${controller.data[index]['weightPerItem']}',
                                                            style: GoogleFonts
                                                                .lato(
                                                              fontSize: 10,
                                                              color:
                                                                  primayColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            'Total Weight',
                                                            style: GoogleFonts
                                                                .lato(
                                                              fontSize: 11,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                          Text(
                                                            '${controller.data[index]['totalWeight']}',
                                                            style: GoogleFonts
                                                                .lato(
                                                              fontSize: 10,
                                                              color:
                                                                  primayColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),

                                                  // 1st dash line text

                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 3.0,
                                                            right: 3),
                                                    child: Text(
                                                      '--------------------',
                                                      style: TextStyle(
                                                          letterSpacing: 2,
                                                          fontSize: 20,
                                                          color:
                                                              Colors.black26),
                                                    ),
                                                  ),
                                                  //2nd row that has 2 column

                                                  Row(
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Vehicle',
                                                            style: GoogleFonts
                                                                .lato(
                                                              fontSize: 11,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                          Text(
                                                            '${controller.data[index]['vehicle']}',
                                                            style: GoogleFonts
                                                                .lato(
                                                              fontSize: 10,
                                                              color:
                                                                  primayColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            'Pick Up          ',
                                                            style: GoogleFonts
                                                                .lato(
                                                              fontSize: 11,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                          Text(
                                                            '${controller.data[index]['pickUp']}',
                                                            style: GoogleFonts
                                                                .lato(
                                                              fontSize: 10,
                                                              color:
                                                                  primayColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: 15,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Vehicle Type',
                                                            style: GoogleFonts
                                                                .lato(
                                                              fontSize: 11,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                          Text(
                                                            '${controller.data[index]['vehicleType']}',
                                                            style: GoogleFonts
                                                                .lato(
                                                              fontSize: 10,
                                                              color:
                                                                  primayColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
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
                                                                    GoogleFonts
                                                                        .lato(
                                                                  fontSize: 11,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
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
                                                                  style:
                                                                      GoogleFonts
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
                                                            style: GoogleFonts
                                                                .lato(
                                                              fontSize: 10,
                                                              color:
                                                                  primayColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),

                                                  // 2nd dash line text

                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 3.0,
                                                            right: 3),
                                                    child: Text(
                                                      '-------------------',
                                                      style: TextStyle(
                                                          letterSpacing: 2,
                                                          fontSize: 20,
                                                          color:
                                                              Colors.black26),
                                                    ),
                                                  ),
                                                  //button

                                                  Row(

                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          _makePhoneCall(
                                                              '${controller.data[index]['user']['phoneNo']}');
                                                        },
                                                        child: Container(
                                                          height: 30,
                                                          width: 70,
                                                          decoration: BoxDecoration(
                                                            color: Color(0xff25AE6A),
                                                            borderRadius: BorderRadius.circular(30),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment.center,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment.center,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                const EdgeInsets.only(top: 8.0),
                                                                child: Image.asset(
                                                                  'assets/images/cal.png',
                                                                  scale: 3,
                                                                ),
                                                              ),
                                                              Text(
                                                                'Call',
                                                                style: GoogleFonts.lato(
                                                                  fontSize: 12,
                                                                  color: Colors.white,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          openWhatsApp(
                                                              '${controller.data[index]['user']['phoneNo']}');
                                                        },
                                                        child: Container(
                                                          height: 30,
                                                          width: 80,
                                                          decoration: BoxDecoration(
                                                            color: Color(0xff25AE6A),
                                                            borderRadius: BorderRadius.circular(30),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment.center,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment.center,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                const EdgeInsets.only(top: 8.0),
                                                                child: Image.asset(
                                                                  'assets/images/cal.png',
                                                                  scale: 3,
                                                                ),
                                                              ),
                                                              Text(
                                                                'WhatsApp',
                                                                style: GoogleFonts.lato(
                                                                  fontSize: 10,
                                                                  color: Colors.white,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
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
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  //for phone call
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
  Future<void> openWhatsApp(String phoneNumber) async {
    var whatsapp = phoneNumber;
    var androidUrl = "whatsapp://send?phone=$whatsapp&text=Hi";
    try {
      await launchUrl(Uri.parse(androidUrl));
    } catch (e) {
     CustomDialogs.showSnakcbar(context, 'Please Install WHATSAPP');
    }
  }


  // ---- filter sheet
  String dropdownValue = 'Mazda Truck';
  String dropdownValueTwo = 'Flat Bed';
  TextEditingController pickpC = TextEditingController();
  TextEditingController dropOffC = TextEditingController();
  TextEditingController limitC = TextEditingController();

  // double sval2 = 0;
  RangeValues _currentRangeValues = RangeValues(500, 6000);

  void filterSheetModel() {
    showModalBottomSheet(
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        var width = MediaQuery.of(context).size.width;

        return Container(
          height: 550,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Filter',
                  style: TextStyle(
                      fontFamily: 'Douro',
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
                // SizedBox(
                //   height: 10,
                // ),

                // Padding(
                //   padding: const EdgeInsets.only(left: 18.0),
                //   child: Row(
                //     children: [
                //       Text(
                //         'Total Weight',
                //         style: GoogleFonts.lato(
                //             fontSize: 18,
                //             color: Colors.black,
                //             fontWeight: FontWeight.w400),
                //       ),
                //     ],
                //   ),
                // ),
                // SizedBox(
                //   height: 10,
                // ),
                // RangeSlider(
                //   activeColor: Colors.grey.withOpacity(0.6),
                //   inactiveColor: Colors.blue,
                //   // overlayColor: MaterialStateProperty.all(Colors.blue),
                //
                //   values: _currentRangeValues,
                //   max: 6000,
                //   min: 500,
                //   // divisions: 20,
                //
                //   onChanged: (values) {
                //     setState(() {
                //       _currentRangeValues = values;
                //     });
                //   },
                // ),
                // SizedBox(
                //   height: 3,
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 20, right: 20),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Text('${_currentRangeValues.start.round().toInt()} Kg'),
                //       Text('${_currentRangeValues.end.round().toInt()} Kg'),
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 18.0, left: 18),
                  child: Container(
                    height: 50,
                    width: width / 1,
                    decoration: BoxDecoration(
                      color: primayColorBlue,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.verified,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Verified Only',
                          style: GoogleFonts.montserrat(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          selectedContainerIndex = 0;
                          isSelected = true;
                          isSelectedTwo = false;
                        });
                      },
                      child: Container(
                        height: 44,
                        width: 140,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.green : Color(0xffDBDBDB),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Center(
                          child: Text(
                            'Broker',
                            style: GoogleFonts.montserrat(
                              color: isSelected ? Colors.white : Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          selectedContainerIndex = 1;
                          isSelected = false;
                          isSelectedTwo = true;
                        });
                      },
                      child: Container(
                        height: 44,
                        width: 140,
                        decoration: BoxDecoration(
                          color:
                              isSelectedTwo ? Colors.green : Color(0xffDBDBDB),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Center(
                          child: Text(
                            'User',
                            style: GoogleFonts.montserrat(
                              color:
                                  isSelectedTwo ? Colors.white : Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 10,
                ),

                //vhicle name drop down
                Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Row(
                    children: [
                      Text(
                        'Vehicle',
                        style: GoogleFonts.lato(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
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
                //vhicle type drop down

                Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Row(
                    children: [
                      Text(
                        'Vehicle Type',
                        style: GoogleFonts.lato(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
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

                // pick up vhiecle text

                Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Row(
                    children: [
                      Text(
                        'Pick Up',
                        style: GoogleFonts.lato(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18),
                  child: SizedBox(
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
                      onChanged: (newValue) {},
                      controller: pickpC,

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
                              color: Colors.grey.withOpacity(0.4), width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              BorderSide(color: Colors.black54, width: 1),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                // drop off vhiecle text

                Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Row(
                    children: [
                      Text(
                        'Drop Off',
                        style: GoogleFonts.lato(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18),
                  child: SizedBox(
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
                      onChanged: (newValue) {},
                      controller: dropOffC,

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

                        hintText: 'Lahore',
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
                              color: Colors.grey.withOpacity(0.4), width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              BorderSide(color: Colors.black54, width: 1),
                        ),
                      ),
                    ),
                  ),
                ),

                // SizedBox(
                //   height: 10,
                // ),
                //
                // // Geographical Limitations text
                //
                // Padding(
                //   padding: const EdgeInsets.only(left: 18.0),
                //   child: Row(
                //     children: [
                //       Text(
                //         'Geographical Limitations',
                //         style: GoogleFonts.lato(
                //             fontSize: 18,
                //             color: Colors.black,
                //             fontWeight: FontWeight.w400),
                //       ),
                //     ],
                //   ),
                // ),
                // SizedBox(
                //   height: 10,
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 18.0, right: 18),
                //   child: SizedBox(
                //     width: width / 1,
                //     height: 60,
                //     child: TextFormField(
                //       cursorColor: Colors.black,
                //       style: TextStyle(
                //         color: Colors.black,
                //         fontSize: 14,
                //         fontFamily: 'Inter',
                //         fontWeight: FontWeight.w400,
                //       ),
                //       onChanged: (newValue) {},
                //       controller: limitC,
                //
                //       // ignore: body_might_complete_normally_nullable
                //       validator: (value) {
                //         if (value!.isEmpty) {
                //           return 'Please Enter product';
                //         }
                //         return null;
                //       },
                //       decoration: InputDecoration(
                //         contentPadding:
                //             EdgeInsets.only(top: 2, left: 15, right: 15),
                //
                //         border: InputBorder.none,
                //
                //         hintText: 'Johar Town',
                //         hintStyle: TextStyle(
                //           color: Colors.black.withOpacity(0.5),
                //           fontSize: 14,
                //           fontFamily: 'Inter',
                //           fontWeight: FontWeight.w400,
                //         ),
                //         // filled: true,
                //         // fillColor: Colors.grey.withOpacity(0.2),
                //         enabledBorder: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(30),
                //           borderSide: BorderSide(
                //               color: Colors.grey.withOpacity(0.4), width: 1),
                //         ),
                //         focusedBorder: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(30),
                //           borderSide:
                //               BorderSide(color: Colors.black54, width: 1),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 56,
                        width: 150,
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
                    InkWell(
                      onTap: () {
                        filter(
                            dropdownValue,
                            dropdownValueTwo,
                            pickpC.text.trim().toString(),
                            selectedContainerIndex == 0 ? 'Broker' : 'User');
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 56,
                        width: 150,
                        decoration: BoxDecoration(
                            color: primayColor,
                            borderRadius: BorderRadius.circular(30)),
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
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  int selectedContainerIndex = 0;
  bool isSelected = true;
  bool isSelectedTwo = false;

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
}
