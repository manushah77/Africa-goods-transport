import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:goods_transport/Constant/Controller/ger_all_user_controller.dart';
import 'package:goods_transport/Widegts/custom_button.dart';
import 'package:goods_transport/Widegts/custom_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Constant/colors_constant.dart';

class VerifiedAccountScreen extends StatefulWidget {
  const VerifiedAccountScreen({super.key});

  @override
  State<VerifiedAccountScreen> createState() => _VerifiedAccountScreenState();
}

class _VerifiedAccountScreenState extends State<VerifiedAccountScreen> {
  String? token;
  String? userId;
  String? type;
  String? name;
  String? phone;

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

  var controller = Get.put(GetAllUser_Controller());

  void search(String keyword) {
    setState(() {
      controller.data.value = controller.searchData.value.where((item) {
        final title = item['user']['name'].toString().toLowerCase();
        return title.contains(keyword.toLowerCase());
      }).toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveToken();
    controller.getAllVerifiedUser();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
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
          'Verified Accounts',
          style: GoogleFonts.duruSans(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: primayColor,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
                        // suffixIcon: Padding(
                        //   padding: EdgeInsets.only(right: 12.0),
                        //   child: InkWell(
                        //     onTap: () {
                        //       filterSheetModel();
                        //     },
                        //     child: Container(
                        //       height: 10,
                        //       width: 10,
                        //       decoration: BoxDecoration(
                        //         shape: BoxShape.circle,
                        //         color: Color(0xffDBDBDB),
                        //       ),
                        //       child: Center(
                        //         child: Image.asset(
                        //           'assets/icons/filter.png',
                        //           scale: 1.7,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  // contaier

                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.data.length,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        String currentUserId = userId.toString();
                        if (controller.data[index]['user']['isVerified'] ==  "\"0\"" ||
                            controller.data[index]['user']['isVerified'] == "2" ||
                            controller.data[index]['details']['userId'] == currentUserId) {
                          // Skip unverified accounts and the current user
                          return SizedBox.shrink();
                        }
                        return Padding(
                            padding: EdgeInsets.only(left: 20.0, right: 20,bottom: 10),
                            child: Container(
                              height: height / 5.1,
                              width: width / 1.14,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12,
                                        spreadRadius: 1,
                                        blurRadius: 4)
                                  ]),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    height: height / 5.8,
                                    width: width / 4,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            '${controller.data[index]['user']['imageUrl']}',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black12,
                                              spreadRadius: 1,
                                              blurRadius: 4)
                                        ]),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '${controller.data[index]['user']['name']}',
                                            style: GoogleFonts.lato(
                                              fontSize: 18,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Icon(
                                            Icons.verified,
                                            color: primayColor,
                                            size: 12,
                                          )
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
                                            'assets/icons/location.png',
                                            scale: 1.7,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            controller.data[index]['details']
                                                            ['address'] ==
                                                        '' ||
                                                    controller.data[index]
                                                                ['details']
                                                            ['address'] ==
                                                        null
                                                ? "Kalma Garden"
                                                : '${controller.data[index]['details']['address']}',
                                            style: GoogleFonts.lato(
                                              fontSize: 10,
                                              color:
                                                  Colors.black.withOpacity(0.5),
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
                                            'assets/icons/acc.png',
                                            scale: 1.5,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            '${controller.data[index]['user']['personStatus']}',
                                            style: GoogleFonts.lato(
                                              fontSize: 10,
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          _makePhoneCall(
                                              '${controller.data[index]['user']['phoneNo']}');
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 28.0),
                                          child: Container(
                                            height: 35,
                                            width: 130,
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
                                      ),

                                    ],
                                  ),
                                ],
                              ),
                            ));
                      },
                    ),
                  ),
                  SizedBox(height: 20,),
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

  //filter bottom model

  void filterSheetModel() async {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: 750,
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
                    style: GoogleFonts.duruSans(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Row(
                      children: [
                        Text(
                          'User',
                          style: GoogleFonts.duruSans(
                              fontSize: 22,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 50,
                    width: 320,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                            color: Colors.grey.withOpacity(0.6), width: 1)),
                    child: Center(
                      child: Text(
                        'Vehicle Owner',
                        style:
                            GoogleFonts.lato(fontSize: 14, color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 50,
                    width: 320,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                            color: Colors.grey.withOpacity(0.6), width: 1)),
                    child: Center(
                      child: Text(
                        'Broker',
                        style:
                            GoogleFonts.lato(fontSize: 14, color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Row(
                      children: [
                        Text(
                          'Location',
                          style: GoogleFonts.duruSans(
                              fontSize: 22,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 50,
                    width: 320,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                            color: Colors.grey.withOpacity(0.6), width: 1)),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 25,
                          ),
                          Text(
                            'Goreme, Turkey',
                            style: GoogleFonts.lato(
                                fontSize: 14, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
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
                      SizedBox(
                        width: 10,
                      ),
                      Container(
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
        });
  }
}
