import 'package:final_offer/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SliderWidget extends StatelessWidget {
  const SliderWidget(
      {Key? key,
      required this.image,
      required this.title,
      required this.description})
      : super(key: key);

  final String image;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 50.h),
            Image.asset(
              image,
              width: 212.8.w,
              height: 220.h,
            ),
            SizedBox(height: 64.h),
            Text(
              title,
              style: TextStyle(
                color: kColorBlack,
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 29.h),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kUILight2,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
