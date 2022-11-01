import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_offer/constants.dart';
import 'package:final_offer/widgets/notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class Notify extends StatefulWidget {
  final NotificationData data;
  const Notify({Key? key, required this.data}) : super(key: key);

  @override
  State<Notify> createState() => _NotifyState();
}

class _NotifyState extends State<Notify> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('notification')
            .doc(widget.data.msgid)
            .update({'status': true});
        setState(() {
          widget.data.status = true;
        });
      },
      child: Column(
        children: [
          Row(
            children: [
              widget.data.status!
                  ? Image.asset(
                      'assets/icons/Open.png',
                      scale: 5,
                    )
                  : Image.asset(
                      'assets/icons/Closed.png',
                      scale: 5,
                    ),
              SizedBox(
                width: 11.59.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        DateFormat('MMM dd yyyy hh:mm a').format(widget.data.date!.toDate()),
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                          color: kUIDark,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: Row(children: [
                      Expanded(
                        child: Text(
                          widget.data.message!,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w400,
                            color: kUILight2,
                          ),
                        ),
                      )
                    ]),
                  )
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          const Divider(
            thickness: 1,
            color: kUILight,
          ),
        ],
      ),
    );
  }
}
