import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:goods_transport/Constant/Controller/show_help_request_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Constant/colors_constant.dart';
import '../../../Widegts/custom_text_field.dart';

class HelpRequetScreen extends StatefulWidget {
  const HelpRequetScreen({super.key});

  @override
  State<HelpRequetScreen> createState() => _HelpRequetScreenState();
}

class _HelpRequetScreenState extends State<HelpRequetScreen> {
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

    print('asdadasda $userId');
  }

  var controller = Get.put(ShowHelpRequest_Controller());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.showHelpRequest();
    retrieveToken();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
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
              scale: 3.5,
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          'Help Request\'s',
          style: TextStyle(
            fontFamily: 'Douro',
            fontSize: 30,
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
            : controller.data.isEmpty
                ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                 Image.asset('assets/images/help.png'),
                    Text('No help request found.'),
                  ],
                )
                : Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: controller.data.length,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            String currentUserId = userId.toString();
                            if (controller.data[index]['userId'] ==
                                currentUserId) {
                              // Skip the current user's help request
                              return SizedBox.shrink();
                            }

                            return Padding(
                                padding: EdgeInsets.only(left: 20.0, right: 20),
                                child: Container(
                                  width: width / 1,
                                  height: 255,
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
                                        child: Container(
                                          width: width / 2.5,
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                '${controller.data[index]['user']['imageUrl']}',
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        width: width / 2.4,
                                        // color: Colors.red,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${controller.data[index]['user']['name']}',
                                                  style: GoogleFonts.lato(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  textScaleFactor: 1.0,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  // softWrap: true,
                                                ),
                                                // Icon(
                                                //   Icons.verified,
                                                //   color: primayColor,
                                                //   size: 12,
                                                // ),
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
                                                  '${controller.data[index]['location']}',
                                                  style: GoogleFonts.lato(
                                                    fontSize: 10,
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Image.asset(
                                                  'assets/icons/car.png',
                                                  scale: 1.7,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  '${controller.data[index]['type']}',
                                                  style: GoogleFonts.lato(
                                                    fontSize: 10,
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              '--------------',
                                              style: GoogleFonts.lato(
                                                fontSize: 25,
                                                letterSpacing: 2,
                                                color: Colors.grey
                                                    .withOpacity(0.6),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Vehicle',
                                                      style: GoogleFonts.lato(
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${controller.data[index]['vehicle']}',
                                                      style: GoogleFonts.lato(
                                                        fontSize: 7,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                // Column(
                                                //   mainAxisAlignment:
                                                //       MainAxisAlignment.start,
                                                //   crossAxisAlignment:
                                                //       CrossAxisAlignment.start,
                                                //   children: [
                                                //     Text(
                                                //       'Vehicle Type',
                                                //       style: GoogleFonts.lato(
                                                //         fontSize: 10,
                                                //       ),
                                                //     ),
                                                //     Text(
                                                //       '${controller.data[index]['vehicle']}',
                                                //       style: GoogleFonts.lato(
                                                //         fontSize: 7,
                                                //       ),
                                                //     ),
                                                //   ],
                                                // ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 7,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Location',
                                                      style: GoogleFonts.lato(
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${controller.data[index]['location']}',
                                                      style: GoogleFonts.lato(
                                                        fontSize: 7,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 7,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Notes',
                                                        style: GoogleFonts.lato(
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${controller.data[index]['notes']}',
                                                        style: GoogleFonts.lato(
                                                          fontSize: 7,
                                                          color: Colors.black,
                                                        ),
                                                        textScaleFactor: 1.0,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 4,
                                                        // softWrap: true,
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 7,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                _makePhoneCall(
                                                    '${controller.data[index]['user']['phoneNo']}');
                                              },
                                              child: Container(
                                                height: 35,
                                                width: 130,
                                                decoration: BoxDecoration(
                                                  color: Color(0xff25AE6A),
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0),
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
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                // : Center(
                                //     child: Column(
                                //       crossAxisAlignment: CrossAxisAlignment.center,
                                //       mainAxisAlignment: MainAxisAlignment.center,
                                //       children: [
                                //         Image.asset('assets/images/help.png',scale: 2,),
                                //         SizedBox(
                                //           height: 10,
                                //         ),
                                //         Text(
                                //           'No Help Request',
                                //           style: GoogleFonts.lato(
                                //             fontSize: 14,
                                //             color: Colors.black,
                                //             fontWeight: FontWeight.w400
                                //           ),
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
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
}
