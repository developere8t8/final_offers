import 'package:final_offer/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUpTxtField extends StatelessWidget {
  final String hintText;
  final Icon? suffixIcon;
  TextEditingController? controller;
  String? errorTxt;
  bool? validate;
  final onchange;
  final keyboradType;
  final obscure;
  SignUpTxtField(
      {super.key,
      required this.hintText,
      this.suffixIcon,
      this.controller,
      this.errorTxt,
      this.validate,
      this.onchange,
      this.keyboradType,
      this.obscure});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: kUILight2,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: kUILight2,
        ),
      ),
      controller: controller,
      // ignore: body_might_complete_normally_nullable
      validator: (value) {
        if (validate != null) {
          if (value == null || value.isEmpty) {
            return errorTxt;
          }
          return null;
        }
      },
      onChanged: onchange,
      keyboardType: keyboradType,
      obscureText: obscure ?? false,
    );
  }
}

class TextFieldWidget extends StatelessWidget {
  final Color color;
  final Color color2;
  final String text;
  const TextFieldWidget({Key? key, required this.color, required this.text, required this.color2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: color,
      ),
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: color2),
        ),
        hintText: text,
        hintStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}

class MySearch extends StatelessWidget {
  const MySearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 340.w,
      height: 47.h,
      child: TextField(
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: kUILight2),
        decoration: InputDecoration(
          // ignore: prefer_const_constructors
          suffixIcon: Icon(
            CupertinoIcons.search,
            color: kUILight2,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(128.r),
            borderSide: BorderSide(color: kUILight2, width: 1.w),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(128.r),
            borderSide: BorderSide(color: kUILight2, width: 1.w),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 21.w),
          // filled: true,
          // fillColor: kWhiteColor,
          hintText: 'Search',
          hintStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: kUILight2),
        ),
      ),
    );
  }
}
