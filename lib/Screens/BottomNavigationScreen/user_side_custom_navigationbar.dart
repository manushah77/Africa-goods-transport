
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goods_transport/Screens/BottomNavigationScreen/HomeScreen/homeScreen.dart';
import 'package:goods_transport/Screens/BottomNavigationScreen/HomeScreen/user_homeScreen.dart';
import 'package:goods_transport/Screens/BottomNavigationScreen/MyRequestScreen/myRequestScreen.dart';
import 'package:goods_transport/Screens/BottomNavigationScreen/MyRequestScreen/userRequestScreen.dart';
import 'package:goods_transport/Screens/BottomNavigationScreen/MyRequestScreen/viechle_owner_myRequest_screen.dart';
import 'package:goods_transport/Screens/BottomNavigationScreen/ProfileScreen/user_profile_screen.dart';
import 'package:goods_transport/Screens/LoginScreen/login_screen.dart';
import 'package:goods_transport/Screens/SignupScreen/OTP_Screen/otp_screen.dart';
import 'package:goods_transport/Screens/SplashScreen/welcome_screen.dart';

import 'HomeScreen/viechle_owner_home_screen.dart';
import 'ProfileScreen/profile_screen.dart';


class UserSideCustom_BottomBar extends StatefulWidget {
  int selectedIndex =0;
  UserSideCustom_BottomBar({required this.selectedIndex});
  @override
  _BottomBar createState() => _BottomBar();
}

class _BottomBar extends State<UserSideCustom_BottomBar> {

  // selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[

    UserHomeScreen(),
    UserRequestScreen(),
    UserProfile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      widget.selectedIndex = index;
    });
  }

  // late PageController _pageController;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _pageController = PageController();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt( widget.selectedIndex),
      bottomNavigationBar: Container(
        height: 60, // Adjust the height as needed
        decoration: BoxDecoration(
          color: Color(0xff98C7DB),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0), // Adjust the radius as needed
            topRight: Radius.circular(15.0), // Adjust the radius as needed
          ),
          child: BottomNavyBar(
            backgroundColor:  Color(0xff98C7DB),
            selectedIndex:  widget.selectedIndex,
            onItemSelected: (index) {
              setState(() =>  widget.selectedIndex = index);
              // _pageController.jumpToPage(index);
            },
            items: <BottomNavyBarItem>[
              BottomNavyBarItem(
                activeColor: Colors.white,
                title: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Home',
                    style: TextStyle(
                        color:  widget.selectedIndex == 0 ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                    textScaleFactor: 1.0,
                  ),
                ),
                icon:  Image.asset(
                  'assets/icons/house.png',
                  scale: 3.5,
                ),
              ),

              BottomNavyBarItem(
                activeColor: Colors.white,
                title: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Request',
                    style: TextStyle(
                        color:  widget.selectedIndex == 1 ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                    textScaleFactor: 1.0,

                  ),
                ),
                icon: Image.asset(
                  'assets/icons/app.png',
                  scale: 3.5,
                ),
              ),

              BottomNavyBarItem(
                activeColor: Colors.white,
                title: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Profile',
                    style: TextStyle(
                        color:  widget.selectedIndex == 2 ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                    textScaleFactor: 1.0,
                  ),
                ),
                icon: Image.asset(
                  'assets/icons/user.png',
                  scale: 3.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
