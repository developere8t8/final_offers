// ignore_for_file: prefer_const_constructors

import 'dart:isolate';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_offer/constants.dart';
import 'package:final_offer/models/noty.dart';
import 'package:final_offer/widgets/error.dart';
import 'package:final_offer/widgets/notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../widgets/bottom_navigation_bar.dart';

class MyNotifications extends StatefulWidget {
  const MyNotifications({Key? key}) : super(key: key);

  @override
  State<MyNotifications> createState() => _MyNotificationsState();
}

class _MyNotificationsState extends State<MyNotifications> {
  bool isLoading = false;
  List<NotificationData> notifications = [];

  @override
  void initState() {
    getNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            backgroundColor: kColorWhite,
            title: Text(
              'Notifications',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: kColorBlack,
              ),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomBar()));
              },
              icon: Icon(
                CupertinoIcons.arrow_left,
                color: kUIDark,
                size: 20,
              ),
            ),
            actions: [
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  for (var item in notifications) {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection('notification')
                        .doc(item.id)
                        .delete();
                  }
                  setState(() {
                    notifications.clear();
                    isLoading = false;
                  });
                },
                icon: Image.asset(
                  'assets/icons/Bin.png',
                  scale: 5,
                ),
              ),
            ],
          ),
          body: isLoading
              ? Container(
                  color: Colors.white,
                  child: Center(
                      child: SizedBox(
                    height: 30,
                    width: 60,
                    child: LoadingIndicator(
                      indicatorType: Indicator.lineScalePulseOut,
                    ),
                  )),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 19.59.w),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 42.h,
                        ),
                        ListView.builder(
                            itemCount: notifications.isEmpty ? 0 : notifications.length,
                            shrinkWrap: true,
                            primary: false,
                            itemBuilder: (context, index) {
                              return notifications.isEmpty
                                  ? Center(
                                      child: Text(
                                        'Nothing to show',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    )
                                  : Notify(data: notifications[index]);
                            })
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Future getNotification() async {
    try {
      setState(() {
        isLoading = true;
      });

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('notification')
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(DateTime.now().add(Duration(days: 1))))
          .get();
      if (snapshot.docs.isNotEmpty) {
        notifications = snapshot.docs
            .map((e) => NotificationData.fromMap(e.data() as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ErrorDialog(
                  title: 'Error',
                  message: e.toString(),
                  type: 'E',
                  function: () {
                    Navigator.pop(context);
                  },
                  buttontxt: 'Ok')));
    } finally {
      isLoading = false;
      setState(() {});
    }
  }
}
