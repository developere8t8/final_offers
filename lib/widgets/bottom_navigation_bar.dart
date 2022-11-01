// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:final_offer/app_screens/home_screen.dart';
import 'package:final_offer/app_screens/my_offers_screen.dart';
import 'package:final_offer/app_screens/profile_screen.dart';
import 'package:final_offer/constants.dart';
import 'package:final_offer/models/users.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomBar> createState() => _MainPageState();
}

class _MainPageState extends State<BottomBar> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List _pages = [
    MyHome(),
    MyOffers(),
    MyHome(),
    MyProfile(),
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ignore: sized_box_for_whitespace
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: kColorWhite,
        elevation: 0,
        selectedLabelStyle: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
        ),
        selectedItemColor: kPrimary1,
        unselectedItemColor: kUILight2,
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.compass), label: 'My Offers'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.person_fill), label: 'My Profile'),
        ],
      ),
      body: _pages[_selectedIndex],
    );
  }
}
