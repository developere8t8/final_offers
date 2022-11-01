// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields

import 'package:final_offer/app_screens/auth.dart';
import 'package:final_offer/app_screens/home_screen.dart';
import 'package:final_offer/app_screens/signin_screen.dart';
import 'package:final_offer/constants.dart';
import 'package:final_offer/widgets/buttons.dart';
import 'package:final_offer/widgets/slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({Key? key}) : super(key: key);

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  int _currentPage = 0;
  PageController _controller = PageController();
  bool isLastPage = false;
  List<Widget> _pages = [
    SliderWidget(
        image: 'assets/images/1.png',
        title: 'Instruction 1',
        description:
            "Lorem ipsum dolor sit amet, consectetur\nadipiscing elit. Ptesque et pellentesque\ntristique egestas. "),
    SliderWidget(
        image: 'assets/images/2.png',
        title: 'Instruction 2',
        description:
            "Lorem ipsum dolor sit amet, consectetur\nadipiscing elit. Ptesque et pellentesque\ntristique egestas. "),
    SliderWidget(
        image: 'assets/images/3.png',
        title: 'Instruction 3',
        description:
            "Lorem ipsum dolor sit amet, consectetur\nadipiscing elit. Ptesque et pellentesque\ntristique egestas. "),
  ];

  _onchanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            PageView.builder(
              scrollDirection: Axis.horizontal,
              controller: _controller,
              itemCount: _pages.length,
              onPageChanged: (index) {
                setState(() => isLastPage = index == 2);
              },
              itemBuilder: ((context, int index) {
                return _pages[index];
              }),
            ),
            Center(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 520.h,
                  ),
                  SmoothPageIndicator(
                    controller: _controller, // PageController
                    count: 3,
                    effect: ExpandingDotsEffect(
                      activeDotColor: kPrimary1,
                    ),
                    onDotClicked: (index) => _controller.animateToPage(index,
                        duration: Duration(milliseconds: 500), curve: Curves.easeInOutQuint),
                  ),
                  SizedBox(
                    height: 41.74.h,
                  ),
                  isLastPage
                      ? FixedPrimary(
                          buttonText: 'Get Started',
                          ontap: () async {
                            SharedPreferences storage = await SharedPreferences.getInstance();
                            storage.setBool('first', false);
                            // ignore: use_build_context_synchronously
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CheckAuth(),
                              ),
                            );
                          })
                      // ignore: avoid_unnecessary_containers
                      : Container(
                          child: Column(
                            children: [
                              FixedPrimary(
                                  buttonText: 'Next',
                                  ontap: () {
                                    _controller.nextPage(
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.easeInOutQuint);
                                  }),
                              SizedBox(
                                height: 20.h,
                              ),
                              InkWell(
                                onTap: () async {
                                  SharedPreferences storage = await SharedPreferences.getInstance();
                                  storage.setBool('first', false);
                                  // ignore: use_build_context_synchronously
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CheckAuth(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Skip',
                                  style: TextStyle(
                                    color: kUILight2,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
