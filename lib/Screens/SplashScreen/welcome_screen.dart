import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Constant/colors_constant.dart';
import '../LoginScreen/login_screen.dart';


class WelComeScreen extends StatefulWidget {
  const WelComeScreen({super.key});

  @override
  State<WelComeScreen> createState() => _WelComeScreenState();
}

class _WelComeScreenState extends State<WelComeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(left: 22.0,right: 22,bottom: 18),
          child: InkWell(
            onTap: (){
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              );
            },
            child: Container(
              height: 57,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text('Get Started',style: TextStyle(color: Colors.white),),
              ),
            ),
          ),
        ),
        backgroundColor: Color(0xffF6F7FC),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Image.asset(
                'assets/images/sp.png',
                scale: 3,
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Deliver ',
                    style:TextStyle(
                      fontFamily: 'Douro',
                      fontSize: 28,
                      color: primayColor,
                    ),
                  ),
                  Text(
                    'your goods',
                    style: TextStyle(
                      fontFamily: 'Douro',
                      fontSize: 28,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'as you ',
                    style: TextStyle(
                      fontFamily: 'Douro',
                      fontSize: 28,
                    ),
                  ),
                  Text(
                    'Require.',
                    style: TextStyle(
                      fontFamily: 'Douro',
                      fontSize: 28,
                      color: primayColor,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Deliver your Goods within Africa with \nAfrica Goods Transport. We have a \nvariety of transport options and Goods \ncarriers within the app.',
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Color(0xff1A242C).withOpacity(0.5),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
