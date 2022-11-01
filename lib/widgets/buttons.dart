// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:final_offer/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FixedPrimary extends StatelessWidget {
  final String buttonText;
  final Function ontap;
  const FixedPrimary({
    Key? key,
    required this.buttonText,
    required this.ontap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 339.w,
      height: 52.h,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.15),
            offset: Offset(0.0, 8.0),
            blurRadius: 24,
          ),
        ],
      ),
      child: OutlinedButton(
        onPressed: () {
          ontap();
        },
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(104.r),
            ),
          ),
          backgroundColor: MaterialStateProperty.all(kPrimary1),
          foregroundColor: MaterialStateProperty.all(kColorWhite),
          padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(vertical: 14.h),
          ),
          textStyle: MaterialStateProperty.all(
            TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        child: Text(buttonText),
      ),
    );
  }
}

class FixedSecondary extends StatelessWidget {
  final String buttonText;
  final Function ontap;
  const FixedSecondary({
    Key? key,
    required this.buttonText,
    required this.ontap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 339.w,
        height: 52.h,
        child: TextButton(
          onPressed: () {
            ontap();
          },
          child: Text(
            buttonText,
            style: TextStyle(
              color: kUIDark,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          style: TextButton.styleFrom(
            primary: kColorWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(104.r),
              ),
            ),
            side: BorderSide(color: kUIDark, width: 1.w, style: BorderStyle.solid),
          ),
        ));
  }
}

class FixedBlured extends StatelessWidget {
  final String buttonText;
  final Function ontap;
  const FixedBlured({
    Key? key,
    required this.buttonText,
    required this.ontap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 339.w,
      height: 52.h,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.15),
          offset: Offset(0.0, 8.0),
          blurRadius: 24,
        ),
      ]),
      child: OutlinedButton(
        onPressed: () {
          ontap();
        },
        style: ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(104.r),
          )),
          backgroundColor: MaterialStateProperty.all(kColorWhite),
          foregroundColor: MaterialStateProperty.all(kColorBlack),
          padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 14.h)),
          textStyle: MaterialStateProperty.all(
            TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        child: Text(buttonText),
      ),
    );
  }
}

class FreePrimary extends StatelessWidget {
  final String buttonText;
  final Function ontap;
  const FreePrimary({
    Key? key,
    required this.buttonText,
    required this.ontap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.15),
          offset: Offset(0.0, 8.0),
          blurRadius: 24,
        ),
      ]),
      child: OutlinedButton(
        onPressed: () {
          ontap();
        },
        style: ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(49.r),
          )),
          backgroundColor: MaterialStateProperty.all(kPrimary1),
          foregroundColor: MaterialStateProperty.all(kColorWhite),
          padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 14.h)),
          textStyle: MaterialStateProperty.all(
            TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        child: Text(buttonText),
      ),
    );
  }
}

class FreeSecondary extends StatelessWidget {
  final String buttonText;
  final Function ontap;
  const FreeSecondary({
    Key? key,
    required this.buttonText,
    required this.ontap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 101.w,
        height: 51.h,
        child: TextButton(
          onPressed: () {
            ontap();
          },
          child: Text(
            buttonText,
            style: TextStyle(
              color: kPrimary1,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          style: TextButton.styleFrom(
            primary: kColorWhite,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(49.r))),
            side: BorderSide(color: kPrimary1, width: 1.w, style: BorderStyle.solid),
          ),
        ));
  }
}

class ChipsActive extends StatelessWidget {
  final String buttonText;
  final Function ontap;
  const ChipsActive({
    Key? key,
    required this.buttonText,
    required this.ontap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        ontap();
      },
      style: ButtonStyle(
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        )),
        backgroundColor: MaterialStateProperty.all(kPrimary1),
        foregroundColor: MaterialStateProperty.all(kColorWhite),
        padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 8.h)),
        textStyle: MaterialStateProperty.all(
          TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      child: Text(buttonText),
    );
  }
}

class ChipsNonActive extends StatelessWidget {
  final String buttonText;
  final Function ontap;
  const ChipsNonActive({
    Key? key,
    required this.buttonText,
    required this.ontap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        ontap();
      },
      child: Text(
        buttonText,
        style: TextStyle(
          color: kPrimary1,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      style: TextButton.styleFrom(
        primary: kColorWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.r))),
        padding: EdgeInsets.symmetric(vertical: 6.h),
        side: BorderSide(color: kPrimary1, width: 1.w, style: BorderStyle.solid),
      ),
    );
  }
}
