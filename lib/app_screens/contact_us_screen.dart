// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_offer/app_screens/chat_screen.dart';
import 'package:final_offer/app_screens/notifications_screen.dart';
import 'package:final_offer/constants.dart';
import 'package:final_offer/models/cahtroom.dart';
import 'package:final_offer/models/users.dart';
import 'package:final_offer/widgets/buttons.dart';
import 'package:final_offer/widgets/drawer.dart';
import 'package:final_offer/widgets/error.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../models/messages.dart';

class ContactUs extends StatefulWidget {
  final Users user;
  const ContactUs({Key? key, required this.user}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      left: false,
      top: false,
      right: false,
      bottom: false,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: kColorWhite,
          title: Text(
            'Contact Us',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
              color: kUIDark,
            ),
          ),
          leading: Builder(
            builder: (context) => IconButton(
              icon: Image.asset(
                'assets/icons/menu1.png',
                scale: 3.5,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyNotifications(),
                  ),
                );
              },
              icon: Icon(
                CupertinoIcons.bell_fill,
                size: 20,
                color: kColorBlack,
              ),
            ),
          ],
        ),
        drawer: MyDrawer(
          user: widget.user,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: Column(
              children: [
                SizedBox(height: 46.h),
                Image.asset(
                  'assets/images/pana.png',
                  scale: 4.5,
                ),
                SizedBox(
                  height: 50.h,
                ),
                Text(
                  'Having an issue? Please let us know in the box below and our team will get back to you as soon as possible.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: kUILight2,
                  ),
                ),
                SizedBox(
                  height: 24.h,
                ),
                TextField(
                  controller: controller,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Type Here',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.w, color: kFormStockColor),
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.r),
                      borderSide: BorderSide(width: 1.w, color: kFormStockColor),
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: kUILight2,
                  ),
                ),
                SizedBox(
                  height: 61.h,
                ),
                FixedPrimary(
                    buttonText: 'Send',
                    ontap: () {
                      if (controller.text.isNotEmpty) {
                        checkChatroom();
                      } else {
                        showMsg(
                            'write something to send',
                            Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                            context);
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //checking chat room

  Future checkChatroom() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('chatrooms')
        .where('participant', arrayContains: FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (snapshot.docs.isNotEmpty) {
      ChatroomModel model = ChatroomModel.fromMap(snapshot.docs.first.data() as Map<String, dynamic>);
      sendMessage(model.id!);

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
      sendMessage(newChatroom.id);
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SupportChat(
            model: model,
          ),
        ),
      );
    }
  }

  //send messaage
  Future sendMessage(String modelID) async {
    try {
      final send =
          FirebaseFirestore.instance.collection('chatrooms').doc(modelID).collection('chat').doc();
      Messages newmessage = Messages(
          date: Timestamp.fromDate(DateTime.now()),
          id: send.id,
          receiver: 'Ptb2W9v3oRZyNeynKEag',
          seen: false,
          sender: FirebaseAuth.instance.currentUser!.uid,
          type: 'text',
          message: controller.text,
          groupdDate: DateFormat('MMM dd yyyy').format(DateTime.now()));
      await send.set(newmessage.toMap());
      //setState(() {
      controller.clear();
      //});
    } catch (e) {
      showMsg(
          e.toString(),
          const Icon(
            Icons.close,
            color: Colors.red,
          ),
          context);
    }
  }
}
