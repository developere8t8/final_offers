// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, prefer_const_declarations

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_offer/app_screens/auth.dart';
import 'package:final_offer/app_screens/contact_us_screen.dart';
import 'package:final_offer/app_screens/my_offers_screen.dart';
import 'package:final_offer/app_screens/notifications_screen.dart';
import 'package:final_offer/app_screens/profile_screen.dart';
import 'package:final_offer/constants.dart';
import 'package:final_offer/models/cahtroom.dart';
import 'package:final_offer/models/users.dart';
import 'package:final_offer/provider/signin.dart';
import 'package:final_offer/widgets/bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../app_screens/chat_screen.dart';

class MyDrawer extends StatefulWidget {
  final Users user;
  const MyDrawer({Key? key, required this.user}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.user.name != null
        ? SizedBox(
            width: 270.w,
            child: Drawer(
              backgroundColor: kColorWhite,
              elevation: 0,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyProfile(),
                        ),
                      );
                    },
                    child: DrawerHeader(
                      padding: EdgeInsets.zero,
                      child: UserAccountsDrawerHeader(
                          margin: EdgeInsets.zero,
                          decoration: BoxDecoration(),
                          accountName: Text(
                            widget.user.name!,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                              color: kUIDark,
                            ),
                          ),
                          accountEmail: Text(
                            '',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12.sp,
                              color: kPrimary1,
                            ),
                          ),
                          currentAccountPicture: widget.user.imageurl!.isEmpty
                              ? CircleAvatar(
                                  backgroundImage: AssetImage('assets/images/splash_logo.png'),
                                )
                              : CircleAvatar(
                                  backgroundImage: NetworkImage(widget.user.imageurl!),
                                )),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BottomBar(),
                        ),
                      );
                    },
                    child: ListTile(
                      minLeadingWidth: 16.w,
                      leading: Icon(
                        CupertinoIcons.house_fill,
                        color: kUIDark,
                      ),
                      title: Text(
                        'Home',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: kUIDark,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyOffers(),
                        ),
                      );
                    },
                    child: ListTile(
                      minLeadingWidth: 16.w,
                      leading: Icon(
                        CupertinoIcons.hand_point_right_fill,
                        color: kUIDark,
                      ),
                      title: Text(
                        'My Offers',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: kUIDark,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyNotifications(),
                        ),
                      );
                    },
                    child: ListTile(
                      minLeadingWidth: 16.w,
                      leading: Icon(
                        CupertinoIcons.bell_fill,
                        color: kUIDark,
                      ),
                      title: Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: kUIDark,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyProfile(),
                        ),
                      );
                    },
                    child: ListTile(
                      minLeadingWidth: 16.w,
                      leading: Icon(
                        CupertinoIcons.person_fill,
                        color: kUIDark,
                      ),
                      title: Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: kUIDark,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      checkChatroom();
                    },
                    child: ListTile(
                      minLeadingWidth: 16.w,
                      leading: Icon(
                        CupertinoIcons.phone_fill,
                        color: kUIDark,
                      ),
                      title: Text(
                        'Contact Us',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: kUIDark,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  InkWell(
                    onTap: () {
                      final logout = Provider.of<SigninProvider>(context, listen: false);
                      logout.logOut();
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (context) => CheckAuth()));
                    },
                    child: ListTile(
                      minLeadingWidth: 16.w,
                      leading: Image.asset(
                        'assets/icons/logout.png',
                        scale: 3.5,
                      ),
                      title: Text(
                        'Log Out',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: kPrimary2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container();
  }

  //checking chat room

  Future checkChatroom() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('chatrooms')
        .where('participant', arrayContains: FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (snapshot.docs.isNotEmpty) {
      ChatroomModel model = ChatroomModel.fromMap(snapshot.docs.first.data() as Map<String, dynamic>);
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SupportChat(
            model: model,
          ),
        ),
      );
    } else {
      final newChatroom = FirebaseFirestore.instance.collection('chatrooms').doc();
      ChatroomModel model = ChatroomModel(
          date: Timestamp.fromDate(DateTime.now()),
          id: newChatroom.id,
          lastMessage: '',
          participants: [FirebaseAuth.instance.currentUser!.uid, 'Ptb2W9v3oRZyNeynKEag']);

      await newChatroom.set(model.toMap());
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ContactUs(
            user: widget.user,
          ),
        ),
      );
    }
  }
}
