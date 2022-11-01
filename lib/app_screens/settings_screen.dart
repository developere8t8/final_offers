// ignore_for_file: prefer_const_constructors

import 'package:final_offer/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MySettings extends StatelessWidget {
  const MySettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: kColorWhite,
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: kColorBlack,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            CupertinoIcons.arrow_left,
            color: kUIDark,
            size: 20,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40.h,
            ),
            Text(
              'Account Settings',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: kUIDark,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Divider(
              thickness: 1,
              color: kUILight,
            ),
            SizedBox(
              height: 20.h,
            ),
            Text(
              'Notification Settings',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: kUIDark,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Divider(
              thickness: 1,
              color: kUILight,
            ),
            SizedBox(
              height: 20.h,
            ),
            Text(
              'Terms & Conditions',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: kUIDark,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Divider(
              thickness: 1,
              color: kUILight,
            ),
            SizedBox(
              height: 20.h,
            ),
            Text(
              'Placeholder',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: kUIDark,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Divider(
              thickness: 1,
              color: kUILight,
            ),
          ],
        ),
      ),
    );
  }
}
