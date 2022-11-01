// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_offer/app_screens/edit_profile_screen.dart';
import 'package:final_offer/constants.dart';
import 'package:final_offer/models/users.dart';
import 'package:final_offer/widgets/buttons.dart';
import 'package:final_offer/widgets/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../widgets/bottom_navigation_bar.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({
    Key? key,
  }) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final user = FirebaseAuth.instance.currentUser;
  Users? userdata;
  //get user detail

  Future getUser() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').where('id', isEqualTo: user!.uid).get();
    if (snapshot.docs.isNotEmpty) {
      setState(() {
        userdata = Users.fromMap(snapshot.docs.first.data() as Map<String, dynamic>);
      });
    }
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: userdata != null
            ? SafeArea(
                child: Scaffold(
                  resizeToAvoidBottomInset: true,
                  drawerScrimColor: Colors.transparent,
                  appBar: AppBar(
                    centerTitle: true,
                    elevation: 0,
                    backgroundColor: kColorWhite,
                    title: Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: kColorBlack,
                      ),
                    ),
                    leading: IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) => BottomBar()));
                      },
                      icon: Icon(
                        CupertinoIcons.arrow_left,
                        color: kUIDark,
                        size: 20,
                      ),
                    ),
                    // actions: [
                    //   IconButton(
                    //     onPressed: () {
                    //       Navigator.pushReplacement(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) => EditProfile(),
                    //         ),
                    //       );
                    //     },
                    //     icon: Image.asset(
                    //       'assets/icons/edit.png',
                    //       scale: 5,
                    //     ),
                    //   ),
                    // ],
                  ),
                  body: SingleChildScrollView(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18.0.w),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Positioned(
                                  child: userdata!.imageurl!.isNotEmpty
                                      ? CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            userdata!.imageurl!,
                                          ),
                                          radius: 70.r,
                                        )
                                      : CircleAvatar(
                                          backgroundImage: AssetImage('assets/images/splash_logo.png'),
                                          radius: 70.r,
                                        ),
                                ),
                                // Positioned(
                                //   left: 80.w,
                                //   child: Container(
                                //     width: 41.w,
                                //     height: 41.h,
                                //     decoration: BoxDecoration(
                                //       shape: BoxShape.circle,
                                //       color: kUILight4,
                                //     ),
                                //     child: Image.asset(
                                //       'assets/icons/edit.png',
                                //       scale: 6,
                                //       color: kPrimary1,
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                            SizedBox(
                              height: 25.h,
                            ),
                            Text(
                              userdata!.name!,
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500,
                                color: kUIDark,
                              ),
                            ),
                            SizedBox(
                              height: 47.h,
                            ),
                            TextFieldWidget(
                              color: kUILight2,
                              text: userdata!.name!,
                              color2: kUILight,
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            TextFieldWidget(
                              color: kUILight2,
                              text: userdata!.email!,
                              color2: kUILight,
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            TextFieldWidget(
                              color: kUILight2,
                              text: userdata!.contact != null ? userdata!.contact! : 'Phone Number',
                              color2: kUILight,
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            TextFieldWidget(
                              color: kUILight2,
                              text: userdata!.address != null ? userdata!.address! : 'address',
                              color2: kUILight,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            FixedPrimary(
                              buttonText: 'Edit Profile',
                              ontap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProfile(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : Container(
                color: Colors.white,
                child: Center(
                    child: SizedBox(
                  height: 50,
                  width: 80,
                  child: LoadingIndicator(
                    indicatorType: Indicator.lineScalePulseOut,
                  ),
                )),
              ),
        onWillPop: () async => false);
  }
}
