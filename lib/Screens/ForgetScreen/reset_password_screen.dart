import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goods_transport/Constant/colors_constant.dart';
import 'package:goods_transport/Screens/LoginScreen/login_screen.dart';
import 'package:goods_transport/Widegts/custom_button.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Constant/dialoag_widget.dart';
import '../../Widegts/custom_text_field.dart';
import 'package:http/http.dart' as http;

class ResetPasswordScreen extends StatefulWidget {
  String? id;

  ResetPasswordScreen({super.key, this.id});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController passwordC = TextEditingController();
  bool isLoading = false;
  bool ispasswordvisible = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('My id is ${widget.id}');
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Reset Password',
            style: TextStyle(
              fontFamily: 'Douro',
              fontSize: 32,
              fontWeight: FontWeight.w500,
              color: primayColor,
            ),
          ),
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
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Image.asset(
                  'assets/images/forget.png',
                  scale: 4.5,
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 22.0),
                      child: Text(
                        'Enter Password',
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
                    height: 60,
                    child: CustomTextField(
                      hintText: 'Reset Password',
                      controller: passwordC,
                      validate: true,
                      errorHint: 'Enter Password',
                      obsecureText: ispasswordvisible,
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
                  height: 15,
                ),
                isLoading == true ? Center(
                  child: CircularProgressIndicator(
                    color: primayColor,
                  ),
                ) :
                CustomButton(
                  title: 'Reset',
                  onTap: () {
                    if(formKey.currentState!.validate()) {
                      passwordReset().then((value) {
                        Get.offAll(LoginScreen());
                      });
                    }

                  },
                  btnclr: primayColorBlue,
                  txtclr: Colors.white,
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> passwordReset() async {
    final String apiUrl = "https://agt.jeuxtesting.com/api/password/reset";

    // Replace this map with your actual data
    Map<String, dynamic> data = {
      "id": widget.id.toString(),
      "password": passwordC.text.toString(),
      // Add other fields as needed
    };

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        print("POST request successful!");
        // Parse the response body as JSON
        final responseData = jsonDecode(response.body);

        // Check if the 'message' key exists and is not null
        if (responseData.containsKey('message') && responseData['message'] != null) {
          CustomDialogs.showSnakcbar(context, responseData['message']);
        } else {
          CustomDialogs.showSnakcbar(context, 'Unexpected response format: ${response.body}');
        }

        print("Response: ${response.body}");
      } else {
        CustomDialogs.showSnakcbar(context, 'Failed to reset password');
        throw Exception("Failed to post data");
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
