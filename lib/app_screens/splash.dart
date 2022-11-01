// ignore_for_file: prefer_const_constructors
import 'package:final_offer/app_screens/auth.dart';
import 'package:final_offer/app_screens/onboard_screen.dart';
import 'package:final_offer/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigatetohome();
  }

  _navigatetohome() async {
    await Future.delayed(Duration(seconds: 2), () {});

    SharedPreferences storage = await SharedPreferences.getInstance();
    final bool? first = storage.getBool('first');
    if (first != null) {
      if (first) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OnboardScreen()));
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CheckAuth()));
      }
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OnboardScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/splash_image.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 154.h,
                  ),
                  Image.asset(
                    'assets/images/splash_logo.png',
                    width: 180.39.w,
                    height: 124.7.h,
                  ),
                  SizedBox(
                    height: 14.3.h,
                  ),
                  // Text(
                  //   'Lorem ipsum dolor sit amet, consectetur\nadipiscing elit.',
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //     color: kUILight2,
                  //     fontSize: 12.sp,
                  //     fontWeight: FontWeight.w400,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
