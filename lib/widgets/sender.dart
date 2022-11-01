import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_offer/app_screens/preview.dart';
import 'package:final_offer/constants.dart';
import 'package:final_offer/models/cahtroom.dart';
import 'package:final_offer/models/messages.dart';
import 'package:final_offer/models/users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Sender extends StatefulWidget {
  final ChatroomModel model;
  final Users user;
  final Messages message;
  const Sender({Key? key, required this.message, required this.user, required this.model})
      : super(key: key);

  @override
  State<Sender> createState() => _SenderState();
}

class _SenderState extends State<Sender> {
  bool isLoadingMessage = true;
  @override
  Widget build(BuildContext context) {
    return widget.message.type == 'text'
        ? Container(
            //if message type is text
            margin: const EdgeInsets.only(top: 3.0, bottom: 3.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                        width: 250.w,
                        //height: 41.h,
                        decoration: BoxDecoration(
                          color: kColorChat,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                                child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                widget.message.message!,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: kUIDark,
                                ),
                              ),
                            ))
                          ],
                        )),
                    SizedBox(width: 10.w),
                    CircleAvatar(
                      backgroundImage: NetworkImage(widget.user.imageurl!),
                    ),
                    SizedBox(width: 18.w),
                  ],
                ),
              ],
            ))
        : Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                  margin: const EdgeInsets.only(right: 10, top: 03, bottom: 03),
                  height: 180,
                  width: 230,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: Colors.orange[50]),
                  child: Center(
                    child: Stack(
                      children: [
                        Positioned(
                          left: 10,
                          top: 10,
                          bottom: 10,
                          child: widget.message.message != 'file'
                              ? InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PicPreview(
                                                name: widget.user.name!,
                                                pics: [widget.message.message!])));
                                  },
                                  child: Image.network(
                                    widget.message.message!,
                                    height: 160,
                                    width: 160,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const SizedBox(
                                  height: 160,
                                  width: 160,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                        ),
                        Positioned(
                          top: 5,
                          right: 10,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(widget.user.imageurl!),
                          ),
                        ),
                        Positioned(
                            right: 30,
                            bottom: 5,
                            child: InkWell(
                              onTap: () async {
                                setState(() {
                                  isLoadingMessage = true;
                                });
                                await FirebaseStorage.instance
                                    .refFromURL(widget.message.message!)
                                    .delete();
                                await FirebaseFirestore.instance
                                    .collection('chatrooms')
                                    .doc(widget.model.id)
                                    .collection('chat')
                                    .doc(widget.message.id)
                                    .delete();
                                setState(() {
                                  isLoadingMessage = false;
                                });
                              },
                              child: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ))
                      ],
                    ),
                  ))
            ],
          );
  }
}
