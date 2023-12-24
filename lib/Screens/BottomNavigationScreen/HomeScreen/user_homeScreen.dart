import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:goods_transport/Constant/colors_constant.dart';
import 'package:goods_transport/Constant/dialoag_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Constant/Controller/show_vehicleOwner_request_controller.dart';
import '../../../Models/broker_verification_model.dart';
import '../../../Widegts/custom_text_field.dart';
import 'package:http/http.dart' as http;

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {

  String? token;
  String? id;

  Future retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      id = prefs.getString('id');
    });
  }

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

  var controller = Get.put(VehicleOwnerReuestScreen_Controller());

  void search(String keyword) {
    setState(() {
      controller.data.value = controller.searchData.value.where((item) {
        final title = item['name'].toString().toLowerCase();
        return title.contains(keyword.toLowerCase().trim());
      }).toList();
    });
  }

  void filter(String keyword,String types ,String pickup) {
    setState(() {
      controller.data.value = controller.searchData.value.where((item) {
        final title = item['vehicle'].toString().toLowerCase();
        final type = item['vehicleType'].toString().toLowerCase();
        final pickUp = item['pickUp'].toString().toLowerCase();
        return title.contains(keyword.toLowerCase().trim()) && type.contains(types.toLowerCase().trim()) && pickUp.contains(pickup.toLowerCase().trim());
      }).toList();
    });
  }
  Future refresh() async {
    await controller.getVehicleOwnerReuestData();
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveToken().then((value) {
      fetchCurrentUser();
      refresh();
    });
    setState(() {
      controller.getVehicleOwnerReuestData();
    });

  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    GlobalKey<State> popupKey = GlobalKey<State>();

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
                    return Center(
                    );
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
                              onchange: (val){
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
                  :  controller.data.isEmpty
                      ? Center(
                    child: Text('No matching data found.'),
                  )
                      :
                  Container(
                    height:  height / 1.71,
                    child: RefreshIndicator(
                      onRefresh: refresh,
                      child: ListView.builder(
                itemCount: controller.data.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20,bottom: 10),
                        child: controller.data[index]['requestStatus'] =='1' ?

                        Container(
                          width: width / 1,
                          height: 200,
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
                                  height: 185,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(16),
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
                                      height: 10,
                                    ),
                                    controller.data[index]['user']['isVerified'] == "1"
                                        ? Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${controller.data[index]['name']}',
                                          style: GoogleFonts.lato(
                                            fontSize: 18,
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
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,

                                      children: [
                                        Text(
                                          '${controller.data[index]['name']}',
                                          style: GoogleFonts.lato(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                          textScaleFactor: 1.0,
                                          maxLines: 2,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
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
                                            color: Colors.black.withOpacity(0.5),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          'assets/icons/acc.png',
                                          scale: 1.7,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          '${controller.data[index]['personStatus']}',
                                          style: GoogleFonts.lato(
                                            fontSize: 10,
                                            color: Colors.black.withOpacity(0.5),
                                          ),
                                        ),
                                      ],
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
                                    SizedBox(
                                      height: 4,
                                    ),
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
                                            Text(
                                              'Drop Off               ',
                                              style: GoogleFonts.lato(
                                                fontSize: 11,
                                                color: Colors.black,
                                                fontWeight:
                                                FontWeight.w400,
                                              ),
                                            ),
                                            Container(
                                              width: 50,
                                              height: 12,
                                              child: Text(
                                                '${controller.data[index]['dropOff']}',
                                                style: GoogleFonts.lato(
                                                  fontSize: 10,
                                                  color: primayColor,
                                                  fontWeight:
                                                  FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(

                                      children: [
                                        InkWell(
                                          onTap: () {
                                            _makePhoneCall(
                                                '${controller.data[index]['user']['phoneNo']}');
                                          },
                                          child: Container(
                                            height: 30,
                                            width: 67,
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
                                            width: 75,
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
                                    SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
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


  void filterSheetModel() {
    showModalBottomSheet(
      useRootNavigator: true,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) =>
          StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
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
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 18.0,left: 18),
                      child: Container(
                        height: 50,
                        width: width/1,
                        decoration: BoxDecoration(
                          color: primayColorBlue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.verified,color: Colors.white,),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Verified Only',
                              style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                            ),                     ],
                        ),
                      ),
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
                      padding: const EdgeInsets.only(left: 18.0,right: 18),
                      child: Container(
                        width: width/1,
                        height: 50,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            isExpanded: true,
                            hint: Row(
                              children: [
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
                              // Update the state of dropdownValue when an option is selected
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
                      padding: const EdgeInsets.only(left: 18.0,right: 18),
                      child: Container(
                        width: width/1,
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
                      padding: const EdgeInsets.only(left: 18.0,right: 18),
                      child:  SizedBox(
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

                          },
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
                      padding: const EdgeInsets.only(left: 18.0,right: 18),
                      child:  SizedBox(
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

                          },
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
                    //   padding: const EdgeInsets.only(left: 18.0,right: 18),
                    //   child:  SizedBox(
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
                    //       onChanged: (newValue) {
                    //
                    //       },
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
                    //         EdgeInsets.only(top: 2, left: 15, right: 15),
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
                    //               color: Colors.grey.withOpacity(0.4),
                    //               width: 1),
                    //         ),
                    //         focusedBorder: OutlineInputBorder(
                    //           borderRadius: BorderRadius.circular(30),
                    //           borderSide:
                    //           BorderSide(color: Colors.black54, width: 1),
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
                            filter(dropdownValue,dropdownValueTwo,pickpC.text.trim().toString());
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
}
