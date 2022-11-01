import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_offer/constants.dart';
import 'package:final_offer/models/cahtroom.dart';
import 'package:final_offer/models/messages.dart';
import 'package:final_offer/models/users.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../app_screens/preview.dart';

class Receiver extends StatefulWidget {
  final Users user;
  final String imgUrl;
  final Messages message;
  final ChatroomModel model;
  const Receiver(
      {Key? key, required this.message, required this.imgUrl, required this.user, required this.model})
      : super(key: key);

  @override
  State<Receiver> createState() => _ReceiverState();
}

class _ReceiverState extends State<Receiver> {
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
                  mainAxisAlignment: MainAxisAlignment.start,
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
                    const CircleAvatar(
                      backgroundImage: AssetImage('assets/icons/Person.png'),
                    ),
                    SizedBox(width: 18.w),
                  ],
                ),
              ],
            ))
        : Row(
            mainAxisAlignment: MainAxisAlignment.start,
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
                          right: 10,
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
                                  child: SizedBox(
                                    height: 160,
                                    width: 160,
                                    child: Image.network(
                                      widget.message.message!,
                                      fit: BoxFit.cover,
                                    ),
                                  ))
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
                          left: 10,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(widget.user.imageurl!),
                          ),
                        ),
                        Positioned(
                            left: 30,
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
                            )),
                        // Positioned(
                        //   bottom: 0,
                        //   left: 100,
                        //   right: 100,
                        //   child: Padding(
                        //     padding: EdgeInsets.only(right: 150.w),
                        //     child: Text(
                        //       widget.message.seen!
                        //           ? DateFormat('hh:mm a').format(widget.message.date!.toDate())
                        //           : 'not seen',
                        //       style: TextStyle(
                        //         fontSize: 12.sp,
                        //         fontWeight: FontWeight.w400,
                        //         color: kUILight2,
                        //       ),
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  ))
            ],
          );
    // @override
    // Widget build(BuildContext context) {

    // return Container(
    //     margin: const EdgeInsets.only(top: 3.0, bottom: 3.0),
    //     child: Column(
    //       children: [
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.start,
    //           children: [
    //             SizedBox(width: 18.w),
    //             const CircleAvatar(
    //               backgroundImage: AssetImage('assets/icons/Person.png'),
    //             ),
    //             SizedBox(width: 10.w),
    //             Container(
    //                 width: 250.w,
    //                 //height: 41.h,
    //                 decoration: BoxDecoration(
    //                   color: kColorChat,
    //                   borderRadius: BorderRadius.circular(8.r),
    //                 ),
    //                 child: Row(
    //                   children: [
    //                     Expanded(
    //                       child: Text(
    //                         widget.message.message!,
    //                         style: TextStyle(
    //                           fontSize: 14.sp,
    //                           fontWeight: FontWeight.w400,
    //                           color: kUIDark,
    //                         ),
    //                       ),
    //                     )
    //                   ],
    //                 )),
    //           ],
    //         ),
    //         SizedBox(height: 1.h),
    //         Padding(
    //           padding: EdgeInsets.only(right: 150.w),
    //           child: Text(
    //             widget.message.seen!
    //                 ? DateFormat('hh:mm a').format(widget.message.date!.toDate())
    //                 : 'not seen',
    //             style: TextStyle(
    //               fontSize: 12.sp,
    //               fontWeight: FontWeight.w400,
    //               color: kUILight2,
    //             ),
    //           ),
    //         ),
    //       ],
    //     ));
  }
}
